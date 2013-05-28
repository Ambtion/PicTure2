//
//  AccountSystem.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-22.
//
//

#import "AccountLoginResquest.h"
#import "ASIFormDataRequest.h"
#import "LoginStateManager.h"
#import "JSON.h"

#define CLIENT_ID @"355d0ee5-d1dc-3cd3-bdc6-76d729f61655"

@implementation AccountLoginResquest

+ (NSString *)getUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFBridgingRelease(theUUID);
    return (NSString *)string;
}
+ (BOOL)upDateDeviceToken
{
    NSString * str = [LoginStateManager deviceToken];
    if (!str) return NO;
    NSString * url_s = [NSString stringWithFormat:@"%@/api/v1/device_tokens/add",BASICURL];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url_s]];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setPostValue:[LoginStateManager currentToken] forKey:@"access_token"];
    [request setPostValue:str forKey:@"device_token"];
    [request startSynchronous];
    if (request.responseStatusCode == 200) {
        return YES;
    }
    return NO;
}

+ (BOOL)deleteDeviceToken
{
    NSString * str = [LoginStateManager deviceToken];
    if (!str) return NO;
    NSString * url_s = [NSString stringWithFormat:@"%@/api/v1/device_tokens/delete",BASICURL];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url_s]];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setPostValue:[LoginStateManager currentToken] forKey:@"access_token"];
    [request setPostValue:str forKey:@"device_token"];
    [request startSynchronous];
    if (request.responseStatusCode == 200) {
        return YES;
    }
    return NO;
}
+ (BOOL)resigiterDevice
{
    NSString * url_s = [NSString stringWithFormat:@"%@/api/v1/devices",BASICURL];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url_s]];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setPostValue:[LoginStateManager currentToken] forKey:@"access_token"];
    [request setPostValue:[[UIDevice currentDevice] name] forKey:@"device_name"];
    [request setPostValue:[[UIDevice currentDevice] model] forKey:@"device_model"];
    [request setPostValue:[self getUUID] forKey:@"device_serial_number"];
    [request startSynchronous];
    if (request.responseStatusCode == 200) {
        NSNumber * num = [[[request responseString] JSONValue] objectForKey:@"device_id"];
        [LoginStateManager storeDeviceID:num];
        return YES;
    }
    return NO;
}

+ (BOOL)setBindingInfo
{
    NSString * url_s = [NSString stringWithFormat:@"http://pp.sohu.com/bind/mobile/list?access_token=%@",[LoginStateManager currentToken]];
    __block ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url_s]];
    [request startSynchronous];
    if (request.responseStatusCode == 200) {
        
        NSDictionary * dic = [request.responseString JSONValue];
        DLog(@"%@",dic);
        NSDictionary * dataInfo = [dic objectForKey:@"data"];
        NSArray * keys = [dataInfo allKeys];
        for (int i = 0; i < keys.count ; i ++ ) {
            NSString * key_str = [keys objectAtIndex:i];
            NSDictionary * dic = [dataInfo objectForKey:key_str];
            NSString * type = [dic objectForKey:@"type"];
            if (type && [type isKindOfClass:[NSString class]]) {
                if ([type isEqualToString:@"QQ"]) {
                    [LoginStateManager storeQQTokenInfo:dic];
                }
                if ([type isEqualToString:@"WEIBO"]) {
                    [LoginStateManager storeSinaTokenInfo:dic];
                }
                if ([type isEqualToString:@"RENREN"]) {
                    [LoginStateManager storeRenRenTokenInfo:dic];
                }
            }
        }
        return YES;
        
    }
    return NO;
} 
+ (BOOL)unBinging:(KShareModel)shareModel 
{
    NSString * string = nil;
    switch (shareModel) {
        case QQShare:
            string = @"http://pp.sohu.com/bind/mobile/qq";
            break;
        case SinaWeiboShare:
            string = @"http://pp.sohu.com/bind/mobile/weibo";
            break;
        case RenrenShare:
            string = @"http://pp.sohu.com/bind/mobile/renren";
            break;
        default:
            break;
    }
    NSDictionary * tokenInfo = [LoginStateManager getTokenInfo:shareModel];
    string = [string stringByAppendingFormat:@"?access_token=%@&uid=%@&identify=%@",[LoginStateManager currentToken],[tokenInfo objectForKey:@"uid"],[tokenInfo objectForKey:@"identify"]];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:string]];
    [request setRequestMethod:@"DELETE"];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request startAsynchronous];
    if (request.responseStatusCode == 200) {
        if ([request responseString] && [[[[request responseString] JSONValue] objectForKey:@"code"] intValue] == 0) {
            return YES;
        }
    }
    return NO;
}


+ (void)sohuLoginWithuseName:(NSString *)useName password:(NSString *)password sucessBlock:(void (^)(NSDictionary  * response))success failtureSucess:(void (^)(NSString * error))faiture
{
    NSString * url_s = [NSString stringWithFormat:@"%@/oauth2/access_token",BASICURL];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url_s]];
    [request setPostValue:useName forKey:@"username"];
    [request setPostValue:password forKey:@"password"];
    [request setPostValue:@"password" forKey:@"grant_type"];
    [request setPostValue:CLIENT_ID forKey:@"client_id"];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setCompletionBlock:^{
        DLog(@"%d %@",[request responseStatusCode],[request responseString]);
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] < 300 &&[[request responseString] JSONValue]) {
            success([[request responseString] JSONValue]);
        }else if([request responseStatusCode] == 403){
            faiture(@"您的用户名与密码不匹配");
        }else{
            faiture(@"当前网络不给力，请稍后重试");
        }
    }];
    [request setFailedBlock:^{
        DLog(@"Failture::%@ %d",[request responseString],[request responseStatusCode]);
        faiture(@"当前网络不给力，请稍后重试");
    }];
    [request startAsynchronous];
}

+ (void)resigiterWithuseName:(NSString *)useName password:(NSString *)password nickName:(NSString *)nick sucessBlock:(void (^)(NSDictionary  * response))success failtureSucess:(void (^)(NSString * error))faiture
{
    NSString * str = [NSString stringWithFormat:@"%@/api/v1/register",BASICURL];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setPostValue:useName forKey:@"passport"];
    [request setPostValue:password forKey:@"password"];
    [request setTimeOutSeconds:5.f];
    [request setCompletionBlock:^{
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 ) {
            success(nil);
        }else if([request responseStatusCode] == 403){
            NSDictionary * dic = [[request responseString] JSONValue];
            NSInteger code = [[dic objectForKey:@"code"] intValue];
            switch (code) {
                case 0:
                    success(dic);
                    break;
                case 1:
                    faiture(@"您的密码格式不正确");//密码不符合要求
                    break;
                case 2:
                    faiture(@"您的用户名格式不正确");
                    break;
                case 3:
                    faiture(@"您的用户名格式不正确");//账号不符合要求
                    break;
                case 4:
                    faiture(@"该用户名已被注册");//已有账号
                    break;
                default:
                    faiture(@"当前网络不给力，请稍后重试");
                    break;
            }
            
        }else{
            faiture(@"当前网络不给力，请稍后重试");
        }
    }];
    [request setFailedBlock:^{
        faiture(@"当前网络不给力，请稍后重试");
    }];
    [request startAsynchronous];
}

@end
