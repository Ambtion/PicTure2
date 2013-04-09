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
    CustomizationNavBar * _cusBar;
    imageStatePosition _imagestate;
    
    BOOL _canGetActualImage;
    BOOL _isHidingBar;
    BOOL _isInit;
    BOOL _isRotating;
    BOOL _isAnimating;
    
    ALAssetsLibrary * _libiary;
    ALAssetsGroup * _group;
}
- (id)initWithAssetsArray:(NSArray *)array andCurAsset:(ALAsset *)asset andAssetGroup:(ALAssetsGroup *)group;
 
@end
