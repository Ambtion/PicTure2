//
//  CloudAlbumPhotosController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-6-18.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGRefreshTableView.h"
#import "CloudPictureCell.h"
#import "ShareBox.h"
#import "ShareViewController.h"

@interface CloudAlbumPhotosController : UIViewController <EGRefreshTableViewDelegate,UITableViewDataSource,CusNavigationBarDelegate,CloudPictureCellDelegate,ShareBoxDelegate,WXApiDelegate,PopAlertViewDeleagte,ShareViewControllerDelegate>
{
    CustomizationNavBar * _cusBar;
    EGRefreshTableView * _refreshTableView;
    ShareBox * _shareBox;
    NSString * _folderId;
}

@property(nonatomic,strong)NSString * folderId;
@property(nonatomic,assign)viewState viewState;
- (id)initWithFoldersId:(NSString *)folderId;

@end
