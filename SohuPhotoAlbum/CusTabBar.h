//
//  CusTabBar.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-28.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TABSHARETAG         11111
#define TABDOWNLOADNTAG     11112
#define TABEDITTAG          11113
#define TABDELETETAG        11114

@class CusTabBar;
@protocol CusTabBarDelegate <NSObject>
- (void)cusTabBar:(CusTabBar *)bar buttonClick:(UIButton *)button;
@end

@interface CusTabBar : UIImageView
@property(nonatomic,assign)id<CusTabBarDelegate> delegate;
- (id)initWithFrame:(CGRect)frame delegate:(id<CusTabBarDelegate>)deletate;
@end
