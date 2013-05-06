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
#import "LocalShareDesView.h"
#import "TextAlertView.h"
#import "RequestManager.h"

@interface CloudPictureController : LocalBaseController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,SCPMoreTableFootViewDelegate,CloudPictureCellDelegate,UIActionSheetDelegate,LocalShareDesViewDelegate,TextAlertViewDelegate>
{
    EGORefreshTableHeaderView * _refresHeadView;
    SCPMoreTableFootView * _moreFootView;
    BOOL _isLoading;
    BOOL _isLoadingMax;
    requsetShareMode model;
}

@end