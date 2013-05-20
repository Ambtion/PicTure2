//
//  PhotoDetailController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageScaleView.h"
#import "CustomizationNavBar.h"
#import "LimitCacheForImage.h"
#import "CustomizetionTabBar.h"

typedef enum _imageStatePosition
{
    AtLess = 0,
    AtNomal,
    AtMore
    
}imageStatePosition;

@interface PhotoDetailBaseController : UIViewController <UIScrollViewDelegate,ImageScaleViewDelegate,CusTabBarDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UIScrollView * _scrollView;
    ImageScaleView * _fontScaleImage;
    ImageScaleView * _curScaleImage;
    ImageScaleView * _rearScaleImage;
    NSMutableArray * _curImageArray;
    CustomizetionTabBar * _tabBar;
    imageStatePosition _imagestate;
    
    BOOL _canGetActualImage;
    BOOL _isHidingBar;
    BOOL _isInit;
    BOOL _isRotating;
    BOOL _isAnimating;
}
@property(nonatomic,strong)NSMutableArray * assetsArray;
@property(nonatomic,assign)NSInteger curPageNum;
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)ImageScaleView * fontScaleImage;
@property(nonatomic,strong)ImageScaleView * curScaleImage;
@property(nonatomic,strong)ImageScaleView * rearScaleImage;
@property(nonatomic,strong)CustomizetionTabBar * tabBar;
@property(nonatomic,assign)BOOL isLoading;
@property(nonatomic,assign)BOOL isPushView;
- (int)validPageValue:(NSInteger)value;
- (void)refreshScrollView;

//for overLoad
- (void)applicationDidBecomeActive:(NSNotification *)notification;
- (void)setImageView:(ImageScaleView *)scaleView imageFromAsset:(id)asset;
- (void)setImageView:(ImageScaleView *)scaleView ActualImage:(id)asset andOrientation:(UIImageOrientation)orientation;
- (CGSize)getIdentifyImageSizeWithImageView:(ImageScaleView *)scaleView isPortraitorientation:(BOOL)isPortrait;
- (void)getMoreAssetsAfterCurNum;
- (void)getMoreAssetsBeforeCurNum;
- (void)cusTabBar:(CustomizetionTabBar *)bar buttonClick:(UIButton *)button;
@end
