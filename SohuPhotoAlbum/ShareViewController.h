//
//  ShareViewController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-7.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalShareDesView.h"
#import "RequestManager.h"
@class ShareViewController;
@protocol ShareViewControllerDelegate <NSObject>
@optional
- (void)shareViewcontrollerDidShareClick:(ShareViewController *)controller withDes:(NSString *)des shareMode:(KShareModel)model;
@end

@interface ShareViewController : UIViewController<LocalShareDesViewDelegate>
{
    KShareModel _sharemodel;
    UIImageView * _myBgView;
}
@property(nonatomic,strong)NSString * bgPhotoUrl;
@property(nonatomic,strong)NSString * ownerId;
@property(nonatomic,strong)NSString * storyId;
@property(nonatomic,strong)NSArray * photosArray;
@property(weak,nonatomic)id<ShareViewControllerDelegate> delegate;
- (id)initWithModel:(KShareModel)model bgPhotoUrl:(NSString *)bgPhotoUrl andDelegate:(id<ShareViewControllerDelegate>)Adelegete;

@end
