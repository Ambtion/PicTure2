//
//  ImageView_Scale.m
//  ScaleImageView
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "ImageView_Scale.h"
#define OFFSETX 20

@implementation ImageView_Scale
@synthesize Adelegate = _Adelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setPerporty];
        [self addImageView:frame];
    }
    return self;
}
- (void)setPerporty
{
    self.maximumZoomScale = 2.f;
    self.minimumZoomScale = 1.f;
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
}
- (void)addImageView:(CGRect)frame
{
    frame.origin.x += OFFSETX;
    frame.size.width -= 2* OFFSETX;
    _imageView = [[UIImageView alloc] initWithFrame:frame];
    _imageView.backgroundColor = [UIColor clearColor];
    //    _imageView.image = [UIImage imageNamed:@"用户界面.png"];
    [self addSubview:_imageView];
    [_imageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer * tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapgestureWithTwoTap:)];
    tapGesture1.numberOfTapsRequired = 1;
    UITapGestureRecognizer * tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapgestureWithTwoTap:)];
    tapGesture2.numberOfTapsRequired = 2;
    [_imageView addGestureRecognizer:tapGesture1];
    [_imageView addGestureRecognizer:tapGesture2];
    [tapGesture1 requireGestureRecognizerToFail:tapGesture2];
    
}
- (void)handleTapgestureWithTwoTap:(UITapGestureRecognizer *)tap
{
    if (tap.numberOfTapsRequired == 2) {
        if (self.zoomScale != self.maximumZoomScale) {
            [self setZoomScale:self.maximumZoomScale animated:YES];
        }else{
            [self setZoomScale:self.minimumZoomScale animated:YES];
        }
    }
    if (tap.numberOfTapsRequired == 1) {
        NSLog(@"%s",__FUNCTION__);
        if ([_Adelegate respondsToSelector:@selector(imageViewScale:clickCurImage:)])
            [_Adelegate imageViewScale:self clickCurImage:_imageView];
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
- (void)resetImagetView:(UIScrollView *)scrollView
{
    return;
    UIImageView * view =  _imageView;
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    if (view.frame.size.width > scrollView.frame.size.width){
        x = 0;
        offsetX = (view.frame.size.width - scrollView.frame.size.width)/2.f;
    }else{
        offsetX = 0;
        x = (scrollView.frame.size.width - view.frame.size.width)/ 2;
    }
    if (view.frame.size.height > scrollView.frame.size.height){
        y = 0;
        offsetY = ( view.frame.size.height - scrollView.frame.size.height)/2.f;
    }else{
        offsetY = 0;
        y = (scrollView.frame.size.height - view.frame.size.height)/2.f;
    }
    scrollView.contentOffset = CGPointMake(offsetX , offsetY);
    view.frame = CGRectMake(x, y, view.frame.size.width, view.frame.size.height);
    scrollView.contentSize = view.frame.size;
}

@end
