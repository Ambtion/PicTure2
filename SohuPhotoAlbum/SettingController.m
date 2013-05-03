//
//  SettingController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-22.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "SettingController.h"
#import "PerfrenceSettingManager.h"
#import "UserInfoCell.h"
#import "FeedBackController.h"

#define maxRow 7
static NSString * const titleOfRow[maxRow] = {@"", @"自动备份",@"压缩上传图片",@"清楚缓冲",@"意见反馈",@"为搜狐相册打分",@"检测更新"};\
@implementation SettingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1.f];
    [self.view addSubview:_myTableView];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UIButton * loginOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOutButton.frame = CGRectMake(0, 0, 115, 41);
    [loginOutButton addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchUpInside];
    [loginOutButton setImage:[UIImage imageNamed:@"loginOut.png"] forState:UIControlStateNormal];
    [view addSubview:loginOutButton];
    loginOutButton.center = CGPointMake(160, 32);
    _myTableView.tableFooterView = view;
    
    _navBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navBar_signalLine.png"]];
    _navBar.frame = CGRectMake(0, 0, 320, 45);
    [_navBar setUserInteractionEnabled:YES];
    //返回按钮
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(cancelLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_navBar addSubview:backButton];
}

#pragma mark View lifeCircle
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_navBar removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated
{
    if (_navBar && !_navBar.superview)
        [self.navigationController.navigationBar addSubview:_navBar];
}
- (void)cancelLogin:(UIButton *)button
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.presentingViewController) {
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    }
    if ([_delegate respondsToSelector:@selector(settingControllerDidDisappear:)]) {
        [_delegate settingControllerDidDisappear:self];
    }
}

#pragma mark Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return maxRow;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row) {
        return 130;
    }else{
        return [self getSectionByIndexpath:indexPath] ? 85 : 55;
    }
    return 55.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row) {
        UserInfoCell * infoCell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
        if (!infoCell) {
            infoCell = [[UserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
        }
        UserInfoCellDataSource * dataSource = [[UserInfoCellDataSource alloc] init];
        dataSource.userName = @"afdkadfa@qq.com";
        dataSource.sizeOfAll = 5.f;
        dataSource.sizeOfUsed = 1.234235f;
        infoCell.dataSource = dataSource;
        return infoCell;
    }
    MySettingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell){
        cell = [[MySettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        cell.delegate = self;
    }
    [cell setSectionTitle:[self getSectionByIndexpath:indexPath]];
    cell.c_Label.text = titleOfRow[indexPath.row];

    if (indexPath.row == 4) {
        [cell.accessoryImage setHidden:NO];
    }else{
        [cell.accessoryImage setHidden:YES];
    }
    if (indexPath.row == 3) {
        [cell.lineImageView setHidden:YES];
    }else{
        [cell.lineImageView setHidden:NO];
    }
    if (indexPath.row == 1 || indexPath.row == 2) {
        [self setDifCellSwithcByRow:indexPath.row cell:cell];
    }else{
        [cell.cusSwitch setHidden:YES];

    }
    return cell;
}
- (void)setDifCellSwithcByRow:(NSInteger)row cell:(MySettingCell *)cell
{
    [cell.cusSwitch setHidden:NO];
    BOOL isTure = NO;
    switch (row) {
        case 1:
            isTure  = [PerfrenceSettingManager isAutoUpload];
            break;
        case 2:
            isTure  = [PerfrenceSettingManager isUploadJPEGImage];
            break;
        default:
            break;
    }
    cell.cusSwitch.isTure = isTure;
}
- (NSString *)getSectionByIndexpath:(NSIndexPath *)path
{
    switch (path.row) {
        case 0:
            return @"个人信息";
            break;
        case 1:
            return @"同步设置";
//        case 4:
//            return @"分享设置";
        case 4:
            return @"其他设置";
        default:
            break;
    }
    return nil;
}

#pragma mark  Action
- (void)mySettingCell:(MySettingCell *)cell didSwitchValueChange:(CusSwitch *)Aswitch
{
    NSIndexPath * path = [_myTableView indexPathForCell:cell];
    if (path.row == 1 ) {
        [PerfrenceSettingManager setIsAutoUpload:[Aswitch isTure]];
    }
    if (path.row == 2) {
        DLog(@"%d",[Aswitch isTure]);
        [PerfrenceSettingManager setIsUploadJPEGImage:[Aswitch isTure]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 4:
            [self.navigationController pushViewController:[[FeedBackController alloc] init] animated:YES];
            break;
            
        default:
            break;
    }
}
- (void)loginOut:(id)sender
{
    if ([LoginStateManager isLogin])
        [LoginStateManager logout];
}
@end
