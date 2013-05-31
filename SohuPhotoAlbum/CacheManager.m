//
//  SCPCacheManager.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-16.
//
//

#import "CacheManager.h"
#import "ASIDownloadCache.h"

@implementation CacheManager
+ (void)removeAllCache
{
    [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self removeCacheOfImage];
}
+ (void)removeCacheOfImage
{
    NSFileManager * manager  = [NSFileManager defaultManager];
    NSString * str = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCache"];
    NSError * error = nil;
    [manager removeItemAtPath:str error:&error];
    [manager createDirectoryAtPath:str withIntermediateDirectories:YES attributes:nil error:NULL];
    //    if (error) NSLog(@"error::%@",error);
    
}
@end
