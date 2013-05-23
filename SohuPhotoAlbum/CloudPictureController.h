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
#import "CloudPictureCell.h"
#import "LocalBaseController.h"
#import "RequestManager.h"
#import "ShareViewController.h"
#import "ShareBox.h"

@protocol CloudPictureControllerDelegate <NSObject>

@end
@interface CloudPictureController : LocalBaseController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,SCPMoreTableFootViewDelegate,CloudPictureCellDelegate,UIActionSheetDelegate,ShareViewControllerDelegate,PopAlertViewDeleagte,WXApiDelegate,ShareBoxDelegate>
{
    EGORefreshTableHeaderView * _refresHeadView;
    SCPMoreTableFootView * _moreFootView;
    BOOL _isLoading;
    BOOL _isLoadingMax;
    ShareBox * _shareBox;
    BOOL _shouldRefreshOnce;
}

@property(nonatomic,strong)NSMutableDictionary * assetDictionary;
@end