//
//  PhotoAlbumCell.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountLabel.h"
#import "FolderImageView.h"

@class PhotoAlbumCell;
@interface  PhotoAlbumCellDataSource:NSObject
@property(nonatomic,strong)id  leftGroup;
@property(nonatomic,strong)id  rightGroup;
+ (CGFloat)cellHight;
@end




@protocol PhotoAlbumCellDelegate <NSObject>
- (void)photoAlbumCell:(PhotoAlbumCell *)photoCell clickCoverGroup:(id)group;
@end

@interface PhotoAlbumCell : UITableViewCell
{
    FolderImageView * _leftImage;
    FolderImageView * _rightImage;
    UILabel * _leftLabel;
    UILabel * _rigthLabel;
    CountLabel * _leftCount;
    CountLabel * _rightCount;
}
@property(nonatomic,strong)PhotoAlbumCellDataSource * dataSource;
@property(nonatomic,weak)id<PhotoAlbumCellDelegate> delegate;

- (void)showNomalState:(BOOL)isShow;
- (void)isSelectedinSeletedArray:(NSArray *)array;
@end
