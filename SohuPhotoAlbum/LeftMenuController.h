//
//  LeftMenuController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "LocalALLPhotoesController.h" //本地相册
#import "PhotoWallController.h"
#import "LoginStateManager.h"
#import "LoginViewController.h"
#import "AccountCell.h"
#import "MenuCell.h"

@interface LeftMenuController : UIViewController<UITableViewDataSource,UITableViewDelegate,LoginViewControllerDelegate>
{
    UITableView * _tableView;
    AccountCell * _accountCell;
}
@end
