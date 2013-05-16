//
//  StatusImageView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-28.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "StatusImageView.h"

#define BorderWidth 0.0f

@implementation StatusImageView
@synthesize selected = _selected;
@synthesize isShowStatus;
@synthesize statueImage = _statuImage;
@synthesize actualView = _actualView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView * view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor clearColor];
        
        _actualView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, -1, self.bounds.size.width + 2, self.bounds.size.height + 2)];
        [view addSubview:_actualView];
        view.clipsToBounds = YES;
        [self addSubview:view];
//        [self addSubview:_actualView];
//        _actualView.layer.borderColor = [[UIColor colorWithRed:192.f/255.f green:192.f/255.f blue:192.f/255.f alpha:1.f]CGColor];
//        _actualView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:_actualView.bounds] CGPath];
//        _actualView.layer.borderWidth = 0.0f;
//        _actualView.layer.shouldRasterize = YES;
        _statuImage = [[UIImageView alloc] initWithFrame:self.bounds];
        _statuImage.backgroundColor = [UIColor clearColor];
        [self addSubview:_statuImage];
        [self resetStatusImageToHidden];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    if (!isShowStatus)
        return;
    _selected = selected;
    if (selected) {
        [_actualView setAlpha:1.f];
        [self shouldShowAcutalViewLayer:NO];
        [_statuImage setImage:[UIImage imageNamed:@"check_box_select_image.png"]];
        
    }else{
        [self uploadStatus];
    }
}
- (void)showStatusWithoutUpload
{
    isShowStatus = YES;
    isUpload = NO;
    [self uploadStatus];
}
- (void)showStatusWithUpload
{
    isShowStatus = YES;
    isUpload = YES;
    [self uploadStatus];
}
- (void)uploadStatus
{
    if (!isShowStatus)
    {
        [self resetStatusImageToHidden];
        return;
    }
    [_statuImage setHidden:NO];
    if (isUpload) {
        [_actualView setAlpha:0.5];
        [_statuImage setImage:[UIImage imageNamed:@"upload_pic.png"]];
//        [self shouldShowAcutalViewLayer:YES];
    }else{
        [_actualView setAlpha:0.5], [_statuImage setImage:nil];
//        [self shouldShowAcutalViewLayer:NO];
    }
}
- (void)resetStatusImageToHidden
{
    self.selected = NO;
    isShowStatus = NO;
    isUpload = NO;
    [_actualView setAlpha:1.0];
    [_statuImage setHidden:YES];
    _statuImage.image = nil;
}
- (void)resetImageViewTohide
{
    [self resetStatusImageToHidden];
    [_actualView.layer setBorderWidth:0.0f];
}
- (void)shouldShowAcutalViewLayer:(BOOL)isShow
{
    if (isShow || _actualView.image) {
        [_actualView.layer setBorderWidth:BorderWidth];
    }else{
        [_actualView.layer setBorderWidth:0.0f];
    }
}

#pragma mark - Reloadfunctions
- (void)setImage:(UIImage *)image
{
    if (!image) {
        [self setUserInteractionEnabled:NO];
        _actualView.layer.borderWidth = 0.f;
    }else{
        [self setUserInteractionEnabled:YES];
        _actualView.layer.borderWidth = BorderWidth;
    }
    _actualView.image = image;
}
- (UIImage *)image
{
    return _actualView.image;
}
@end
