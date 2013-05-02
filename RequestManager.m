//
//  RequestManager.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "RequestManager.h"
#import "ASIFormDataRequest.h"
#import "LoginStateManager.h"
#import "PopAlertView.h"
#import "URLLibaray.h"

#define TIMEOUT 10.f
#define REQUSETFAILERROR @"当前网络不给力,请稍后重试"
#define REFRESHFAILTURE @"登录过期,请重新登录"

@implementation RequestManager(private)

+ (void)refreshToken:(NSInteger)requsetStatusCode withblock:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"%@/oauth2/access_token?grant_type=refresh_token",BASICURL];
    __weak  ASIFormDataRequest  *  request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setPostValue:CLIENT_ID forKey:@"client_id"];
    [request setPostValue:CLIENT_SECRET forKey:@"client_secret"];
    [request setPostValue:[LoginStateManager refreshToken] forKey:@"refresh_token"];
    [request setCompletionBlock:^{
        if ([request responseStatusCode] == 200) {
            NSDictionary * dic = [[request responseString] JSONValue];
            [LoginStateManager refreshToken:[NSString stringWithFormat:@"%@",[dic objectForKey:@"access_token"]] RefreshToken:[NSString stringWithFormat:@"%@",[dic objectForKey:@"refresh_token"]]];
        }else{
            failure(REFRESHFAILTURE);
            [LoginStateManager logout];
        }
    }];
    
    [request setFailedBlock:^{
        failure(REFRESHFAILTURE);
        [LoginStateManager logout];
    }];
    [request startAsynchronous];
}

+ (BOOL)handlerequsetStatucode:(NSInteger)requsetCode withblock:(void (^) (NSString * error))failure
{
    
    if (requsetCode >= 200 && requsetCode <= 300) return YES;
    if (requsetCode == 401) {
        [self refreshToken:401 withblock:failure];
        return NO;
    }
    return NO;
}

+ (void)getSourceWithStringUrl:(NSString * )strUrl success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    __block __weak ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setRequestMethod:@"GET"];
    [request setCompletionBlock:^{
        
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code withblock:failure]) {
            success([request responseString]);
        }
    }];
    [request setFailedBlock:^{
        if (![self handlerequsetStatucode:[request responseStatusCode] withblock:failure]) return;
        failure(REQUSETFAILERROR);
    }];
    [request startAsynchronous];
}
+ (void)postWithURL:(NSString *)strUrl body:(NSDictionary *)body success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    __block __weak ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setStringEncoding:NSUTF8StringEncoding];
    for (id key in [body allKeys])
        [request setPostValue:[body objectForKey:key] forKey:key];
    [request setCompletionBlock:^{
        DLog(@"%@",[request responseString]);
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code withblock:failure]) {
            success([request responseString]);
        }
    }];
    [request setFailedBlock:^{
        if (![self handlerequsetStatucode:[request responseStatusCode] withblock:failure]) return;
        failure(REQUSETFAILERROR);
    }];
    [request startAsynchronous];
}
@end

@implementation RequestManager

//时间轴获取
+ (void)getTimePhtotWithAccessToken:(NSString *)token beforeTime:(long long)time count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    
    NSString *  str = nil;
    if (time) {
        str =  [NSString stringWithFormat:@"%@/api/v1/sync_photos?access_token=%@&before_taken_id=%lld&count=%d",BASICURL,token,time,count];
    }else{
        str =  [NSString stringWithFormat:@"%@/api/v1/sync_photos?access_token=%@&count=%d",BASICURL,token,count];
    }
    [self getSourceWithStringUrl:str success:success failure:failure];
    
}

+ (void)deletePhotosWithaccessToken:(NSString *)token	photoIds:(NSArray *)photo_ids success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * strUrl =  [NSString stringWithFormat:@"%@/api/v1/sync_photos/destroy",BASICURL];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:token forKey:@"access_token"];
    NSString * iDsStr = nil;
    if (photo_ids.count > 1){
        iDsStr = [photo_ids componentsJoinedByString:@","];
    }else{
        iDsStr = [photo_ids lastObject];
    }
    [dic setValue:iDsStr forKey:@"photo_ids"];
    [self postWithURL:strUrl body:dic success:success failure:failure];

}


+ (void)getTimePhtotWallStorysWithOwnerId:(NSString *)ownId start:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"%@/api/v1/portfolios?owner_id=%@&start=%d&count=%d",BASICURL,@"4",start,count];
    DLog(@"%@",str);
    [self getSourceWithStringUrl:str success:success failure:failure];
}
@end
