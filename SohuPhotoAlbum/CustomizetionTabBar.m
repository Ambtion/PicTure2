//
//  CusTabBar.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-28.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CustomizetionTabBar.h"

@implementation CustomizetionTabBar
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<CusTabBarDelegate>)deletate

{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = deletate;
        self.frame = CGRectMake(frame.origin.x,frame.origin.y, 320, 44);
        self.backgroundColor = [UIColor clearColor];
//        self.image = [UIImage imageNamed:@"full_screen_buttom_bar.png"];
        [self setUserInteractionEnabled:YES];
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews
{
    CGFloat offset = 28;
    CGRect rect = CGRectMake(30, 0, 44, 44);
    backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = rect;
    backButton.tag = TABBARCANCEL;
    [backButton setImage:[UIImage imageNamed:@"full_screen_share_icon.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    
    rect.origin.x += offset + rect.size.width;
    rect.origin.x += offset + rect.size.width;
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = rect;
    shareButton.tag = TABBARSHARETAG;
    [shareButton setImage:[UIImage imageNamed:@"full_screen_share_icon.png"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareButton];
    
    rect.origin.x += offset + rect.size.width;
    loadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loadButton.frame = rect;
    loadButton.tag = TABBARLOADPIC;
    [loadButton setImage:[UIImage imageNamed:@"full_screen_download_icon.png"] forState:UIControlStateNormal];
    [loadButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loadButton];
}
- (void)buttonClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(cusTabBar:buttonClick:)]) {
        [_delegate cusTabBar:self buttonClick:button];
    }
}
- (void)hideBar
{
    CGRect backrect = backButton.frame;
    backrect.origin.x = -44;
    CGRect shareRect = shareButton.frame;
    shareRect.origin.x = 320 + 44;
    CGRect loadRect = loadButton.frame;
    loadRect.origin.x = 320 + 88;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        backButton.frame = backrect;
        shareButton.frame = shareRect;
        loadButton.frame = loadRect;
    } completion:^(BOOL finished) {
        [self setUserInteractionEnabled:NO];
    }];
}
- (void)showBar
{
    CGRect backrect = backButton.frame;
    backrect.origin.x = 0;
    CGRect shareRect = shareButton.frame;
    shareRect.origin.x = 320 - 88;
    CGRect loadRect = loadButton.frame;
    loadRect.origin.x = 320 - 44 ;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        backButton.frame = backrect;
        shareButton.frame = shareRect;
        loadButton.frame = loadRect;
    } completion:^(BOOL finished) {
        [self setUserInteractionEnabled:YES];
    }];
}
- (BOOL)isHiddenBar
{
    return backButton.frame.origin.x == -44;
}
@end
