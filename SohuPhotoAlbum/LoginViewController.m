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

- (void)loadView
{
    [super loadView];
    CGRect frame = [[UIScreen mainScreen] bounds];
    UIScrollView * view = [[UIScrollView alloc] initWithFrame:frame];
    view.bounces = NO;
    view.scrollEnabled = NO;
    view.contentSize = frame.size;
    self.view = view;
    self.view.backgroundColor = [UIColor colorWithRed:244.0f/255.f green:244.0f/255.f blue:244.0f/255.f alpha:1];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addsubViews];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)addsubViews
{
    CGRect bounds = CGRectMake(0, 0, 320, 480);
    _backgroundImageView = [[UIImageView alloc] initWithFrame:bounds];
    _backgroundImageView.image = [UIImage imageNamed:@"login_bg.png"];
    _backgroundControl = [[UIControl alloc] initWithFrame:bounds];
    [_backgroundControl addTarget:self action:@selector(allTextFieldsResignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    
    //登录用户名
    _usernameTextField = [[EmailTextField alloc] initWithFrame:CGRectMake(79, 131, 200, 22) dropDownListFrame:CGRectMake(69, 160, 214, 200) domainsArray:EMAIL_ARRAY];
    _usernameTextField.font = [UIFont systemFontOfSize:15];
    _usernameTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    _usernameTextField.placeholder = @"通行证";
    _usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_usernameTextField addTarget:self action:@selector(usernameDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //输入密码
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(79, 189, 200, 22)];
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"密码";
//    [_passwordTextField addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventEditingDidEndOnExit];
//     [_passwordTextField addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventEditingDidEnd];
    
    //注册
    UIButton *  registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(35, 239, 110, 35);
    [registerButton setBackgroundImage:[UIImage imageNamed:@"login_btn_normal"] forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"login_btn_press"] forState:UIControlStateHighlighted];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * externalLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 290, 150, 15)];
    externalLabel.text = @"其他账号登录";
    externalLabel.textAlignment = UITextAlignmentLeft;
    externalLabel.backgroundColor = [UIColor clearColor];
    externalLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    externalLabel.font = [UIFont systemFontOfSize:15.f];
    
    UILabel * forget = [[UILabel alloc] initWithFrame:CGRectMake(320 - 35 - 150, 290, 150, 15)];
    forget.text = @"忘记密码";
    forget.textAlignment = UITextAlignmentRight;
    forget.backgroundColor = [UIColor clearColor];
    forget.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    forget.font = [UIFont systemFontOfSize:15.f];
    [forget setUserInteractionEnabled:YES];
    
    UIButton * forgetPassWord = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPassWord.frame = forget.bounds;
    forgetPassWord.backgroundColor = [UIColor clearColor];
    [forgetPassWord addTarget:self action:@selector(forgetPassWord:) forControlEvents:UIControlEventTouchUpInside];
    [forget addSubview:forgetPassWord];
    
    //登录按钮
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(175, 239, 110, 35);
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn_normal"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn_press"] forState:UIControlStateHighlighted];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_backgroundImageView];
    [self.view addSubview:_backgroundControl];
    [self.view addSubview:_usernameTextField];
    [self.view addSubview:_passwordTextField];
    [self.view addSubview:externalLabel];
    [self.view addSubview:registerButton];
    [self.view addSubview:loginButton];
    [self.view addSubview:forget];
    
    //返回按钮
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(5, 2, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_press.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(cancelLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    //第三方登录
    UIButton * qqbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    qqbutton.frame = CGRectMake(35, 319, 42, 42);
    [qqbutton setImage:[UIImage imageNamed:@"qqLogin.png"] forState:UIControlStateNormal];
    [qqbutton addTarget:self action:@selector(qqLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqbutton];
    
    UIButton * sinabutton = [UIButton buttonWithType:UIButtonTypeCustom];
    sinabutton.frame = CGRectMake(35 + 42 + 15, 319, 42, 42);
    [sinabutton setImage:[UIImage imageNamed:@"sinaLogin.png"] forState:UIControlStateNormal];
    [sinabutton addTarget:self action:@selector(sinaLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sinabutton];
    
    UIButton * renrenbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    renrenbutton.frame = CGRectMake(35 + 42 + 15 + 42 + 15, 319, 42, 42);
    [renrenbutton setImage:[UIImage imageNamed:@"renrenLogin.png"] forState:UIControlStateNormal];
    [renrenbutton addTarget:self action:@selector(renrenLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:renrenbutton];
    
    UIImageView * sohu2003 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sohu-2013.png"]];
    CGRect rect = CGRectMake(0, 0, 320, 10);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    rect.origin.y = screenRect.size.height - 20;
    sohu2003.frame = rect;
    [self.view addSubview:sohu2003];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
        PopAlertView * alterview = [[PopAlertView alloc] initWithTitle:@"您还没有填写用户名" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterview show];
        return;
    }
    if (!_passwordTextField.text || [_passwordTextField.text isEqualToString:@""]) {
        PopAlertView * alterview = [[PopAlertView alloc] initWithTitle:@"您还没有填写密码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterview show];
        return;
    }
//    [_passwordTextField resignFirstResponder];
//    [_usernameTextField resignFirstResponder];
    
    NSString * useName = [NSString stringWithFormat:@"%@",[_usernameTextField.text lowercaseString]];
    NSString * passWord = [NSString stringWithFormat:@"%@",_passwordTextField.text];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:self.view];
//    hud.delegate = self;
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
    [LoginStateManager loginUserId:@"user_ID" withToken:[response objectForKey:@"access_token"] RefreshToken:[response objectForKey:@"refresh_token"]];
    if ([_delegate respondsToSelector:@selector(loginViewController:loginSucessWithinfo:)])
        [_delegate loginViewController:self loginSucessWithinfo:response];
}
- (void)showError:(NSString *)error
{
    PopAlertView * alterView = [[PopAlertView alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alterView show];
    if ([_delegate respondsToSelector:@selector(loginViewController:loginFailtureWithinfo:)])
        [_delegate loginViewController:self loginFailtureWithinfo:error];
}

#pragma mark OAuthor
- (void)sinaLogin:(UIButton*)button
{
    [self presentWithControlleByLoginMode:LoginModelSina];
}
- (void)qqLogin:(UIButton *)button
{
    [self presentWithControlleByLoginMode:LoginModelQQ];
}
- (void)renrenLogin:(UIButton *)button
{
    [self presentWithControlleByLoginMode:LoginModelRenRen];
}
- (void)presentWithControlleByLoginMode:(LoginModel)model
{
    OAuthorController * atcq = [[OAuthorController alloc] initWithMode:model];
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

#pragma mark - MBProgress Delegate
//- (void)hudWasHidden:(MBProgressHUD *)hud
//{
//    [hud removeFromSuperview];
//}
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
