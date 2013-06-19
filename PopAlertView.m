//
//  SCPAlertView_LoginTip.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-28.
//
//

#import "PopAlertView.h"


@implementation PopAlertView
@synthesize userinfo;
@synthesize identifyMes;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<PopAlertViewDeleagte>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle
{
    if (self = [super init]) {
        self.identifyMes = message;
//        [AHAlertView applySystemAlertAppearance];
        [self applyCustomAlertAppearance];
        _delegate = delegate;
        
        __block id delegateWeak = _delegate;
        alert = [[AHAlertView alloc] initWithTitle:title message:message];
        __block PopAlertView * weakSelf = self;
        if (cancelButtonTitle) {
            [alert setCancelButtonTitle:cancelButtonTitle block:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([delegateWeak respondsToSelector:@selector(popAlertView:clickedButtonAtIndex:)]) {
                        [delegateWeak popAlertView:weakSelf clickedButtonAtIndex:0];
                    }
                });
            }];
        }
        if (otherButtonTitle) {
            [alert addButtonWithTitle:otherButtonTitle block:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([delegateWeak respondsToSelector:@selector(popAlertView:clickedButtonAtIndex:)]) {
                        [delegateWeak popAlertView:weakSelf clickedButtonAtIndex:1];
                    }
                });
            }];
        }
    }
    return self;
}
- (void)show
{
    [alert show];
}
- (void)applyCustomAlertAppearance
{
//	[[AHAlertView appearance] setContentInsets:UIEdgeInsetsMake(12, 18, 12, 18)];
    [[AHAlertView appearance] setContentInsets:UIEdgeInsetsMake(12 + 20, 18, 12, 18)];
	[[AHAlertView appearance] setBackgroundImage:[UIImage imageNamed:@"custom-dialog-background"]];
	
	UIEdgeInsets buttonEdgeInsets = UIEdgeInsetsMake(20, 8, 20, 8);
	
	UIImage *cancelButtonImage = [[UIImage imageNamed:@"custom-cancel-normal"]
								  resizableImageWithCapInsets:buttonEdgeInsets];
    UIImage *cancelButtonPress = [[UIImage imageNamed:@"custom-cancel-higthed"]
                                  resizableImageWithCapInsets:buttonEdgeInsets];
	UIImage *normalButtonImage = [[UIImage imageNamed:@"custom-button-normal"]
                                  resizableImageWithCapInsets:buttonEdgeInsets];
    UIImage *normalButotonPress = [[UIImage imageNamed:@"custom-button-higthed"]
                                   resizableImageWithCapInsets:buttonEdgeInsets];
    
	[[AHAlertView appearance] setCancelButtonBackgroundImage:cancelButtonImage
													forState:UIControlStateNormal];
    [[AHAlertView appearance] setCancelButtonBackgroundImage:cancelButtonPress forState:UIControlStateHighlighted];
	[[AHAlertView appearance] setButtonBackgroundImage:normalButtonImage
											  forState:UIControlStateNormal];
    [[AHAlertView appearance] setButtonBackgroundImage:normalButotonPress forState:UIControlStateHighlighted];
	[[AHAlertView appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      [UIFont boldSystemFontOfSize:18], UITextAttributeFont,
                                                      [UIColor blackColor], UITextAttributeTextColor,
                                                      [UIColor clearColor], UITextAttributeTextShadowColor,
                                                      [NSValue valueWithCGSize:CGSizeMake(0, -1)], UITextAttributeTextShadowOffset,
                                                      nil]];
    
	[[AHAlertView appearance] setMessageTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        [UIFont systemFontOfSize:18], UITextAttributeFont,
                                                        [UIColor blackColor], UITextAttributeTextColor,
                                                        [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                        [NSValue valueWithCGSize:CGSizeMake(0, -1)], UITextAttributeTextShadowOffset,
                                                        nil]];
    
	[[AHAlertView appearance] setButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [UIFont boldSystemFontOfSize:14], UITextAttributeFont,
                                                            [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1.f], UITextAttributeTextColor,
                                                            [UIColor clearColor], UITextAttributeTextShadowColor,
                                                            [NSValue valueWithCGSize:CGSizeMake(0, -1)], UITextAttributeTextShadowOffset,
                                                            nil]];
}

//-(void)layoutSubviews
//{
//    for (UIView *v in self.subviews) {
//
//        if ([v isKindOfClass:[UIImageView class]]) {
//            UIImageView *imageV = (UIImageView *)v;
//            UIImage *image = [UIImage imageNamed:@"pop_up_m_bg.png"];
//            [imageV setImage:image];
//        }
//        if ([v isKindOfClass:[UILabel class]]) {
//
//            UILabel *label = (UILabel *)v;
//            label.numberOfLines = 0;
//            label.lineBreakMode = UILineBreakModeWordWrap;
//            label.textColor = [UIColor colorWithRed:98.0/255 green:98.0/255 blue:98.0/255 alpha:1];
//            label.shadowColor = [UIColor clearColor];
//            label.backgroundColor = [UIColor clearColor];
//            label.textAlignment = UITextAlignmentCenter;
//        }
//        if ([v isKindOfClass:NSClassFromString(@"UIAlertButton")]) {
//            UIButton * button = (UIButton *)v;
//            button.titleLabel.minimumFontSize = 10;
//            button.titleLabel.textAlignment = UITextAlignmentCenter;
//            button.backgroundColor = [UIColor clearColor];
//            [button.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
//            UIImage * image = nil;
//            image = [UIImage imageNamed:@"ALertView.png"];
//            image = [image stretchableImageWithLeftCapWidth:(int)(image.size.width+1)>>1 topCapHeight:0];
//            [button setBackgroundImage:image forState:UIControlStateNormal];
//            image = [UIImage imageNamed:@"ALertView_press.png"];
//            image = [image stretchableImageWithLeftCapWidth:(int)(image.size.width+1)>>1 topCapHeight:0];
//            [button setBackgroundImage:image forState:UIControlStateHighlighted];
//
//            [button setTitleColor:[UIColor colorWithRed:98.0/255 green:98.0/255 blue:98.0/255 alpha:1] forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor colorWithRed:98.0/255 green:98.0/255 blue:98.0/255 alpha:1] forState:UIControlStateHighlighted];
//            [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
//            [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
//        }
//    }
//}

@end
