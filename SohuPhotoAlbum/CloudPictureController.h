//
//  CloudPictureController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGRefreshTableView.h"
#import "CloudPictureCell.h"
#import "RequestManager.h"
#import "ShareViewController.h"
#import "ShareBox.h"
#import "LocalBaseController.h"


@interface CloudPictureController : UIViewController <UITableViewDataSource,EGRefreshTableViewDelegate,CusNavigationBarDelegate,CloudPictureCellDelegate,ShareViewControllerDelegate,PopAlertViewDeleagte,WXApiDelegate,ShareBoxDelegate>
{
 
    EGRefreshTableView * _refreshTableView;
    CustomizationNavBar * _cusBar;
    BOOL _isLoading;
    BOOL _isLoadingMax;
    ShareBox * _shareBox;
    BOOL _shouldRefreshOnce;
}

@property(nonatomic,strong)NSMutableDictionary * assetDictionary;
@property(nonatomic,assign)viewState viewState;
@end