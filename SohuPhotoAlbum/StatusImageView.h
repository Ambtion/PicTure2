//
//  StatusImageView.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-28.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusImageView : UIView
{
    UIImageView * _statuImage;
    UIImageView * _actualView;
    BOOL isShowStatus;
    BOOL isUpload;
}
@property(nonatomic,getter=isSelected) BOOL selected;
@property(nonatomic,readonly)BOOL isShowStatus;
@property(nonatomic,strong)UIImageView * statueImage;
@property(nonatomic,strong)UIImageView * actualView;
- (void)showStatusWithoutUpload;
- (void)showStatusWithUpload;

- (void)resetStatusImageToHidden;
- (void)resetImageViewTohide;
- (void)setImage:(UIImage *)image;
- (UIImage *)image;
@end
