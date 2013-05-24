//
//  RequestManager.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <Foundation/Foundation.h>

enum Soruce_Type {
    KSourcePhotos = 0,
    KSourcePortfolios = 1
    };
typedef enum  Soruce_Type source_type;

@interface RequestManager : NSObject

//时间轴相册
+ (void)getTimeStructWithAccessToken:(NSString *)token withtime:(NSString *)beforeTime success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
+ (void)getTimePhtotWithAccessToken:(NSString *)token day:(NSString *)days success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
+ (void)deletePhotosWithaccessToken:(NSString *)token photoIds:(NSArray *)photo_ids success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//获取图片墙storys
+ (void)getTimePhtotWallStorysWithOwnerId:(NSString *)ownId withAccessToken:(NSString *)token start:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
+(void)deleteStoryFromWallWithaccessToken:(NSString *)token StoryId:(NSString *)storyId  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//story图片
+ (void)getAllPhototInStoryWithOwnerId:(NSString *)ownId stroyId:(NSString *)storyId start:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
+(void)deletePhotoFromStoryWithAccessToken:(NSString *)token stroyid:(NSString *)storyId photoId:(NSString *)photoId  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//获取个人信息
+ (void)getUserInfoWithId:(NSString *)userId success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//评论
+ (void)getCommentWithSourceType:(source_type)type andSourceID:(NSString *)srouceId page:(NSInteger)page success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
+ (void)postCommentWithSourceType:(source_type)type andSourceID:(NSString *)srouceId onwerID:(NSString *)ownerId andAccessToken:(NSString *)token comment:(NSString *)comment success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//喜欢
+ (void)likeWithSourceId:(NSString *)sourceID source:(source_type)type OwnerID:(NSString *)ownId Accesstoken:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
+ (void)unlikeWithSourceId:(NSString *)sourceID source:(source_type)type OwnerID:(NSString *)ownId Accesstoken:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//分享
+ (void)sharePhotosWithAccesstoken:(NSString *)token photoIDs:(NSArray *)photos_Ids share_to:(KShareModel)shareMode  shareAccestoken:(NSString *)sharetoken optionalTitle:(NSString *)title desc:(NSString *)description success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//分享主页
+ (void)shareUserHomeWithAccesstoken:(NSString *)token ownerId:(NSString *)ownerId share_to:(KShareModel)shareMode  shareAccestoken:(NSString *)sharetoken desc:(NSString *)description success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//分享单个作品集
+ (void)sharePortFoliosWithAccesstoken:(NSString *)token ownerId:(NSString *)ownerId portfilosId:(NSString *)portfolisId share_to:(KShareModel)shareMode  shareAccestoken:(NSString *)sharetoken desc:(NSString *)description success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;


//分享单张图片
+ (void)sharePhotoWithAccesstoken:(NSString *)token ownerId:(NSString *)ownerId portfilosId:(NSString *)portfolisId photoId:(NSString *)photoID share_to:(KShareModel)shareMode  shareAccestoken:(NSString *)sharetoken desc:(NSString *)description success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//星用户
+ (void)getRecomendusersWithsuccess:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;



//反馈
+ (void)feedBackWithidea:(NSString *)idea success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure;
@end
