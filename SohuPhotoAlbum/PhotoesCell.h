//
//  PhotoesCell.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class PhotoesCell;
@interface PhotoesCellDataSource : NSObject
@property(nonatomic,retain)ALAsset * firstAsset;
@property(nonatomic,retain)ALAsset * secoundAsset;
@property(nonatomic,retain)ALAsset * thridAsset;
@property(nonatomic,retain)ALAsset * lastAsset;
- (CGFloat)cellHigth;
@end

@protocol PhotoesCellDelegate <NSObject>
@optional
- (void)photoesCell:(PhotoesCell *)cell clickAsset:(ALAsset *)asset;
@end
@interface PhotoesCell : UITableViewCell
{
    PhotoesCellDataSource * _dataSource;
}

@property(nonatomic,assign)id<PhotoesCellDelegate> delegate;
@property(nonatomic,retain)PhotoesCellDataSource * dataSource;
@end
