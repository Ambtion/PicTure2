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
@synthesize tapEnabled = _tapEnabled;
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
    self.bouncesZoom = YES;
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.tapEnabled = YES;
}

- (void)addImageView
{
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imageView];
    [_imageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer * tapGesture1 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapgestureWithTap:)] autorelease];
    tapGesture1.delegate= self;
    tapGesture1.numberOfTapsRequired = 1;
    UITapGestureRecognizer * tapGesture2 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapgestureWithTap:)] autorelease];
    tapGesture2.numberOfTapsRequired = 2;
    tapGesture2.delegate = self;
    [_imageView addGestureRecognizer:tapGesture1];
    [_imageView addGestureRecognizer:tapGesture2];
    [tapGesture1 requireGestureRecognizerToFail:tapGesture2];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.tapEnabled;
}
- (void)handleTapgestureWithTap:(UITapGestureRecognizer *)tap
{
    
    if (tap.numberOfTapsRequired == 2) {
        if (self.zoomScale != self.maximumZoomScale) {
            [self zoomToRect:[self zoomRectForScale:self.maximumZoomScale withCenter:[tap locationInView:tap.view]] animated:YES];
        }else{
            [self zoomToRect:[self zoomRectForScale:self.minimumZoomScale withCenter:[tap locationInView:tap.view]] animated:YES];
        }
    }
    if (tap.numberOfTapsRequired == 1) {
        if ([_Adelegate respondsToSelector:@selector(imageViewScale:clickCurImage:)])
            [_Adelegate imageViewScale:self clickCurImage:_imageView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)aScrollView
{
    //保持X,Y方向的偏移量一致(也就是时刻保持居中)
    CGFloat offsetX = (self.bounds.size.width > self.contentSize.width) ?
    (self.bounds.size.width - self.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (self.bounds.size.height > self.contentSize.height)?
    (self.bounds.size.height - self.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(self.contentSize.width * 0.5 + offsetX,
                                   self.contentSize.height * 0.5 + offsetY);
}

#pragma mark Scale Funciton
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self frame].size.height / scale;
    zoomRect.size.width  = [self frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    //make gesture location as the scale center,then get origin
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}
@end
