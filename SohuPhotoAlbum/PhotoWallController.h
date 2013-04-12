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

@interface PhotoWallController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,SCPMoreTableFootViewDelegate>
{
    UITableView * _myTableView;
    EGORefreshTableHeaderView * _refresHeadView;
    SCPMoreTableFootView * _moreFootView;
    NSMutableArray * _dataSourceArray;
    
    UILabel * label;
    BOOL _isLoading;
}
@end
