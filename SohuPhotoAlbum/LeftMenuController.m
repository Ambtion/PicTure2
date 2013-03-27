//
//  LeftMenuController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//
#import "AppDelegate.h"
#import "LeftMenuController.h"

#import "LocalAlbumsController.h" //本地相册
//test
#import "LocalPhotoesController.h" //测试用

#define MENUMAXNUMBER 4
static NSString * menu[4] = {@"账号",@"本地相册",@"网络相册",@"图片墙"};

@interface LeftMenuController ()

@end

@implementation LeftMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, rect.size.width, rect.size.height)
                                              style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.sectionHeaderHeight = 32;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}

#pragma mark Delegate TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"CELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] autorelease];
    }
    if (indexPath.row < MENUMAXNUMBER)
        cell.textLabel.text = menu[indexPath.row];
    return cell;
}

#pragma mark SelectRow
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.view.userInteractionEnabled = NO;
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        if (indexPath.row == 1) {
            LocalAlbumsController * la = [[[LocalAlbumsController alloc] init] autorelease];
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:la] autorelease];
            [navApiVC.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBarBG.png"] forBarMetrics:UIBarMetricsDefault];
            self.viewDeckController.centerController = navApiVC;
        }
        if (indexPath.row == 2) {
            LocalPhotoesController * lp = [[[LocalPhotoesController alloc] init] autorelease];
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:lp] autorelease];
            [navApiVC.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBarBG.png"] forBarMetrics:UIBarMetricsDefault];
            self.viewDeckController.centerController = navApiVC;
        }
//        UIViewController * apiVC = [[[CenterController alloc] init] autorelease];
//        apiVC.title = [NSString stringWithFormat:@"第%d页面",indexPath.row];
//        CGFloat rgp = indexPath.row /4.f;
//        apiVC.view.backgroundColor = [UIColor colorWithRed:rgp green:rgp blue:rgp alpha:1.f];
//        UINavigationController *navApiVC = [[[UINavigationController alloc]
//                                             initWithRootViewController:apiVC] autorelease];
//        [navApiVC.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBarBG.png"] forBarMetrics:UIBarMetricsDefault];
//        self.viewDeckController.centerController = navApiVC;
        self.view.userInteractionEnabled = YES;
    }];
}

@end
