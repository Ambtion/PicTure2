//
//  UIViewController+extension.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-28.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopAlertView.h"
#import "ToastAlertView.h"
#import "MBProgressHUD.h"
@interface NSObject (extension)
- (void)showPopAlerViewnotTotasView:(BOOL)isPopView WithMes:(NSString *)mesage;
+ (void)objectPopAlerViewnotTotasView:(BOOL)isPopView WithMes:(NSString *)mesage;
@end
