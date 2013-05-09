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
        PopAlertView * popA = [[PopAlertView alloc] initWithTitle:mesage message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [popA show];
    }else{
        ToastAlertView * alertView = [[ToastAlertView alloc] initWithTitle:mesage];
        [alertView show];   
    }
}

+ (void)objectPopAlerViewRatherThentasView:(BOOL)isPopView WithMes:(NSString *)mesage
{
    if (isPopView) {
        PopAlertView * popA = [[PopAlertView alloc] initWithTitle:mesage message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
@end