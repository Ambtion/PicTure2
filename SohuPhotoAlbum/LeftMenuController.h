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
#import "LoginStateManager.h"
#import "LoginViewController.h"
#import "MenuCell.h"
#import "AccountView.h"

@interface LeftMenuController : UIViewController<UITableViewDataSource,UITableViewDelegate,LoginViewControllerDelegate,AccountViewDelegate>
{
    UITableView * _tableView;
    AccountView * _accountView;
    UIView * _oauthorBindView;
}
@end
