//
//  PhotoDetailController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageScaleView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CusNavigationBar.h"
//#import "CusTabBar.h"

typedef enum _imageStatePosition
{
    AtLess = 0,
    AtNomal,
    AtMore
    
}imageStatePosition;

@interface PhotoDetailController : UIViewController <UIScrollViewDelegate,ImageScaleViewDelegate,CusNavigationBarDelegate>
{
    UIScrollView * _scrollView;
    ImageScaleView * _fontScaleImage;
    ImageScaleView * _curScaleImage;
    ImageScaleView * _rearScaleImage;
    NSMutableArray * _curImageArray;
    imageStatePosition Imagestate;
    CusNavigationBar * _cusBar;

    BOOL canGetActualImage;
//    CusTabBar * _tabBar;
    BOOL _isHidingBar;
    BOOL _isInit;
    BOOL _isRotating;
    BOOL _isAnimating;
    
}
- (id)initWithAssetsArray:(NSArray *)array andCurAsset:(ALAsset *)asset;

@end
