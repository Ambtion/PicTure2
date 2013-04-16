//
//  PhotoesCell.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusImageView.h"

@class PhotoesCell;
@interface PhotoesCellDataSource : NSObject
@property(nonatomic,strong)ALAsset * firstAsset;
@property(nonatomic,strong)ALAsset * secoundAsset;
@property(nonatomic,strong)ALAsset * thridAsset;
@property(nonatomic,strong)ALAsset * lastAsset;

+ (CGFloat)cellHigth;
+ (CGFloat)cellLastHigth;
@end

@protocol PhotoesCellDelegate <NSObject>
- (void)photoesCell:(PhotoesCell *)cell clickAsset:(ALAsset *)asset;
- (void)photoesCell:(PhotoesCell *)cell clickAsset:(ALAsset *)asset Select:(BOOL)isSelected;

@end
@interface PhotoesCell : UITableViewCell
{
    PhotoesCellDataSource * _dataSource;
}

@property(nonatomic,weak)id<PhotoesCellDelegate> delegate;
@property(nonatomic,strong)PhotoesCellDataSource * dataSource;


- (void)showCellSelectedStatus;
- (void)hiddenCellSelectedStatus;

- (BOOL)hasSelectedAsset:(ALAsset *)asset;
- (void)isShow:(BOOL)isShow SelectedAsset:(ALAsset *)asset;
@end
