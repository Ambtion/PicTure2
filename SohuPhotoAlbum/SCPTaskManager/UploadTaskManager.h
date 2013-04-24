//
//  SCPUploadTaskManager.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-13.
//
//

#import <Foundation/Foundation.h>
#import "AlbumTaskList.h"
#import "TaskNotification.h"
#import "JSON.h"

@interface UploadTaskManager : NSObject<AlbumTaskListDelegate>
{
    NSMutableArray * _taskList;
    NSMutableDictionary * _taskDic;
}

@property (nonatomic,strong)AlbumTaskList * curTask;
@property (nonatomic,strong)NSMutableArray * taskList;
+ (UploadTaskManager *)currentManager; // 单例模式

//增加队列上传任务
- (void)addTaskList:(AlbumTaskList *)taskList; // 将任务列表加入到队列中

- (void)cancelOperationWithAlbumID:(NSString *)albumID;

- (void)cancelupLoadWithAlbumID:(NSString *)albumId WithUnit:(NSArray *)unitArray;

- (void)cancelAllOperation;

#pragma mark view
//管理相册列表上传进度

//管理照片列表下载进度
- (AlbumTaskList *)getAlbumTaskWithAlbum:(NSString *)albumId;

//获取当前队列状态
- (NSDictionary *)currentTaskInfo;

- (BOOL)isUploading;

@end
