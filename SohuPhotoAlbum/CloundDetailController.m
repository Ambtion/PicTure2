//
//  CloundDetailController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

//height = 960;
//id = 94580671967932416;
//"multi_frames" = 0;
//"photo_url" = "http://img.itc.cn/ph0/ogIYYoPUQVd";
//"taken_at" = 1366872495000;
//"taken_id" = 5733078775651119104;
//"upload_at" = 1366872495000;
//width = 640;

#import "CloundDetailController.h"
#import "UIImageView+WebCache.h"

@interface CloundDetailController ()

@end

@implementation CloundDetailController
- (id)initWithAssetsArray:(NSArray *)array andCurAsset:(NSDictionary *)asset
{
    self = [super init];
    if (self) {
        self.assetsArray = [NSMutableArray arrayWithArray:array];
        self.curPageNum = [array indexOfObject:asset];
        self.wantsFullScreenLayout = YES;
        _curImageArray = [NSMutableArray arrayWithCapacity:0];
        _isHidingBar = NO;
        _isInit = YES;
        _isRotating = NO;
        _isLoading = NO;
    }
    return self;
}
- (void)cusTabBar:(CustomizetionTabBar *)bar buttonClick:(UIButton *)button
{
    
}
#pragma mark overLoad
#pragma mark - GetIdentifyImageSizeWithImageView
- (CGSize)getIdentifyImageSizeWithImageView:(UIImageView *)imageView isPortraitorientation:(BOOL)isPortrait
{
    if (!imageView.image) return CGSizeZero;
    
    CGFloat w = imageView.image.size.width;
    CGFloat h = imageView.image.size.height;
    CGRect frameRect = CGRectZero;
    CGRect  screenFrame = [[UIScreen mainScreen] bounds];
    if (isPortrait) {
        frameRect = screenFrame;
    }else{
        frameRect = CGRectMake(0, 0, screenFrame.size.height, screenFrame.size.width);
    }
    CGRect rect = CGRectZero;
    CGFloat scale = MIN(frameRect.size.width / w, frameRect.size.height / h);
    rect = CGRectMake(0, 0, w * scale, h * scale);
    return rect.size;
}

#pragma mark -  GetImageFromAsset
- (void)setImageView:(UIImageView *)imageView imageFromAsset:(id)asset
{
    
    NSString * strUrl = [NSString stringWithFormat:@"%@_w640",[asset objectForKey:@"photo_url"]];
    DLog(@"%@",strUrl);
    [imageView setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
//    imageView.image = [UIImage imageNamed:@"1.jpg"];
}

#pragma mark - GetActualImage
- (void)setImageView:(UIImageView *)imageView ActualImage:(id)asset andOrientation:(UIImageOrientation)orientation
{
//    NSString * strUrl = [NSString stringWithFormat:@"%@_w640",[asset objectForKey:@"photo_url"]];
//    [imageView setImageWithURL:[NSURL URLWithString:strUrl]];
}

@end
