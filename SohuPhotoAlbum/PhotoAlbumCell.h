//
//  PhotoAlbumCell.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountLabel.h"

@class PhotoAlbumCell;
@interface  PhotoAlbumCellDataSource:NSObject
@property(nonatomic,retain)ALAssetsGroup * leftGroup;
@property(nonatomic,retain)ALAssetsGroup * rightGroup;
- (CGFloat)cellHight;
@end

@protocol PhotoAlbumCellDelegate <NSObject>
- (void)photoAlbumCell:(PhotoAlbumCell *)photoCell clickCoverGroup:(ALAssetsGroup *)group;
@end

@interface PhotoAlbumCell : UITableViewCell
{
    UIImageView * _leftImage;
    UIImageView * _rightImgae;
    UILabel * _leftLabel;
    UILabel * _rigthLabel;
    CountLabel * _leftCount;
    CountLabel * _rightCount;
}
@property(nonatomic,retain)PhotoAlbumCellDataSource * dataSource;
@property(nonatomic,assign)id<PhotoAlbumCellDelegate> delegate;
@end
