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

//#import "CusTabBar.h"

typedef enum _imageStatePosition
{
    AtLess = 0,
    AtNomal,
    AtMore
    
}imageStatePosition;

@interface PhotoDetailBaseController : UIViewController <UIScrollViewDelegate,ImageScaleViewDelegate,CusNavigationBarDelegate>
{
    UIScrollView * _scrollView;
    ImageScaleView * _fontScaleImage;
    ImageScaleView * _curScaleImage;
    ImageScaleView * _rearScaleImage;
    NSMutableArray * _curImageArray;
    CustomizationNavBar * _cusBar;
    imageStatePosition _imagestate;
    
    BOOL _canGetActualImage;
    BOOL _isHidingBar;
    BOOL _isInit;
    BOOL _isRotating;
    BOOL _isAnimating;
    
    ALAssetsLibrary * _libiary;
//    ALAssetsGroup * _group;
}
@property(nonatomic,retain)NSMutableArray * assetsArray;
@property(nonatomic,assign)NSInteger curPageNum;
@property(nonatomic,retain)UIScrollView * scrollView;
@property(nonatomic,retain)ImageScaleView * fontScaleImage;
@property(nonatomic,retain)ImageScaleView * curScaleImage;
@property(nonatomic,retain)ImageScaleView * rearScaleImage;
@property(nonatomic,retain)CustomizationNavBar * cusBar;
//@property(nonatomic,retain)LimitCacheForImage * cache;
//@property(nonatomic,retain)ALAssetsGroup * group;

//- (id)initWithAssetsArray:(NSArray *)array andCurAsset:(ALAsset *)asset andAssetGroup:(ALAssetsGroup *)group;
- (int)validPageValue:(NSInteger)value;
- (void)refreshScrollView;
@end
