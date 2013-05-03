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

@implementation TaskUnit

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
    if (!isUploadJPEGImage) {
        DLog(@"ori:when upload: %f",[data length]/(1024 * 1024.f));
    }else{
        NSDictionary * dic = [self infoDic];
        CGDataProviderRef jpegdata = CGDataProviderCreateWithCFData((__bridge CFDataRef)_fulldata);
        CGImageRef imageRef = CGImageCreateWithJPEGDataProvider(jpegdata, NULL, YES, kCGRenderingIntentDefault);
        UIImage * image = [UIImage imageWithCGImage:imageRef];
        data = UIImageJPEGRepresentation(image, 0.5);
        data = [self writeExif:dic intoImage:data];
        DLog(@"cpmpre:when upload: %f",[data length]/(1024 * 1024.f));
//        NSLog(@"%@",[self getPropertyOfdata:data]);
    }
    return data;
}
- (NSData *)fullData
{
    ALAssetRepresentation * defaultRep = [self.asset defaultRepresentation];
    Byte *buffer = (Byte*)malloc(defaultRep.size);
    NSUInteger buffered = [defaultRep getBytes:buffer fromOffset:0.0 length:defaultRep.size error:nil];
    NSData * data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
    return data;
}
- (NSDictionary *)infoDic
{
    if (!_fulldata)
        _fulldata = [self fullData];
    return (NSDictionary *)[self getPropertyOfdata:_fulldata];
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
- (CFDictionaryRef )getPropertyOfdata:(NSData *)data
{
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if (imageSource == NULL) {
        // Error loading image
        return nil;
    }
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:NO], (NSString *)kCGImageSourceShouldCache,
                             nil];
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (__bridge CFDictionaryRef)options);
    return imageProperties;
}
//- (void)setImagePropertyWith:(ALAsset *)asset
//{
//    //get full imageData
//    ALAssetRepresentation * defaultRep = [asset defaultRepresentation];
//    Byte *buffer = (Byte*)malloc(defaultRep.size);
//    NSUInteger buffered = [defaultRep getBytes:buffer fromOffset:0.0 length:defaultRep.size error:nil];
//    NSData * data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
//    // compressData providerData
//    CGDataProviderRef jpegdata = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
//    CGImageRef imageRef = CGImageCreateWithJPEGDataProvider(jpegdata, NULL, YES, kCGRenderingIntentDefault);
//    UIImage * image = [UIImage imageWithCGImage:imageRef];
//    NSData* finaldata = UIImageJPEGRepresentation(image, 0.5);
//    //compressData with exif
//    finaldata =  [self writeExif:(NSDictionary *)[self getPropertyOfdata:data] intoImage:finaldata];
//}

@end
