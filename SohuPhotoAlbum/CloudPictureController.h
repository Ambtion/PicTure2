//
//  CloudPictureController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "SCPMoreTableFootView.h"
#import "CustomizationNavBar.h"
#import "CloudPictureCell.h"

@interface CloudPictureController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,SCPMoreTableFootViewDelegate,CloudPictureCellDelegate,CusNavigationBarDelegate>
{
    UITableView * _myTableView;
    EGORefreshTableHeaderView * _refresHeadView;
    SCPMoreTableFootView * _moreFootView;
    CustomizationNavBar * _navBar;
    BOOL _isSelectedState;
    BOOL _isLoading;
}

@end