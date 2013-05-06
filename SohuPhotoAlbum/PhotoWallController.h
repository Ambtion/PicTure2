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

@interface PhotoWallController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,SCPMoreTableFootViewDelegate,PhotoWallCellDelegate,CusNavigationBarDelegate>
{
    UITableView * _myTableView;
    EGORefreshTableHeaderView * _refresHeadView;
    SCPMoreTableFootView * _moreFootView;
    NSMutableArray * _dataSourceArray;
    CustomizationNavBar * _navBar;
    TimeLabelView * _timelabel;
    BOOL _isLoading;
    BOOL _isRoot;
}
@property(nonatomic,strong)NSString * ownerID;
- (id)initWithOwnerID:(NSString *)ownID isRootController:(BOOL)isRoot;
@end