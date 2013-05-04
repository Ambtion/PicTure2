//
//  ComentView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-4.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "ComentView.h"

#define DESC_COUNT_LIMIT 200
#define PLACEHOLDER  @"我来说两句"
#define TITLE_DES @"300字以内"

@implementation ComentView
@synthesize textView = _textView;
@synthesize textCountLimit = _textCountLimit;
@synthesize comentButton = _comentButton;
- (id)initWithFrame:(CGRect)frame
{
    frame.size.width = 320;
    frame.size.height = 38;
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [[UIImage imageNamed:@"commentBar_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(19, 19, 19, 19)];
        [imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)];
        tapGesture.delegate = self;
        [imageView addGestureRecognizer:tapGesture];
        imageView.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
        [self addSubview:imageView];
        
        UIImageView * commentbgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 6, 259, 26)];
        commentbgView.image = [[UIImage imageNamed:@"commentBar_textBg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 100, 13, 100)];
        commentbgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubview:commentbgView];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(commentbgView.frame.origin.x + 8, commentbgView.frame.origin.y + 3, commentbgView.frame.size.width - 16,commentbgView.frame.size.height - 6)];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:18];
//        _textView.scrollEnabled  = NO;
        _textView.returnKeyType = UIReturnKeyDefault;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _textView.delegate = self;
        _textView.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1];
        _placeHolder = [[UITextField alloc] initWithFrame:CGRectMake(_textView.frame.origin.x + 5,_textView.frame.origin.y + 2, _textView.frame.size.width - 5, _textView.frame.size.height - 4)];
        _placeHolder.font = [UIFont systemFontOfSize:13];
        _placeHolder.placeholder = PLACEHOLDER;
        [_placeHolder setUserInteractionEnabled:NO];
        [self addSubview:_textView];
        [self addSubview:_placeHolder];
        [self textViewDidChange:_textView];
        
        _comentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _comentButton.frame = CGRectMake(269, 6, 45, 26);
        [_comentButton setImage:[UIImage imageNamed:@"commentBar_Button.png"] forState:UIControlStateNormal];
        _comentButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_comentButton];
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self resetTextViewFiled];
    }
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength >(_textCountLimit ? _textCountLimit:DESC_COUNT_LIMIT) )? NO : YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text && ![textView.text isEqualToString:@""]) {
        if (!_placeHolder.hidden)
            [_placeHolder setHidden:YES];
    }else{
        if (_placeHolder.hidden)
            [_placeHolder setHidden:NO];
    }
}
- (void)resetTextViewFiled
{
    CGRect rect = self.frame;
    if (rect.origin.y - 20 > 44){
        rect.origin.y -= 20;
        rect.size.height += 20;
        self.frame = rect;
    }
}
- (void)addresignFirTapOnView:(UIView *)view
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)];
    tap.delegate = self;
    [view addGestureRecognizer:tap];
}
- (void)commentbuttonAddtar:(id)target action:(SEL)action
{
    [_comentButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([[touch view] isKindOfClass:[UIButton class]] || [[touch view] isKindOfClass:[UITextView class]] )
        return NO;
    return YES;
}

- (void)handleGuesture:(UITapGestureRecognizer *)gesture
{
    [_textView resignFirstResponder];
}
@end
