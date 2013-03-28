//
//  BaseViewController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "BaseViewController.h"

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
    if (_cusBar.superview)
        [_cusBar removeFromSuperview];
}
- (void)viewDidDisappear:(BOOL)animated
{
    if (_cusBar.superview)
        [_cusBar removeFromSuperview];
}
- (void)cusNavigationBar:(CusNavigationBar *)bar buttonClick:(UIButton *)button
{
    //for reload
}
@end
