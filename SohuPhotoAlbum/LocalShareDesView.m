//
//  ShareDescriptionView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-15.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "LocalShareDesView.h"
#import "EmojiUnit.h"
#import "PortraitView.h"

#define DESC_COUNT_LIMIT 140

@implementation LocalShareDesView
@synthesize delegate = _delegate;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithModel:(DesViewShareModel )model thumbnail:(UIImage *)thumbnail andDelegate:(id<LocalShareDesViewDelegate>)Adelegete
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.delegate = Adelegete;
        [self setUserInteractionEnabled:YES];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _model = model;
        //headView
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        //        [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [self addheadView];
        [self addContentViewwithTunmbnail:thumbnail];
    }
    return self;
}
- (void)addheadView
{
    UIImageView * headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    headView.backgroundColor = [UIColor clearColor];
    headView.image = [UIImage imageNamed:@"desViewBar.png"];
    
    [headView setUserInteractionEnabled:YES];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    backBtn.tag = 100;
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(44 + 10, 0, 320 - 88, 44)];
    [self setLabelProperty:label];
    [headView addSubview:label];
    [backBtn addTarget:self action:@selector(sharebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.frame = CGRectMake(320 - 44, 0, 44, 44);
    [_shareButton setImage:[UIImage imageNamed:@"desShareBtn.png"] forState:UIControlStateNormal];
    _shareButton.tag = 200;
    [_shareButton addTarget:self action:@selector(sharebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_shareButton];
    [self addSubview:headView];
}

- (void)addContentViewwithTunmbnail:(UIImage *)thumbnail
{
    _contentView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 84, 300, self.bounds.size.height - 100)];
    [_contentView setUserInteractionEnabled:YES];
    _contentView.image = [[UIImage imageNamed:@"contentBgView.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, _contentView.frame.size.width - 20, _contentView.frame.size.height - 60)];
    _contentTextView.backgroundColor  = [UIColor clearColor];
    _contentTextView.font = [UIFont boldSystemFontOfSize:14.f];
    _contentTextView.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
    _contentTextView.delegate = self;
    
    [_contentView addSubview:_contentTextView];
    _textcount = [[UILabel alloc] initWithFrame:CGRectMake(_contentView.frame.size.width - 100, _contentView.frame.size.height - 45, 100, 40)];
    
    _textcount.backgroundColor = [UIColor clearColor];
    _textcount.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _textcount.textAlignment = UITextAlignmentCenter;
    _textcount.text = @"0/140";
    [_contentView addSubview:_textcount];
    
    
    PortraitView * imageView = [[PortraitView alloc] initWithFrame:CGRectMake(10, _contentView.frame.size.height - 45, 40, 40)];
    imageView.imageView.image = thumbnail;
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 5.f;
    imageView.layer.borderWidth = 1.f;
    imageView.layer.borderColor = [[UIColor blackColor] CGColor];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_contentView addSubview:imageView];
    [self addSubview:_contentView];
    [_contentTextView  becomeFirstResponder];
}

- (void)setLabelProperty:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    switch (_model) {
        case QQModel:
            label.text = @"腾讯QQ空间上传";
            break;
        case RenrenModel:
            label.text = @"人人校内分享";
            break;
        case SinaModel:
            label.text = @"新浪微博分享";
            break;
        default:
            break;
    }
}

- (void)sharebuttonClick:(UIButton *)button
{
    switch (button.tag) {
        case 100: //back
            [self removeFromSuperview];
            break;
        case 200: //share
            DLog(@"%s",__FUNCTION__);
            if ([_delegate respondsToSelector:@selector(localShareDesView:shareTo:withDes:)]) {
                [_delegate localShareDesView:self shareTo:_model withDes:_contentTextView.text];
            }
            break;
        default:
            break;
    }
}

#pragma mark keyBoard show/hide
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary * dic = [notification userInfo];
    CGFloat heigth = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect rect = _contentView.frame;
    rect.size.height = self.bounds.size.height - 64 - 35 - heigth;
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = rect;
    }];
}

#pragma mark TextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > DESC_COUNT_LIMIT) ? NO : YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text && ![textView.text isEqualToString:@""]) {
        //            [_shareButton setAlpha:1.0];
        //            [_shareButton setUserInteractionEnabled:YES];
        //        if (!_placeHolder.hidden)
        //            [_placeHolder setHidden:YES];
    }else{
        //            [_shareButton setAlpha:0.3];
        //            [_shareButton setUserInteractionEnabled:NO];
        //        if (_placeHolder.hidden)
        //            [_placeHolder setHidden:NO];
    }
}


@end
