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

@class CusNavigationBar;
@protocol CusNavigationBarDelegate <NSObject>
- (void)cusNavigationBar:(CusNavigationBar *)bar buttonClick:(UIButton *)button;
@end

@interface CusNavigationBar : UIImageView

@property(nonatomic,assign)id<CusNavigationBarDelegate> delegate;
@property(nonatomic,retain)UIButton * leftButton;
@property(nonatomic,retain)UIImageView * labelImage;
@property(nonatomic,retain)UILabel * labelText;
@property(nonatomic,retain)UIButton * rightButton1;
@property(nonatomic,retain)UIButton * rightButton2;
@property(nonatomic,retain)UIButton * rightButton3;

- (id)initwithDelegate:(id<CusNavigationBarDelegate>)Adelegate;
@end
