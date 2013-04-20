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
#import "LocalBaseController.h"

@interface CloudPictureController : LocalBaseController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,SCPMoreTableFootViewDelegate,CloudPictureCellDelegate,CusNavigationBarDelegate>
{
    EGORefreshTableHeaderView * _refresHeadView;
    SCPMoreTableFootView * _moreFootView;
    BOOL _isLoading;
}

@end