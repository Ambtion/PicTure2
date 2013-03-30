//
//  LocalShareController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-30.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalShareRef.h"
#import "BaseViewController.h"

@interface LocalShareController : BaseViewController<TencentSessionDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate>
{
    TencentOAuth * _tencentOAuth;
}
@end
