//
//  EGRefreshTableView.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-6-17.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "SCPMoreTableFootView.h"

@protocol EGRefreshTableViewDelegate <NSObject, UITableViewDelegate>
@optional
-(void)pullingreloadMoreTableViewData:(id)sender;
-(void)pullingreloadTableViewDataSource:(id)sender;
@end

@class EGOManager;
@interface EGRefreshTableView : UITableView
{
    EGORefreshTableHeaderView * _refresHeadView;
    SCPMoreTableFootView * _moreFootView;
    EGOManager *_egoManager;
}

@property (assign, nonatomic) NSObject<EGRefreshTableViewDelegate> *pDelegate;
- (void)didFinishedLoadingTableViewData;
@end
