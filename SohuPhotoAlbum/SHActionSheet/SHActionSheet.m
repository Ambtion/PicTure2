//
//  SHActionSheet.m
//  ActionSheet
//
//  Created by sohu on 13-6-20.
//  Copyright (c) 2013年 sohu. All rights reserved.
//

#import "SHActionSheet.h"
#import <QuartzCore/QuartzCore.h>

@implementation SHActionSheet

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.frame = self.bounds;
            view.backgroundColor = [UIColor whiteColor];
            [view removeFromSuperview];
            UIView * view = [[UIView alloc] initWithFrame:self.bounds];
            view.backgroundColor = [UIColor whiteColor];
            [self addSubview:view];
            [self sendSubviewToBack:view];
        }
        if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:NSClassFromString(@"UIAlertButton")]) {
            NSLog(@"view %@ %@",NSStringFromCGRect(view.frame),view.superclass);
            if (![[[(UIButton *)view titleLabel] text] isEqualToString:@"取消"]){
                [(UIButton *)view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [(UIButton *)view setBackgroundImage:[UIImage imageNamed:@"button_blue_nomal.png"]  forState:UIControlStateNormal];
                [(UIButton *)view setBackgroundImage:[UIImage imageNamed:@"button_blue_press.png"]  forState:UIControlStateHighlighted];
            }else{
                [(UIButton *)view setBackgroundImage:[UIImage imageNamed:@"button_gray_normal.png"]  forState:UIControlStateNormal];
                [(UIButton *)view setBackgroundImage:[UIImage imageNamed:@"button_gray_press.png"]  forState:UIControlStateHighlighted];
                [(UIButton *)view setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                
            }
        }
    }
}

@end
