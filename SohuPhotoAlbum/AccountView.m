//
//  AcountView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-15.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "AccountView.h"

@implementation AccountView
@synthesize portraitImageView;
@synthesize nameLabel;
@synthesize desLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.image = [UIImage imageNamed:nil];
        [self setUserInteractionEnabled:YES];
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureOnAllView:)];
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
        self.backgroundColor = [UIColor redColor];
        portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)];
        [self addSubview:portraitImageView];
        
        CGRect rect = CGRectMake(self.bounds.size.height, 0, 100, self.bounds.size.height/2.f);
        nameLabel = [[UILabel alloc] initWithFrame:rect];
        [self addSubview:nameLabel];
        rect.origin.y += rect.size.height;
        desLabel = [[UILabel alloc] initWithFrame:rect];
        [self addSubview:desLabel];
        
        //箭头
        rect.origin.x += rect.size.width + 10;
        rect.origin.y = 0;
        rect.size.width = self.bounds.size.height;
        rect.size.height = self.bounds.size.height;
        accessory = [[UIImageView alloc] initWithFrame:rect];
        [accessory setUserInteractionEnabled:YES];
        accessory.backgroundColor = [UIColor clearColor];
        accessory.image = [UIImage imageNamed:@"full_screen_upload_icon.png"];
        UITapGestureRecognizer * gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAccestoryTapGesture:)];
        [accessory addGestureRecognizer:gest];
        [self addSubview:accessory];
        //设置
        rect.origin.x += rect.size.width + 10;
        setting = [[UIImageView alloc] initWithFrame:rect];
        setting.backgroundColor = [UIColor grayColor];
        [setting setUserInteractionEnabled:YES];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSettingGesture:)];
        [setting addGestureRecognizer:tap];
        [self addSubview:setting];
    }
    return self;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self];
    return !(CGRectContainsPoint(accessory.frame, point) || CGRectContainsPoint(setting.frame, point));
}
- (void)handleGestureOnAllView:(id)sender
{
    if ([_delegate respondsToSelector:@selector(accountView:fullScreenClick:)]) {
        [_delegate accountView:self fullScreenClick:sender];
    }
}
- (void)handleAccestoryTapGesture:(id)sender
{
    CGAffineTransform transfrom1 = CGAffineTransformRotate(accessory.transform,M_PI);
    [UIView animateWithDuration:0.3 animations:^{
        accessory.transform = transfrom1;
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_delegate respondsToSelector:@selector(accountView:accessoryClick:)]) {
                [_delegate accountView:self accessoryClick:sender];
            }
        });
    }];
}
- (void)handleSettingGesture:(id)sender
{
    if ([_delegate respondsToSelector:@selector(accountView:setttingClick:)])
        [_delegate accountView:self setttingClick:sender];
}
@end
