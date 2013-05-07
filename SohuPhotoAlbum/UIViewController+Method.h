//
//  UIViewController+DivideAssett.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Method)
- (void)cloundDivideAssettByDayTimeWithAssetArray:(NSMutableArray *)_assetsArray exportToassestionArray:(NSMutableArray *)assetsSection assetSectionisShow:(NSMutableArray *)_assetSectionisShow dataScource:(NSMutableArray *)dataSourceArray;
- (void)localDivideAssettByDayTimeWithAssetArray:(NSMutableArray *)assetsArray exportToassestionArray:(NSMutableArray *)assetsSection assetSectionisShow:(NSMutableArray *)assetSectionisShow dataScource:(NSMutableArray *)dataSourceArray;
- (NSMutableArray *)sortArrayByTime:(NSMutableArray *)array;
- (UIView *)getSectionView:(NSInteger)section withImageCount:(NSInteger)count ByisShow:(BOOL)isShowRow WithTimeText:(NSString *)labelText;
@end

@interface UIViewController (Private)
- (void)showLoginViewWithMethodNav:(BOOL)isNav;
@end
