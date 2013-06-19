//
//  CloudAlbumPhotosController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-6-18.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGRefreshTableView.h"
#import "CloundPictureCell.h"
#import "ShareBox.h"
#import "ShareViewController.h"

@interface CloundAlbumPhotosController : UIViewController <EGRefreshTableViewDelegate,UITableViewDataSource,CusNavigationBarDelegate,CloundPictureCellDelegate,ShareBoxDelegate,WXApiDelegate,PopAlertViewDeleagte,ShareViewControllerDelegate,UIActionSheetDelegate>
{
    CustomizationNavBar * _cusBar;
    EGRefreshTableView * _refreshTableView;
    ShareBox * _shareBox;
    NSString * _folderId;
    NSString * _folderName;
}

@property(nonatomic,strong)NSString * folderId;
@property(nonatomic,assign)viewState viewState;
- (id)initWithFoldersId:(NSString *)folderId folderName:(NSString *)name;

@end
