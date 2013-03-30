//
//  BaseNaviController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-29.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "BaseNaviController.h"

@interface BaseNaviController ()

@end

@implementation BaseNaviController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationBar.frame = CGRectMake(0, 20, 320, 44);
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    self.navigationBar.frame = CGRectMake(0, 20, 320, 44);
}
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray * array = [super popToRootViewControllerAnimated:animated];
    self.navigationBar.frame = CGRectMake(0, 20, 320, 44);
    return array;
}
-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    id ob = [super popViewControllerAnimated:animated];\
    self.navigationBar.frame = CGRectMake(0, 20, 320, 44);
    return ob;
}
@end
