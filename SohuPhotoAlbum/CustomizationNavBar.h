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
- (BOOL)isUploadStateButton;
@end

@class CustomizationNavBar;
@protocol CusNavigationBarDelegate <NSObject>
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload;
@end

@interface CustomizationNavBar : UIView
{
    UIImageView * _normalBar;
    UIImageView * _stateBar;
}

@property(nonatomic,weak)id<CusNavigationBarDelegate> delegate;
@property(nonatomic,strong)UIImageView * normalBar;
@property(nonatomic,strong)UIButton * nLeftButton;
@property(nonatomic,strong)UIImageView * nLabelImage;
@property(nonatomic,strong)UILabel * nLabelText;
@property(nonatomic,strong)GIFButton * nRightButton1;
@property(nonatomic,strong)GIFButton * nRightButton2;
@property(nonatomic,strong)GIFButton * nRightButton3;

@property(nonatomic,strong)UILabel * sLabelText;
@property(nonatomic,strong)UIButton * sLeftButton;
@property(nonatomic,strong)UIButton * sAllSelectedbutton;
@property(nonatomic,strong)UIButton * sRightStateButton;

- (id)initwithDelegate:(id<CusNavigationBarDelegate>)Adelegate;
- (void)switchBarStateToUpload:(BOOL)isUploadState;
- (void)setBackgroundImage:(UIImage *)image;
@end
