//
//  ImageView_Scale.h
//  ScaleImageView
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageScaleView;
@protocol ImageScaleViewDelegate <NSObject>
- (void)imageViewScale:(ImageScaleView *)imageScale clickCurImage:(UIImageView *)imageview;
@end

@interface ImageScaleView : UIScrollView<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIImageView * _imageView;
}

@property(nonatomic,assign)id<ImageScaleViewDelegate> Adelegate;
@property(nonatomic,retain)UIImageView * imageView;
@property(nonatomic,assign)BOOL tapEnabled;
@end
