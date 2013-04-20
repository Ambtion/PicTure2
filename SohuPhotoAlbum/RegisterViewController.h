//
//  SCPRegisterViewController.h
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmailTextField.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate>
{
    UIImage *_checked, *_noChecked;
}

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIControl * backgroundControl;
@property (strong, nonatomic) UITextField *usernameTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *mailBindTextField;
@property (strong, nonatomic) UIButton *displayPasswordButton;
@property (strong, nonatomic) UIButton *dealPassButton;
@property (strong, nonatomic) UIButton *readDealButton;
@property (strong, nonatomic) UIButton *registerButton;

@end
