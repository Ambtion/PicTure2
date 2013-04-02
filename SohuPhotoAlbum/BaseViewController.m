//
//  BaseViewController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
//#import "BaseNaviController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)dealloc
{
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self) {
        _viewState = NomalState;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
}
- (void)viewDidDisappear:(BOOL)animated
{
    if (_cusBar.superview){
        [UIView animateWithDuration:0.0 animations:^{
            [_cusBar removeFromSuperview];
        }];
    }
}
- (void)cusNavigationBar:(CusNavigationBar *)bar buttonClick:(UIButton *)button
{
    //for reload
}
- (CGRect)subTableViewRect
{
//    NSLog(@"subTableViewRect:%@",NSStringFromCGRect(self.view.frame));
    CGRect rect = self.view.bounds;
    rect.size.height -= 44;
    return rect;
}
@end
