//
//  SCPRegisterViewController.m
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "ReadSohuDealController.h"

@implementation RegisterViewController

@synthesize loginController = _loginController;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize backgroundControl = _backgroundControl;
@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize mailBindTextField = _mailBindTextField;
@synthesize displayPasswordButton = _displayPasswordButton;
@synthesize dealPassButton = _dealPassButton;
@synthesize readDealButton = _readDealButton;
@synthesize registerButton = _registerButton;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)loadView
{
    [super loadView];
    UIScrollView * view = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.bounces = NO;
    view.contentSize = view.frame.size;
    self.view = view;
    self.view.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1.f];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addViews];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_navBar removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    if (!_navBar) {
        _navBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        _navBar.normalBar.image = [UIImage imageNamed:@"Login_Bar.png"];
        [_navBar.nRightButton1 setHidden:YES];
        [_navBar.nLeftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    }
    [self.navigationController.navigationBar addSubview:_navBar];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
}
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addViews
{
    
    CGFloat offset = 44.f;
    _checked = [[UIImage imageNamed:@"check_box_select.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 0)];
    _noChecked = [[UIImage imageNamed:@"check_box_no_select.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 0)];
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480 - offset)];
    _backgroundImageView.image = [UIImage imageNamed:@"registerBg.png"];
    _backgroundControl = [[UIControl alloc] initWithFrame:_backgroundImageView.bounds];
    [_backgroundControl addTarget:self action:@selector(allTextFieldsResignFirstResponder:) forControlEvents:UIControlEventTouchDown];
    
	_usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 74 - offset, 190 - 73, 22) ];
    _usernameTextField.font = [UIFont systemFontOfSize:15];
    _usernameTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _usernameTextField.returnKeyType = UIReturnKeyNext;
//    _usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _usernameTextField.placeholder = @"用户名";
    _usernameTextField.delegate = self;
    _usernameTextField.backgroundColor = [UIColor clearColor];
    _usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_usernameTextField addTarget:self action:@selector(usernameDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];

    //    _mailBindTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 110 -offset, 190, 22) ];
    //    _mailBindTextField.font = [UIFont systemFontOfSize:15];
    //    _mailBindTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    //    _mailBindTextField.returnKeyType = UIReturnKeyNext;
    //    _mailBindTextField.placeholder = @"绑定邮箱";
    //    _mailBindTextField.delegate = self;
    //    _mailBindTextField.backgroundColor = [UIColor clearColor];
    //    _mailBindTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //    [_mailBindTextField addTarget:self action:@selector(mailBindDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    offset += 30.f;
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 142 - offset , 190, 22)];
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"密码";
    _passwordTextField.backgroundColor = [UIColor clearColor];
    [_passwordTextField addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _dealPassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dealPassButton.frame = CGRectMake(38, 210 - offset , 22, 22);
    _dealPassButton.selected = YES;
    [_dealPassButton setBackgroundImage:_noChecked forState:UIControlStateNormal];
    [_dealPassButton setBackgroundImage:_checked forState:UIControlStateSelected];
    [_dealPassButton setBackgroundImage:_checked forState:UIControlStateHighlighted];
    [_dealPassButton setBackgroundImage:_checked forState:UIControlStateHighlighted | UIControlStateSelected];
    [_dealPassButton addTarget:self action:@selector(agreeDeal:) forControlEvents:UIControlEventTouchUpInside];
    _dealPassButton.backgroundColor = [UIColor clearColor];
    
    _readDealButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    _readDealButton.frame = CGRectMake(50, 208 - offset, 160, 25);
    _readDealButton.backgroundColor = [UIColor clearColor];
    [_readDealButton setImage:[UIImage imageNamed:@"readDeal.png"] forState:UIControlStateNormal];
    [_readDealButton addTarget:self action:@selector(readDeal:) forControlEvents:UIControlEventTouchUpInside];
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton.frame = CGRectMake(35, 270, 250, 40);
    
    [_registerButton setImage:[UIImage imageNamed:@"doneRegister.png"] forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_backgroundImageView];
    [self.view addSubview:_backgroundControl];
    [self.view addSubview:_usernameTextField];
    //    [self.view addSubview:_mailBindTextField];
    [self.view addSubview:_passwordTextField];
    [self.view addSubview:_displayPasswordButton];
    [self.view addSubview:_dealPassButton];
    [self.view addSubview:_readDealButton];
    [self.view addSubview:_registerButton];
    
    //    //后退按钮
    //    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    backButton.frame = CGRectMake(0, 0, 44, 44);
    //    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    //    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:backButton];
    
    UIImageView * sohu2003 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sohu-2013.png"]];
    CGRect rect = CGRectMake(0, 0, 320, 10);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    rect.origin.y = screenRect.size.height - 40 - offset;
    sohu2003.frame = rect;
    [self.view addSubview:sohu2003];
}
#pragma mark - TextFiledDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text  = [textField.text lowercaseString];
}
- (void)agreeDeal:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [_registerButton setUserInteractionEnabled:YES];
        [_registerButton setAlpha:1.0];
    }else{
        [_registerButton setAlpha:0.3];
        [_registerButton setUserInteractionEnabled:NO];
    }
}
- (void)readDeal:(UIButton *)button
{
    [self.navigationController pushViewController:[[ReadSohuDealController alloc] init] animated:YES];
}
- (void)backButtonClick:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)allTextFieldsResignFirstResponder:(id)sender
{
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    //    [_mailBindTextField resignFirstResponder];
}
- (void)mailBindDidEndOnExit
{
    [_passwordTextField becomeFirstResponder];
    
}
- (void)usernameDidEndOnExit
{
    //    [_mailBindTextField becomeFirstResponder];
    [_passwordTextField becomeFirstResponder];
}

- (void)checkBoxClicked
{
    [self allTextFieldsResignFirstResponder:nil];
    _displayPasswordButton.selected = !_displayPasswordButton.selected;
    _passwordTextField.secureTextEntry = !_displayPasswordButton.selected;
}

- (void)doRegister
{
    if (!_usernameTextField.text || [_usernameTextField.text isEqualToString:@""]) {
        [self showPopAlerViewRatherThentasView:YES WithMes:@"您还没有填写用户名"];
        return;
    }
    if (!_passwordTextField.text || [_passwordTextField.text isEqualToString:@""]) {
        [self showPopAlerViewRatherThentasView:YES WithMes:@"您还没有填写密码"];
        return;
    }
    [self allTextFieldsResignFirstResponder:nil];
    [self waitForMomentsWithTitle:@"注册中"];
    NSString * username = [NSString stringWithFormat:@"%@@sohu.com",_usernameTextField.text];
    NSString * password = [NSString stringWithFormat:@"%@",_passwordTextField.text];
    [AccountLoginResquest resigiterWithuseName:username password:password nickName:nil sucessBlock:^(NSDictionary *response) {
        [AccountLoginResquest sohuLoginWithuseName:username password:password sucessBlock:^(NSDictionary * response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self backHomeWithRespose:response];
            });
        } failtureSucess:^(NSString *error) {
            [self stopWait];
            [self showPopAlerViewRatherThentasView:YES WithMes:error];
        }];
        
    }failtureSucess:^(NSString *error) {
        [self stopWait];
        [self showPopAlerViewRatherThentasView:YES WithMes:error];
    }];
}
- (void)backHomeWithRespose:(NSDictionary *)response
{
    [self stopWait];
    [self.navigationController popViewControllerAnimated:NO];
    LoginViewController * vc = _loginController;
    [vc handleLoginInfo:response];
}

-(void)waitForMomentsWithTitle:(NSString*)str
{
    //    if (_alterView.superview) return;
    if (!_alterView) {
        _alterView = [[MBProgressHUD alloc] initWithView:self.view];
        _alterView.animationType = MBProgressHUDAnimationZoomOut;
        _alterView.labelText = str;
        [self.view addSubview:_alterView];
    }
    [_alterView show:YES];
}

-(void)stopWait
{
    DLog(@"%s",__FUNCTION__);
    [_alterView hide:YES];
}

#pragma mark KeyBoardnotification
- (void)keyboardWillShow:(NSNotification *)notification
{
    UIScrollView * view = (UIScrollView *) self.view;
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGSize size = view.bounds.size;
    size.height += keyboardSize.height;
    view.contentSize = size;
    //    CGPoint point = view.contentOffset;
    //    point.y = 118;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    //    view.contentOffset = point;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIScrollView *view = (UIScrollView *) self.view;
    CGPoint point = view.contentOffset;
    point.y  =  0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    view.contentOffset = point;
    [UIView commitAnimations];
    
    CGSize size = view.bounds.size;
    view.contentSize = size;
}
@end
