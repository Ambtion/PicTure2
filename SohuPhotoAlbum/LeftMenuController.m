//
//  LeftMenuController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//
#import "LeftMenuController.h"
#import "RequestManager.h"
#import "UIImageView+WebCache.h"

#define MENUMAXNUMBER 4

static NSString *   menuText[4] =   {@"本地相册",@"云备份",@"分享历史",@"星用户"};
static NSString *   image[4]    =   {@"localPhoto.png",@"cloundPhoto.png",@"shareHistory.png",@"hotUser.png"};

@implementation LeftMenuController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    //bgView
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"menuBackground.png"];
    [self.view addSubview:bgView];
    
    UIImageView * logoText = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 59, 320, 59)];
    logoText.image = [UIImage imageNamed:@"logoText.png"];
    [self.view addSubview:logoText];
    
    //控制statuBar
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0 ,60.f, rect.size.width, rect.size.height)
                                              style:UITableViewStylePlain];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    //三方登陆绑定页面
    _oauthorBindView = [[OauthirizeView alloc] initWithFrame:CGRectMake(0, 48, 320, 0)];
    [_oauthorBindView addtarget:self action:@selector(oauthorizeButtonClick:)];
    [self.view addSubview:_oauthorBindView];
    //accoutView
    _accountView = [[AccountView alloc] initWithFrame:CGRectMake(0, 0, 320, 63.f)];
    _accountView.delegate = self;
    [self setAccountView];
    [self.view addSubview:_accountView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setAccountView];
    [_tableView reloadData];
}

#pragma mark AccoutView
- (void)setAccountView
{
    //暂时写着
    if (![LoginStateManager isLogin]) {
        _accountView.portraitImageView.imageView.image = [UIImage imageNamed:@"1.jpg"];
        _accountView.nameLabel.text =  @"请登录账号";
        _accountView.desLabel.text = nil;
    }else{
        [RequestManager getUserInfoWithToken:[LoginStateManager currentToken] success:^(NSString *response) {
        NSDictionary * dic = [response JSONValue];
            [_accountView.portraitImageView.imageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"user_icon"]] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
            _accountView.desLabel.text  = [NSString stringWithFormat:@"@%@",[dic objectForKey:@"sname"]];
            _accountView.nameLabel.text = [dic objectForKey:@"user_nick"];
        } failure:^(NSString *error) {
            
        }];
    }
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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}
#pragma mark Selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.view.userInteractionEnabled = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row) {
        if (![LoginStateManager isLogin]) {
            [self accountView:nil fullScreenClick:nil];
            self.view.userInteractionEnabled = YES;
            return;
        }
    }
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        if (indexPath.row == 0) {
            LocalALLPhotoesController * la = [[LocalALLPhotoesController alloc] init];
            self.viewDeckController.centerController = la;
        }
        if (indexPath.row == 1) {
            CloudPictureController * cp = [[CloudPictureController alloc] init];
            self.viewDeckController.centerController = cp;
        }
        if (indexPath.row == 2) {
            PhotoWallController * lp = [[PhotoWallController alloc] initWithOwnerID:[LoginStateManager currentUserId]];
            self.viewDeckController.centerController = lp;
        }
        if (indexPath.row == 3) {
            HostUserController * hs = [[HostUserController alloc] init];
            self.viewDeckController.centerController = hs;
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
    [self setAccountView];
    [self dismissModalViewControllerAnimated:YES];
    [self.viewDeckController toggleLeftViewAnimated:NO];
}

#pragma mark - Delegate of SetttingControlelr
- (void)settingControllerDidDisappear:(SettingController *)controller
{
    [self.viewDeckController toggleLeftViewAnimated:NO];
}

#pragma mark -  AccoutViewDelgate
- (void)accountView:(AccountView *)acountView fullScreenClick:(id)sender
{
    if ([LoginStateManager isLogin]) {
        [LoginStateManager logout];
        [self setAccountView];
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            LocalALLPhotoesController * la = [[LocalALLPhotoesController alloc] init];
            self.viewDeckController.centerController = la;
            self.view.userInteractionEnabled = YES;
        }];
    }else{
        LoginViewController * lv = [[LoginViewController alloc] init];
        lv.delegate = self;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:lv];
        [self presentModalViewController:nav animated:YES];
    }
}
- (void)accountView:(AccountView *)acountView accessoryClick:(id)sender
{
    if (![LoginStateManager isLogin]) {
        LoginViewController * lv = [[LoginViewController alloc] init];
        lv.delegate = self;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:lv];
        [self presentModalViewController:nav animated:YES];
        return;
    }
    UIButton * accessory = (UIButton *)sender;
    CGAffineTransform transfrom1 = CGAffineTransformRotate(accessory.transform,M_PI);
    [UIView animateWithDuration:0.3 animations:^{
        accessory.transform = transfrom1;
    } completion:^(BOOL finished) {
        
    }];
    if ([self isHiddenOAuthorView]) {
        [self showOAuthorView];
    }else{
        [self hideOAuthorView];
    }
}
- (void)accountView:(AccountView *)acountView setttingClick:(id)sender
{
    SettingController * sc = [[SettingController alloc] init];
    sc.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:sc];
    [self presentModalViewController:nav animated:YES];
}
#pragma mark oauthorize Action
- (void)oauthorizeButtonClick:(UIButton *)button
{
    DLog(@"%d",button.tag);
}
#pragma mark OauthorViews
- (void)showOAuthorView
{
    [self.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.3 animations:^{
        _oauthorBindView.frame = CGRectMake(0, 48, 320, 320);
    } completion:^(BOOL finished) {
        [self.view setUserInteractionEnabled:YES];
    }];
}
- (void)hideOAuthorView
{
    [self.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.3 animations:^{
        _oauthorBindView.frame = CGRectMake(0, 48, 320, 0);
    } completion:^(BOOL finished) {
        [self.view setUserInteractionEnabled:YES];
    }];
}
- (BOOL)isHiddenOAuthorView
{
    return _oauthorBindView.frame.size.height == 0;
}

@end
