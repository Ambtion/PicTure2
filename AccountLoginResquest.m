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

+ (BOOL)resigiterDevice
{
    NSString * url_s = [NSString stringWithFormat:@"%@/api/v1/devices",BASICURL];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url_s]];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setPostValue:[LoginStateManager currentToken] forKey:@"access_token"];
    [request setPostValue:[[UIDevice currentDevice] name] forKey:@"device_name"];
    [request setPostValue:@1 forKey:@"device_type"];
    [request setPostValue:[[UIDevice currentDevice] model] forKey:@"model"];
    [request setPostValue:[self getUUID] forKey:@"device_serial_number"];
    [request startSynchronous];
    if (request.responseStatusCode == 200) {
        NSNumber * num = [[[request responseString] JSONValue] objectForKey:@"device_id"];
        DLog(@"%@",[[request responseString] JSONValue]);
        [LoginStateManager storeDeviceID:num];
        return YES;
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
