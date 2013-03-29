//
//  PhotoesCell.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "StatusImageView.h"

@class PhotoesCell;
@interface PhotoesCellDataSource : NSObject
@property(nonatomic,retain)ALAsset * firstAsset;
@property(nonatomic,retain)ALAsset * secoundAsset;
@property(nonatomic,retain)ALAsset * thridAsset;
@property(nonatomic,retain)ALAsset * lastAsset;
- (CGFloat)cellHigth;
- (CGFloat)cellLastHigth;
@end

@protocol PhotoesCellDelegate <NSObject>
- (void)photoesCell:(PhotoesCell *)cell clickAsset:(ALAsset *)asset;
- (void)photoesCell:(PhotoesCell *)cell clickAsset:(ALAsset *)asset Select:(BOOL)isSelected;

@end
@interface PhotoesCell : UITableViewCell
{
    PhotoesCellDataSource * _dataSource;
}

@property(nonatomic,assign)id<PhotoesCellDelegate> delegate;
@property(nonatomic,retain)PhotoesCellDataSource * dataSource;

- (void)showCellSelectedStatus;
- (void)hiddenCellSelectedStatus;

- (BOOL)hasSelectedAsset:(ALAsset *)asset;
- (void)isShow:(BOOL)isShow SelectedAsset:(ALAsset *)asset;
@end
