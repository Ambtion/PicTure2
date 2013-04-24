//
//  SCPTaskUnit.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-11.
//
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ASIFormDataRequest.h"

typedef enum {
    UPLoadstatusWait = 0,
    UPLoadstatusIsUploading = 1,
    UPLoadstatusFinishUpload = 2,
    UPLoadStatusFailedUpload = 3,
} UPloadStatus;

@interface TaskUnit : NSObject
{
    NSData * _fulldata;
}
// 要上传的图片的路径
@property (strong, nonatomic) ALAsset * asset;
//缩略图
@property (strong, nonatomic) UIImage * thumbnail;
// 要上传的图片的文字描述
@property (strong, nonatomic)  NSString * description;
@property (strong, nonatomic ) NSData * data;
@property (strong, nonatomic)  NSDictionary * infoDic;
//任务状态
@property (assign, nonatomic) UPloadStatus taskState;

//保留request
@property (strong, nonatomic) ASIFormDataRequest * request;

- (NSData*)imageDataFromAsset;
@end
