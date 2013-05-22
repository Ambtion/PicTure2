//
//  StoryFootView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-17.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "StoryFootView.h"


static NSString * const Images4[4]={@"footViewtalk4.png",@"footViewunlike4.png",@"footViewshare4.png",@"footViewdelete4.png"};
static NSString * const Images3[3] = {@"footViewtalk3.png",@"footViewunlike3.png",@"footViewshare3.png"};


@implementation StoryFootView
@synthesize delegate = _delegate;

- (id)initWitFrame:(CGRect)frame thenHiddenDeleteButton:(BOOL)isHidden
{
    self = [super initWithFrame:frame];
    if (self) {
        ishiddenDelete = isHidden;
        self.backgroundColor = [UIColor clearColor];
        [self setUserInteractionEnabled:YES];

        if (isHidden) {
            [self initSubViewsWithOutDeleteButton];
        }else{
            [self initAllSubViews];
        }
    }
    return self;
}

- (void)initAllSubViews
{
    self.image = [UIImage imageNamed:@"footbgView4.png"];
    CGFloat offset = 6;
    CGFloat width = (self.bounds.size.width  - 2 * offset)/ 4.f;
    for (int i = 0; i < 4; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(offset + width * i, 5, width,30);
        [button setImage:[UIImage imageNamed:Images4[i]] forState:UIControlStateNormal];
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        button.tag = i + 1000;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    _likeButton = (UIButton *)[self viewWithTag:1001];
}
- (void)setLikeStateTolike:(BOOL)isLike
{
    DLog(@"hide:%d like:%d",ishiddenDelete,isLike);
    if (ishiddenDelete) {
        if (isLike){
            [_likeButton setImage:[UIImage imageNamed:@"footViewlike3.png"] forState:UIControlStateNormal];
        }else{
            [_likeButton setImage:[UIImage imageNamed:@"footViewunlike3.png"] forState:UIControlStateNormal];
        }
    }else{
        if (isLike){
            [_likeButton setImage:[UIImage imageNamed:@"footViewlike4.png"] forState:UIControlStateNormal];
        }else{
            [_likeButton setImage:[UIImage imageNamed:@"footViewunlike4.png"] forState:UIControlStateNormal];
        }
    }
}
- (void)initSubViewsWithOutDeleteButton
{
    self.image = [UIImage imageNamed:@"footbgView3.png"];
    CGFloat offset = 6;
    CGFloat width = (self.bounds.size.width  - 2 * offset)/ 3.f;
    for (int i = 0; i < 3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(offset + width * i, 5, width, 30.f);
        [button setImage:[UIImage imageNamed:Images3[i]] forState:UIControlStateNormal];
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        button.tag = i + 1000;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    _likeButton = (UIButton *)[self viewWithTag:1001];
}
- (void)clickButton:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(storyFootView:clickButtonAtIndex:)]) {
        [_delegate storyFootView:self clickButtonAtIndex:sender.tag - 1000];
    }
}

@end
