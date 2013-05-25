//
//  ALAssetsLibrary+Read.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-8.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "ALAssetsLibrary+Read.h"

@implementation ALAssetsLibrary (Read)

#pragma mark - Read All photo From Album
- (void)readPhotoIntoAssetsContainer:(NSMutableArray *)assetsArray fromGroup:(ALAssetsGroup *)assetGroups sucess:(void(^)(void))sucess
{
    @autoreleasepool {
        [assetGroups setAssetsFilter:[ALAssetsFilter allPhotos]];
        [assetGroups enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
         {
             if(result == nil){
                 dispatch_async(dispatch_get_main_queue(), ^{
                     sucess();
                 });
                 return;
             }
             [assetsArray addObject:result];
         }];
    }
}

#pragma mark - read All Album
- (void)readAlbumsIntoGroupArray:(NSMutableArray *)assetGroups sucess:(void(^)(void))sucess failture:(void(^)(NSError * error))failture
{
    @autoreleasepool {
    // Load Albums into assetGroups
        [self enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group == nil)
            {
                //finished
                dispatch_async(dispatch_get_main_queue(), ^{
                    sucess();
                });
                return ;
            }
            if ([group numberOfAssets] && ![[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"我的照片流"])
                [assetGroups addObject:group];
        } failureBlock:^(NSError *error) {
            failture(error);
        }];
    }
}

#pragma mark read All photoes
- (void) readAlbumIntoGroupContainer:(NSMutableArray *)assetGroups  assetsContainer:(NSMutableArray *)assetsArray sucess:(void(^)(void))sucess failture:(void(^)(NSError * error))failture;
{
    @autoreleasepool {
    // Load Albums into assetGroups
        [self enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group == nil)
            {
                
                //finished
                dispatch_async(dispatch_get_main_queue(), ^{
                    //递归读取专辑的照片
                    [self readPhotoesWithAssetsGroup:[assetGroups mutableCopy] assetsContainer:assetsArray sucess:sucess failture:failture];
                });
                return ;
            }
            //filter group
            if ([group numberOfAssets] && ![[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"我的照片流"])
                [assetGroups addObject:group];
        } failureBlock:^(NSError *error) {
            failture(error);
        }];
    }
}

- (void)readPhotoesWithAssetsGroup:(NSMutableArray *)tempAssetGroups  assetsContainer:(NSMutableArray *)assetsArray sucess:(void(^)(void))sucess failture:(void(^)(NSError * error))failture
{
    if (!tempAssetGroups.count) {
        //递归结束
        dispatch_async(dispatch_get_main_queue(), ^{
            sucess();
        });
        return;
    }
    @autoreleasepool {
        [[tempAssetGroups lastObject] setAssetsFilter:[ALAssetsFilter allPhotos]];
        [[tempAssetGroups lastObject] enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
         {
             if(result == nil){
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [tempAssetGroups removeLastObject];
                     [self readPhotoesWithAssetsGroup:tempAssetGroups assetsContainer:assetsArray sucess:sucess failture:failture];
                 });
                 return;
             }
             [assetsArray addObject:result];
         }];
    }
}

@end
