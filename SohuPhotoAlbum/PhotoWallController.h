//
//  RootViewController.h
//  test
//
//  Created by sohu on 13-4-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "SCPMoreTableFootView.h"
#import "PhotoWallCell.h"
#import "CustomizationNavBar.h"
#import "TimeLabelView.h"
#import "RequestManager.h"
#import "ShareViewController.h"
#import "TitleAccountView.h"
#import "ShareBox.h"

@interface PhotoWallController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,      SCPMoreTableFootViewDelegate,PhotoWallCellDelegate,CusNavigationBarDelegate,
            UIActionSheetDelegate,ShareBoxDelegate,WXApiDelegate,ShareViewControllerDelegate>
{
    UITableView * _myTableView;
    EGORefreshTableHeaderView * _refresHeadView;
    SCPMoreTableFootView * _moreFootView;
    NSMutableArray * _dataSourceArray;
    CustomizationNavBar * _navBar;
    TimeLabelView * _timelabel;
    TitleAccountView * _titleAccoutView;
    ShareBox * _shareBox;
    BOOL _isLoading;
    BOOL _isRoot;
    BOOL _pushView;
    PhotoWallCell * tempCellForDelete;
    NSDictionary * _userInfo;
}
@property(nonatomic,strong)NSString * ownerID;
- (id)initWithOwnerID:(NSString *)ownID isRootController:(BOOL)isRoot;
@end