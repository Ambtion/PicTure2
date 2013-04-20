//
//  StoryFootView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-17.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "StoryFootView.h"


static NSString * const normalImage[4] = {@"storyTalkButton.png",@"storylikeButton.png",
                                            @"storyShareButton.png",@"storyDeleteButton.png"};
static NSString * const higthedimage[4] = {};

@implementation StoryFootView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.image = [UIImage imageNamed:@"stroyFootViewbg.png"];
        [self setUserInteractionEnabled:YES];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    CGFloat offset = 6;
    CGFloat width = (self.bounds.size.width  - 2 * offset)/ 4.f;
    for (int i = 0; i < 4; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustomg];
        button.frame = CGRectMake(offset + width * i, 0, width, self.bounds.size.height);
        [button setImage:[UIImage imageNamed:normalImage[i]] forState:UIControlStateNormal];
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        button.tag = i;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}
- (void)clickButton:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(storyFootView:clickButtonAtIndex:)]) {
        [_delegate storyFootView:self clickButtonAtIndex:sender.tag];
    }
}

@end
