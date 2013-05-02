//
//  UIViewController+extension.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-28.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "UIViewController+extension.h"

@implementation UIViewController (extension)
#pragma mark ShowAlert
- (void)showPopAlerViewnotTotasView:(BOOL)isPopView WithMes:(NSString *)mesage
{
    if (isPopView) {
        PopAlertView * popA = [[PopAlertView alloc] initWithTitle:mesage message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [popA show];
    }else{
        ToastAlertView * alertView = [[ToastAlertView alloc] initWithTitle:mesage];
        [alertView show];
    }
}
@end
