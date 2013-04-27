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

@interface PhotoDetailBaseController : UIViewController <UIScrollViewDelegate,ImageScaleViewDelegate,
                                                        CusNavigationBarDelegate,CusTabBarDelegate>
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
    
    ALAssetsLibrary * _libiary;
}
@property(nonatomic,strong)NSMutableArray * assetsArray;
@property(nonatomic,assign)NSInteger curPageNum;
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)ImageScaleView * fontScaleImage;
@property(nonatomic,strong)ImageScaleView * curScaleImage;
@property(nonatomic,strong)ImageScaleView * rearScaleImage;
@property(nonatomic,strong)CustomizetionTabBar * tabBar;

- (int)validPageValue:(NSInteger)value;
- (void)refreshScrollView;
@end
