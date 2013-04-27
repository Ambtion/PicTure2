//
//  SCPLoginPridictive.h
//  SohuCloudPics
//
//  Created by sohu on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"




@interface LoginStateManager : NSObject

+ (BOOL)isLogin;
+ (void)loginUserId:(NSString *)uid withToken:(NSString *)token RefreshToken:(NSString *)refreshToken;
+ (void)refreshToken:(NSString *)token RefreshToken:(NSString *)refreshToken;
+ (void)logout;

+ (NSString *)currentUserId;
+ (NSString *)currentToken;
+ (NSString *)refreshToken;


+ (BOOL)isSinaBind;
+ (NSString *)sinaToken;

+ (BOOL)isQQBing;
+ (NSString *)qqToken;

+ (BOOL)isRenrenBind;
+ (NSString *)renrenToken;

+ (void)storeDeviceID:(NSNumber *)deviceId;
+ (long long)deviceId;

@end
