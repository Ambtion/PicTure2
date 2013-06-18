//
//  FolderImageView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-6-18.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "FolderImageView.h"
@implementation FolderImageView
@synthesize actualView = _actualView;
@synthesize isNomalState = _isNomalState;
@synthesize isSelected = _isSelected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgImageView.backgroundColor = [UIColor clearColor];
        _bgImageView.image = [UIImage imageNamed:@"alume-pic.png"];
        [self addSubview:_bgImageView];
        _actualView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, _bgImageView.bounds.size.width - 24, _bgImageView.bounds.size.height - 24)];
        [self addSubview:_actualView];
        _actualView.backgroundColor = [UIColor clearColor];
        _statuImage = [[UIImageView alloc] initWithFrame:_actualView.frame];
        [self addSubview:_statuImage];
        [self setStateImageToNomal];
        _isNomalState = YES;
    }
    return self;
}
- (void)setIsNomalState:(BOOL)isNomalState
{
    _isNomalState = isNomalState;
    if (_isNomalState) {
        [self setStateImageToNomal];
    }else{
        [self showSeletedState];
    }
}
- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    [self setStateimageToSelectd:_isSelected];
}
- (void)setStateImageToNomal
{
    _statuImage.backgroundColor = [UIColor clearColor];
    _statuImage.image = nil;
    _actualView.alpha = 1.f;
    [self bringSubviewToFront:_statuImage];
}
- (void)setStateimageToSelectd:(BOOL)isSelected
{
    if (_isNomalState) {
        return;
    }
    [self bringSubviewToFront:_statuImage];
    if (isSelected) {
        [self showSeleteStateWithSeleted];
    }else{
        [self showSeleteStateWithoutSeleted];
    }
}
- (void)showSeletedState
{
    [self showSeleteStateWithoutSeleted];
}
- (void)showSeleteStateWithoutSeleted
{
    [_actualView setAlpha:0.5], [_statuImage setImage:nil];
}
- (void)showSeleteStateWithSeleted
{
    [self bringSubviewToFront:_statuImage];
    [_statuImage setImage:[UIImage imageNamed:@"check_box_select_image.png"]];
}
@end