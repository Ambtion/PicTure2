//
//  HostUserController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-23.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalBaseController.h"
#import "EGORefreshTableHeaderView.h"
#import "SCPMoreTableFootView.h"

@interface HostUserController :  LocalBaseController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,SCPMoreTableFootViewDelegate>
{
    EGORefreshTableHeaderView * _refresHeadView;
    SCPMoreTableFootView * _moreFootView;
    BOOL _isLoading;
}
@end
