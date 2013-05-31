//
//  ALAssetsLibrary+Read.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-8.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

@interface ALAssetsLibrary (Read)
- (void) readAlbumIntoGroupContainer:(NSMutableArray *)assetGroups  assetsContainer:(NSMutableArray *)assetsArray sucess:(void(^)(void))sucess failture:(void(^)(NSError * error))failture;
- (void)readAlbumsIntoGroupArray:(NSMutableArray *)assetGroups sucess:(void(^)(void))sucess failture:(void(^)(NSError * error))failture;
- (void)readPhotoIntoAssetsContainer:(NSMutableArray *)assetsArray fromGroup:(ALAssetsGroup *)assetGroups sucess:(void(^)(void))sucess;
@end
