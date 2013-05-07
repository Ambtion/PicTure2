//
//  DetailPhotoStoryController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-17.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomizationNavBar.h"
#import "EGORefreshTableHeaderView.h"
#import "SCPMoreTableFootView.h"
#import "PhotoStoryCell.h"
#import "ShareViewController.h"
#import "RequestManager.h"

@interface PhotoStoryController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,
                            SCPMoreTableFootViewDelegate,CusNavigationBarDelegate,PhotoStoryCellDelegate,UIActionSheetDelegate>
{
    UITableView * _myTableView;
    EGORefreshTableHeaderView * _refresHeadView;
    SCPMoreTableFootView * _moreFootView;
    NSMutableArray * _dataSourceArray;
    CustomizationNavBar * _navBar;
    DesViewShareModel model;
    PhotoStoryCellDataSource * _shareDateSource;
    BOOL _isShareAll;
    BOOL _isLoading;
}
@property(strong,nonatomic)NSString * ownerID;
@property(strong,nonatomic)NSString * storyID;
- (id)initWithStoryId:(NSString *)AstoryID ownerID:(NSString *)AownerID;
@end
