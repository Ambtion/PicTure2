//
//  DetailPhotoStoryController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-17.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomizationNavBar.h"
#import "EGRefreshTableView.h"
#import "PhotoStoryCell.h"
#import "ShareViewController.h"
#import "RequestManager.h"
#import "TitleAccountView.h"
#import "ShareBox.h"

@interface PhotoStoryController : UIViewController<EGRefreshTableViewDelegate,UITableViewDataSource,CusNavigationBarDelegate,PhotoStoryCellDelegate,ShareBoxDelegate,WXApiDelegate,ShareViewControllerDelegate,PopAlertViewDeleagte>
{
     
    EGRefreshTableView * _refreshTableView;
    NSMutableArray * _dataSourceArray;
    NSMutableArray * _assetArray;

    CustomizationNavBar * _navBar;
    TitleAccountView * _titleAccoutView;
    
    ShareBox * _shareBox;
    BOOL _isShareAll;
    PhotoStoryCellDataSource * _shareDateSource;
    PhotoStoryCell * tempCellForDelete;
    NSDictionary * _userInfo;
}

@property(strong,nonatomic)NSString * ownerID;
@property(strong,nonatomic)NSString * storyID;
@property(strong,nonatomic)NSString * storyName;
@property(strong,nonatomic)NSString * storyDes;
@property(strong,nonatomic)NSString * showID;
@property(strong,nonatomic)NSDictionary * userInfo;
- (id)initWithStoryId:(NSString *)AstoryID ownerID:(NSString *)AownerID;
@end
