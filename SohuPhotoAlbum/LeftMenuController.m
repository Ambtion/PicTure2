//
//  LeftMenuController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//
#import "LeftMenuController.h"

#define MENUMAXNUMBER 4

static NSString * menuText[4] = {@"本地相册",@"云备份",@"分享历史",@"设置"};
static NSString * image[4]  ={@"LocalPhoto.png",@"cloundPhoto.png",@"shareHistory.png",@"setting.png"};

@implementation LeftMenuController
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    //bgView
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:_tableView.bounds];
    bgView.image = [UIImage imageNamed:@"menuBackground.png"];
    
    [self.view addSubview:bgView];
    
    //accoutView
    _accountView = [[AccountView alloc] initWithFrame:CGRectMake(0, 0, 320, 48.f)];
    _accountView.delegate = self;
    [self.view addSubview:_accountView];
    
    //控制statuBar
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0,48.f, rect.size.width, rect.size.height)
                                              style:UITableViewStylePlain];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}
- (void)setAccountView
{
    //暂时写着
    _accountView.desLabel.text = [LoginStateManager isLogin] ? @"账号已经登陆" : @"请登录账号";
}
#pragma mark Delegate TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"CELL";
    
    MenuCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
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
            LoginViewController * lv = [[LoginViewController alloc] init];
            lv.delegate = self;
            [self presentModalViewController:lv animated:YES];
        }
        return;
    }
    self.view.userInteractionEnabled = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        
        if (indexPath.row == 1) {
            LocalALLPhotoesController * la = [[LocalALLPhotoesController alloc] init];
            self.viewDeckController.centerController = la;
        }
        if (indexPath.row == 3) {
            PhotoWallController * lp = [[PhotoWallController alloc] init];
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
#pragma mark AccoutViewDelgate
- (void)accountView:(AccountView *)acountView accessoryClick:(id)sender
{
    DLog(@"%s",__FUNCTION__);
}
- (void)accountView:(AccountView *)acountView setttingClick:(id)sender
{
    DLog(@"%s",__FUNCTION__);
}
@end
