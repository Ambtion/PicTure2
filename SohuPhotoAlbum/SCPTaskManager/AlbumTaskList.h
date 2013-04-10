//
//  SCPAlbumTaskList.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-12.
//
//

#import <Foundation/Foundation.h>

#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "TaskUnit.h"

#import "URLLibaray.h"

@class AlbumTaskList;
@protocol AlbumTaskListDelegate <NSObject>
- (void)albumTask:(AlbumTaskList *)albumTaskList requsetFinish:(ASIHTTPRequest *)requset;
- (void)albumTask:(AlbumTaskList *)albumTaskList requsetFailed:(ASIHTTPRequest *)requset;
- (void)albumTaskQueneFinished:(AlbumTaskList *)albumTaskList ;
@end

@interface AlbumTaskList : NSObject<ASIHTTPRequestDelegate>
{
    NSMutableArray * _taskList;
}

@property (assign, nonatomic) id<AlbumTaskListDelegate> delegate;

// 关于SCPTask的数组
@property (strong, nonatomic) NSMutableArray *taskList;
// 该任务列表所要上传到的相册的id
@property (strong, nonatomic) NSString *albumId;
@property (nonatomic,retain ) TaskUnit * currentTask;
// 该任务列表是否已经完成
@property (assign, nonatomic) BOOL isUpLoading;
-(id)initWithTaskList:(NSMutableArray *)taskList album_id:(NSString *)albumID;

//@property (nonatomic,retain)ASINetworkQueue * operationQuene;


//队列任务管理
- (void)go;
- (void)clearProgreessView;
- (void)cancelupLoadWithTag:(NSArray *)unitArray;

@end
