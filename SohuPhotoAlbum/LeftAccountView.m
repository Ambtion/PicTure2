//
//  AcountView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-15.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "LeftAccountView.h"

@implementation LeftAccountView
@synthesize portraitImageView;
@synthesize nameLabel;
@synthesize desLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.image = [UIImage imageNamed:@"menuBar.png"];
        self.backgroundColor = [UIColor clearColor];
        [self setUserInteractionEnabled:YES];
        
        //portrait
        portraitImageView = [[PortraitView alloc] initWithFrame:CGRectMake(5, 7, 44, 44)];
        portraitImageView.clipsToBounds = YES;
        portraitImageView.layer.cornerRadius = 5.f;
        portraitImageView.layer.borderWidth = 1.f;
        portraitImageView.layer.borderColor = [[UIColor blackColor] CGColor];
        portraitImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:portraitImageView];        
        CGRect rect = CGRectMake(55, 13, 95, 12.f);
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = portraitImageView.frame;
        [self addSubview:button];
        [button addTarget:self action:@selector(handleGestureOnAllView:) forControlEvents:UIControlEventTouchUpInside];
        nameLabel = [[UILabel alloc] initWithFrame:rect];
        [self setNameLabelPorperty];
        [self addSubview:nameLabel];
              
        rect.origin.y += rect.size.height + 10;
        rect.size.height = 12.f;
        desLabel = [[UILabel alloc] initWithFrame:rect];
        [self setDesNameLabelPorperty];
        [self addSubview:desLabel];
        
        //箭头
        rect.origin.x += rect.size.width + 10;
        rect.origin.y = 9.5;
        rect.size.width = 44;
        rect.size.height = 44;
        accessory = [[UIButton alloc] initWithFrame:rect];
        accessory.backgroundColor = [UIColor clearColor];
        [accessory setImage:[UIImage imageNamed:@"accesstory.png"] forState:UIControlStateNormal];
        [accessory addTarget:self action:@selector(handleAccestoryTapGesture:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:accessory];
        
        //设置
        rect.origin.x += rect.size.width + 15;
        setting = [[UIButton alloc] initWithFrame:rect];
        [setting setImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
        setting.center = CGPointMake(setting.center.x, self.bounds.size.height/2.f);
        [setting addTarget:self action:@selector(handleSettingGesture:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:setting];
    }
    return self;
}
- (void)setNameLabelPorperty
{
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = [UIFont systemFontOfSize:12.f];
    self.nameLabel.textColor = [UIColor whiteColor];
}
- (void)setDesNameLabelPorperty
{
    self.desLabel.backgroundColor = [UIColor clearColor];
    self.desLabel.font = [UIFont systemFontOfSize:11.f];
    self.desLabel.textColor = [UIColor grayColor];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_delegate respondsToSelector:@selector(accountView:accessoryClick:)]) {
            [_delegate accountView:self accessoryClick:sender];
        }
    });
}
- (void)handleSettingGesture:(id)sender
{
    if ([_delegate respondsToSelector:@selector(accountView:setttingClick:)])
        [_delegate accountView:self setttingClick:sender];
}
@end
