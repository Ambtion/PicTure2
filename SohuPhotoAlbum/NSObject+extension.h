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
@interface NSObject (extension)
- (void)showPopAlerViewRatherThentasView:(BOOL)isPopView WithMes:(NSString *)mesage;
+ (void)objectPopAlerViewRatherThentasView:(BOOL)isPopView WithMes:(NSString *)mesage;
@end
