//
//  SCPLoginViewController.m
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

#define EMAIL_ARRAY ([NSArray arrayWithObjects:\
@"sohu.com", @"vip.sohu.com", @"chinaren.com", @"sogou.com", @"17173.com", @"focus.cn", @"game.sohu.com", @"37wanwan.com",\
@"126.com", @"163.com", @"qq.com", @"gmail.com", @"sina.com.cn", @"sina.com", @"yahoo.com", @"yahoo.com.cn", @"yahoo.cn", nil])

#define BACKGROUDCOLOR [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1.f]
@implementation LoginViewController
@synthesize backgroundImageView = _backgroundImageView;
@synthesize backgroundControl = _backgroundControl;
@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize delegate = _delegate;
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView * view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    view.bounces = NO;
    view.scrollEnabled = NO;
    view.contentSize = view.frame.size;
    self.view = view;
    self.view.backgroundColor = BACKGROUDCOLOR;
    [self addsubViews];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)addsubViews
{
    CGFloat offsetY = 44; //BAR
    //backGround
    CGRect bounds = CGRectMake(0, 0, 320, 480 - offsetY);
    _backgroundImageView = [[UIImageView alloc] initWithFrame:bounds];
    _backgroundImageView.image = [UIImage imageNamed:@"login_bg.png"];
    _backgroundControl = [[UIControl alloc] initWithFrame:bounds];
    [_backgroundControl addTarget:self action:@selector(allTextFieldsResignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backgroundImageView];
    //backButton/ ouathorzieButton
    
    //登录用户名
    _usernameTextField = [[EmailTextField alloc] initWithFrame:CGRectMake(79, 186 - offsetY, 200, 22) dropDownListFrame:CGRectMake(80, 208 - offsetY , 200, 100) domainsArray:EMAIL_ARRAY andBackGround:[UIColor whiteColor]];
    _usernameTextField.font = [UIFont systemFontOfSize:15];
    _usernameTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    _usernameTextField.placeholder = @"通行证";
    _usernameTextField.backgroundColor = [UIColor clearColor];
    _usernameTextField.text = [[LoginStateManager lastUserName] copy];
    _usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_usernameTextField addTarget:self action:@selector(usernameDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //输入密码
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(79, 186 + 38 - offsetY, 200, 22)];
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"密码";
    _passwordTextField.backgroundColor = [UIColor clearColor];
    
    //    [_passwordTextField addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventEditingDidEndOnExit];
    //     [_passwordTextField addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventEditingDidEnd];
    
    //注册
    UIButton *  registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(36, 280  - offsetY, 110, 35);
    [registerButton setBackgroundImage:[UIImage imageNamed:@"register_btn_nomal.png"] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //登录按钮
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(175, 280 - offsetY, 110, 35);
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn_normal"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * forgetPassWord = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPassWord.frame = CGRectMake(39, 337 - offsetY , 62, 20);
    [forgetPassWord setImage:[UIImage imageNamed:@"forgetPassWord.png"] forState:UIControlStateNormal];
    forgetPassWord.backgroundColor = [UIColor clearColor];
    [forgetPassWord addTarget:self action:@selector(forgetPassWord:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:_backgroundControl];
    [self.view addSubview:_usernameTextField];
    [self.view addSubview:_passwordTextField];
    [self.view addSubview:registerButton];
    [self.view addSubview:loginButton];
    [self.view  addSubview:forgetPassWord];
    
    //    //返回按钮
    //    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    backButton.frame = CGRectMake(0, 0, 44, 44);
    //    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    //    [backButton addTarget:self action:@selector(cancelLogin:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:backButton];
    
    //第三方登录
    CGFloat buttonY = 67 - offsetY;
    CGFloat width = 84;
    CGFloat heigth = 60;
    UIButton * qqbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    qqbutton.frame = CGRectMake(36,buttonY, width, heigth);
    [qqbutton setImage:[UIImage imageNamed:@"qqLogin.png"] forState:UIControlStateNormal];
    [qqbutton addTarget:self action:@selector(qqLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqbutton];
    
    UIButton * sinabutton = [UIButton buttonWithType:UIButtonTypeCustom];
    sinabutton.frame = CGRectMake(qqbutton.frame.origin.x + qqbutton.frame.size.width, buttonY, width, heigth);
    [sinabutton setImage:[UIImage imageNamed:@"sinaLogin.png"] forState:UIControlStateNormal];
    [sinabutton addTarget:self action:@selector(sinaLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sinabutton];
    
    UIButton * renrenbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    renrenbutton.frame = CGRectMake(sinabutton.frame.size.width+sinabutton.frame.origin.x , buttonY,width,heigth);
    [renrenbutton setImage:[UIImage imageNamed:@"renrenLogin.png"] forState:UIControlStateNormal];
    [renrenbutton addTarget:self action:@selector(renrenLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:renrenbutton];
    
    UIImageView * sohu2003 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sohu-2013.png"]];
    CGRect rect = CGRectMake(0, 0, 320, 10);
    sohu2003.backgroundColor = [UIColor clearColor];
    CGRect screenRect = self.view.bounds;
    rect.origin.y = screenRect.size.height - 60;
    sohu2003.frame = rect;
    [self.view addSubview:sohu2003];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_navBar removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_navBar) {
        _navBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        _navBar.normalBar.image = [UIImage imageNamed:@"Login_Bar.png"];
        [_navBar.nLeftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    }
    [self.navigationController.navigationBar addSubview:_navBar];
}

- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload
{
    if(button.tag == LEFTBUTTON)
        [self cancelLogin:nil];
}
#pragma mark -
- (void)allTextFieldsResignFirstResponder
{
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)usernameDidEndOnExit
{
    [_passwordTextField becomeFirstResponder];
}

#pragma mark  - ButtonClick
- (void)cancelLogin:(UIButton *)button
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.presentingViewController) {
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    }
    if ([_delegate respondsToSelector:@selector(loginViewController:cancleClick:)])
        [_delegate loginViewController:self cancleClick:button];
}
- (void)loginButtonClicked:(UIButton*)button
{
    if (!_usernameTextField.text|| [_usernameTextField.text isEqualToString:@""]) {
        [self showPopAlerViewRatherThentasView:YES WithMes:@"您还没有填写用户名"];
        return;
    }
    if (!_passwordTextField.text || [_passwordTextField.text isEqualToString:@""]) {
        [self showPopAlerViewRatherThentasView:YES WithMes:@"您还没有填写密码"];
        return;
    }
    [LoginStateManager storelastName:_usernameTextField.text];
    NSString * useName = [NSString stringWithFormat:@"%@",[_usernameTextField.text lowercaseString]];
    NSString * passWord = [NSString stringWithFormat:@"%@",_passwordTextField.text];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud show:YES];
    [AccountLoginResquest sohuLoginWithuseName:useName password:passWord sucessBlock:^(NSDictionary *response) {
        [hud hide:YES];
        [self handleLoginInfo:response];
    } failtureSucess:^(NSString *error) {
        [hud hide:YES];
        [self showError:error];
    }];
}

#pragma mark Handle Login Result
- (void)handleLoginInfo:(NSDictionary *)response
{
    [LoginStateManager loginUserId:[NSString stringWithFormat:@"%@",[response objectForKey:@"user_id"]] withToken:[response objectForKey:@"access_token"] RefreshToken:[response objectForKey:@"refresh_token"]];
    [AccountLoginResquest resigiterDevice];
//    [AccountLoginResquest setBindingInfo];
//    [AccountLoginResquest upDateDeviceToken];
    if ([_delegate respondsToSelector:@selector(loginViewController:loginSucessWithinfo:)])
        [_delegate loginViewController:self loginSucessWithinfo:response];
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.presentingViewController) {
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    }
}
- (void)showError:(NSString *)error
{
    [self showPopAlerViewRatherThentasView:NO WithMes:error];
    if ([_delegate respondsToSelector:@selector(loginViewController:loginFailtureWithinfo:)])
        [_delegate loginViewController:self loginFailtureWithinfo:error];
}

#pragma mark OAuthor
- (void)sinaLogin:(UIButton*)button
{
    [self presentWithControlleByLoginMode:SinaWeiboShare];
}

- (void)qqLogin:(UIButton *)button
{
    [self presentWithControlleByLoginMode:QQShare];
}
- (void)renrenLogin:(UIButton *)button
{
    [self presentWithControlleByLoginMode:RenrenShare];
}

- (void)presentWithControlleByLoginMode:(KShareModel)model
{
    OAuthorController * atcq = [[OAuthorController alloc] initWithMode:model ViewModel:LoginModelView];
    atcq.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:atcq];
    [self presentModalViewController:nav animated:YES];
}
- (void)forgetPassWord:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://passport.sohu.com/web/recover.jsp"]];
}

#pragma mark Delgeate Oauthorize
- (void)oauthorController:(OAuthorController *)controller loginSucessInfo:(NSDictionary *)dic
{
    [self dismissModalViewControllerAnimated:NO];
    [self handleLoginInfo:dic];
    [self handleInfoWithshareModel:controller.shareModel infoDic:dic];
//    NSDictionary * third_dic = [NSDictionary dictionaryWithObject:[dic objectForKey:@"third_access_token"] forKey:@"access_token"];
//    switch (controller.shareModel) {
//        case QQShare:
//            [LoginStateManager storeQQTokenInfo:third_dic];
//            break;
//        case SinaWeiboShare:
//            [LoginStateManager storeSinaTokenInfo:third_dic];
//            break;
//        case RenrenShare:
//            [LoginStateManager storeRenRenTokenInfo:third_dic];;
//            break;
//        default:
//            break;
//    }
}
- (void)oauthorController:(OAuthorController *)controlle loginFailture:(NSString *)error
{
    [self showError:error];
}
#pragma mark resiteruseinfo
- (void)registerButtonClicked:(UIButton *)button
{
    [_passwordTextField resignFirstResponder];
    [_usernameTextField resignFirstResponder];
    RegisterViewController *reg = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:reg animated:YES];
}

#pragma mark Keyboard lifeCircle
- (void)keyboardWillShow:(NSNotification *)notification
{
    UIScrollView * view = (UIScrollView *) self.view;
    view.scrollEnabled = YES;
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGSize size = view.bounds.size;
    size.height += keyboardSize.height;
    view.contentSize = size;
    
    CGPoint point = view.contentOffset;
    point.y =  120;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    view.contentOffset = point;
    [UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    
    //视图消失时自动失去第一响应者,为了保持动画一致性
    if ([LoginStateManager isLogin]) return;
    DLog(@"%s",__FUNCTION__);
    UIScrollView *view = (UIScrollView *) self.view;
    CGPoint point = view.contentOffset;
    point.y  =  0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    view.contentOffset = point;
    [UIView commitAnimations];
    view.scrollEnabled = NO;
    CGSize size = view.bounds.size;
    view.contentSize = size;
}

@end
