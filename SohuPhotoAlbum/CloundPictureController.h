//
//  CloudPictureController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGRefreshTableView.h"
#import "CloundPictureCell.h"
#import "RequestManager.h"
#import "ShareViewController.h"
#import "ShareBox.h"
#import "LocalBaseController.h"
#import "CloundAlbumController.h"

@class CQSegmentControl;
@interface CloundPictureController : UIViewController <UITableViewDataSource,EGRefreshTableViewDelegate,CusNavigationBarDelegate,CloundPictureCellDelegate,ShareViewControllerDelegate,PopAlertViewDeleagte,WXApiDelegate,ShareBoxDelegate>
{
    EGRefreshTableView * _refreshTableView;
    CustomizationNavBar * _cusBar;
    ShareBox * _shareBox;

    BOOL _isLoading;
    BOOL _isLoadingMax;
    BOOL _shouldRefreshOnce;
    CloundAlbumController * cloudAlbumsConroller;
    CQSegmentControl *segControll;
}

@property(nonatomic,strong)NSMutableDictionary * assetDictionary;
@property(nonatomic,assign)viewState viewState;
@end