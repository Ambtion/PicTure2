//
//  UIViewController+extension.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-28.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Method.h"
#import "PopAlertView.h"
#import "ToastAlertView.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface NSObject (extension)
+ (void)objectPopAlerViewRatherThentasView:(BOOL)isPopView WithMes:(NSString *)message;
- (void)showPopAlerViewRatherThentasView:(BOOL)isPopView WithMes:(NSString *)message;


- (NSString *)encodeWithBase64:(NSString *)input;
- (NSString*)decodeBase64:(NSString*)input;

#pragma mark NetWourkState
- (NetworkStatus)netWorkStatues;
- (void)showNetWorkAlertView;
- (void)postNotificationWithStr:(NSString *)str;
@end
