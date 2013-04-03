//
//  PhotoesCell.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PhotoesCell.h"
#import "DataBaseManager.h"
#import <QuartzCore/QuartzCore.h>

#define CELLHIGTH  80.f

@implementation PhotoesCellDataSource
@synthesize firstAsset,secoundAsset,thridAsset,lastAsset;
- (void)dealloc
{
    [firstAsset release];
    [secoundAsset release];
    [thridAsset release];
    [lastAsset release];
    [super dealloc];
}
- (CGFloat)cellHigth
{
    return CELLHIGTH;
}
- (CGFloat)cellLastHigth
{
    return CELLHIGTH + 5;
}
@end
@implementation PhotoesCell
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
- (void)dealloc
{
    [_dataSource release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, CELLHIGTH);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews
{
    StatusImageView * imageView;
    CGRect frame = CGRectMake(4, 5, 75, 75);
    for (int i = 0; i < 4; i++) {
        imageView = [[[StatusImageView alloc] initWithFrame:frame] autorelease];
        imageView.tag = 1000+i;
        imageView.layer.borderWidth = 0.5f;
        imageView.layer.borderColor = [[UIColor colorWithRed:192.f/255.f green:192.f/255.f blue:192.f/255.f alpha:1.f]CGColor];
        imageView.layer.shouldRasterize = YES;
        [self.contentView addSubview:imageView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGustrure:)];
        [imageView addGestureRecognizer:tap];
        frame.origin.x = frame.origin.x + frame.size.width + 4;
    }
}
- (void)setDataSource:(PhotoesCellDataSource *)dataSource
{
    if (_dataSource != dataSource) {
        [_dataSource release];
        _dataSource = [dataSource retain];
        [self updataViews];
    }
}
- (void)updataViews
{
    [self setImageViews:(StatusImageView *)[self.contentView viewWithTag:1000] With:_dataSource.firstAsset];
    [self setImageViews:(StatusImageView *)[self.contentView viewWithTag:1001] With:_dataSource.secoundAsset];
    [self setImageViews:(StatusImageView *)[self.contentView viewWithTag:1002] With:_dataSource.thridAsset];
    [self setImageViews:(StatusImageView *)[self.contentView viewWithTag:1003] With:_dataSource.lastAsset];
}
- (void)setImageViews:(StatusImageView*)imageView With:(ALAsset *)asset
{
    if (asset) {
        imageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
        imageView.layer.borderWidth = 0.5f;
        [imageView setUserInteractionEnabled:YES];
    }else{
        imageView.image = nil;
        [imageView setUserInteractionEnabled:NO];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.layer.borderWidth = 0.f;
    }
}
- (void)handleGustrure:(UITapGestureRecognizer *)gesture
{
    StatusImageView * view = (StatusImageView *)[gesture view];
    [view setSelected:!view.isSelected];
    ALAsset * asset = nil;
    switch (view.tag) {
        case 1000:
            asset = self.dataSource.firstAsset;
            break;
        case 1001:
            asset = self.dataSource.secoundAsset;
            break;
        case 1002:
            asset = self.dataSource.thridAsset;
            break;
        case 1003:
            asset = self.dataSource.lastAsset;
            break;
        default:
            break;
    }
    if (view.isShowStatus) {
        if ([_delegate respondsToSelector:@selector(photoesCell:clickAsset:Select:)]) {
            [_delegate photoesCell:self clickAsset:asset Select:view.isSelected];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(photoesCell:clickAsset:)]){
            [_delegate photoesCell:self clickAsset:asset];
        }
    }
    
}
#pragma mark ImageViewStatus

- (void)showCellSelectedStatus
{
    [self showImageViewStatus:(StatusImageView *)[self.contentView viewWithTag:1000] byAsset:_dataSource.firstAsset];
    [self showImageViewStatus:(StatusImageView *)[self.contentView viewWithTag:1001] byAsset:_dataSource.secoundAsset];
    [self showImageViewStatus:(StatusImageView *)[self.contentView viewWithTag:1002] byAsset:_dataSource.thridAsset];
    [self showImageViewStatus:(StatusImageView *)[self.contentView viewWithTag:1003] byAsset:_dataSource.lastAsset];
}

- (void)hiddenCellSelectedStatus
{
    [(StatusImageView *)[self.contentView viewWithTag:1000] resetStatusImageToHidden];
    [(StatusImageView *)[self.contentView viewWithTag:1001] resetStatusImageToHidden];
    [(StatusImageView *)[self.contentView viewWithTag:1002] resetStatusImageToHidden];
    [(StatusImageView *)[self.contentView viewWithTag:1003] resetStatusImageToHidden];
}
- (BOOL)hasSelectedAsset:(ALAsset *)asset
{
    if (_dataSource.firstAsset == asset ||
        _dataSource.secoundAsset == asset ||
        _dataSource.thridAsset == asset ||
        _dataSource.lastAsset == asset)
    {
        return YES;
    }
    return NO;
}
- (void)isShow:(BOOL)isShow SelectedAsset:(ALAsset *)asset
{
    
    if (_dataSource.firstAsset == asset ) {
        [(StatusImageView *)[self.contentView viewWithTag:1000] setSelected:isShow];
    }
    if ( _dataSource.secoundAsset == asset) {
        [(StatusImageView *)[self.contentView viewWithTag:1001] setSelected:isShow];
    }
    if ( _dataSource.thridAsset == asset) {
        [(StatusImageView *)[self.contentView viewWithTag:1002] setSelected:isShow];
    }
    if (_dataSource.lastAsset == asset) {
        [(StatusImageView *)[self.contentView viewWithTag:1003] setSelected:isShow];
    }
}
- (void)showImageViewStatus:(StatusImageView *)imageView byAsset:(ALAsset *)asset
{
    if (!asset) return;
    if ([[DataBaseManager defaultDataBaseManager] hasPhotoURL:[[asset defaultRepresentation] url]]) {
        [imageView showStatusWithUpload];
    }else{
        [imageView showStatusWithOutUpload];
    }
}

@end
