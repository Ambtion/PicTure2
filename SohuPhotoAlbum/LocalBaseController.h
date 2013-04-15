//
//  BaseViewController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomizationNavBar.h"
#import "LoginViewController.h"

#define BACKGORUNDCOLOR [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1.f]

typedef enum ViewState {
    NomalState  ,
    UPloadState ,
}viewState;

@interface LocalBaseController : UIViewController<CusNavigationBarDelegate,LoginViewControllerDelegate>
{
    CustomizationNavBar * _cusBar;
    NSMutableArray * _selectedArray;
    viewState _viewState;
}
@property(nonatomic,assign)viewState viewState;
@property(nonatomic,strong)UITableView * myTableView;
//@property(nonatomic,assign)NSMutableArray * selectedArray;
- (CGRect)subTableViewRect;

#pragma mark Uplaod Function
- (BOOL)canUpload;
- (void)uploadPicTureWithArray:(NSMutableArray *)assetArray;
- (void)showPopAlerViewnotTotasView:(BOOL)isPopView WithMes:(NSString *)mesage;
@end
