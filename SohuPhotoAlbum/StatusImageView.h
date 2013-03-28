//
//  StatusImageView.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-28.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusImageView : UIImageView
{
    UIImageView * _statuImage;
    BOOL isShowStatus;
    BOOL isUpload;
}
@property(nonatomic,getter=isSelected) BOOL selected;
@property(nonatomic,readonly)BOOL isShowStatus;

- (void)showStatusWithOutUpload;
- (void)showStatusWithUpload;

- (void)resetStatusImageToHidden;
@end
