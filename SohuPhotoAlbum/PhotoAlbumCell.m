//
//  PhotoAlbumCell.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PhotoAlbumCell.h"

#define CELLHEIGTH 160

#define TEXTBACKGROUND  [UIColor redColor]

@implementation PhotoAlbumCellDataSource
@synthesize leftGroup,rightGroup;
- (void)dealloc
{
    self.leftGroup = nil;
    self.rightGroup = nil;
    [super dealloc];
}
- (CGFloat)cellHight
{
    return CELLHEIGTH;
}
@end
@implementation PhotoAlbumCell

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
- (void)dealloc
{
    self.dataSource = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 130, 120)];
        [self.contentView addSubview:_leftImage];
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGusture:)];
        gesture.numberOfTapsRequired = 1;
        [_leftImage addGestureRecognizer:gesture];
        [_leftImage setUserInteractionEnabled:YES];
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 130, 20)];
        _leftLabel.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:_leftLabel];
        
        _rithtImgae = [[UIImageView alloc] initWithFrame:CGRectMake(160, 10, 130, 120)];
        [self.contentView addSubview:_rithtImgae];
        UITapGestureRecognizer * gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGusture:)];
        gesture2.numberOfTapsRequired = 1;
        [_rithtImgae addGestureRecognizer:gesture2];
        [_rithtImgae setUserInteractionEnabled:YES];
        _rigthLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 130, 130, 20)];
        _rigthLabel.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:_rigthLabel];
    }
    return self;
}

- (void)setDataSource:(PhotoAlbumCellDataSource *)dataSource
{
    if (_dataSource != dataSource) {
        [_dataSource release];
        _dataSource = [dataSource retain];
        [self updataViews];
    }
}
- (void)updataViews
{
    [_leftImage setImage:[UIImage imageWithCGImage:[self.dataSource.leftGroup posterImage]]];
    [_leftLabel setText:[NSString stringWithFormat:@"%@(%d)",[self.dataSource.leftGroup valueForProperty:ALAssetsGroupPropertyName],[self.dataSource.leftGroup numberOfAssets]]];
    if (self.dataSource.rightGroup) {
        [_rithtImgae setImage:[UIImage imageWithCGImage:[self.dataSource.rightGroup posterImage]]];
        [_rigthLabel setText:[NSString stringWithFormat:@"%@(%d)",[self.dataSource.rightGroup valueForProperty:ALAssetsGroupPropertyName],[self.dataSource.leftGroup numberOfAssets]]];
    }
}
- (void)handleGusture:(UITapGestureRecognizer *)gesture
{
    NSLog(@"%s",__FUNCTION__);
    id view = [gesture view];
    ALAssetsGroup * group = nil;
    if ([view isEqual:_leftImage]) {
        group = _dataSource.leftGroup;
    }else{
        group = _dataSource.rightGroup;
    }
    if ([_delegate respondsToSelector:@selector(photoAlbumCell:clickCoverGroup:)])
        [_delegate photoAlbumCell:self clickCoverGroup:group];
}
@end
