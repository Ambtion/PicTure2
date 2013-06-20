//
//  CloudPictureCell.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CloundPictureCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

#define CELLHIGTH  80.f

#define IMAGEOFFSET             4.f
#define IMAGEWIDTH              (320 - IMAGEOFFSET * 5 ) / 4.f

@implementation CloundPictureCellDataSource
@synthesize firstDic,secoundDic,thridDic,lastDic;
- (NSInteger)sourceNumber
{
    NSInteger number = 0;
    if (firstDic)
        number++;
    if (secoundDic)
        number++;
    if (thridDic)
        number++;
    if (lastDic)
        number++;
    return number;
    
}
- (CGFloat)cellHigth
{
    return IMAGEOFFSET + IMAGEWIDTH;
}
- (CGFloat)cellLastHigth
{
    return IMAGEWIDTH + IMAGEOFFSET * 2;
}
+ (CGFloat)cellHigth
{
    return IMAGEOFFSET + IMAGEWIDTH;
}
+ (CGFloat)cellLastHigth
{
    return IMAGEWIDTH + IMAGEOFFSET * 2;
}
@end

@implementation CloundPictureCell

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSInteger)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:cloudIdentify[reuseIdentifier]];
    if (self) {
        sourceNumber = reuseIdentifier;
        cache = [[SDImageCache alloc] init];
        self.frame = CGRectMake(0, 0, 320, IMAGEOFFSET + IMAGEWIDTH);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews
{
    StatusImageView * imageView;
    CGRect frame = CGRectMake(IMAGEOFFSET, IMAGEOFFSET, IMAGEWIDTH, IMAGEWIDTH);
    for (int i = 0; i < sourceNumber; i++) {
        imageView = [[StatusImageView alloc] initWithFrame:frame];
        imageView.tag = 1000 + i;
        [self.contentView addSubview:imageView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGustrure:)];
        [imageView addGestureRecognizer:tap];
        frame.origin.x = frame.origin.x + frame.size.width + IMAGEOFFSET;
    }
}

- (void)setDataSource:(CloundPictureCellDataSource *)dataSource
{
    _dataSource = dataSource;
    [self updataViews];
}
- (void)updataViews
{
    [self setImageViews:(StatusImageView *)[self.contentView viewWithTag:1000] With:_dataSource.firstDic];
    [self setImageViews:(StatusImageView *)[self.contentView viewWithTag:1001] With:_dataSource.secoundDic];
    [self setImageViews:(StatusImageView *)[self.contentView viewWithTag:1002] With:_dataSource.thridDic];
    [self setImageViews:(StatusImageView *)[self.contentView viewWithTag:1003] With:_dataSource.lastDic];
}

#pragma mark - SetImage
- (void)setImageViews:(StatusImageView*)imageView With:(NSDictionary *)dic
{
    [imageView setImage:[UIImage imageNamed:@"moren.png"]];
    if (dic) {
        //设置图片
        if ([dic allKeys].count) {
            canBeOperated = YES;
            NSString * strUrl = [NSString stringWithFormat:@"%@_c100",[dic objectForKey:@"photo_url"]];
            UIImage * image = [cache imageFromKey:strUrl];
            if (image) {
                //获取同步保证图片实时更替
                [imageView setImage:image];
                return;
            }
            __weak StatusImageView * weakSelf = imageView;
            UIImageView * AimageView = [[UIImageView alloc] init];
            [AimageView setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"moren.png"] success:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf setImage:image];
                });
            } failure:^(NSError *error) {
            }];
        }else{
            canBeOperated = NO;
        }
    }else{
        //temp
        [imageView setImage:nil];
    }
}

- (void)handleGustrure:(UITapGestureRecognizer *)gesture
{
    if (!canBeOperated) return;
    StatusImageView * view = (StatusImageView *)[gesture view];
    [view setSelected:!view.isSelected];
    NSDictionary * dic = nil;
    switch (view.tag) {
        case 1000:
            dic = self.dataSource.firstDic;
            break;
        case 1001:
            dic = self.dataSource.secoundDic;
            break;
        case 1002:
            dic = self.dataSource.thridDic;
            break;
        case 1003:
            dic = self.dataSource.lastDic;
            break;
        default:
            break;
    }
    if (view.isShowStatus) {
        if ([_delegate respondsToSelector:@selector(cloudPictureCell:clickInfo:Select:)]) {
            [_delegate cloudPictureCell:self clickInfo:dic Select:view.isSelected];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(cloudPictureCell:clickInfo:)]){
            [_delegate cloudPictureCell:self clickInfo:dic];
        }
    }
    
}
#pragma mark ImageViewStatus

- (void)showCellSelectedStatus
{
    [self showImageViewStatus:(StatusImageView *)[self.contentView viewWithTag:1000] byDic:_dataSource.firstDic];
    [self showImageViewStatus:(StatusImageView *)[self.contentView viewWithTag:1001] byDic:_dataSource.secoundDic];
    [self showImageViewStatus:(StatusImageView *)[self.contentView viewWithTag:1002] byDic:_dataSource.thridDic];
    [self showImageViewStatus:(StatusImageView *)[self.contentView viewWithTag:1003] byDic:_dataSource.lastDic];
}

- (void)hiddenCellSelectedStatus
{
    [(StatusImageView *)[self.contentView viewWithTag:1000] resetStatusImageToHidden];
    [(StatusImageView *)[self.contentView viewWithTag:1001] resetStatusImageToHidden];
    [(StatusImageView *)[self.contentView viewWithTag:1002] resetStatusImageToHidden];
    [(StatusImageView *)[self.contentView viewWithTag:1003] resetStatusImageToHidden];
}
- (BOOL)hasSelectedDic:(NSDictionary *)dic
{
    if (_dataSource.firstDic == dic ||
        _dataSource.secoundDic == dic ||
        _dataSource.thridDic  == dic ||
        _dataSource.lastDic == dic)
    {
        return YES;
    }
    return NO;
}
- (void)cloudPictureCellisShow:(BOOL)isShow selectedDic:(NSDictionary *)dic
{
    if (_dataSource.firstDic == dic ) {
        [(StatusImageView *)[self.contentView viewWithTag:1000] setSelected:isShow];
    }
    if ( _dataSource.secoundDic == dic) {
        [(StatusImageView *)[self.contentView viewWithTag:1001] setSelected:isShow];
    }
    if ( _dataSource.thridDic == dic) {
        [(StatusImageView *)[self.contentView viewWithTag:1002] setSelected:isShow];
    }
    if (_dataSource.lastDic == dic) {
        [(StatusImageView *)[self.contentView viewWithTag:1003] setSelected:isShow];
    }
}
- (void)showImageViewStatus:(StatusImageView *)imageView byDic:(NSDictionary *)dic
{
    if (!dic) return;
    [imageView showStatusWithoutUpload];
}

@end
