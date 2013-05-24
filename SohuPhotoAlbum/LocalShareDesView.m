//
//  ShareDescriptionView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-15.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "LocalShareDesView.h"
#import "EmojiUnit.h"
#import "UIImageView+WebCache.h"

#define DESC_COUNT_LIMIT 140

@implementation LocalShareDesView
@synthesize delegate = _delegate;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithModel:(KShareModel)model thumbnail:(UIImage *)thumbnail andDelegate:(id<LocalShareDesViewDelegate>)Adelegete
{
    return [self initWithModel:model thumbnail:thumbnail andDelegate:Adelegete offsetY:20.f];
}
- (id)initWithModel:(KShareModel)model thumbnail:(UIImage *)thumbnail andDelegate:(id<LocalShareDesViewDelegate>)Adelegete offsetY:(CGFloat)offsetY
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.delegate = Adelegete;
        _offsetY = offsetY;
        [self setUserInteractionEnabled:YES];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _model = model;
        //headView
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [self addheadView];
        [self addContentViewwithTunmbnail:thumbnail];
    }
    return self;
}
- (void)addheadView
{
    UIImageView * headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _offsetY, 320, 44)];
    headView.backgroundColor = [UIColor clearColor];
    //    headView.image = [UIImage imageNamed:@"desViewBar.png"];
    headView.image = [UIImage imageNamed:@"navbarnoline.png"];
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
    headView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
}

- (void)addContentViewwithTunmbnail:(UIImage *)thumbnail
{
    _contentView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64 + _offsetY, 300, self.bounds.size.height - 100)];
    [_contentView setUserInteractionEnabled:YES];
    _contentView.image = [[UIImage imageNamed:@"contentBgView.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(90, 124, 124, 90)];
    _contentView.backgroundColor = [UIColor clearColor];
    
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, _contentView.frame.size.width - 20, _contentView.frame.size.height - 55)];
    
    _contentTextView.backgroundColor  = [UIColor clearColor];
    _contentTextView.font = [UIFont systemFontOfSize:16.f];
    _contentTextView.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
    _contentTextView.delegate = self;
    
    [_contentView addSubview:_contentTextView];
    
    _textcount = [[UILabel alloc] initWithFrame:CGRectMake(_contentView.frame.size.width - 100, _contentView.frame.size.height - 45, 100, 40)];
    _textcount.backgroundColor = [UIColor clearColor];
    _textcount.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _textcount.textAlignment = UITextAlignmentCenter;
    _textcount.text = @"0/140";
    [_contentView addSubview:_textcount];
    
    _porTraitView = [[PortraitView alloc] initWithFrame:CGRectMake(10, _contentView.frame.size.height - 45, 40, 40)];
    _porTraitView.imageView.image = thumbnail;
    _porTraitView.clipsToBounds = YES;
    _porTraitView.layer.cornerRadius = 5.f;
    _porTraitView.layer.borderWidth = 1.f;
    _porTraitView.layer.borderColor = [[UIColor blackColor] CGColor];
    _porTraitView.backgroundColor = [UIColor clearColor];
    _porTraitView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_contentView addSubview:_porTraitView];
    [self addSubview:_contentView];
    [_contentTextView  becomeFirstResponder];
}

- (void)setLabelProperty:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    switch (_model) {
        case QQShare:
            label.text = @"分享到腾讯QQ空间";
            break;
        case RenrenShare:
            label.text = @"分享到人人网";
            break;
        case SinaWeiboShare:
            label.text = @"分享到新浪微博";
            break;
        case SohuShare:
            label.text = @"分享到图片墙";
        default:
            break;
    }
}

- (void)sharebuttonClick:(UIButton *)button
{
    switch (button.tag) {
        case 100: //back
            if ([_delegate respondsToSelector:@selector(localShareDesViewcancelShare:)]) {
                [_delegate localShareDesViewcancelShare:self];
                return;
            }
            [self removeFromSuperview];
            break;
        case 200: //share
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
    _textcount.text = [NSString stringWithFormat:@"%d/%d",[textView.text length],DESC_COUNT_LIMIT];
}


@end
