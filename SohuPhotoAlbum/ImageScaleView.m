//
//  ImageView_Scale.m
//  ScaleImageView
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "ImageScaleView.h"
#define OFFSETX 0

@implementation ImageScaleView
@synthesize Adelegate = _Adelegate;
@synthesize imageView = _imageView;
- (void)dealloc
{
    [_imageView release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setPerporty];
        [self addImageView];
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

- (void)addImageView
{
//    frame.origin.x += OFFSETX;
//    frame.size.width -= 2* OFFSETX;
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.backgroundColor = [UIColor clearColor];
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

@end
