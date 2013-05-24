//
//  shareBox.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-20.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestManager.h"


@protocol ShareBoxDelegate <NSObject>
@optional
- (void)shareBoxViewShareTo:(KShareModel)model;
- (void)shareBoxViewWeiXinShareToScene:(enum WXScene)scene;
- (void)shareBoxViewWriteImageTolocal;
@end
@interface ShareBox : NSObject<UIActionSheetDelegate>
{
    UIView * showView;
    KShareModel model;
    UIActionSheet * weixinAtion;
    BOOL isShowWeixin;
    BOOL isShowWall;
}
@property(weak,nonatomic) id<ShareBoxDelegate,WXApiDelegate> delegate;
- (void)showShareViewWithWeixinShow:(BOOL)showWeiXin photoWall:(BOOL)showWall andWriteImage:(BOOL)isShowWrite OnView:(UIView *)view;
@end
