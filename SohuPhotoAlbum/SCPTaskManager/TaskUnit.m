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


@implementation TaskUnit

@synthesize asset = _asset;
@synthesize description = _description;
@synthesize taskState = _taskState;
@synthesize thumbnail = _thumbnail;
@synthesize request = _request;
@synthesize data = _data;

- (void)dealloc
{
    self.asset = nil;
    self.thumbnail = nil;
    self.description = nil;
    self.request = nil;
    self.data = nil;
    [super dealloc];
}

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
    NSNumber * isUploadJPEGImage = nil;
    if ([LoginStateManager isLogin]){
        isUploadJPEGImage = [PerfrenceSettingManager isUploadJPEGImage];
    }else{
        return nil;
    }
    
    ALAssetRepresentation * defaultRep = [self.asset defaultRepresentation];
    Byte *buffer = (Byte*)malloc(defaultRep.size);
    NSUInteger buffered = [defaultRep getBytes:buffer fromOffset:0.0 length:defaultRep.size error:nil];
    NSData * data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
    
    if (!isUploadJPEGImage || ![isUploadJPEGImage boolValue]) {
        DLog(@"Original Image");
        //            data = UIImageJPEGRepresentation(image, 1.f);
        //            NSLog(@"ori:when upload: %f",[data length]/(1024 * 1024.f));
    }else{
        CGDataProviderRef jpegdata = CGDataProviderCreateWithCFData((CFDataRef)data);
        CGImageRef imageRef = CGImageCreateWithJPEGDataProvider(jpegdata, NULL, YES, kCGRenderingIntentDefault);
        UIImage * image = [UIImage imageWithCGImage:imageRef];
        data = UIImageJPEGRepresentation(image, 0.5);
        DLog(@"cpmpre:when upload : %f",[data length]/(1024 * 1024.f));
    }
    return data;
}
@end
