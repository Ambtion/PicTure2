//
//  StatusImageView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-28.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "StatusImageView.h"

@implementation StatusImageView
@synthesize selected = _selected;
@synthesize isShowStatus;
- (void)dealloc
{
    [_statuImage release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _actualView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_actualView];
        
        _statuImage = [[UIImageView alloc] initWithFrame:self.bounds];
        _statuImage.backgroundColor = [UIColor clearColor];
        [self addSubview:_statuImage];
        self.backgroundColor = [UIColor clearColor];
        [self resetStatusImageToHidden];
    }
    return self;
}
- (void)setSelected:(BOOL)selected
{
    if (!isShowStatus) {
        return;
    }
    _selected = selected;
    if (selected) {
        [_actualView setAlpha:1.f];
        [_statuImage setImage:[UIImage imageNamed:@"check_box_select_image.png"]];
    }else{
        [self uploadStatus];
    }
}
- (void)showStatusWithOutUpload
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
    }else{
        [_actualView setAlpha:0.5], [_statuImage setImage:nil];
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
    [_statuImage setBackgroundColor:[UIColor clearColor]];
}
#pragma mark - Reloadfunctions
- (void)setImage:(UIImage *)image
{
    _actualView.image = image;
}
- (UIImage *)image
{
    return _actualView.image;
}

@end
