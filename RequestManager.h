//
//  RequestManager.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RequestManager : NSObject

+ (void)getTimePhtotWithAccessToken:(NSString *)token beforeTime:(long long)time count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

+ (void)getTimePhtotWallStorysWithOwnerId:(NSString *)ownId start:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

+ (void)getAllPhototInStroyWithOwnerId:(NSString *)ownId stroyId:(NSString *)storyId start:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

+ (void)deletePhotosWithaccessToken:(NSString *)token photoIds:(NSArray *)photo_ids success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

+ (void)getStroyOffWallWithAccessToken:(NSString *)token andStoryId:(NSString *)storyID success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
@end
