//
//  BaseViewController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CusNavigationBar.h"

typedef enum ViewState {
    NomalState  ,
    UPloadState ,
}viewState;

@interface BaseViewController : UIViewController<CusNavigationBarDelegate>
{
    CusNavigationBar * _cusBar;
    viewState _viewState;
}
- (CGRect)subTableViewRect;
@end
