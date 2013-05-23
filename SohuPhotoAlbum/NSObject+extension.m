//
//  UIViewController+extension.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-28.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "NSObject+extension.h"
#import "GTMBase64.h"

@implementation NSObject (extension)
#pragma mark ShowAlert
- (void)showPopAlerViewRatherThentasView:(BOOL)isPopView WithMes:(NSString *)mesage
{
    if (isPopView) {
        PopAlertView * popA = [[PopAlertView alloc] initWithTitle:nil message:mesage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [popA show];
    }else{
        ToastAlertView * alertView = [[ToastAlertView alloc] initWithTitle:mesage];
        [alertView show];   
    }
}

+ (void)objectPopAlerViewRatherThentasView:(BOOL)isPopView WithMes:(NSString *)mesage
{
    if (isPopView) {
        PopAlertView * popA = [[PopAlertView alloc] initWithTitle:nil message:mesage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [popA show];
    }else{
        ToastAlertView * alertView = [[ToastAlertView alloc] initWithTitle:mesage];
        [alertView show];
    }
}

- (NSString *)encodeWithBase64:(NSString *)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //转换到base64
    data = [GTMBase64 encodeData:data];
    NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

- (NSString*)decodeBase64:(NSString*)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //转换到base64
    data = [GTMBase64 decodeData:data];
    NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

#pragma mark - 
- (NetworkStatus)netWorkStatues
{
    Reachability * reachability;
    NetworkStatus  status;
    reachability = [Reachability reachabilityForLocalWiFi];
    status       = [reachability currentReachabilityStatus];
    return  status;
}
- (void)showNetWorkAlertView
{
    PopAlertView * alerView = [[PopAlertView alloc] initWithTitle:nil message:@"您当前网络环境不是wifi,上传终止,请到设置中确认允许3G上传" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alerView show];
    [[UploadTaskManager currentManager] cancelAllOperation];
}
- (void)postNotification
{
    DLog(@"%s",__FUNCTION__);
    //chuagjian一个本地推送
    UILocalNotification * noti = [[UILocalNotification alloc] init];
    //设置时区
    noti.timeZone = [NSTimeZone defaultTimeZone];
    //设置重复间隔
    noti.repeatInterval = NSWeekCalendarUnit;
    //推送声音
    noti.soundName = UILocalNotificationDefaultSoundName;
    //内容
    noti.alertBody = @"您当前网络环境不是wifi,上传终止,请到设置中确认允许3G上传";
    //显示在icon上的红色圈中的数子
    //设置userinfo 方便在之后需要撤销的时候使用
    NSDictionary * infoDic = [NSDictionary dictionaryWithObject:@"name" forKey:@"key"];
    noti.userInfo = infoDic;
    //添加推送到uiapplication
    UIApplication *app = [UIApplication sharedApplication];
    [app scheduleLocalNotification:noti];
}
@end