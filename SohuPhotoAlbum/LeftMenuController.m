//
//  LeftMenuController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//
#import "AppDelegate.h"
#import "LeftMenuController.h"
#import "LocalALLPhotoesController.h" //本地相册
#import "AccountCell.h"
#import "MenuCell.h"

#import "LocalAlbumsController.h" //测试用

#define MENUMAXNUMBER 5

static NSString * menuText[5] = {@"账号",@"本地相册",@"云备份",@"分享历史",@"设置"};
static NSString * image[5]  ={@"",@"LocalPhoto.png",@"cloundPhoto.png",@"shareHistory.png",@"setting.png"};

@implementation LeftMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    //控制statuBar
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.f, rect.size.width, rect.size.height)
                                              style:UITableViewStylePlain];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.sectionHeaderHeight = 32;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    UIImageView * bgView = [[[UIImageView alloc] initWithFrame:_tableView.bounds] autorelease];
    bgView.image = [UIImage imageNamed:@"menuBackground.png"];
    [self.view addSubview:bgView];
    [self.view addSubview:_tableView];
}

#pragma mark Delegate TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row) {
        return 40.f;
    }
    return 48.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"CELL";
    static NSString * accout = @"AccountCELL";
    if (!indexPath.row) {
        AccountCell * cell = [tableView dequeueReusableCellWithIdentifier:accout];
        if (!cell)
            cell = [[[AccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:accout] autorelease];
        cell.labelText.text = @"账号";
        return cell;
    }
    MenuCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] autorelease];
    }
    if (indexPath.row < MENUMAXNUMBER){
        cell.leftImage.image = [UIImage imageNamed:image[indexPath.row]];
        cell.labelText.text = menuText[indexPath.row];
    }
    return cell;
}

#pragma mark SelectRow
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.view.userInteractionEnabled = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        if (indexPath.row == 1) {
            LocalALLPhotoesController * la = [[[LocalALLPhotoesController alloc] init] autorelease];
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:la] autorelease];
            [navApiVC.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBarBG.png"] forBarMetrics:UIBarMetricsDefault];
            self.viewDeckController.centerController = la;
        }
        if (indexPath.row == 2) {
            LocalAlbumsController * lp = [[[LocalAlbumsController alloc] init] autorelease];
            UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:lp] autorelease];
            [navApiVC.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBarBG.png"] forBarMetrics:UIBarMetricsDefault];
            self.viewDeckController.centerController = lp;
        }
        self.view.userInteractionEnabled = YES;
    }];
}

@end
