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
#define RIGHTSELECTEDTAG   10006

@interface GIFButton : UIButton
- (void)setButtoUploadState:(BOOL)isUploadStateButton;
@end

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
@property(nonatomic,retain)GIFButton * nLeftButton;
@property(nonatomic,retain)UIImageView * nLabelImage;
@property(nonatomic,retain)UILabel * nLabelText;
@property(nonatomic,retain)GIFButton * nRightButton1;
@property(nonatomic,retain)GIFButton * nRightButton2;
@property(nonatomic,retain)GIFButton * nRightButton3;

@property(nonatomic,retain)UILabel * sLabelText;
@property(nonatomic,retain)UIButton * sLeftButton;
@property(nonatomic,retain)GIFButton * sAllSelectedbutton;
@property(nonatomic,retain)GIFButton * sRightStateButton;

- (id)initwithDelegate:(id<CusNavigationBarDelegate>)Adelegate;
- (void)switchBarStateToUpload:(BOOL)isUploadState;
- (void)setBackgroundImage:(UIImage *)image;
@end
