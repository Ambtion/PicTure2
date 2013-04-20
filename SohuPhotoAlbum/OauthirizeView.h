//
//  OauthirizeView.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-18.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OauthirizeView : UIImageView
@property(nonatomic,strong)UIButton * sinabutton;
@property(nonatomic,strong)UIButton * qqButton;
@property(nonatomic,strong)UIButton * renrenButton;
- (void)addtarget:(id)target action:(SEL)action;
- (void)updataButtonState;

@end
