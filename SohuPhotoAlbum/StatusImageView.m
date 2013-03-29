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
        _statuImage = [[UIImageView alloc] initWithFrame:self.bounds];
        _statuImage.backgroundColor = [UIColor clearColor];
        [self addSubview:_statuImage];
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
        
    }else{
        
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
        
    }else{
        [self setAlpha:0.5];
    }
}
- (void)resetStatusImageToHidden
{
    self.selected = NO;
    isShowStatus = NO;
    isUpload = NO;
    [self setAlpha:1.0];
    [_statuImage setHidden:YES];
    _statuImage.image = nil;
    [_statuImage setBackgroundColor:[UIColor clearColor]];
}
@end
