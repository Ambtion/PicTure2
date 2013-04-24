//
//  SCPLoginViewController.h
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"
#import "AccountLoginResquest.h"
#import "LoginStateManager.h"
#import "OAuthorController.h"
#import "EmailTextField.h"
#import "CustomizationNavBar.h"

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>
@optional
- (void)loginViewController:(LoginViewController *)loginController cancleClick:(id)sender;
- (void)loginViewController:(LoginViewController *)loginController loginSucessWithinfo:(NSDictionary *)sucessInfo;
- (void)loginViewController:(LoginViewController *)loginController loginFailtureWithinfo:(id)failtureinfo;
@end

@interface LoginViewController : UIViewController<MBProgressHUDDelegate,OAuthorControllerDelegate,CusNavigationBarDelegate>
{
    CustomizationNavBar * _navBar;
}
@property (strong, nonatomic) id<LoginViewControllerDelegate> delegate;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIControl *backgroundControl;
@property (strong, nonatomic) EmailTextField *usernameTextField;
@property (strong, nonatomic) UITextField *passwordTextField;

@end
