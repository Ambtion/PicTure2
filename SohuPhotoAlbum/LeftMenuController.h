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
#import "CloundPictureController.h"      //云端相册
#import "PhotoWallController.h"         //图片墙
#import "HostUserController.h"          //星用户

#import "LoginStateManager.h"
#import "LoginViewController.h"
#import "LeftAccountView.h"
#import "OauthirizeView.h"
#import "SettingController.h"
#import "MenuCell.h"

@interface LeftMenuController : UIViewController<UITableViewDataSource,UITableViewDelegate,LoginViewControllerDelegate,LeftAccountViewDelegate,SettingControllerDelegate,OAuthorControllerDelegate,PopAlertViewDeleagte>
{
    UITableView * _tableView;
    NSDictionary * _userInfo;
    LeftAccountView * _accountView;
    OauthirizeView * _oauthorBindView;
    NSIndexPath * _selectPath;
}
@property(nonatomic,strong)LocalALLPhotoesController * localAllController;
@property(nonatomic,strong)CloundPictureController *cloudController;
@end
