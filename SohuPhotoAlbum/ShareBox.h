//
//  shareBox.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-20.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestManager.h"
#import "OAuthorController.h"
#import "SHActionSheet.h"

@protocol ShareBoxDelegate <NSObject>
@optional
- (void)shareBoxViewShareTo:(KShareModel)model;
- (void)shareBoxViewWeiXinShareToScene:(enum WXScene)scene;
- (void)shareBoxViewWriteImageTolocal;
@end
@interface ShareBox : NSObject<UIActionSheetDelegate,OAuthorControllerDelegate>
{
    UIView * showView;
    KShareModel model;
    SHActionSheet * weixinAtion;
    BOOL isShowWeixin;
    BOOL isShowWall;
}
@property(weak,nonatomic) id<ShareBoxDelegate,WXApiDelegate> delegate;
- (void)showShareViewWithWeixinShow:(BOOL)showWeiXin photoWall:(BOOL)showWall andWriteImage:(BOOL)isShowWrite OnView:(UIView *)view;
@end
