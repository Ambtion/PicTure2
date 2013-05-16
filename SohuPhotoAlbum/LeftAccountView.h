//
//  AcountView.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-15.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitView.h"

@class LeftAccountView;
@protocol LeftAccountViewDelegate <NSObject>
- (void)accountView:(LeftAccountView *)acountView accessoryClick:(id)sender;
- (void)accountView:(LeftAccountView *)acountView setttingClick:(id)sender;
- (void)accountView:(LeftAccountView *)acountView fullScreenClick:(id)sender;
@end

@interface LeftAccountView : UIImageView<UIGestureRecognizerDelegate>
{
    UIButton * accessory;
    UIButton * setting;
}

@property(strong, nonatomic)PortraitView * portraitImageView;
@property(strong, nonatomic)UILabel * desLabel;
@property(strong, nonatomic)UILabel * nameLabel;
@property(weak, nonatomic)id<LeftAccountViewDelegate> delegate;
@end
