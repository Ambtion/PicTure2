//
//  SCPTaskUnit.m
//  SohuCloudPics
//
//  Created by sohu on 12-12-11.
//
//

#import "TaskUnit.h"
#import "LoginStateManager.h"
#import "PerfrenceSettingManager.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+FixOrientation.h"

@implementation TaskUnit

@synthesize lib = _lib;
@synthesize asset = _asset;
@synthesize description = _description;
@synthesize taskState = _taskState;
@synthesize thumbnail = _thumbnail;
@synthesize request = _request;
@synthesize data = _data;

- (id)init
{
    self = [super init];
    if (self) {
        self.taskState = UPLoadstatusWait;
    }
    return self;
}
- (NSURL *)asseetUrl
{
    return nil;
}

- (NSData*)imageDataFromAsset
{
    //确保登陆
    BOOL  isUploadJPEGImage = NO;
    if ([LoginStateManager isLogin]){
        isUploadJPEGImage = [PerfrenceSettingManager isUploadJPEGImage];
    }else{
        return nil;
    }
    if (!_fulldata)
        _fulldata = [self fullData];
    NSData * data = _fulldata;
    DLog(@"data: %f",[data length]/(1024 * 1024.f));
    if (isUploadJPEGImage) {
        NSMutableDictionary * dic = [[self infoDic] mutableCopy]; //info
//        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initFromAssetURL:[self.asset valueForProperty:ALAssetPropertyAssetURL]];
        CGDataProviderRef jpegdata = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
        CGImageRef imageRef = nil;
        if ([[self.asset.defaultRepresentation UTI] hasSuffix:@"png"]) {
            imageRef = CGImageCreateWithPNGDataProvider(jpegdata, NULL, YES, kCGRenderingIntentDefault);
        }else{
            imageRef = CGImageCreateWithJPEGDataProvider(jpegdata, NULL, YES, kCGRenderingIntentDefault);
        }
        UIImage * image = [UIImage imageWithCGImage:imageRef];
        data = UIImageJPEGRepresentation(image, 0.2);
        DLog(@"cpmpre1:when upload: %f M",[data length]/(1024 * 1024.f));
        if (dic){
            [self fixinfoDic:dic];
            data = [self writeExif:dic intoImage:data];
        }
        DLog(@"cpmpre afterWrite:when upload: %f M",[data length]/(1024 * 1024.f));
    }
    return data;
}
- (NSString *)stringFromdate:(NSDate *)date
{
    //转化日期格式
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyy:MM:dd HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}
- (void)fixinfoDic:(NSMutableDictionary *)dic
{
    NSMutableDictionary * extfDic = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"{Exif}"]];
    if (extfDic && ![extfDic objectForKey:@"DateTimeOriginal"]) {
        NSDate * date = [self.asset valueForProperty:ALAssetPropertyDate];
        [extfDic setObject:[self stringFromdate:date] forKey:@"DateTimeOriginal"];
    }
//    [dic removeAllObjects];
    [dic setObject:extfDic forKey:@"{Exif}"];
}
- (NSData *)fullData
{
    ALAssetRepresentation * defaultRep = [self.asset defaultRepresentation];
    CGImageRef  imageRef = [defaultRep fullResolutionImage];
    UIImage * image = [UIImage imageWithCGImage:imageRef scale:1.f orientation:(int)defaultRep.orientation];
    image = [image fixOrientation];
    if ([self.asset.defaultRepresentation.UTI hasSuffix:@"png"]) {
        NSLog(@"%@",self.asset.defaultRepresentation.UTI);
        return UIImagePNGRepresentation(image);
    }
    return UIImageJPEGRepresentation(image, 0.5);
//    Byte *buffer = (Byte*)malloc(defaultRep.size);
//    NSUInteger buffered = [defaultRep getBytes:buffer fromOffset:0.0 length:defaultRep.size error:nil];
//    NSData * data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
//    return data;
}

- (NSDictionary *)infoDic
{
    return (NSDictionary *)[self getPropertyInfo];
}

- (NSData *)writeExif:(NSDictionary *)dic intoImage:(NSData *)myimageData
{
    NSMutableData * mydata = [[NSMutableData alloc] initWithLength:0];
    CGDataProviderRef jpegdata = CGDataProviderCreateWithCFData((__bridge CFDataRef)myimageData);
    CGImageRef imageRef = CGImageCreateWithJPEGDataProvider(jpegdata, NULL, YES, kCGRenderingIntentDefault);
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)mydata, kUTTypeJPEG, 1, NULL);
    CGImageDestinationAddImage(destination, imageRef, (__bridge CFDictionaryRef)dic);
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
    return mydata;
}
- (CFDictionaryRef )getPropertyInfo
{
    Byte *buffer = (Byte*)malloc(self.asset.defaultRepresentation.size);
    NSUInteger buffered = [self.asset.defaultRepresentation getBytes:buffer fromOffset:0.0 length:self.asset.defaultRepresentation.size error:nil];
    NSData * data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
    //1
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if (imageSource == NULL) {
        // Error loading image
        return nil;
    }
    //2
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:NO], (NSString *)kCGImageSourceShouldCache,
                             nil];
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (__bridge CFDictionaryRef)options);
    return imageProperties;
}
@end
