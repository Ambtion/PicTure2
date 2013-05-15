//
//  LeftMenuController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "LocalALLPhotoesController.h"   //本地相册
#import "CloudPictureController.h"      //云端相册
#import "PhotoWallController.h"         //图片墙
#import "HostUserController.h"          //星用户

#import "LoginStateManager.h"
#import "LoginViewController.h"
#import "AccountView.h"
#import "OauthirizeView.h"
#import "SettingController.h"
#import "MenuCell.h"

@interface LeftMenuController : UIViewController<UITableViewDataSource,UITableViewDelegate,LoginViewControllerDelegate,AccountViewDelegate,SettingControllerDelegate>
{
    UITableView * _tableView;
    AccountView * _accountView;
    OauthirizeView * _oauthorBindView;
    NSIndexPath * _selectPath;
}
@end
