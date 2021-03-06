//
//  RequestManager.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "RequestManager.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import "LoginStateManager.h"
#import "PopAlertView.h"
#import "URLLibaray.h"
#import "UMAppKey.h"
#import "Reachability.h"

#define TIMEOUT 10.f

#define REQUSETFAILERROR    @"当前网络不给力,请稍后重试"
#define REQUSETSOURCEFIAL   @"访问的资源不存在"
#define REFRESHFAILTURE     @"登录过期,请重新登录"
#define INVISABLETOKEN      @"token过期,请重新绑定"

@implementation RequestManager(private)

+ (void)setValueWith:(KShareModel)shareMode intoDic:(NSMutableDictionary *)body
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


+ (BOOL)handlerequsetStatucode:(NSInteger)requsetCode withblock:(void (^) (NSString * error))failure
{
    if (requsetCode <= 300 &&requsetCode >= 200) {
        return NO;
    }
    switch (requsetCode) {
        case 401:
            [self refreshTokenWithblock:failure];
            if (failure)
                failure(REQUSETFAILERROR);
            return YES;
            break;
        case 404:
            if (failure)
                failure(REQUSETSOURCEFIAL);
            return YES;
            break;
        case 407:
            if (failure)
                failure(REQUSETSOURCEFIAL);
            return YES;
            break;
        default:
            if (failure)
                failure(REQUSETFAILERROR);
            return YES;
            break;
    }
    return YES;
}

+ (void)refreshTokenWithblock:(void (^) (NSString * error))failure
{
    if (![LoginStateManager currentToken]) return;
    NSString * str = [NSString stringWithFormat:@"%@/oauth2/access_token?grant_type=refresh_token",BASICURL_V1];
    NSMutableDictionary * body = [NSMutableDictionary dictionaryWithCapacity:0];
    [body setObject:CLIENT_ID forKey:@"client_id"];
    [body setObject:CLIENT_SECRET forKey:@"client_secret"];
    [body setObject:[LoginStateManager currentToken] forKey:@"refresh_token"];
    [self getWithUrlStr:str andMethod:@"POST" body:body asynchronou:YES success:^(NSString *response) {
        NSDictionary * dic = [response JSONValue];
        if ([dic objectForKey:@"access_token"]) {
            [LoginStateManager refreshToken:[NSString stringWithFormat:@"%@",[dic objectForKey:@"access_token"]] RefreshToken:[NSString stringWithFormat:@"%@",[dic objectForKey:@"refresh_token"]]];
        }else{
            [LoginStateManager logout];
            if (failure)
                failure(REFRESHFAILTURE);
        }
    } failure:^(NSString *error) {
        [LoginStateManager logout];
        if (failure)
            failure(REFRESHFAILTURE);
    }];
}

+ (void)getWithUrlStr:(NSString *)strUrl andMethod:(NSString *)method body:(NSDictionary *)body asynchronou:(BOOL)asy success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]]; //开启缓冲
    [request setCachePolicy:ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setRequestMethod:method];
    [request setTimeOutSeconds:TIMEOUT];
    [request setStringEncoding:NSUTF8StringEncoding];
    for (id key in [body allKeys])
        [request setPostValue:[body objectForKey:key] forKey:key];
    __weak ASIFormDataRequest * weakSelf = request;
    [request setCompletionBlock:^{
        DLog(@"url :%@ code :%d",weakSelf.url,[weakSelf responseStatusCode]);
        NSInteger code = [weakSelf responseStatusCode];
        if (![self handlerequsetStatucode:code withblock:failure]) {
            success([weakSelf responseString]);
        }
    }];
    [request setFailedBlock:^{
        DLog(@"failturl :%@ :%d %@",weakSelf.url,[weakSelf responseStatusCode],[weakSelf responseString]);
        [self handlerequsetStatucode:[weakSelf responseStatusCode] withblock:failure];
    }];
    if (asy)
        [request startAsynchronous];
    else
        [request startSynchronous];
}
#pragma mark GET
+ (void)getSourceWithStringUrl:(NSString * )strUrl asynchronou:(BOOL)asy success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    [self getWithUrlStr:strUrl andMethod:@"GET" body:nil asynchronou:asy success:success failure:failure];
}

#pragma mark POST
+ (void)postWithURL:(NSString *)strUrl body:(NSDictionary *)body success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    [self getWithUrlStr:strUrl andMethod:@"POST" body:body asynchronou:YES success:success failure:failure];
}

#pragma mark DELETE
+ (void)deleteSoruce:(NSString * )strUrl success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    [self getWithUrlStr:strUrl andMethod:@"DELETE" body:nil asynchronou:YES success:success failure:failure];
}
@end


@implementation RequestManager

//时间轴获取
+ (void)getTimeStructWithAccessToken:(NSString *)token withtime:(NSString *)beforeTime asynchronou:(BOOL)asy success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString *  str = nil;
    if (beforeTime) {
        str =  [NSString stringWithFormat:@"%@/sync_photos/infos?access_token=%@&before=%@",BASICURL_V1,token,beforeTime];
    }else{
        str =  [NSString stringWithFormat:@"%@/sync_photos/infos?access_token=%@",BASICURL_V1,token];
    }
    [self getSourceWithStringUrl:str asynchronou:asy success:success  failure:failure];
}
+ (void)getTimePhtotWithAccessToken:(NSString *)token day:(NSString *)days success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"%@/sync_photos?access_token=%@&day=%@",BASICURL_V1,token,days];
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
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

//网络相册
+ (void)getFoldersWithAccessToken:(NSString *)token start:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"%@/folders?access_token=%@&start=%d&count=%d",BASICURL_V1,token,start,count];
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}
+ (void)deleteFoldersWithAccessToken:(NSString *)token folderId:(NSString *)folderId success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"%@/folders/%@?access_token=%@",BASICURL_V1,folderId,token];
    [self deleteSoruce:str success:success failure:failure];
}

//网络图片
+ (void)getfoldersPicWithAccessToken:(NSString *)token folderId:(NSString*)folderId start:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"%@/photos?access_token=%@&folder_id=%@&start=%d&count=%d",BASICURL_V1,token,folderId,start,count];
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}
+ (void)deleteFoldersPhotosWithAccessToken:(NSString *)token folderId:(NSString *)folderId  photos:(NSArray *)photosArray success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * photoIds = [photosArray componentsJoinedByString:@","];
    NSString * str = [NSString stringWithFormat:@"%@/photos/destroy?access_token=%@&folder_id=%@&photo_ids=%@",BASICURL_V1,token,folderId,photoIds];
    [self postWithURL:str body:nil success:success failure:failure];
}
//图片墙
#pragma mark -
+ (void)getTimePhtotWallStorysWithOwnerId:(NSString *)ownId withAccessToken:(NSString *)token start:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = nil;
    if (token && [LoginStateManager isLogin]) {
        str = [NSString stringWithFormat:@"%@/portfolios?owner_id=%@&start=%d&count=%d&access_token=%@",BASICURL_V1,ownId,start,count,token];
    }else{
        str = [NSString stringWithFormat:@"%@/portfolios?owner_id=%@&start=%d&count=%d",BASICURL_V1,ownId,start,count];
    }
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
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
    if ([LoginStateManager isLogin]) {
        str  = [NSString stringWithFormat:@"%@/portfolios/%@/photos?owner_id=%@&start=%d&count=%d&access_token=%@",
                BASICURL_V1,storyId,ownId,start,count,[LoginStateManager currentToken]];
        
    }else{
        str = [NSString stringWithFormat:@"%@/portfolios/%@/photos?owner_id=%@&start=%d&count=%d",
               BASICURL_V1,storyId,ownId,start,count];
        
    }
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
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
//    //从第一也开始,变成从0开始
//    page++;
    NSString * soure = (type == KSourcePhotos ? @"photos":@"portfolios");
    NSString * str = [NSString stringWithFormat:@"%@/%@/%@/comments?page=%d",BASICURL_V1,soure,srouceId,page];
    DLog(@"%@",soure);
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
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
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:nil];
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
+ (void)sharePhotosWithAccesstoken:(NSString *)token photoIDs:(NSArray *)photos_Ids share_to:(KShareModel)shareMode  shareAccestoken:(NSString *)sharetoken optionalTitle:(NSString *)title desc:(NSString *)description success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
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
+ (void)shareUserHomeWithAccesstoken:(NSString *)token ownerId:(NSString *)ownerId share_to:(KShareModel)shareMode  shareAccestoken:(NSString *)sharetoken desc:(NSString *)description success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * strUrl = [NSString stringWithFormat:@"%@/users/%@/share",BASICURL_V1, ownerId];
    NSMutableDictionary * body = [NSMutableDictionary dictionaryWithCapacity:0];
    [body setValue:token forKey:@"access_token"];
    [self setValueWith:shareMode intoDic:body];
    [body setValue:sharetoken   forKey:@"share_access_token"];
    if (description) {
        [body setValue:description forKey:@"description"];
    }
    DLog(@"%@",strUrl);
    [self postWithURL:strUrl body:body success:success failure:failure];
    
}
//分享单个作品集
+ (void)sharePortFoliosWithAccesstoken:(NSString *)token ownerId:(NSString *)ownerId portfilosId:(NSString *)portfolisId share_to:(KShareModel)shareMode  shareAccestoken:(NSString *)sharetoken desc:(NSString *)description success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
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
////分享单张图片
//+ (void)sharePhotoWithAccesstoken:(NSString *)token ownerId:(NSString *)ownerId portfilosId:(NSString *)portfolisId photoId:(NSString *)photoID share_to:(KShareModel)shareMode  shareAccestoken:(NSString *)sharetoken desc:(NSString *)description success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
//{
//
//    NSString * strURl = [NSString stringWithFormat:@"%@/portfolios/%@/photos/%@/share",BASICURL_V1,portfolisId,photoID];
//    NSMutableDictionary * body = [NSMutableDictionary dictionaryWithCapacity:0];
//    [body setValue:token forKey:@"access_token"];
//    [body setValue:ownerId forKey:@"owner_id"];
//    [body setValue:sharetoken forKey:@"share_access_token"];
//    [self setValueWith:shareMode intoDic:body];
//    if (description) {
//        [body setValue:description forKey:@"description"];
//    }
//    [self postWithURL:strURl body:body success:success failure:failure];
//
//}

//推荐
+ (void)getRecomendusersWithsuccess:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * strUrl = [NSString stringWithFormat:@"%@/users/recommend",BASICURL_V1];
    [self getSourceWithStringUrl:strUrl asynchronou:YES success:success failure:failure];
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


//三方分享
+ (void)sharePhoto:(UIImage *)image share_to:(KShareModel)shareMode   desc:(NSString *)description success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    CGFloat cpmpress = 1.f;
    switch (shareMode) {
        case QQShare:
            [self sharePhoto:image ToQQwithDes:description compressionQuality:cpmpress success:success failure:failure];
            break;
        case RenrenShare:
            [self sharePhoto:image ToRenRenwithDes:description compressionQuality:cpmpress success:success failure:failure];
            break;
        case SinaWeiboShare:
            [self sharePhoto:image ToSinawithDes:description compressionQuality:cpmpress success:success failure:failure];
            break;
        default:
            break;
    }
}
+ (void)sharePhoto:(UIImage*)image ToQQwithDes:(NSString *)des compressionQuality:(CGFloat)compress  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://graph.qq.com/photo/upload_pic"]];
    [request setPostValue:[[LoginStateManager getTokenInfo:QQShare] objectForKey:@"access_token"] forKey:@"access_token"];
    [request setPostValue:@"100319476" forKey:@"oauth_consumer_key"];
    [request setPostValue:[[LoginStateManager getTokenInfo:QQShare] objectForKey:@"openid"] forKey:@"openid"];
    [request setPostValue:@1 forKey:@"mobile"];
    [request setPostValue:des forKey:@"photodesc"];
    NSData * data = UIImageJPEGRepresentation(image, compress);
    [request setData:data forKey:@"picture"];
    __weak ASIFormDataRequest * weakSelf = request;
    
    [request setCompletionBlock:^{
        NSInteger ret = [[[[weakSelf responseString] JSONValue] objectForKey:@"ret"] integerValue];
        if (!ret) {
            success(nil);
        }else if( (ret>= 100013 && ret >= 100016) || ret == 9016 ||
                 ret == 9017 || ret == 9018 || ret == 9094 || ret == 41003){
            failure(@"token失效,请重新认证");
        }else{
            failure(@"分享失败");
        }
    }];
    [request setFailedBlock:^{
        failure(@"连接失败,请重新分享");
    }];
    [request startAsynchronous];
    
}
+ (void)sharePhoto:(UIImage*)image ToRenRenwithDes:(NSString *)des compressionQuality:(CGFloat)compress  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    //renren
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://api.renren.com/restserver.do"]];
    [request setPostValue:@"1.0"forKey:@"v"];
    [request setPostValue:[[LoginStateManager getTokenInfo:RenrenShare] objectForKey:@"access_token"] forKey:@"access_token"];
    [request setPostValue:@"JSON" forKey:@"format"];
    [request setPostValue:@"photos.upload" forKey:@"method"];
    [request setPostValue:des forKey:@"caption"];
    NSData * data = UIImageJPEGRepresentation(image, compress);
    [request setData:data withFileName:@"1.jpg" andContentType:@"image/jpg" forKey:@"upload"];
    __weak ASIFormDataRequest * weakSelf = request;
    [request setCompletionBlock:^{
        NSDictionary * dic = [[weakSelf responseString] JSONValue];
        NSNumber *errorCode = [dic objectForKey:@"error_code"];
        if (!errorCode) {
            success(nil);
        }else{
            DLog(@"%@",dic);
            NSInteger code = [errorCode integerValue];
            if (code == 2001 || code == 2002) {
                failure(@"token失效,请重新认证");
            }else{
                failure(@"分享失败");
            }
        }
    }];
    [request setFailedBlock:^{
        failure(@"连接失败,请重新分享");
    }];
    [request startAsynchronous];
    
}

+ (void)sharePhoto:(UIImage*)image ToSinawithDes:(NSString *)des compressionQuality:(CGFloat)compress  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://upload.api.weibo.com/2/statuses/upload.json"]];
    [request setPostValue:[[LoginStateManager getTokenInfo:SinaWeiboShare] objectForKey:@"access_token"] forKey:@"access_token"];
    if (!des || [des isEqualToString:@""])  des = @"#搜狐相机伴侣#";
    [request setPostValue:des forKey:@"status"];
    [request setPostValue:@0 forKey:@"visible"];
    NSData * data  = UIImageJPEGRepresentation(image, compress);
    [request setData:data forKey:@"pic"];
    __weak ASIFormDataRequest * weakSelf = request;
    [request setCompletionBlock:^{
        NSDictionary * dic = [[weakSelf responseString] JSONValue];
        NSNumber *errorCode = [dic objectForKey:@"error_code"];
        if (!errorCode) {
            success(nil);
        }else{
            NSInteger code = [errorCode integerValue];
            if ((code >= 21314 && code <= 21319 )|| code == 21327 || code == 21332) {
                failure(@"token失效,请重新认证");
            }else{
                failure(@"分享失败");
            }
        }
    }];
    [request setFailedBlock:^{
        failure(@"连接失败,请重新分享");
    }];
    [request startAsynchronous];
    
}
@end
