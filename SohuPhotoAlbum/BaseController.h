//
//  BaseViewController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomizationNavBar.h"


#define BACKGORUNDCOLOR [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1.f]

typedef enum ViewState {
    NomalState  ,
    UPloadState ,
}viewState;

@interface BaseController : UIViewController<CusNavigationBarDelegate>
{
    CustomizationNavBar * _cusBar;
    viewState _viewState;
}
- (CGRect)subTableViewRect;
@end
