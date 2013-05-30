//
//  SCPPerfrencdStoreManager.m
//  SohuCloudPics
//
//  Created by sohu on 13-2-1.
//
//

#import "PerfrenceSettingManager.h"
#import "LoginStateManager.h"

#define ISUPLOADJPEGIMAGE @"__ISUPLOADJPEGIMAGE__"
#define ISAUTOUPLOAD @"__ISAUTOUPLOAD__"
#define ISWIFILIMITED @"__ISWIFILIMITED__"

@implementation PerfrenceSettingManager

#pragma mark - CommonFunction
+ (NSDictionary *)valueForUserinfo
{
    if (![LoginStateManager isLogin]) return nil;
    return [[NSUserDefaults standardUserDefaults] objectForKey:[LoginStateManager currentUserId]];
}
+ (id)valueForKey:(NSString *)key inUserinfo:(NSDictionary *)userinfo
{
    
    return [userinfo objectForKey:key];
}

+ (void)userDefoultStoreValue:(id)value forKey:(id)key
{
    if (![LoginStateManager isLogin]) return;
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * userinfo = [NSMutableDictionary dictionaryWithDictionary:[self valueForUserinfo]];
    if (!userinfo) userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
    [userinfo setValue:value forKey:key];
    [userDefault setObject:userinfo forKey:[LoginStateManager currentUserId]];
    [userDefault synchronize];
}

#pragma mark - compressImage
+ (BOOL)isUploadJPEGImage;
{
    NSDictionary * userinfo = [self valueForUserinfo];
    NSNumber * num = [self valueForKey:ISUPLOADJPEGIMAGE inUserinfo:userinfo];
    return !num || [num  boolValue];
}
+(void)setIsUploadJPEGImage:(BOOL)ture
{
    [self userDefoultStoreValue:[NSNumber numberWithBool:ture] forKey:ISUPLOADJPEGIMAGE];
}

#pragma mark - AutoLoad
+ (BOOL)isAutoUpload
{
    NSDictionary * userinfo = [self valueForUserinfo];
    NSNumber * number = [self valueForKey:ISAUTOUPLOAD inUserinfo:userinfo];
    return [number boolValue];
}
+(void)setIsAutoUpload:(BOOL)ture
{
    if (![LoginStateManager isLogin]) return;
    [self userDefoultStoreValue:[NSNumber numberWithBool:ture] forKey:ISAUTOUPLOAD];
}
#pragma mark - WifiLimit
+ (BOOL)WifiLimitedAutoUpload
{
    NSDictionary * userinfo = [self valueForUserinfo];
    NSNumber * number = [self valueForKey:ISWIFILIMITED inUserinfo:userinfo];
    return !number || [number  boolValue];
}
+(void)setWifiLimited:(BOOL)ture
{
    if (![LoginStateManager isLogin]) return;
    [self userDefoultStoreValue:[NSNumber numberWithBool:ture] forKey:ISWIFILIMITED];
}

#pragma mark -
//+ (void)archivedDataWithRootObject:(id)object withKey:(NSString *)key
//{
//    NSMutableData * data = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:object forKey:key];
//    [archiver finishEncoding];
//    [[NSUserDefaults standardUserDefaults] setValue:data forKey:key];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//+ (id)unarchiveObjectWithDataWithKey:(NSString *)key
//{
//    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//    NSMutableArray * arDataSource = nil;
//    arDataSource = [unarchiver decodeObjectForKey:key];
//    [unarchiver finishDecoding];
//    return arDataSource;
//}
@end
