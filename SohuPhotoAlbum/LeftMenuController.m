//
//  LeftMenuController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//
#import "LeftMenuController.h"


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
    _tableView.scrollEnabled = YES;
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
        _accountCell = [tableView dequeueReusableCellWithIdentifier:accout];
        if (!_accountCell)
            _accountCell = [[[AccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:accout] autorelease];
        _accountCell.labelText.text = [LoginStateManager isLogin] ? @"账号已经登陆" : @"请登录账号";
        return _accountCell;
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

#pragma mark Selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) { //登陆
        if ([LoginStateManager isLogin]) {
            [LoginStateManager logout];
            [_tableView reloadData];
        }else{
            LoginViewController * lv = [[[LoginViewController alloc] init] autorelease];
            lv.delegate = self;
            [self presentModalViewController:lv animated:YES];
        }
        return;
    }
    self.view.userInteractionEnabled = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        
        if (indexPath.row == 1) {
            LocalALLPhotoesController * la = [[[LocalALLPhotoesController alloc] init] autorelease];
            self.viewDeckController.centerController = la;
        }
        if (indexPath.row == 3) {
            PhotoWallController * lp = [[[PhotoWallController alloc] init] autorelease];
            self.viewDeckController.centerController = lp;
        }
        self.view.userInteractionEnabled = YES;
    }];
}
#pragma mark - Delegate of LoginViewController
- (void)loginViewController:(LoginViewController *)loginController cancleClick:(id)sender
{
    [self.viewDeckController toggleLeftViewAnimated:NO];
}
- (void)loginViewController:(LoginViewController *)loginController loginSucessWithinfo:(NSDictionary *)sucessInfo
{
    _accountCell.labelText.text = [LoginStateManager isLogin] ? @"账号已经登陆" : @"请登录账号";
    [self dismissModalViewControllerAnimated:YES];
    [self.viewDeckController toggleLeftViewAnimated:NO];

}
@end
