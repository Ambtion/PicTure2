//
//  HostUserController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-23.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGRefreshTableView.h"

@interface HostUserController :  UIViewController<UITableViewDataSource,EGRefreshTableViewDelegate,CusNavigationBarDelegate>
{
    CustomizationNavBar * _cusBar;
    EGRefreshTableView * _refreshTableView;
}
@end
