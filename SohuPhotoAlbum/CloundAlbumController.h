//
//  CloudAlbumController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-6-17.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAlbumCell.h"
#import "LocalBaseController.h"
#import "EGRefreshTableView.h"
#import "RequestManager.h"

@interface CloundAlbumController : UIViewController <UITableViewDataSource,PhotoAlbumCellDelegate,EGRefreshTableViewDelegate,CusNavigationBarDelegate,PopAlertViewDeleagte>
{
    EGRefreshTableView * _refreshTableView;
    CustomizationNavBar * _cusBar;
}
@property(nonatomic,assign)viewState viewState;
@end
