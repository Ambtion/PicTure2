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
#import "RequestManager.h"
#import "CacheManager.h"

#define maxRow 8

static NSString * const titleOfRow[maxRow] = {@"", @"自动备份",@"仅在Wifi环境上传",@"压缩上传图片",@"清除缓存",@"意见反馈",@"为搜狐相册打分",@"检查新版本"};

@implementation SettingController
@synthesize isChangeLoginState;

- (void)viewDidLoad
{
    [super viewDidLoad];
    isInit = YES;
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1.f];
    [self.view addSubview:_myTableView];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UIButton * loginOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOutButton.frame = CGRectMake(0, 0, 250, 41);
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
    isChangeLoginState = NO;
    [self getUserInfo];
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
#pragma mark - UserInfo
- (void)getUserInfo
{
    if ([LoginStateManager isLogin]) {
        [RequestManager getUserInfoWithId:[LoginStateManager currentUserId] success:^(NSString *response) {
            userInfodic = [response JSONValue];
            [_myTableView reloadData];
        } failure:^(NSString *error) {
            
        }];
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
        if (userInfodic) {
            dataSource.userName =[NSString stringWithFormat:@"%@(@%@)", [userInfodic objectForKey:@"user_nick"],[userInfodic objectForKey:@"sname"]];
            dataSource.sizeOfAll = [[userInfodic objectForKey:@"quota"] floatValue];
            dataSource.sizeOfUsed = [[userInfodic objectForKey:@"usage"] floatValue];
        }else{
            dataSource.userName = @"用户未登陆";
            dataSource.sizeOfAll = 0.f;
            dataSource.sizeOfUsed = 0.f;
        }
        
        infoCell.dataSource = dataSource;
        return infoCell;
    }
    
    MySettingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell){
        cell = [[MySettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    //sectionTitle
    [cell setSectionTitle:[self getSectionByIndexpath:indexPath]];
    //title
    cell.c_Label.text = titleOfRow[indexPath.row];
    //detail
    cell.d_Label.text  = [self getDetaiStringByIndexpath:indexPath];
    //accestory
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
    //设置选择开关
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
        [self setDifCellSwithcByRow:indexPath.row cell:cell];
    }else{
        [cell.cusSwitch setHidden:YES];
    }
    if (indexPath.row == maxRow)
        isInit = NO;
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
            isTure  = [PerfrenceSettingManager WifiLimitedAutoUpload];
            break;
        case 3:
            isTure  = [PerfrenceSettingManager isUploadJPEGImage];
            break;
        default:
            break;
    }
    cell.cusSwitch.isTure = isTure;
    cell.delegate = self;
}

- (NSString *)getSectionByIndexpath:(NSIndexPath *)path
{
    switch (path.row) {
        case 0:
            return @"个人信息";
            break;
        case 1:
            return @"同步设置";
        case 4:
            return @"其他设置";
        default:
            break;
    }
    return nil;
}
- (NSString *)getDetaiStringByIndexpath:(NSIndexPath *)path
{
    switch (path.row) {
        case 1:
            return @"您上传的图片仅限自己查看";
            break;
        case 2:
            return @"图片自动同步时";
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
        [PerfrenceSettingManager setWifiLimited:[Aswitch isTure]];
    }
    if (path.row == 3) {
        [PerfrenceSettingManager setIsUploadJPEGImage:[Aswitch isTure]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 4: //清除缓冲
            _cache = [[PopAlertView alloc] initWithTitle:@"确认清除缓存" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [_cache show];
            break;
        case 5: //反馈
            [self.navigationController pushViewController:[[FeedBackController alloc] init] animated:YES];
            break;
        case 6: //打分
            [self rating];
            break;
        case 7: //更新
            [self onCheckVersion];
            break;
        default:
            break;
    }
}

#pragma mark AlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_cache == alertView && buttonIndex == 1)
        [CacheManager removeCacheOfImage];
    //
    if (_loginView == alertView && buttonIndex == 1) {
        isChangeLoginState = YES;
        [[UploadTaskManager currentManager] cancelAllOperation];
        [LoginStateManager logout];
    }
}

#pragma mark Rating
- (void)rating
{
    NSDictionary * dic = [self getAppInfoFromNet];
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:[dic objectForKey:@"updateURL"]]];
}
#pragma mark CheckVerSion
-(void)onCheckVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSNumber *currentVersion = [infoDic objectForKey:@"VersionCode"];
    
    NSDictionary * dic = [self getAppInfoFromNet];
    NSNumber * newVersion = [dic objectForKey:@"versionCode"];
    
    BOOL isUpata = [self CompareVersionFromOldVersion:currentVersion newVersion:newVersion];
    if (isUpata) {
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:[dic objectForKey:@"updateURL"]]];
    }else{
        [self showPopAlerViewRatherThentasView:YES WithMes:@"当前已是最新版本"];
    }
}
-(BOOL)CompareVersionFromOldVersion : (NSNumber *)oldVersion newVersion : (NSNumber *)newVersion
{
    return ([oldVersion intValue] < [newVersion intValue]);
}
- (NSDictionary *)getAppInfoFromNet
{
    NSString *URL =[NSString stringWithFormat:@"%@/version?app=ios",BASICURL_V1];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError * error = nil;
    NSData * recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    return [results JSONValue];
}
#pragma mark Login
- (void)loginOut:(id)sender
{
    if ([LoginStateManager isLogin]){
        NSString * str = nil;
        if (![[UploadTaskManager currentManager] taskList] || ![[UploadTaskManager currentManager] taskList].count) {
            str  = [NSString stringWithFormat:@"确定要登出吗?"];
        }else{
            str  = [NSString stringWithFormat:@"图片上传中,确定登出?"];
        }
        _loginView = [[PopAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [_loginView show];
    }
}
@end
