//
//  ComentView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-4.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "MakeCommentView.h"

#define DESC_COUNT_LIMIT 200
#define PLACEHOLDER  @"我来说两句"
#define TITLE_DES @"200字以内"

@implementation MakeCommentView
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
        
        
        _commenBgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 6, 259, 26)];
        _commenBgView.image = [[UIImage imageNamed:@"commentBar_textBg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 100, 13, 100)];
        _commenBgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_commenBgView setUserInteractionEnabled:YES];
        [self addSubview:_commenBgView];
        
        //243
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 3, _commenBgView.frame.size.width - 16, _commenBgView.frame.size.height - 6)];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _textView.backgroundColor = [UIColor redColor];
        _textView.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:14];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _textView.delegate = self;
        _textView.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1];
        _placeHolder = [[UITextField alloc] initWithFrame:CGRectMake(_textView.frame.origin.x + 5,_textView.frame.origin.y + 5, _textView.frame.size.width - 5, _textView.frame.size.height - 4)];
        _placeHolder.font = [UIFont systemFontOfSize:14];
        _placeHolder.placeholder = PLACEHOLDER;
        [_placeHolder setUserInteractionEnabled:NO];
        [_commenBgView addSubview:_textView];
        [self addSubview:_placeHolder];
        [self textViewDidChange:_textView];
        
        _comentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _comentButton.frame = CGRectMake(269, 10, 45, 26);
        [_comentButton setImage:[UIImage imageNamed:@"commentBar_Button.png"] forState:UIControlStateNormal];
        _comentButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_comentButton];
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    if ([text isEqualToString:@"\n"]) {
//        [self resetTextViewFiled];
//    }
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
    [self resetTextViewFiled];
}
- (void)resetTextViewFiled
{
    CGSize size = _textView.contentSize;
    CGRect rect = self.frame;
    CGFloat buttom = self.frame.size.height + self.frame.origin.y;
    rect.size.height = size.height + 8.f;
    rect.origin.y = buttom - rect.size.height;
    if (rect.origin.y > 26)
        self.frame = rect;
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
