//
//  SCPLoginPridictive.m
//  SohuCloudPics
//
//  Created by sohu on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginStateManager.h"
#import "DataBaseManager.h"

#define USER_ID             [NSString stringWithFormat:@"__USER_ID__%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]
#define DEVICE_TOKEN        @"__device_token__"
#define LASTUSERNAME        @"__last_usrName__"
#define USER_TOKEN          @"__USER_TOKEN__"
#define REFRESH_TOKEN       @"__REFRESH_TOKEN__"
#define DEVICEDID           @"__DEVICEDID__"
#define SINA_TOKEN          @"__SINA_TOKEN__"
#define RENREN_TOKEN        @"__RENREN_TOKEN__"
#define QQ_TOKEN            @"__QQ_TOKEN__"

@implementation LoginStateManager (private)

+ (void)userDefoultStoreValue:(id)value forKey:(id)key
{
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * userinfo = [NSMutableDictionary dictionaryWithDictionary:[self valueForUserinfo]];
    if (!userinfo) userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
    [userinfo setValue:value forKey:key];
    [userDefault setObject:userinfo forKey:[LoginStateManager currentUserId]];
    [userDefault synchronize];
}

+ (NSDictionary *)valueForUserinfo
{
    if (![LoginStateManager isLogin]) return nil;
    return [[[NSUserDefaults standardUserDefaults] objectForKey:[LoginStateManager currentUserId]] copy] ;
}

+ (void)userDefoultRemoveValeuForKey:(NSString *)key
{
    if (!key || [key isEqualToString:@""]) return;
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * userinfo = [NSMutableDictionary dictionaryWithDictionary:[self valueForUserinfo]];
    if (!userinfo) userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
//    if ([[userinfo allKeys] containsObject:key])
    [userinfo removeObjectForKey:key];
    [userDefault setObject:userinfo forKey:[LoginStateManager currentUserId]];
    [userDefault synchronize];
}
#pragma mark - StoreDefaults
+ (void)storeData:(NSString *)data forKey:(NSString *)key
{
    NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
    [defults setObject:data forKey:key];
    [defults synchronize];
}

+ (NSString *)dataForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * data = [defaults objectForKey:key];
    return data;
}
+ (void)removeDataForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}
@end

@implementation LoginStateManager

+ (NSString *)lastUserName
{
    return [self dataForKey:LASTUSERNAME];
}
+ (void)storelastName:(NSString *)userName
{
    [self storeData:userName forKey:LASTUSERNAME];
}

+ (BOOL)isLogin
{
    return [self dataForKey:USER_ID] != nil;
}

+ (void)loginUserId:(NSString *)uid withToken:(NSString *)token RefreshToken:(NSString *)refreshToken
{
    [self storeData:uid forKey:USER_ID];
    [self userDefoultStoreValue:token forKey:USER_TOKEN];
    [self userDefoultStoreValue:refreshToken forKey:REFRESH_TOKEN];
}

+ (void)refreshToken:(NSString *)token RefreshToken:(NSString *)refreshToken
{
    [self storeData:token forKey:USER_TOKEN];
    [self storeData:refreshToken forKey:REFRESH_TOKEN];
}
+ (void)logout
{
    //    [AccountLoginResquest deleteDeviceToken];
    //    [self removeDataForKey:[self currentUserId]];
    //    [self unbindAll];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [self removeDataForKey:USER_ID];
}

+ (NSString *)currentUserId
{
    return [self dataForKey:USER_ID];
}

#pragma mark Token
+ (NSString *)currentToken
{
    return [[[self valueForUserinfo] objectForKey:USER_TOKEN] copy];
}
+ (NSString *)refreshToken
{
    return [[[self valueForUserinfo] objectForKey:REFRESH_TOKEN] copy];
}

+ (BOOL)isSinaBind
{
    return [[self valueForUserinfo] objectForKey:SINA_TOKEN] ? YES:NO;
}
+ (void)storeSinaTokenInfo:(NSDictionary *)info
{
    [self userDefoultStoreValue:info forKey:SINA_TOKEN];
}

+ (NSDictionary *)sinaTokenInfo
{
    return [[self valueForUserinfo] objectForKey:SINA_TOKEN];
}

+ (BOOL)isQQBing
{
    return [[self valueForUserinfo] objectForKey:QQ_TOKEN]?YES : NO;
}
+ (void)storeQQTokenInfo:(NSDictionary *)info
{
    NSString * openid = [self getQQopenIdWithAccess_token:[info objectForKey:@"access_token"]];
    if (!openid) {
        openid = [self getQQopenIdWithAccess_token:[info objectForKey:@"access_token"]];
        if (!openid) {
            //两次获取失败,默认绑定失败
//            [self objectPopAlerViewRatherThentasView:NO WithMes:@"绑定失败,请稍后重试"];
            return;
        }
    }
    NSMutableDictionary * dic = [info mutableCopy];
    [dic setObject:openid forKey:@"openid"];
    [self userDefoultStoreValue:dic forKey:QQ_TOKEN];
}
+ (NSString *)getQQopenIdWithAccess_token:(NSString *)token
{
    NSString * url = [NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/me?access_token=%@",token];
    ASIHTTPRequest * getOpneUid = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [getOpneUid startSynchronous];
    NSString * finalStr = [getOpneUid responseString];
    if (finalStr.length < 9) {
        return nil;
    }
    finalStr = [finalStr substringFromIndex:9];
    finalStr = [finalStr substringToIndex:[finalStr length] - 4];
    return [[finalStr JSONValue] objectForKey:@"openid"];
}

+ (NSDictionary *)qqTokenInfo
{
    return [[self valueForUserinfo] objectForKey:QQ_TOKEN];
}

+ (BOOL)isRenrenBind
{
    return [[self valueForUserinfo] objectForKey:RENREN_TOKEN]? YES:NO;
}
+ (void)storeRenRenTokenInfo:(NSDictionary *)info
{
    [self userDefoultStoreValue:info forKey:RENREN_TOKEN];
}

+ (NSDictionary *)renrenTokenInfo
{
    return [[self valueForUserinfo] objectForKey:RENREN_TOKEN];
}

+ (NSDictionary *)getTokenInfo:(KShareModel)model
{
    switch (model) {
        case QQShare:
            return [self qqTokenInfo];
            break;
        case RenrenShare:
            return [self renrenTokenInfo];
            break;
        case SinaWeiboShare:
            return [self sinaTokenInfo];
            break;
        default:
            break;
    }
    return nil;
}
+ (void)unbindAll
{
    [self unbind:QQShare];
    [self unbind:RenrenShare];
    [self unbind:SinaWeiboShare];
}
+ (void)unbind:(KShareModel)model
{
    NSString * str = nil;
    switch (model) {
        case SinaWeiboShare:
            str = SINA_TOKEN;
            break;
        case QQShare:
            str = QQ_TOKEN;
            break;
        case RenrenShare:
            str = RENREN_TOKEN;
            break;
        default:
            break;
    }
    [self userDefoultRemoveValeuForKey:str];
}

#pragma mark Device
+ (void)storeDeviceID:(NSNumber *)deviceId
{
    [self userDefoultStoreValue:deviceId forKey:DEVICEDID];
}
+ (long long)deviceId
{
    return [[[self valueForUserinfo] objectForKey:DEVICEDID] longLongValue];
}

+ (void)storeDeviceToken:(NSString *)deviceToken
{
    if ([self deviceToken] && [[self deviceToken] isEqualToString:deviceToken]) return;
    [self storeData:deviceToken forKey:DEVICE_TOKEN];
}
+ (NSString *)deviceToken
{
    return [self dataForKey:DEVICE_TOKEN];
}
@end
