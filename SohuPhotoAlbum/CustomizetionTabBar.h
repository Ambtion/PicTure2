//
//  CusTabBar.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-28.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TABBARCANCEL           11114
#define TABBARSHARETAG         11111
#define TABBARLOADPIC          11112
#define TABBARDELETE           11113

@class CustomizetionTabBar;
@protocol CusTabBarDelegate <NSObject>
- (void)cusTabBar:(CustomizetionTabBar *)bar buttonClick:(UIButton *)button;
@end

@interface CustomizetionTabBar : UIImageView
{
    UIButton * backButton;
    UIButton * shareButton;
    UIButton * loadButton;
    UIButton * deleteButton;
    
}
@property(nonatomic,weak)id<CusTabBarDelegate> delegate;
@property(strong,nonatomic)UIButton * loadButton;
@property(strong,nonatomic)UIButton * deleteButton;
- (id)initWithFrame:(CGRect)frame delegate:(id<CusTabBarDelegate>)deletate;
- (void)hideBarWithAnimation:(BOOL)animation;
- (void)showBarWithAnimation:(BOOL)animation;
- (BOOL)isHiddenBar;
@end
