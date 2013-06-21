//
//  UIViewController+DivideAssett.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"

#define WRITEIMAGE @"WriteImage"

@interface UIViewController (Assets)
- (void)cloundDivideAssettByDayTimeWithAssetArray:(NSMutableArray *)_assetsArray exportToassestionArray:(NSMutableArray *)assetsSection assetSectionisShow:(NSMutableArray *)_assetSectionisShow dataScource:(NSMutableArray *)dataSourceArray;
- (void)localDivideAssettByDayTimeWithAssetArray:(NSMutableArray *)assetsArray exportToassestionArray:(NSMutableArray *)assetsSection assetSectionisShow:(NSMutableArray *)assetSectionisShow dataScource:(NSMutableArray *)dataSourceArray;
- (NSMutableArray *)sortArrayByTime:(NSMutableArray *)array;
- (UIView *)getSectionView:(NSInteger)section withImageCount:(NSInteger)count ByisShow:(BOOL)isShowRow WithTimeText:(NSString *)labelText;
@end

@interface UIViewController (Tips)
- (void)showLoginViewWithMethodNav:(BOOL)isNav;
- (void)showBingViewWithShareModel:(KShareModel)model delegate:(id)Adelegete andShowWithNav:(BOOL)isNav;
- (MBProgressHUD *)waitForMomentsWithTitle:(NSString*)str withView:(UIView *)view;
- (void)stopWaitProgressView:(MBProgressHUD *)view;
@end

@interface UIViewController(WriteImage)
- (void)writePicToAlbumWith:(NSString *)imageStr;
@end

@interface UIViewController(Libiary)
- (ALAssetsLibrary *)libiary;
@end

@interface UIViewController(IsMine)
- (BOOL)isMineWithOwnerId:(NSString *)ownerID;
@end

@interface UIViewController(ShareToWeixin)
- (void)shareNewsToWeixinWithUrl:(NSString *)url ToSence:(enum WXScene)scene Title:(NSString *)title photoUrl:(NSString *)photoUrl des:(NSString *)des;
- (void)shareImageToWeixinWithUrl:(NSString *)imageURL ToSence:(enum WXScene)scene;
@end

@interface UIViewController(Login)
- (void)handleInfoWithshareModel:(KShareModel)shareModel infoDic:(NSDictionary *)dic;
@end