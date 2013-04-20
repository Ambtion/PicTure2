//
//  PhotoWallBaseCell.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewAdaper.h"
#import "CountLabel.h"

static  NSString * const identify[7] = {@"__0",@"__1",@"__2",@"__3",@"__4",@"__5",@"__6"};


@interface CellFootView:UIView
@property (strong,nonatomic)UILabel * shareTimeLabel;
@property (strong,nonatomic)UIButton * talkCountbutton;
@property (strong,nonatomic)UILabel * talkContLabel;
@property (strong,nonatomic)UIButton * likeCountbutton;
@property (strong,nonatomic)UILabel * likeCountLabel;
@end

@interface PhotoWallCellDataSource : NSObject
@property(strong,nonatomic)NSMutableArray * imageWallInfo;
@property(strong,nonatomic)NSString * wallDescription;
@property(strong,nonatomic)NSString * shareTime;
@property(assign,nonatomic)NSInteger talkCount;
@property(assign,nonatomic)NSInteger likeCount;
@property(assign,nonatomic)NSInteger photoCount;
- (CGFloat)getCellHeigth;
- (NSInteger)numOfCellStragey;
@end

@class PhotoWallCell;
@protocol PhotoWallCellDelegate <NSObject>
- (void)photoWallCell:(PhotoWallCell *)cell talkClick:(UIButton *)button;
- (void)photoWallCell:(PhotoWallCell *)cell likeClick:(UIButton *)button;
@end
@interface PhotoWallCell : UITableViewCell
{
    UIImageView * _backImageView;
    NSMutableArray * _framesArray;
    NSMutableArray * _imageViewArray;
    UILabel * _wallDesLabel;
    CellFootView * _footView;
    PhotoWallCellDataSource * _dataSource;
    CountLabel * _countLabel;
    CGFloat heigth;
}
@property(strong,nonatomic)PhotoWallCellDataSource * dataSource;
@property(weak,nonatomic)id<PhotoWallCellDelegate> delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifierNum:(NSInteger)reuseIdentifiernum;

@end
