//
//  ImageView_Scale.h
//  ScaleImageView
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoImageView : UIImageView<UIWebViewDelegate>
{
    UIActivityIndicatorView * actV;
    UIImageView * logo;
}
- (void)startLoading;
- (void)stopLoading;
@end

@class ImageScaleView;
@protocol ImageScaleViewDelegate <NSObject>
- (void)imageViewScale:(ImageScaleView *)imageScale clickCurImage:(UIImageView *)imageview;
@end

@interface ImageScaleView : UIScrollView<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    InfoImageView * _imageView;
}

@property(nonatomic,weak)id<ImageScaleViewDelegate> Adelegate;
@property(nonatomic,strong)InfoImageView * imageView;
@property(nonatomic,strong)id asset;
@property(nonatomic,assign)BOOL tapEnabled;
@end
