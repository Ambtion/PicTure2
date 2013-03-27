//
//  PhotoesCell.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PhotoesCell.h"

#define CELLHIGTH  79.f

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews
{
    UIImageView * imageView;
    CGRect frame = CGRectMake(4, 2, 75, 75);
    for (int i = 0; i < 4; i++) {
        imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.tag = 1000+i;
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
    [self setImageViews:(UIImageView *)[self.contentView viewWithTag:1000] With:_dataSource.firstAsset];
    [self setImageViews:(UIImageView *)[self.contentView viewWithTag:1001] With:_dataSource.secoundAsset];
    [self setImageViews:(UIImageView *)[self.contentView viewWithTag:1002] With:_dataSource.thridAsset];
    [self setImageViews:(UIImageView *)[self.contentView viewWithTag:1003] With:_dataSource.lastAsset];
}
- (void)setImageViews:(UIImageView*)imageView With:(ALAsset *)asset
{
    
    if (asset) {
        imageView.image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
        [imageView setUserInteractionEnabled:YES];
    }else{
        imageView.image = nil;
        [imageView setUserInteractionEnabled:NO];
        imageView.backgroundColor = [UIColor clearColor];
    }
}
- (void)handleGustrure:(UITapGestureRecognizer *)gesture
{
    UIView * view = [gesture view];
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
    if ([_delegate respondsToSelector:@selector(photoesCell:clickAsset:)] && asset)
        [_delegate photoesCell:self clickAsset:asset];
}
@end
