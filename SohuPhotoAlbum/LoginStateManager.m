//
//  SCPLoginPridictive.m
//  SohuCloudPics
//
//  Created by sohu on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginStateManager.h"

@implementation LoginStateManager (private)

+ (void)storeData:(NSString *)data forKey:(NSString *)key
{
    NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
    [defults setObject:data forKey:key];
    [defults synchronize];
}

+ (NSString *)dataForKey:(NSString *)key
{
    NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
    NSString *data = [defults objectForKey:key];
    return data;
}

+ (void)removeDataForKey:(NSString *)key
{
    NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
    [defults removeObjectForKey:key];
    [defults synchronize];
}

@end

@implementation LoginStateManager

+ (BOOL)isLogin
{
    return [self dataForKey:USER_TOKEN] != nil;
}

+ (void)loginUserId:(NSString *)uid withToken:(NSString *)token RefreshToken:(NSString *)refreshToken
{
    
    [self storeData:uid forKey:USER_ID];
    [self storeData:token forKey:USER_TOKEN];
    [self storeData:refreshToken forKey:REFRESH_TOKEN];
}
+ (void)refreshToken:(NSString *)token RefreshToken:(NSString *)refreshToken
{
    [self storeData:token forKey:USER_TOKEN];
    [self storeData:refreshToken forKey:REFRESH_TOKEN];
}
+ (void)logout
{
    [self removeDataForKey:USER_ID];
    [self removeDataForKey:USER_TOKEN];
    [self removeDataForKey:REFRESH_TOKEN];
}

+ (NSString *)currentUserId
{
    return [self dataForKey:USER_ID];
}

+ (NSString *)currentToken
{
    return [self dataForKey:USER_TOKEN];
}
+ (NSString *)refreshToken
{
    return [self dataForKey:REFRESH_TOKEN];
}
@end
