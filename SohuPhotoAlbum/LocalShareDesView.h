//
//  ShareDescriptionView.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-15.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitView.h"
#import "CustomizationNavBar.h"

@class LocalShareDesView;
@protocol LocalShareDesViewDelegate <NSObject>
- (void)localShareDesView:(LocalShareDesView *)view shareTo:(KShareModel)model withDes:(NSString *)text;
@optional
- (void)localShareDesViewcancelShare:(LocalShareDesView *)view;
@end
@interface LocalShareDesView : UIImageView<UITextViewDelegate,CusNavigationBarDelegate>
{
    UIImageView * _thumbNailView;
    KShareModel  _model;
    UIButton * _shareButton;
    UIImageView * _contentView;
    UITextView * _contentTextView;
    UILabel * _textcount;
    PortraitView * _porTraitView;
    CGFloat _offsetY;
    CustomizationNavBar*  _navBar;
}
@property(weak,nonatomic) id<LocalShareDesViewDelegate> delegate;
- (id)initWithModel:(KShareModel )model thumbnail:(UIImage *)thumbnail andDelegate:(id<LocalShareDesViewDelegate>)Adelegete;
- (id)initWithModel:(KShareModel )model thumbnail:(UIImage *)thumbnail andDelegate:(id<LocalShareDesViewDelegate>)Adelegete offsetY:(CGFloat)offsetY;
@end
