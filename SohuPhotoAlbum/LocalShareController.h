//
//  LocalShareController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-30.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalShareRef.h"
#import "ShareBaseController.h"

@interface LocalShareController : ShareBaseController<TencentSessionDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate,RenrenDelegate,WXApiDelegate>

@end
