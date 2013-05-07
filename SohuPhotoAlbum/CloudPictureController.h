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

@interface CloudPictureController : LocalBaseController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,SCPMoreTableFootViewDelegate,CloudPictureCellDelegate,UIActionSheetDelegate,ShareViewControllerDelegate>
{
    EGORefreshTableHeaderView * _refresHeadView;
    SCPMoreTableFootView * _moreFootView;
    BOOL _isLoading;
    BOOL _isLoadingMax;
    DesViewShareModel model;
}

@end