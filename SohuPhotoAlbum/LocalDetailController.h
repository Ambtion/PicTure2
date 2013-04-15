//
//  LocalDetailController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-11.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PhotoDetailBaseController.h"
#import "AppDelegate.h"
#import "LocalShareRef.h"
#import "LocalShareDesView.h"

@interface LocalDetailController : PhotoDetailBaseController<UIActionSheetDelegate,LoginViewControllerDelegate
                                ,TencentSessionDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate,RenrenDelegate,WXApiDelegate,LocalShareDesViewDelegate>

- (id)initWithAssetsArray:(NSArray *)array andCurAsset:(ALAsset *)asset andAssetGroup:(ALAssetsGroup *)group;

@property(nonatomic,strong)ALAssetsGroup * group;
@property(nonatomic,strong)LimitCacheForImage * cache;

@end
