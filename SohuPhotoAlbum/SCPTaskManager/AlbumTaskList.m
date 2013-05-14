//
//  SCPAlbumTaskList.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-12.
//
//

#import "AlbumTaskList.h"
#import "JSON.h"
#import "TaskNotification.h"
#import "LoginStateManager.h"
#import "ToastAlertView.h"

#define UPTIMEOUT 30.f
#define UPLOADIMAGESIZE 1024 * 1024 * 10  // 图片最大10MB

@implementation AlbumTaskList

@synthesize backgroundUpdateTask;
@synthesize taskList = _taskList;
@synthesize albumId = _albumId;
@synthesize isUpLoading = _isUpLoading;
@synthesize delegate = _delegate;
@synthesize currentTask = _currentTask;

- (void)dealloc
{
    [self.currentTask.request cancel];
    [self.currentTask.request clearDelegatesAndCancel];
}

-(id)initWithTaskList:(NSMutableArray *)taskList album_id:(NSString *)albumID
{
    self = [super init];
    if (self) {
        self.backgroundUpdateTask = UIBackgroundTaskInvalid;
        self.taskList = taskList;
        self.albumId = albumID;
        _isUpLoading = NO;
        isStopTask = NO;
    }
    return self;
}

#pragma mark 
- (void)pauseTask
{
    isStopTask = YES;
}
- (void)startTask
{
    NSLog(@"");
    isStopTask = NO;
    [self go];
}
- (void)goNextTask
{
    DLog(@"%s",__FUNCTION__);
    if (isStopTask) return;
    [self go];
}
- (void)addTaskUnitToQuene
{
    if (!self.currentTask) self.currentTask = [self.taskList objectAtIndex:0];
    self.currentTask.request = [self getUploadRequest:[self currentTask].asset];
    NSData * imageData = [self.currentTask imageDataFromAsset];
    if ([imageData length] > UPLOADIMAGESIZE) {
        [self.currentTask.request setUserInfo:[NSDictionary dictionaryWithObject:@"图片太大,无法上传" forKey:@"FAILTURE"]];
        [self requestFailed:self.currentTask.request];
        return ;
    }else{
        [self.currentTask.request setPostBody:[imageData mutableCopy]];
        [self.currentTask.request startAsynchronous];
    }
    return;
}

- (void)startTaskUnit
{
    [self addTaskUnitToQuene];
}
- (void)go
{
    [self startTaskUnit];
    DLog(@"%s",__FUNCTION__);
}
- (void)cancelupLoadWithTag:(NSArray *)unitArray
{
    for (TaskUnit * unit in unitArray) {
        if ([self.currentTask isEqual:unit]) {
            [self.currentTask.request cancel];
            [self.currentTask.request clearDelegatesAndCancel];
            [self requestFinished:nil];
            continue;
        }
        for (int i = _taskList.count - 1 ; i >= 0;i--) {
            TaskUnit * tss = [_taskList objectAtIndex:i];
            if ([tss isEqual:unit]) [self.taskList removeObject:tss];
        }
    }
}

- (void)clearProgreessView
{
    for (TaskUnit * unit in _taskList) {
        [unit.request setUploadProgressDelegate:nil];
    }
}

#pragma mark - Requsetdelgate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    if ([request responseStatusCode] != 200) {
        [self requestFailed:request];
        return;
    }
    //不等于200时候上传出错.....
    NSDictionary * dic = [[request responseString] JSONValue];
    NSInteger code = [[dic objectForKey:@"code"] intValue];
    if (![self handleCode:code]) return;
    //上传成功
    [request cancel];
    [request clearDelegatesAndCancel];
    if (self.taskList.count)
        [self.taskList removeObjectAtIndex:0];
    [[DataBaseManager defaultDataBaseManager] insertPhotoURLIntoTable:[[self.currentTask.asset defaultRepresentation] url]];
    if ([_delegate respondsToSelector:@selector(albumTask:requsetFinish:)]) {
        [_delegate performSelector:@selector(albumTask:requsetFinish:) withObject:self withObject:request];
    }
    
    //开始下一任务
    self.currentTask = nil;
//    if (self.taskList.count) {
//        [self goNextTask];
//    }else{
//        //        NSLog(@"Task Finished");
//        if ([_delegate respondsToSelector:@selector(albumTaskQueneFinished:)]) {
//            [_delegate performSelector:@selector(albumTaskQueneFinished:) withObject:self];
//        }
//    }
    [self startToNext];
}
- (BOOL)handleCode:(NSInteger)code
{
    BOOL returnValue = NO;
    NSString * reason = nil;
    switch (code){
        case 0:
            returnValue = YES;
            break;
        case 1:
            reason = [NSString stringWithFormat:@"当前未登录,上传失败"];//取消任务;
            [self requestClearCurTask:reason];
            break;
        case 2:
            reason = [NSString stringWithFormat:@"专辑不存在,上传失败"];//取消任务;
            [self requestClearCurTask:reason];
            break;
        case 11:
            reason = [NSString stringWithFormat:@"专辑已满,上传失败"];//取消任务;
            [self requestClearCurTask:reason];
            break;
        case 12:
            reason = [NSString stringWithFormat:@"空间已满,上传失败"];//取消任务;
            [self requestClearCurTask:reason];
            break;
        default:
            [self requestFailed:nil];
            break;
    }
    return returnValue;
    
}
- (void)requestClearCurTask:(NSString *)reason
{
    [self.taskList removeAllObjects];
    self.currentTask = nil;
    ToastAlertView * cus = [[ToastAlertView alloc] initWithTitle:reason];
    [cus show];
    if ([_delegate respondsToSelector:@selector(albumTaskQueneFinished:)]) {
        [_delegate performSelector:@selector(albumTaskQueneFinished:) withObject:self];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"requestFailed:NNNN::%s, %d, %@",__FUNCTION__,[request responseStatusCode],[request error]);
    [request cancel];
    [request clearDelegatesAndCancel];
    NSDictionary * dic = [request userInfo];
    if (dic) {
        ToastAlertView * cus = [[ToastAlertView alloc] initWithTitle:[dic objectForKey:@"FAILTURE"]];
        [cus show];
    }else{
        ToastAlertView * cus = [[ToastAlertView alloc] initWithTitle:@"图片上传失败"];
        [cus show];
    }
    if ([_delegate respondsToSelector:@selector(albumTask:requsetFailed:)]) {
        [_delegate performSelector:@selector(albumTask:requsetFailed:) withObject:self withObject:request];
    }
    //开始下一任务
    if (self.taskList.count)
        [self.taskList removeObjectAtIndex:0];
    [self startToNext];
}

- (void)startToNext
{
 
    if (self.taskList.count) {
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
            [self beginBackgroundUpdateTask];
            [self goNextTask];
        }else{
            [self endBackgroundUpdateTask];
            [self goNextTask];
        }
    }else{
        [self endBackgroundUpdateTask];
        if ([_delegate respondsToSelector:@selector(albumTaskQueneFinished:)]) {
            [_delegate performSelector:@selector(albumTaskQueneFinished:) withObject:self];
        }
    }

}
- (ASIFormDataRequest *)getUploadRequest:(ALAsset *)asset
{
    //    http://pp.sohu.com/upload/api/sync
    NSString * photoName = [[asset defaultRepresentation] filename];
    NSString * str = [NSString stringWithFormat:@"%@/upload/api/sync?device=%lld&access_token=%@&filename=%@",BASICURL,[LoginStateManager deviceId],[LoginStateManager  currentToken],photoName];
    DLog(@"upload:%@",str);
    NSURL * url  = [NSURL URLWithString:str];
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:url];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setDelegate:self];
    [request setTimeOutSeconds:UPTIMEOUT];
    [request setShowAccurateProgress:YES];
    [request setShouldAttemptPersistentConnection:NO];
    [request setNumberOfTimesToRetryOnTimeout:5];
    
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    [request setShouldContinueWhenAppEntersBackground:YES];
#endif
    return request;
}

#pragma mark  backGround
- (void)beginBackgroundUpdateTask
{
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}
- (void) endBackgroundUpdateTask
{
    if (self.backgroundUpdateTask == UIBackgroundTaskInvalid) return;
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}
@end
