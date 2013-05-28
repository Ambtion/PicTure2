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

static NSString *   menuText[5] =   {@"本地相册",@"云备份",@"图片墙",@"星用户",@"通知"};
static NSString *   image[5]    =   {@"localPhoto.png",@"cloundPhoto.png",@"shareHistory.png",@"hotUser.png",@"hotUser.png"};

@implementation LeftMenuController
@synthesize localAllController;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    //bgView
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"menuBackground.png"];
    [self.view addSubview:bgView];
    
    UIImageView * logoText = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 69, 320, 59)];
    logoText.image = [UIImage imageNamed:@"logoText.png"];
    [self.view addSubview:logoText];
    
    //控制statuBar
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0,60.f, rect.size.width, rect.size.height)
                                              style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView reloadData];
    
    //三方登陆绑定页面
    _oauthorBindView = [[OauthirizeView alloc] initWithFrame:CGRectMake(0, 48, 320, 0)];
    _oauthorBindView.frame = CGRectMake(0, -(self.view.frame.size.height- 48) , 320, 0);
    [_oauthorBindView addtarget:self action:@selector(oauthorizeButtonClick:)];
    [self.view addSubview:_oauthorBindView];
    //accoutView
    _accountView = [[LeftAccountView alloc] initWithFrame:CGRectMake(0, 0, 320, 63.f)];
    _accountView.delegate = self;
    [self setAccountView];
    [self.view addSubview:_accountView];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setAccountView];
    [_tableView reloadData];
    if (!_selectPath)
        _selectPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView selectRowAtIndexPath:_selectPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
}
#pragma mark AccoutView
- (void)setAccountView
{
    //暂时写着
    if (![LoginStateManager isLogin]) {
        _accountView.portraitImageView.imageView.image = [UIImage imageNamed:@"nicheng.png"];
        _accountView.nameLabel.text =  @"请登录账号";
        _accountView.desLabel.text = nil;
    }else{
        [RequestManager getUserInfoWithId:[LoginStateManager currentUserId] success:^(NSString *response) {
            NSDictionary * dic = [response JSONValue];
            [_accountView.portraitImageView.imageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"user_icon"]] placeholderImage:[UIImage imageNamed:@"nicheng.png"]];
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
    return MENUMAXNUMBER;
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
    //    self.view.userInteractionEnabled = NO;
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectPath = indexPath;
    if (indexPath.row && indexPath.row != 3) {
        if (![LoginStateManager isLogin]) {
            [self accountView:nil fullScreenClick:nil];
            self.view.userInteractionEnabled = YES;
            return;
        }
    }
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        if (indexPath.row == 0) {
            self.viewDeckController.centerController = localAllController;
        }
        if (indexPath.row == 1) {
            CloudPictureController * cp = [[CloudPictureController alloc] init];
            self.viewDeckController.centerController = cp;
        }
        if (indexPath.row == 2) {
            PhotoWallController * lp = [[PhotoWallController alloc] initWithOwnerID:[LoginStateManager currentUserId] isRootController:YES];
            self.viewDeckController.centerController = lp;
        }
        if (indexPath.row == 3) {
            HostUserController * hs = [[HostUserController alloc] init];
            self.viewDeckController.centerController = hs;
        }
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
    if (controller.isChangeLoginState && ![LoginStateManager isLogin]) {
        [self resetLeftMenu];
    }else{
        [self.viewDeckController toggleLeftViewAnimated:NO];
    }
}
#pragma mark -  AccoutViewDelgate
- (void)accountView:(LeftAccountView *)acountView fullScreenClick:(id)sender
{
    if (![LoginStateManager isLogin]) {
        LoginViewController * lv = [[LoginViewController alloc] init];
        lv.delegate = self;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:lv];
        [self presentModalViewController:nav animated:YES];
    }
}

- (void)resetLeftMenu
{
    [self setAccountView];
    [self hideOAuthorView];
    _selectPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView selectRowAtIndexPath:_selectPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    self.viewDeckController.centerController = self.localAllController;
    self.view.userInteractionEnabled = YES;
}
- (void)accountView:(LeftAccountView *)acountView accessoryClick:(id)sender
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
- (void)accountView:(LeftAccountView *)acountView setttingClick:(id)sender
{
    SettingController * sc = [[SettingController alloc] init];
    sc.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:sc];
    [self presentModalViewController:nav animated:YES];
}

#pragma mark oauthorize Action
- (void)oauthorizeButtonClick:(UIButton *)button
{
    if (button.tag == 1000) {
        if([LoginStateManager isSinaBind]){
            [self showPopViewForunbindWith:SinaWeiboShare];
        }else{
            [self showBingViewWithShareModel:SinaWeiboShare delegate:self andShowWithNav:NO];
        }
    }
    if (button.tag == 1001) {  
        if([LoginStateManager isQQBing]){
            [self showPopViewForunbindWith:QQShare];
        }else{
            [self showBingViewWithShareModel:QQShare delegate:self andShowWithNav:NO];
        }
    }
    if (button.tag == 1002) {  
        if([LoginStateManager isRenrenBind]){
            [self showPopViewForunbindWith:RenrenShare];
        }else{
            [self showBingViewWithShareModel:RenrenShare delegate:self andShowWithNav:NO];
        }
    }
    [_oauthorBindView updataButtonState];
}

- (void)showPopViewForunbindWith:(KShareModel)model
{
    PopAlertView * view  = [[PopAlertView alloc] initWithTitle:nil message:@"取消绑定?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
    view.userinfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:model] forKey:@"sharModel"];
    [view show];
}
- (void)popAlertView:(PopAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self unbind:[[alertView.userinfo objectForKey:@"sharModel"] intValue]];
    }
}

- (void)unbind:(KShareModel)model
{
//    BOOL isUnbing = [AccountLoginResquest unBinging:model];
    BOOL isUnbing = YES;
    if (isUnbing) {
        [LoginStateManager unbind:model];
        [self showPopAlerViewRatherThentasView:NO WithMes:@"解除绑定"];
    }else{
        [self showPopAlerViewRatherThentasView:NO WithMes:@"解除失败"];
    }
    [_oauthorBindView  updataButtonState];
}

- (void)oauthorController:(OAuthorController *)controlle bindFailture:(NSString *)error
{
    [self.viewDeckController toggleLeftViewAnimated:NO];
    if (error) {
        [self showPopAlerViewRatherThentasView:NO WithMes:error];
    }
    [self.viewDeckController toggleLeftViewAnimated:NO];
}
- (void)oauthorController:(OAuthorController *)controller bingSucessInfo:(NSDictionary *)dic
{
    
    [self.viewDeckController toggleLeftViewAnimated:NO];
    [_oauthorBindView updataButtonState];
}
- (void)oauthorControllerCancel:(OAuthorController *)controlle
{
    [self.viewDeckController toggleLeftViewAnimated:NO];
}
#pragma mark OauthorViews
- (void)showOAuthorView
{
    [_oauthorBindView  updataButtonState];
    [self.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.2 animations:^{
        _oauthorBindView.frame = CGRectMake(0, 48, 320, self.view.frame.size.height - 48);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            _oauthorBindView.frame = CGRectMake(0, 40, 320, self.view.frame.size.height - 48);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                _oauthorBindView.frame = CGRectMake(0, 48, 320, self.view.frame.size.height - 48);
            } completion:^(BOOL finished) {
                [self.view setUserInteractionEnabled:YES];
            }];
        }];
    }];
}

- (void)hideOAuthorView
{
    [self.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.3 animations:^{
        _oauthorBindView.frame = CGRectMake(0, -(self.view.frame.size.height- 48) , 320, 0);
    } completion:^(BOOL finished) {
        [self.view setUserInteractionEnabled:YES];
    }];
}
- (BOOL)isHiddenOAuthorView
{
    return _oauthorBindView.frame.size.height == 0;
}

@end
