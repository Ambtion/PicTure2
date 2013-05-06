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
@interface SettingController : UIViewController<UITableViewDataSource,UITableViewDelegate,MySettingCellDelegate>
{
    UITableView * _myTableView;
    UIImageView * _navBar;
    NSDictionary * userInfodic;

}
@property(weak,nonatomic)id delegate;
@property(nonatomic,assign) BOOL isChangeLoginState;
@end
