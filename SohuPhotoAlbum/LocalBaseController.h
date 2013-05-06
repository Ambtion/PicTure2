//
//  BaseViewController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CustomizationNavBar.h"
#import "UPLoadController.h"

typedef enum ViewState {
    NomalState  ,
    UPloadState ,
    ShareState,
    DeleteState
}viewState;

@interface LocalBaseController : UIViewController<CusNavigationBarDelegate,UPLoadControllerDelegate>
{
    CustomizationNavBar * _cusBar;
    NSMutableArray * selectedArray;
    viewState _viewState;
}
@property(nonatomic,assign)viewState viewState;
@property(nonatomic,strong)UITableView * myTableView;
//@property(nonatomic,assign)NSMutableArray * selectedArray;
- (CGRect)subTableViewRect;

#pragma mark Uplaod Function
- (BOOL)canUpload;
- (void)uploadPicTureWithArray:(NSMutableArray *)assetArray;
@end
