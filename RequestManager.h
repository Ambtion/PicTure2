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
+ (void)getTimePhtotWithAccessToken:(NSString *)token beforeTime:(long long)time count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
+ (void)deletePhotosWithaccessToken:(NSString *)token photoIds:(NSArray *)photo_ids success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//获取图片墙storys
+ (void)getTimePhtotWallStorysWithOwnerId:(NSString *)ownId start:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

+ (void)getAllPhototInStoryWithOwnerId:(NSString *)ownId stroyId:(NSString *)storyId start:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//story图片
+ (void)getStorysOffWallWithAccessToken:(NSString *)token andStoryId:(NSString *)storyID success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//获取个人信息
+ (void)getUserInfoWithToken:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
//评论
+ (void)getCommentWithSourceType:(source_type)type andSourceID:(NSString *)srouceId success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
+ (void)postCommentWithSourceType:(source_type)type andSourceID:(NSString *)srouceId onwerID:(NSString *)ownerId andAccessToken:(NSString *)token comment:(NSString *)comment success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
//喜欢
+ (void)likeWithSourceId:(NSString *)sourceID source:(source_type)type OwnerID:(NSString *)ownId Accesstoken:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
+ (void)unlikeWithSourceId:(NSString *)sourceID source:(source_type)type OwnerID:(NSString *)ownId Accesstoken:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

@end
