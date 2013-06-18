//
//  RootViewController.h
//  test
//
//  Created by sohu on 13-4-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGRefreshTableView.h"
#import "PhotoWallCell.h"
#import "CustomizationNavBar.h"
#import "TimeLabelView.h"
#import "RequestManager.h"
#import "ShareViewController.h"
#import "TitleAccountView.h"
#import "ShareBox.h"

@interface PhotoWallController : UIViewController<EGRefreshTableViewDelegate,UITableViewDataSource,PhotoWallCellDelegate,CusNavigationBarDelegate,ShareBoxDelegate,WXApiDelegate,ShareViewControllerDelegate,PopAlertViewDeleagte>
{
    EGRefreshTableView * _refreshTableView;
    NSMutableArray * _dataSourceArray;
    CustomizationNavBar * _navBar;
    TimeLabelView * _timelabel;
    TitleAccountView * _titleAccoutView;
    ShareBox * _shareBox;
    BOOL _isRoot;
    BOOL _pushView;
    PhotoWallCell * tempCellForDelete;
    NSDictionary * _userInfo;
}
@property(nonatomic,strong)NSString * ownerID;
- (id)initWithOwnerID:(NSString *)ownID isRootController:(BOOL)isRoot;
@end