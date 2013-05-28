//
//  SCPUploadTaskManager.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AlbumTaskList.h"
#import "TaskNotification.h"
#import "JSON.h"
#import "PerfrenceSettingManager.h"

@interface UploadTaskManager : NSObject <AlbumTaskListDelegate>
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

//上传接口
- (void)uploadPicTureWithALasset:(ALAsset *)asset;

- (void)uploadPicTureWithArray:(NSMutableArray *)assetArray autoUpload:(BOOL)uploadState;

#pragma mark view

//管理照片列表下载进度
- (AlbumTaskList *)getAlbumTaskWithAlbum:(NSString *)albumId;

//获取当前队列状态
- (NSDictionary *)currentTaskInfo;

- (BOOL)isUploading;

- (BOOL)isAutoUploading;

//自动批量上传
- (void)autoUploadAssets:(NSMutableArray *)array ToTaskIncludeAssetThatUploaded:(BOOL)isUploadAll;
@end
