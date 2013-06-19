//
//  CloudPictureCell.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusImageView.h"
#import "SDImageCache.h"

static NSString * const cloudIdentify[5] = {@"____0",@"____1",@"____2",@"3____",@"____4"};


@interface CloundPictureCellDataSource : NSObject
@property(nonatomic,strong)NSDictionary * firstDic;
@property(nonatomic,strong)NSDictionary * secoundDic;
@property(nonatomic,strong)NSDictionary * thridDic;
@property(nonatomic,strong)NSDictionary * lastDic;
- (CGFloat)cellHigth;
- (NSInteger)sourceNumber;
- (CGFloat)cellLastHigth;
+ (CGFloat)cellHigth;
+ (CGFloat)cellLastHigth;
@end

@class CloundPictureCell;
@protocol CloundPictureCellDelegate <NSObject>
- (void)cloudPictureCell:(CloundPictureCell *)cell clickInfo:(NSDictionary *)dic;
- (void)cloudPictureCell:(CloundPictureCell *)cell clickInfo:(NSDictionary *)dic Select:(BOOL)isSelected;
@end

@interface CloundPictureCell : UITableViewCell
{
    CloundPictureCellDataSource * _dataSource;
    SDImageCache * cache;
    NSInteger sourceNumber;
    BOOL canBeOperated;
}

@property(nonatomic,weak)id<CloundPictureCellDelegate> delegate;
@property(nonatomic,strong)CloundPictureCellDataSource * dataSource;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSInteger)reuseIdentifier;
- (void)showCellSelectedStatus;
- (void)hiddenCellSelectedStatus;
- (BOOL)hasSelectedDic:(NSDictionary *)dic;

- (void)cloudPictureCellisShow:(BOOL)isShow selectedDic:(NSDictionary *)dic;
@end
