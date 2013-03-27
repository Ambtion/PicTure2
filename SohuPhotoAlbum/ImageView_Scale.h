//
//  ImageView_Scale.h
//  ScaleImageView
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageView_Scale;
@protocol ImageView_ScaleDelegate <NSObject>
- (void)imageViewScale:(ImageView_Scale *)imageScale clickCurImage:(UIImageView *)imageview;
@end

@interface ImageView_Scale : UIScrollView<UIScrollViewDelegate>
{
    UIImageView * _imageView;
}
@property(nonatomic,assign)id<ImageView_ScaleDelegate> Adelegate;
@property(nonatomic,retain)id assetInfo;

@end
