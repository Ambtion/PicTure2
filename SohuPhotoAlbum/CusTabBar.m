//
//  CusTabBar.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-28.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CusTabBar.h"

@implementation CusTabBar
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<CusTabBarDelegate>)deletate

{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = deletate;
        self.frame = CGRectMake(frame.origin.x,frame.origin.y, 320, 44);
        self.image = [UIImage imageNamed:@"full_screen_buttom_bar.png"];
        [self setUserInteractionEnabled:YES];
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews
{
    CGFloat offset = 28;
    CGRect rect = CGRectMake(30, 0, 44, 44);
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.tag = TABSHARETAG;
    [button setImage:[UIImage imageNamed:@"full_screen_share_icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    rect.origin.x += offset + rect.size.width;
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.tag = TABDOWNLOADNTAG;
    [button setImage:[UIImage imageNamed:@"full_screen_download_icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    rect.origin.x += offset + rect.size.width;
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.tag = TABEDITTAG;
    [button setImage:[UIImage imageNamed:@"full_screen_edit_icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    rect.origin.x += offset + rect.size.width;
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.tag = TABDELETETAG;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"full_screen_delete_icon.png"] forState:UIControlStateNormal];
    [self addSubview:button];
}
- (void)buttonClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(cusTabBar:buttonClick:)]) {
        [_delegate cusTabBar:self buttonClick:button];
    }
}

@end
