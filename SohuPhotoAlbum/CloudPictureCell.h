//
//  CloudPictureCell.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusImageView.h"

@interface CloudPictureCellDataSource : NSObject
@property(nonatomic,strong)NSDictionary * firstDic;
@property(nonatomic,strong)NSDictionary * secoundDic;
@property(nonatomic,strong)NSDictionary * thridDic;
@property(nonatomic,strong)NSDictionary * lastDic;
- (CGFloat)cellHigth;
- (CGFloat)cellLastHigth;
+ (CGFloat)cellHigth;
+ (CGFloat)cellLastHigth;
@end

@class CloudPictureCell;
@protocol CloudPictureCellDelegate <NSObject>
- (void)cloudPictureCell:(CloudPictureCell *)cell clickInfo:(NSDictionary *)dic;
- (void)cloudPictureCell:(CloudPictureCell *)cell clickInfo:(NSDictionary *)dic Select:(BOOL)isSelected;
@end

@interface CloudPictureCell : UITableViewCell


{
    CloudPictureCellDataSource * _dataSource;
}

@property(nonatomic,weak)id<CloudPictureCellDelegate> delegate;
@property(nonatomic,strong)CloudPictureCellDataSource * dataSource;


- (void)showCellSelectedStatus;
- (void)hiddenCellSelectedStatus;
- (BOOL)hasSelectedDic:(NSDictionary *)dic;

- (void)cloudPictureCellisShow:(BOOL)isShow selectedDic:(NSDictionary *)dic;
@end
