//
//  SCPUploadTaskManager.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-13.
//
//

#import "UploadTaskManager.h"

static UploadTaskManager * sharedTaskManager = nil;

@implementation UploadTaskManager
@synthesize curTask;
@synthesize taskList = _taskList;

#pragma mark -
+ (UploadTaskManager *)currentManager  // 单例模式
{
    if (sharedTaskManager == nil) {
        @synchronized (self) {
            if (sharedTaskManager == nil) {
                sharedTaskManager = [[self alloc] init];
            }
        }
    }
    return sharedTaskManager;
}
#pragma mark - AutonUploadPic
- (BOOL)isAutoUploading
{
    return isAutoUploading;
}

- (void)autoUploadAssets:(NSMutableArray *)array ToTaskExceptIsUPloadAlready:(BOOL)isExceptAlready
{
    isAutoUploading = YES;
    NSMutableArray * taskArray = [NSMutableArray arrayWithCapacity:0];
    for (ALAsset * asset in array) {
        if (isExceptAlready) {
            if (![[DataBaseManager defaultDataBaseManager] hasPhotoURL:[[asset defaultRepresentation] url]]) {
                TaskUnit * unit = [[TaskUnit alloc] init];
                unit.asset = asset;
                unit.description = nil;
                [taskArray addObject:unit];
            }
        }
    }
    if (taskArray.count) {
        ToastAlertView * cus = [[ToastAlertView alloc] initWithTitle:@"照片开始备份"];
        [cus show];
        AlbumTaskList * album = [[AlbumTaskList alloc] initWithTaskList:taskArray album_id:ALBUMID];
        [[UploadTaskManager currentManager] addTaskList:album];
    }
}
#pragma mark - Init
- (id)init
{
    if (self = [super init]) {
        _taskList = [[NSMutableArray alloc] initWithCapacity:0];
        _taskDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (void)addTaskList:(AlbumTaskList *)taskList
{
    taskList.delegate = self;
    AlbumTaskList * oldTask = nil;
    for (AlbumTaskList * task in _taskList) {
        if ([task.albumId isEqualToString:taskList.albumId]) {
            oldTask = task;
            break;
        }
    }
    if (oldTask) {
        [oldTask.taskList addObjectsFromArray:[taskList taskList]];
    }else{
        [_taskList addObject:taskList];
    }
    [self updataAlbumInfoWith:taskList];
    [self go];
}
- (void)go
{
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    AlbumTaskList * task = [_taskList objectAtIndex:0];
    if (self.curTask == task) {
        DLog(@"There is Task going");
        return;
    }else{
        self.curTask = task;
    }
    if (!task.isUpLoading) {
        [self setAlbumInfoWith:self.curTask];
        [self albumTaskStart];
        [task go];
    }
}
- (BOOL)isUploading
{
    if (self.curTask.currentTask) {
        return YES;
    }else{
        return NO;
    }
}
- (NSDictionary *)currentTaskInfo
{
    return [[_taskDic objectForKey:self.curTask.albumId] copy];
}

#pragma mark - AlbumInfo
- (void)updataAlbumInfoWith:(AlbumTaskList *)taskList
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    NSInteger total = [self getTotalNumWith:taskList];
    total += taskList.taskList.count;
    NSInteger finished = [self getFinisheNumWith:taskList];
    [dic setObject:[NSNumber numberWithInt:total] forKey:@"Total"];
    [dic setObject:[NSNumber numberWithInt:finished] forKey:@"Finish"];
    [_taskDic setObject:dic forKey:taskList.albumId];
}
- (NSInteger)getTotalNumWith:(AlbumTaskList *)taskList
{
    NSMutableDictionary * albumInfo = [_taskDic objectForKey:taskList.albumId];
    if (!albumInfo || ![albumInfo objectForKey:@"Total"]) {
        return 0;
    }else{
        return [[albumInfo objectForKey:@"Total"] intValue];
    }
}
- (NSInteger)getFinisheNumWith:(AlbumTaskList *)taskList
{
    NSMutableDictionary * albumInfo = [_taskDic objectForKey:taskList.albumId];
    if (!albumInfo || ![albumInfo objectForKey:@"Finish"]) {
        return 0;
    }else{
        return [[albumInfo objectForKey:@"Finish"] intValue];
    }
}
- (void)setAlbumInfoWith:(AlbumTaskList *)taskList
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    NSInteger total = [self getTotalNumWith:taskList];
    NSInteger finished = [self getFinisheNumWith:taskList];
    [dic setObject:[NSNumber numberWithInt:total] forKey:@"Total"];
    [dic setObject:[NSNumber numberWithInt:finished] forKey:@"Finish"];
    [_taskDic setObject:dic forKey:taskList.albumId];

}
- (void)finishOneRequsetWith:(AlbumTaskList *)taskList
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    NSInteger total = [self getTotalNumWith:taskList];
    NSInteger finished = [self getFinisheNumWith:taskList];
    finished++;
    [dic setObject:[NSNumber numberWithInt:total] forKey:@"Total"];
    [dic setObject:[NSNumber numberWithInt:finished] forKey:@"Finish"];
    [_taskDic setObject:dic forKey:taskList.albumId];
    
}
- (void)cancelOneRequestWith:(AlbumTaskList *)taskList
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    NSInteger total = [self getTotalNumWith:taskList];
    NSInteger finished = [self getFinisheNumWith:taskList];
    total--;
    [dic setObject:[NSNumber numberWithInt:total] forKey:@"Total"];
    [dic setObject:[NSNumber numberWithInt:finished] forKey:@"Finish"];
    [_taskDic setObject:dic forKey:taskList.albumId];
}
- (void)removeAlbunInfo:(NSString  *)albumId
{
    for (AlbumTaskList * task in _taskList) {
        if ([task.albumId isEqualToString:albumId]) {
            return;
        }
    }
    [_taskDic removeObjectForKey:albumId];
}
- (void)gotoNext
{
    self.curTask = [_taskList objectAtIndex:0];
    [self.curTask go];
}

#pragma mark - GETALBUMYASK
- (AlbumTaskList *)getAlbumTaskWithAlbum:(NSString *)albumId
{
    for (AlbumTaskList * list in self.taskList) {
        if ([list.albumId isEqualToString:albumId]) {
            return list;
        }
    }
    return nil;
}
- (void)cancelOperationWithAlbumID:(NSString *)albumID
{
//    NSLog(@"Operation cancel");
    if ([self.curTask.albumId isEqualToString:albumID]) {
        [self.curTask.currentTask.request cancel];
        [self.curTask.currentTask.request clearDelegatesAndCancel];
        [self.taskList removeObject:self.curTask];
        [self albumTaskQueneFinished:nil];
        return;
    }
    for (AlbumTaskList * tss in _taskList) {
        if ([tss.albumId isEqualToString:albumID]) [self.taskList removeObject:tss];
    }
}
- (void)cancelAllOperation
{
    [self.curTask.currentTask.request cancel];
    [self.curTask.currentTask.request clearDelegatesAndCancel];
    [self.taskList removeAllObjects];
    [self albumTaskQueneFinished:nil];

}
- (void)cancelupLoadWithAlbumID:(NSString *)albumId WithUnit:(NSArray *)unitArray
{
    if ([self.curTask.albumId isEqualToString:albumId]) {
        if (self.curTask.taskList.count == unitArray.count) {
            [self cancelOperationWithAlbumID:albumId];
        }else{
            [self.curTask cancelupLoadWithTag:unitArray];
        }
    }else{
        for (AlbumTaskList * taskList in _taskList) {
            if ([taskList.albumId isEqualToString:albumId]) {
                if (self.curTask.taskList.count == unitArray.count) {
                    [self cancelOperationWithAlbumID:albumId];
                }else{
                    [self removeUint:unitArray From:taskList];
                }
            }
        }
    }
}
- (void)removeUint:(NSArray *)uintArray From:(AlbumTaskList *)taskList
{
    for (TaskUnit * unit in uintArray) {
        [taskList.taskList removeObject:unit];
        [self cancelOneRequestWith:taskList];
    }
}
#pragma mark AlbumProgress
- (void)albumTaskStart
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ALBUMTUPLOADSTART object:[_taskDic objectForKey:self.curTask.albumId]];
}
- (void)albumTaskQueneFinished:(AlbumTaskList *)albumTaskList
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:ALBUMUPLOADOVER object:nil userInfo:[_taskDic objectForKey:self.curTask.albumId]];
    if (!albumTaskList) return;
    [_taskList removeObjectAtIndex:0];
    [self removeAlbunInfo:self.curTask.albumId];
    self.curTask = nil;
    if (_taskList.count) {
        [self gotoNext];
    }else{
        isAutoUploading = NO;
        NSLog(@"All operation Over");
    }
}
- (void)albumTask:(AlbumTaskList *)albumTaskList requsetFinish:(ASIHTTPRequest *)requset
{
    [self finishOneRequsetWith:self.curTask];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:[_taskDic objectForKey:self.curTask.albumId]];
    if (requset && [requset responseString] && [[requset responseString] JSONValue])
        [dic setObject:[[requset responseString] JSONValue] forKey:@"RequsetInfo"];
    [[NSNotificationCenter defaultCenter] postNotificationName:ALBUMTASKCHANGE object:nil userInfo:dic];
    
}
- (void)albumTask:(AlbumTaskList *)albumTaskList requsetFailed:(ASIHTTPRequest *)requset
{
//    NSLog(@"fail one Requset");
    [[NSNotificationCenter defaultCenter] postNotificationName:ALBUMTASKCHANGE object:nil userInfo:nil];
}
#pragma mark upload
- (void)uploadPicTureWithALasset:(ALAsset *)asset
{
    [self uploadPicTureWithArray:[NSMutableArray arrayWithObject:asset]];
}
- (void)uploadPicTureWithArray:(NSMutableArray *)assetArray
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (ALAsset * asset in assetArray) {
        TaskUnit * unit = [[TaskUnit alloc] init];
        unit.asset = asset;
        unit.description = nil;
        [array addObject:unit];
    }
    ToastAlertView * tos = [[ToastAlertView alloc] initWithTitle:@"图片已在后台上传"];
    [tos show];
    AlbumTaskList * album = [[AlbumTaskList alloc] initWithTaskList:array album_id:ALBUMID];
    [[UploadTaskManager currentManager] addTaskList:album];
}

@end
