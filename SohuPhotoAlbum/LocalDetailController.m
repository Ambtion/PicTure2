//
//  LocalDetailController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-11.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "LocalDetailController.h"
#import "LocalShareController.h"

@interface LocalDetailController ()

@end

@implementation LocalDetailController
@synthesize cache = _cache, group = _group;
- (void)dealloc
{
    [_cache release];
    [_group release];
    [super dealloc];
}
- (id)initWithAssetsArray:(NSArray *)array andCurAsset:(ALAsset *)asset andAssetGroup:(ALAssetsGroup *)group
{
    self = [super init];
    if (self) {
        self.wantsFullScreenLayout = YES;
        _curImageArray = [[NSMutableArray arrayWithCapacity:0] retain];
        _isHidingBar = NO;
        _isInit = YES;
        _isRotating = NO;
        self.cache = [[[LimitCacheForImage alloc] init] autorelease];
        self.curPageNum = [array indexOfObject:asset];
        self.assetsArray = [[array copy] autorelease];
        self.group = group;
    }
    return self;
}

#pragma mark Overide applicationDidBecomeActive
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self readPhotoes];
}
- (void)readPhotoes
{
    ALAsset * asset = [self.assetsArray objectAtIndex:self.curPageNum];
    self.assetsArray = [NSMutableArray arrayWithCapacity:0];
    if (!_libiary)
        _libiary = [[ALAssetsLibrary alloc] init];
    NSMutableArray * tempArry = [NSMutableArray arrayWithCapacity:0];
    if (!self.group) {
        [_libiary readAlbumIntoGroupContainer:tempArry assetsContainer:self.assetsArray sucess:^{
            [self resetCurNumWhenAssetArryChangeWithPreAsset:asset];
        } failture:^(NSError *error) {
            
        }];
    }else{
        [_libiary readPhotoIntoAssetsContainer:self.assetsArray fromGroup:self.group sucess:^{
            [self resetCurNumWhenAssetArryChangeWithPreAsset:asset];
        }];
    }
}

- (NSMutableArray *)revertObjectArray:(NSMutableArray *)array
{
    NSMutableArray * finalArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = array.count - 1; i >= 0; i--)
        [finalArray addObject:[array objectAtIndex:i]];
    return finalArray;
}
- (void)resetCurNumWhenAssetArryChangeWithPreAsset:(ALAsset *)asset
{
    self.assetsArray = [self revertObjectArray:self.assetsArray]; //逆序排序
    NSUInteger curnum = [self.assetsArray indexOfObject:asset];
    if (curnum == NSNotFound) {
        self.curPageNum = [self validPageValue:self.curPageNum];
    }else{
        self.curPageNum =  curnum;
    }
    _canGetActualImage = YES;
    [self refreshScrollView];
}

#pragma mark - GetIdentifyImageSizeWithImageView
- (CGSize)getIdentifyImageSizeWithImageView:(UIImageView *)imageView isPortraitorientation:(BOOL)isPortrait
{
    CGFloat w = imageView.image.size.width;
    CGFloat h = imageView.image.size.height;
    CGRect frameRect = CGRectZero;
    CGRect  screenFrame = [[UIScreen mainScreen] bounds];
    if (isPortrait) {
        frameRect = screenFrame;
    }else{
        frameRect = CGRectMake(0, 0, screenFrame.size.height, screenFrame.size.width);
    }
    CGRect rect = CGRectZero;
    CGFloat scale = MIN(frameRect.size.width / w, frameRect.size.height / h);
    rect = CGRectMake(0, 0, w * scale, h * scale);
    return rect.size;
}

#pragma mark -  GetImageFromAsset
- (UIImage *)getImageFromAsset:(id)asset
{
    
    UIImage * image = [self getImageFromCacheWithKey:[[[(ALAsset * )asset defaultRepresentation] url] absoluteString]];
    if (!image) {
        image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
    }
    return image;
}

- (UIImage *)getImageFromCacheWithKey:(id)aKey
{
    NSData * imageData = [self.cache objectForKey:aKey];
    return [UIImage imageWithData:imageData];
}

#pragma mark - GetActualImage
- (UIImage *)getActualImage:(id)asset andOrientation:(UIImageOrientation)orientation
{
    UIImage * image = [self getImageFromCacheWithKey:[[[asset defaultRepresentation] url] absoluteString]];
    if (!image) {
        image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:1.0f orientation:orientation];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.cache setObject:UIImagePNGRepresentation(image) forKey:[[[asset defaultRepresentation] url] absoluteString]];
        });
    }
    return image;
}

#pragma mark - Action
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button
{
    if (button.tag == LEFTBUTTON)
        [self.navigationController popViewControllerAnimated:YES];
    if (button.tag == RIGHT1BUTTON)
        return ;
    if (button.tag == RIGHT2BUTTON)
        [self.navigationController pushViewController:[[[LocalShareController alloc] initWithUpLoadAsset:[self.assetsArray objectAtIndex:self.curPageNum]] autorelease] animated:YES];
}
#pragma mark cache Manager
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DLog(@"%s",__FUNCTION__);
    [self.cache clear];
}
@end
