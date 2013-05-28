//
//  CommentController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "SCPMoreTableFootView.h"
#import "CustomizationNavBar.h"
#import "CommentCell.h"
#import "RequestManager.h"
#import "MakeCommentView.h"

@interface CommentController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,
SCPMoreTableFootViewDelegate,CusNavigationBarDelegate,CommentCellDelegate,MakeCommentViewDelegate>
{
    UITableView * _myTableView;
    UIImageView * _myBgView;
    EGORefreshTableHeaderView * _refresHeadView;
    SCPMoreTableFootView * _moreFootView;
    NSMutableArray * _dataSourceArray;
    CustomizationNavBar * _navBar;
    BOOL _isLoading;
    source_type type;
    MakeCommentView * commentView;
    BOOL _isSending;
    NSDictionary * userInfo;
}

@property(nonatomic,strong)NSString * ownerId;
@property(nonatomic,strong)NSString * sourceId;
@property(nonatomic,strong)NSString * imageUrl;
- (id)initWithSourceId:(NSString *)AsourceId andSoruceType:(source_type)Atype withBgImageURL:(NSString * )bgUrl WithOwnerID:(NSString *)ownID;
@end
