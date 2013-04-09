//
//  CusNavigationBar.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LEFTBUTTON      10000
#define RIGHT1BUTTON    10001
#define RIGHT2BUTTON    10002
#define RIGHT3BUTTON    10003
#define CANCELBUTTONTAG 10004
#define ALLSELECTEDTAG  10005
#define RIGHTSTATETAG   10006

@class CustomizationNavBar;
@protocol CusNavigationBarDelegate <NSObject>
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button;
@end

@interface CustomizationNavBar : UIView
{
    UIImageView * _normalBar;
    UIImageView * _stateBar;
}

@property(nonatomic,assign)id<CusNavigationBarDelegate> delegate;
@property(nonatomic,retain)UIButton * nLeftButton;
@property(nonatomic,retain)UIImageView * nLabelImage;
@property(nonatomic,retain)UILabel * nLabelText;
@property(nonatomic,retain)UIButton * nRightButton1;
@property(nonatomic,retain)UIButton * nRightButton2;
@property(nonatomic,retain)UIButton * nRightButton3;

@property(nonatomic,retain)UILabel * sLabelText;
@property(nonatomic,retain)UIButton * sLeftButton;
@property(nonatomic,retain)UIButton * sAllSelectedbutton;
@property(nonatomic,retain)UIButton * sRightStateButton;

- (id)initwithDelegate:(id<CusNavigationBarDelegate>)Adelegate;
- (void)switchBarState;
- (void)setBackgroundImage:(UIImage *)image;
@end
