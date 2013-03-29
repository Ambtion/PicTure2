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
#import "BaseViewController.h"
#import "CusTabBar.h"

typedef enum _imageStatePosition
{
    AtLess = 0,
    AtNomal,
    AtMore
    
}imageStatePosition;

@interface PhotoDetailController : BaseViewController <UIScrollViewDelegate,ImageScaleViewDelegate,CusTabBarDelegate>
{
    UIScrollView *_scrollView;
    ImageScaleView * _fontScaleImage;
    ImageScaleView * _curScaleImage;
    ImageScaleView * _rearScaleImage;
    NSMutableArray * _curImageArray;
    imageStatePosition Imagestate;
    CusTabBar * _tabBar;
    BOOL _isHidingBar;
    ALAssetsLibrary * _library;
    
}
- (id)initWithAssetsArray:(NSArray *)array andCurAsset:(ALAsset *)asset;

@end
