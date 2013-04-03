//
//  SCPLoginPridictive.h
//  SohuCloudPics
//
//  Created by sohu on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"

#define USER_ID         @"__USER_ID__"
#define USER_TOKEN      @"__USER_TOKEN__"
#define REFRESH_TOKEN    @"__REFRESH_TOKEN__"

@interface LoginStateManager : NSObject

+ (BOOL)isLogin;

+ (void)loginUserId:(NSString *)uid withToken:(NSString *)token RefreshToken:(NSString *)refreshToken;

+ (void)refreshToken:(NSString *)token RefreshToken:(NSString *)refreshToken;

+ (void)logout;

+ (NSString *)currentUserId;

+ (NSString *)currentToken;

+ (NSString *)refreshToken;

//+ (void)storeData:(NSString *)data forKey:(NSString *)username;
//
//+ (NSString*)dataForKey:(NSString *)username;
//
//+ (void)removeDataForKey:(NSString *)username;

@end
