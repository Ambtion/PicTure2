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
@synthesize loadButton;
- (id)initWithFrame:(CGRect)frame delegate:(id<CusTabBarDelegate>)deletate

{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = deletate;
        self.frame = CGRectMake(frame.origin.x,frame.origin.y, 320, 49);
        self.backgroundColor = [UIColor clearColor];
        
        [self setUserInteractionEnabled:YES];
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews
{
    CGRect rect = CGRectMake(0, 0, 49, 49);
    backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = rect;
    backButton.tag = TABBARCANCEL;
    [backButton setImage:[UIImage imageNamed:@"TabBack.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    
    rect.origin.x = 320 - 49 * 2;
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = rect;
    shareButton.tag = TABBARSHARETAG;
    [shareButton setImage:[UIImage imageNamed:@"TabBarShare.png"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareButton];
    
    rect.origin.x = 320 - 49;
    loadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loadButton.frame = rect;
    loadButton.tag = TABBARLOADPIC;
    [loadButton setImage:[UIImage imageNamed:@"TabBarLoad.png"] forState:UIControlStateNormal];
    [loadButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loadButton];
}
- (void)buttonClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(cusTabBar:buttonClick:)]) {
        [_delegate cusTabBar:self buttonClick:button];
    }
}
- (void)hideBarWithAnimation:(BOOL)animation
{
    CGRect backrect = backButton.frame;
    backrect.origin.x = - 49;
    CGRect shareRect = shareButton.frame;
    shareRect.origin.x = 320 + 49;
    CGRect loadRect = loadButton.frame;
    loadRect.origin.x = 320 + 98;
    if (animation) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            backButton.frame = backrect;
            shareButton.frame = shareRect;
            loadButton.frame = loadRect;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        } completion:^(BOOL finished) {
            [self setUserInteractionEnabled:NO];
        }];
    }else{
        backButton.frame = backrect;
        shareButton.frame = shareRect;
        loadButton.frame = loadRect;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
   
}
- (void)showBarWithAnimation:(BOOL)animation
{
    CGRect backrect = backButton.frame;
    backrect.origin.x = 0;
    CGRect shareRect = shareButton.frame;
    shareRect.origin.x = 320 - 98;
    CGRect loadRect = loadButton.frame;
    loadRect.origin.x = 320 - 49 ;
    if (animation) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            backButton.frame = backrect;
            shareButton.frame = shareRect;
            loadButton.frame = loadRect;
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        } completion:^(BOOL finished) {
            [self setUserInteractionEnabled:YES];
        }];
    }else{
        backButton.frame = backrect;
        shareButton.frame = shareRect;
        loadButton.frame = loadRect;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self setUserInteractionEnabled:YES];
    }
   
}
- (BOOL)isHiddenBar
{
    return backButton.frame.origin.x == -44;
}
@end
