//
//  ComentView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-4.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "MakeCommentView.h"

#define DESC_COUNT_LIMIT 200
#define PLACEHOLDER     @"我来说两句"
#define TITLE_DES       @"200字以内"

#define MAXHEIGTH 
#define CONTENTOFFSETY
#define CONTENTOFFSETX
    
@implementation MakeCommentView
@synthesize delegte = _delegte;
@synthesize textView;
- (id)initWithFrame:(CGRect)frame
{
    frame.size.width = 320;
    frame.size.height = 38;
    self = [super initWithFrame:frame];
    if (self) {
        
        textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240 + 70, 40)];
        textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        textView.minNumberOfLines = 1;
        textView.maxNumberOfLines = 7;
        textView.returnKeyType = UIReturnKeySend; //just as an example
        textView.font = [UIFont systemFontOfSize:15.0f];
        textView.delegate = self;
        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        textView.internalTextView.backgroundColor = [UIColor clearColor];
        textView.backgroundColor = [UIColor clearColor];
                        
//        UIImage * rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
//        UIImage * entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
//        UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
//        entryImageView.frame = CGRectMake(5, 0, 248, 40);
//        entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
        UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
        imageView.image = nil;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        // view hierachy
        [self addSubview:imageView];
        [self addSubview:textView];
    }
    return self;
}

#pragma mark 
- (void)growingTextViewDidClickReturn:(HPGrowingTextView *)growingTextView
{
    if (growingTextView.text && ![growingTextView.text isEqualToString:@""])
        if ([_delegte respondsToSelector:@selector(makeCommentView:commentClick:)])
            [_delegte makeCommentView:self commentClick:nil];
}
#pragma mark - test
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = self.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.frame = r;
}

- (void)addresignFirTapOnView:(UIView *)view
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)];
    tap.delegate = self;
    [view addGestureRecognizer:tap];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([[touch view] isKindOfClass:[UIButton class]] || [[touch view] isKindOfClass:[UITextView class]] )
        return NO;
    return YES;
}

- (void)handleGuesture:(UITapGestureRecognizer *)gesture
{
    [textView resignFirstResponder];
}

- (void)buttonClick:(UIButton *)button
{
    if ([_delegte respondsToSelector:@selector(makeCommentView:commentClick:)]) {
        [_delegte makeCommentView:self commentClick:button];
    }
}
@end
