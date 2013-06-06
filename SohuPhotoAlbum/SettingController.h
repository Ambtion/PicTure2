//
//  SettingController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-22.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomizationNavBar.h"
#import "MySettingCell.h"

@class SettingController;
@protocol SettingControllerDelegate <NSObject>
- (void)settingControllerDidDisappear:(SettingController *)controller;
@end
@interface SettingController : UIViewController<UITableViewDataSource,UITableViewDelegate,MySettingCellDelegate,PopAlertViewDeleagte>
{
    UITableView * _myTableView;
    UIImageView * _navBar;
    PopAlertView * _cache;
    PopAlertView * _loginView;
    BOOL isInit;
}
@property(weak,nonatomic)id delegate;
@property(nonatomic,strong) NSDictionary * userInfodic;
@property(nonatomic,assign) BOOL isChangeLoginState;
@end
