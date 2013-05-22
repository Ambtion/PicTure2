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
#import "UMAppKey.h"

#define TIMEOUT 10.f
#define REQUSETFAILERROR @"当前网络不给力,请稍后重试"
#define REQUSETSOURCEFIAL @"访问的资源不存在"
#define REFRESHFAILTURE @"登录过期,请重新登录"

@implementation RequestManager(private)

+ (void)setValueWith:(shareModel)shareMode intoDic:(NSMutableDictionary *)body
{
    NSString * shareModeStr = nil;
    switch (shareMode) {
        case QQShare:
            shareModeStr = @"qq";
            break;
        case SinaWeiboShare:
            shareModeStr = @"sina";
            break;
        case RenrenShare:
            shareModeStr = @"renren";
            break;
            
        default:
            break;
    }
    if (!shareModeStr) return;
    [body setValue:shareModeStr forKey:@"share_to"];

}
+ (NSString *)sourceToString:(source_type)type
{
    return (type == KSourcePhotos ? @"photos":@"portfolios");
}

+ (void)refreshToken:(NSInteger)requsetStatusCode withblock:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"%@/oauth2/access_token?grant_type=refresh_token",BASICURL_V1];
    __weak  ASIFormDataRequest  *  request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setPostValue:CLIENT_ID forKey:@"client_id"];
    [request setPostValue:CLIENT_SECRET forKey:@"client_secret"];
    [request setPostValue:[LoginStateManager refreshToken] forKey:@"refresh_token"];
    [request setCompletionBlock:^{
        if ([request responseStatusCode] == 200) {
            NSDictionary * dic = [[request responseString] JSONValue];
            [LoginStateManager refreshToken:[NSString stringWithFormat:@"%@",[dic objectForKey:@"access_token"]] RefreshToken:[NSString stringWithFormat:@"%@",[dic objectForKey:@"refresh_token"]]];
        }else{
            if (failure)
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
+ (void)getWithUrlStr:(NSString *)strUrl andMethod:(NSString *)method body:(NSDictionary *)body success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    __block __weak ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setRequestMethod:method];
    [request setStringEncoding:NSUTF8StringEncoding];
    for (id key in [body allKeys])
        [request setPostValue:[body objectForKey:key] forKey:key];
    [request setCompletionBlock:^{
        DLog(@"url :%@ code :%d",request.url,[request responseStatusCode]);
        NSInteger code = [request responseStatusCode];
        if ([self handlerequsetStatucode:code withblock:failure]) {
            success([request responseString]);
        }else{
            if (code == 404) {
                [self objectPopAlerViewRatherThentasView:NO WithMes:REQUSETSOURCEFIAL];
                if (failure)
                    failure(REQUSETSOURCEFIAL);
            }else{
                [self objectPopAlerViewRatherThentasView:NO WithMes:REQUSETFAILERROR];
                if (failure)
                    failure(REQUSETFAILERROR);
            }
        }
    }];
    [request setFailedBlock:^{
        DLog(@"failturl :%@ :%d %@",request.url,[request responseStatusCode],[request responseString]);
        if (![self handlerequsetStatucode:[request responseStatusCode] withblock:failure]) return;
        [self objectPopAlerViewRatherThentasView:NO WithMes:REQUSETFAILERROR];
        if (failure)
            failure(REQUSETFAILERROR);
    }];
    [request startAsynchronous];
    
}
#pragma mark GET
+ (void)getSourceWithStringUrl:(NSString * )strUrl success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    [self getWithUrlStr:strUrl andMethod:@"GET" body:nil success:success failure:failure];
}

#pragma mark POST
+ (void)postWithURL:(NSString *)strUrl body:(NSDictionary *)body success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    [self getWithUrlStr:strUrl andMethod:@"POST" body:body success:success failure:failure];
}

#pragma mark DELETE
+ (void)deleteSoruce:(NSString * )strUrl success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    [self getWithUrlStr:strUrl andMethod:@"DELETE" body:nil success:success failure:failure];
}
@end


@implementation RequestManager

//时间轴获取
+ (void)getTimeStructWithAccessToken:(NSString *)token withtime:(NSString *)beforeTime success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    //    http://dev.pp.sohu.com/api/v1/sync_photos/infos?access_token=e16dac12-9c69-3288-b710-ea2aefd76a0f&before=2013-05-08
    NSString *  str = nil;
    if (beforeTime) {
        str =  [NSString stringWithFormat:@"%@/sync_photos/infos?access_token=%@&before=%@",BASICURL_V1,token,beforeTime];
    }else{
        str =  [NSString stringWithFormat:@"%@/sync_photos/infos?access_token=%@",BASICURL_V1,token];
    }
    [self getSourceWithStringUrl:str success:success failure:failure];
}
+ (void)getTimePhtotWithAccessToken:(NSString *)token day:(NSString *)days success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    //http://dev.pp.sohu.com/api/v1/sync_photos?access_token=e16dac12-9c69-3288-b710-ea2aefd76a0f&day=2013-05-07
    NSString * str = [NSString stringWithFormat:@"%@/sync_photos?access_token=%@&day=%@",BASICURL_V1,token,days];
    DLog(@"%@",str);
    [self getSourceWithStringUrl:str success:success failure:failure];
    
}
+ (void)deletePhotosWithaccessToken:(NSString *)token	photoIds:(NSArray *)photo_ids success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * strUrl =  [NSString stringWithFormat:@"%@/sync_photos/destroy",BASICURL_V1];
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

//图片墙
#pragma mark -
+ (void)getTimePhtotWallStorysWithOwnerId:(NSString *)ownId withAccessToken:(NSString *)token start:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = nil;
    if (token) {
        str = [NSString stringWithFormat:@"%@/portfolios?owner_id=%@&start=%d&count=%d&access_token=%@",BASICURL_V1,ownId,start,count,token];
    }else{
        str = [NSString stringWithFormat:@"%@/portfolios?owner_id=%@&start=%d&count=%d",BASICURL_V1,ownId,start,count];
    }
    [self getSourceWithStringUrl:str success:success failure:failure];
}

+(void)deleteStoryFromWallWithaccessToken:(NSString *)token StoryId:(NSString *)storyId  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    //    2.2 DELETE /portfolios/$id  删除指定的作品集。
    NSString * string = [NSString stringWithFormat:@"%@/portfolios/%@?access_token=%@",BASICURL_V1,storyId,token];
    [self deleteSoruce:string success:success failure:failure];
}

//story详情
#pragma mark -
+ (void)getAllPhototInStoryWithOwnerId:(NSString *)ownId stroyId:(NSString *)storyId start:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = nil;
    if (![LoginStateManager isLogin]) {
        str =  [NSString stringWithFormat:@"%@/portfolios/%@/photos?owner_id=%@&start=%d&count=%d",
                BASICURL_V1,storyId,ownId,start,count];
    }else{
        str =  [NSString stringWithFormat:@"%@/portfolios/%@/photos?owner_id=%@&start=%d&count=%d&access_token=%@",
                BASICURL_V1,storyId,ownId,start,count,[LoginStateManager currentToken]];
    }
   
    [self getSourceWithStringUrl:str success:success failure:failure];
}
+(void)deletePhotoFromStoryWithAccessToken:(NSString *)token stroyid:(NSString *)storyId photoId:(NSString *)photoId  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    //    2.4 DELETE /portfolios/$id/photos/$photoid  删除指定的故事中的指定图片。
    NSString * string = [NSString stringWithFormat:@"%@/portfolios/%@/photos/%@?access_token=%@",BASICURL_V1,storyId,photoId,token];
    [self deleteSoruce:string success:success failure:failure];
}

#pragma mark - comment
+ (void)getCommentWithSourceType:(source_type)type andSourceID:(NSString *)srouceId page:(NSInteger)page success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
{
    //从第一也开始,变成从0开始
    page++;
    NSString * soure = (type == KSourcePhotos ? @"photos":@"portfolios");
    NSString * str = [NSString stringWithFormat:@"%@/%@/%@/comments?page=%d",BASICURL_V1,soure,srouceId,page];
    [self getSourceWithStringUrl:str success:success failure:failure];
}
+ (void)postCommentWithSourceType:(source_type)type andSourceID:(NSString *)srouceId onwerID:(NSString *)ownerId andAccessToken:(NSString *)token comment:(NSString *)comment success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * soure = [self sourceToString:type];
    NSString * str = [NSString stringWithFormat:@"%@/%@/%@/comments",BASICURL_V1,soure,srouceId];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:ownerId,@"owner_id",token,@"access_token",comment,@"content", nil];
    [self postWithURL:str body:dic success:success failure:failure];
}

#pragma mark - userInfo
+ (void)getUserInfoWithId:(NSString *)userId success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    if (!userId) return;
    NSString * str = nil;
    if ([LoginStateManager isLogin] && [userId isEqualToString:[LoginStateManager currentUserId]])
    {
        str = [NSString stringWithFormat:@"%@/users/%@?access_token=%@",BASICURL_V1,userId,[LoginStateManager currentToken]];
    }else{
        str = [NSString stringWithFormat:@"%@/users/%@",BASICURL_V1,userId];
        
    }
    [self getSourceWithStringUrl:str success:success failure:nil];
}

//喜欢
#pragma mark like
+ (void)likeWithSourceId:(NSString *)sourceID source:(source_type)type OwnerID:(NSString *)ownId Accesstoken:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * soure = [self sourceToString:type];
    NSString * str = [NSString stringWithFormat:@"%@/%@/%@/like",BASICURL_V1,soure,sourceID];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:token,@"access_token",ownId,@"owner_id", nil];
    [self postWithURL:str body:dic success:success failure:failure];
}
+ (void)unlikeWithSourceId:(NSString *)sourceID source:(source_type)type OwnerID:(NSString *)ownId Accesstoken:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * soure = [self sourceToString:type];
    NSString * str = [NSString stringWithFormat:@"%@/%@/%@/unlike",BASICURL_V1,soure,sourceID];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:token,@"access_token", nil];
    [self postWithURL:str body:dic success:success failure:failure];
}

//分享
+ (void)createPortfoliosWithDic:(NSDictionary *)dic success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * strUrl = [NSString stringWithFormat:@"%@/portfolios",BASICURL_V1];
    [self postWithURL:strUrl body:dic success:success failure:failure];
}
+ (void)sharePhotosWithAccesstoken:(NSString *)token photoIDs:(NSArray *)photos_Ids share_to:(shareModel)shareMode  shareAccestoken:(NSString *)sharetoken optionalTitle:(NSString *)title desc:(NSString *)description success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * iDsStr = nil;
    NSMutableDictionary * body = [NSMutableDictionary dictionaryWithCapacity:0];
    if (photos_Ids.count > 1){
        iDsStr = [photos_Ids componentsJoinedByString:@","];
    }else{
        iDsStr = [photos_Ids lastObject];
    }
    [body setValue:iDsStr forKey:@"photo_ids"];
    [body setValue:token forKey:@"access_token"];
    if (title) {
        [body setValue:title forKey:@"title"];
    }
    if (description) {
        [body setValue:description forKey:@"description"];
    }
    if (shareMode == SohuShare) {
        [self createPortfoliosWithDic:body success:success failure:failure];
        return;
    }
    NSString * string = [NSString stringWithFormat:@"%@/photos/share",BASICURL_V1];
    [body setValue:sharetoken forKey:@"share_access_token"];
    [self setValueWith:shareMode intoDic:body];
    [body setValue:sharetoken   forKey:@"share_access_token"];
    [self postWithURL:string body:body success:success failure:failure];
}

//分享主页
+ (void)shareUserHomeWithAccesstoken:(NSString *)token ownerId:(NSString *)ownerId share_to:(shareModel)shareMode  shareAccestoken:(NSString *)sharetoken desc:(NSString *)description success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * strUrl = [NSString stringWithFormat:@"%@/users/%@/share",BASICURL_V1, ownerId];
    NSMutableDictionary * body = [NSMutableDictionary dictionaryWithCapacity:0];
    [body setValue:token forKey:@"access_token"];
    [self setValueWith:shareMode intoDic:body];
    [body setValue:sharetoken   forKey:@"share_access_token"];
    if (description) {
        [body setValue:description forKey:@"description"];
    }
    [self postWithURL:strUrl body:body success:success failure:failure];

}
//分享单个作品集
+ (void)sharePortFoliosWithAccesstoken:(NSString *)token ownerId:(NSString *)ownerId portfilosId:(NSString *)portfolisId share_to:(shareModel)shareMode  shareAccestoken:(NSString *)sharetoken desc:(NSString *)description success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * strUrl = [NSString stringWithFormat:@"%@/portfolios/%@/share",BASICURL_V1,portfolisId];
    NSMutableDictionary * body = [NSMutableDictionary dictionaryWithCapacity:0];
    [body setValue:token forKey:@"access_token"];
    [body setValue:ownerId forKey:@"owner_id"];
    [self setValueWith:shareMode intoDic:body];
    [body setValue:sharetoken forKey:@"share_access_token"];
    if (description) {
        [body setValue:description forKey:@"description"];
    }
    [self postWithURL:strUrl body:body success:success failure:failure];
}
//分享单张图片
+ (void)sharePhotoWithAccesstoken:(NSString *)token ownerId:(NSString *)ownerId portfilosId:(NSString *)portfolisId photoId:(NSString *)photoID share_to:(shareModel)shareMode  shareAccestoken:(NSString *)sharetoken desc:(NSString *)description success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * strURl = [NSString stringWithFormat:@"%@/portfolios/%@/photos/%@/share",BASICURL_V1,portfolisId,photoID];
    NSMutableDictionary * body = [NSMutableDictionary dictionaryWithCapacity:0];
    [body setValue:token forKey:@"access_token"];
    [body setValue:ownerId forKey:@"owner_id"];
    [body setValue:sharetoken forKey:@"share_access_token"];
    [self setValueWith:shareMode intoDic:body];
    if (description) {
        [body setValue:description forKey:@"description"];
    }
    [self postWithURL:strURl body:body success:success failure:failure];
}

//推荐
+ (void)getRecomendusersWithsuccess:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * strUrl = [NSString stringWithFormat:@"%@/users/recommend",BASICURL_V1];
    [self getSourceWithStringUrl:strUrl success:success failure:failure];
}

////通知
//+ (void)getNotificationsWithAccessToken:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
//{
////     GET /notifications
//    NSString * string  = [NSString stringWithFormat:@"%@/notifications",BASICURL_V1];
////    8.2 GET /notifications  获得当前用户的通知列表。
////    
////    8.3 DELETE /notifications/$notification_id  删除当前用户的某一指定通知。
//}

//反馈
+ (void)feedBackWithidea:(NSString *)idea success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure
{
    
}

@end
