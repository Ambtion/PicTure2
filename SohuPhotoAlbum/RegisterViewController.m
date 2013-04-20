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
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    view.bounces = NO;
    view.contentSize = view.frame.size;
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addViews];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)addViews
{
    
    _checked = [[UIImage imageNamed:@"check_box_select.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 0)];
    _noChecked = [[UIImage imageNamed:@"check_box_no_select.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 22, 0, 0)];
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    _backgroundImageView.image = [UIImage imageNamed:@"registerBg.png"];
    _backgroundControl = [[UIControl alloc] initWithFrame:_backgroundImageView.bounds];
    [_backgroundControl addTarget:self action:@selector(allTextFieldsResignFirstResponder:) forControlEvents:UIControlEventTouchDown];
    
	_usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 74, 190, 22) ];
    _usernameTextField.font = [UIFont systemFontOfSize:15];
    _usernameTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    _usernameTextField.placeholder = @"用户名";
    _usernameTextField.delegate = self;
    _usernameTextField.backgroundColor = [UIColor clearColor];
    _usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_usernameTextField addTarget:self action:@selector(usernameDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _mailBindTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 110, 190, 22) ];
    _mailBindTextField.font = [UIFont systemFontOfSize:15];
    _mailBindTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _mailBindTextField.returnKeyType = UIReturnKeyNext;
    _mailBindTextField.placeholder = @"绑定邮箱";
    _mailBindTextField.delegate = self;
    _mailBindTextField.backgroundColor = [UIColor clearColor];
    _mailBindTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_mailBindTextField addTarget:self action:@selector(mailBindDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];

    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 146, 190, 22)];
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"密码";
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.backgroundColor = [UIColor clearColor];
    
//    _displayPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _displayPasswordButton.frame = CGRectMake(35, 258, 100, 22);
//    _displayPasswordButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [_displayPasswordButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
//    [_displayPasswordButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
//    [_displayPasswordButton setTitle:@"显示密码" forState:UIControlStateNormal];
//    [_displayPasswordButton setBackgroundImage:_noChecked forState:UIControlStateNormal];
//    [_displayPasswordButton setBackgroundImage:_checked forState:UIControlStateSelected];
//    [_displayPasswordButton setBackgroundImage:_checked forState:UIControlStateHighlighted];
//    [_displayPasswordButton setBackgroundImage:_checked forState:UIControlStateHighlighted | UIControlStateSelected];
//    [_displayPasswordButton addTarget:self action:@selector(checkBoxClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _dealPassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dealPassButton.frame = CGRectMake(38, 210, 22, 22);
    _dealPassButton.selected = YES;
    [_dealPassButton setBackgroundImage:_noChecked forState:UIControlStateNormal];
    [_dealPassButton setBackgroundImage:_checked forState:UIControlStateSelected];
    [_dealPassButton setBackgroundImage:_checked forState:UIControlStateHighlighted];
    [_dealPassButton setBackgroundImage:_checked forState:UIControlStateHighlighted | UIControlStateSelected];
    [_dealPassButton addTarget:self action:@selector(agreeDeal:) forControlEvents:UIControlEventTouchUpInside];
    _dealPassButton.backgroundColor = [UIColor clearColor];
    
    _readDealButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    _readDealButton.frame = CGRectMake(50, 208, 160, 25);
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
    [self.view addSubview:_mailBindTextField];
    [self.view addSubview:_passwordTextField];
    [self.view addSubview:_displayPasswordButton];
    [self.view addSubview:_dealPassButton];
    [self.view addSubview:_readDealButton];
    [self.view addSubview:_registerButton];
    
    //后退按钮
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIImageView * sohu2003 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sohu-2013.png"]];
    CGRect rect = CGRectMake(0, 0, 320, 10);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    rect.origin.y = screenRect.size.height - 20;
    sohu2003.frame = rect;
    [self.view addSubview:sohu2003];
    
}
#pragma mark View Appear
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
    [_mailBindTextField becomeFirstResponder];
}
- (void)mailBindDidEndOnExit
{
    [_passwordTextField becomeFirstResponder];

}
- (void)usernameDidEndOnExit
{
    [_mailBindTextField becomeFirstResponder];
}

- (void)checkBoxClicked
{
    [self allTextFieldsResignFirstResponder:nil];
    _displayPasswordButton.selected = !_displayPasswordButton.selected;
    _passwordTextField.secureTextEntry = !_displayPasswordButton.selected;
    
}
- (void)doRegister
{
    
}
#pragma mark KeyBoardnotification
- (void)keyboardWillShow:(NSNotification *)notification
{
    UIScrollView * view = (UIScrollView *) self.view;
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGSize size = view.bounds.size;
    size.height += keyboardSize.height;
    view.contentSize = size;
    
    CGPoint point = view.contentOffset;
    point.y = 118;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    view.contentOffset = point;
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
