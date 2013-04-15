//
//  AppDelegateOauthor.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum OauthorState {
    SinaUPload ,
    RenrenUpload,
    WeinxinUpload,
    QQUpload
}AppOauthorState;

@interface AppDelegateOauthor : UIResponder<UIApplicationDelegate>
{
    AppOauthorState _state;
    SinaWeibo * sinaweibo;
    TencentOAuth * tencentOAuth;
    id<WXApiDelegate> _tempDelegate;
}
@property(nonatomic,assign)AppOauthorState state;
@property(nonatomic,strong)TencentOAuth * tencentOAuth;
@property(nonatomic,strong)SinaWeibo * sinaweibo;

- (void)sinaLoginWithDelegate:(id<SinaWeiboDelegate>)delegate;
- (void)renrenLoginWithDelegate:(id<RenrenDelegate>)delegate;
- (void)weiXinregisterWithDelegate:(id<WXApiDelegate>)delegate;
- (void)qqLoginWithDelegate:(id<TencentSessionDelegate>)delegate;
@end
