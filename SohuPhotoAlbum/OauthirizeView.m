//
//  OauthirizeView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-18.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "OauthirizeView.h"
#import "LoginStateManager.h"

@implementation OauthirizeView
@synthesize qqButton,renrenButton,sinabutton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUserInteractionEnabled:YES];
        self.clipsToBounds = YES;
        self.image = [UIImage imageNamed:@"menuBackground.png"];
        self.backgroundColor = [UIColor whiteColor];
        CGFloat offsetX = 29.f;
        CGFloat offsetY = 45.f;
        CGFloat width = 50.f;
        
        self.sinabutton = [UIButton buttonWithType:UIButtonTypeCustom];
        sinabutton.frame = CGRectMake(offsetX, offsetY, width,width);
        self.sinabutton.tag = 1000;
        [self addSubview:sinabutton];
        
        self.qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.qqButton.frame = CGRectMake(sinabutton.frame.origin.x + sinabutton.frame.size.width + offsetX
                                         ,offsetY , width, width);
        self.qqButton.tag = 1001;
        [self addSubview:qqButton];
        
        self.renrenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.renrenButton.frame = CGRectMake(qqButton.frame.origin.x + qqButton.frame.size.width + offsetX,offsetY, width, width);
        self.renrenButton.tag = 1002;
        [self addSubview:self.renrenButton];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake((320 - 44 - 100)/2.f, - 30, 100, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:26.f/255 green:26.f/255 blue:26.f/255 alpha:1.f];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:12.f];
        label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        label.textAlignment = UITextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
        [self addSubview:label];
        [self updataButtonState];
    }
    return self;
}
- (void)updataButtonState
{
    if ([LoginStateManager isSinaBind]) {
        [self.sinabutton setImage:[UIImage imageNamed:@"sina.png"] forState:UIControlStateNormal];
    }else{
        [self.sinabutton setImage:[UIImage imageNamed:@"sinanobind.png"] forState:UIControlStateNormal];
    }
    
    if ([LoginStateManager isQQBing]) {
        [self.qqButton setImage:[UIImage imageNamed:@"qq.png"] forState:UIControlStateNormal];
    }else{
        [self.qqButton setImage:[UIImage imageNamed:@"qqnobind.png"] forState:UIControlStateNormal];
    }
    
    if ([LoginStateManager isRenrenBind]) {
        [self.renrenButton setImage:[UIImage imageNamed:@"renren.png"] forState:UIControlStateNormal];
    }else{
        [self.renrenButton setImage:[UIImage imageNamed:@"renrennobind.png"] forState:UIControlStateNormal];
    }
}
- (void)addtarget:(id)target action:(SEL)action
{
    for (int i = 1000; i < 1003; i++) {
        UIButton * button = (UIButton *)[self viewWithTag:i];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}
@end
