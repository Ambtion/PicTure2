//
//  AppDelegateOauthor.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegateOauthor : UIResponder<UIApplicationDelegate>
{
    SinaWeibo * sinaweibo;
    TencentOAuth * tencentOAuth;
    id<WXApiDelegate> _tempDelegate;
}
@property(nonatomic,strong)TencentOAuth * tencentOAuth;
@property(nonatomic,strong)SinaWeibo * sinaweibo;

- (void)sinaLoginWithDelegate:(id<SinaWeiboDelegate>)delegate;
- (void)renrenLoginWithDelegate:(id<RenrenDelegate>)delegate;
- (void)weiXinregisterWithDelegate:(id<WXApiDelegate>)delegate;
- (void)qqLoginWithDelegate:(id<TencentSessionDelegate>)delegate;
@end
