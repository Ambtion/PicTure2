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

@synthesize asseetUrl = _asseetUrl;
@synthesize description = _description;
@synthesize taskState = _taskState;
@synthesize thumbnail = _thumbnail;
@synthesize request = _request;
@synthesize data = _data;

- (void)dealloc
{
    self.asseetUrl = nil;
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
    //    NSLog(@"%s : AssetURL is Write property",__FUNCTION__);
    return nil;
}

- (void)getImageSucess:(void (^)(NSData * imageData,TaskUnit * unit))resultBlock failture:(void(^)(NSError * error,TaskUnit * unit))myfailtureBlock;
{
    
    if (self.data) {
        resultBlock(self.data,self);
        return;
    }
    
    ALAssetsLibrary * lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:_asseetUrl resultBlock:^(ALAsset *asset) {
        
        ALAssetRepresentation * defaultRep = [asset defaultRepresentation];
        
        Byte *buffer = (Byte*)malloc(defaultRep.size);
        NSUInteger buffered = [defaultRep getBytes:buffer fromOffset:0.0 length:defaultRep.size error:nil];
        NSData * data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        
        NSNumber * isUploadJPEGImage = nil;
        
        if ([LoginStateManager isLogin]){
            isUploadJPEGImage = [PerfrenceSettingManager isUploadJPEGImage];
        }else{
            resultBlock(nil,self);
            return;
        }
        
        if (!isUploadJPEGImage || ![isUploadJPEGImage boolValue]) {
//            data = UIImageJPEGRepresentation(image, 1.f);
//            NSLog(@"ori:when upload: %f",[data length]/(1024 * 1024.f));
            
        }else{
            CGDataProviderRef jpegdata = CGDataProviderCreateWithCFData((CFDataRef)data);
            CGImageRef imageRef = CGImageCreateWithJPEGDataProvider(jpegdata, NULL, YES, kCGRenderingIntentDefault);
            UIImage * image = [UIImage imageWithCGImage:imageRef];
            data = UIImageJPEGRepresentation(image, 0.5);
//            UIImage * image = [UIImage imageWithCGImage:[defaultRep fullResolutionImage]                                              scale:[defaultRep scale] orientation:(UIImageOrientation)[defaultRep orientation]];
         //            image = [image fixOrientation];
//            NSLog(@"cpmpre:when upload : %f",[data length]/(1024 * 1024.f));
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(data,self);
            [lib release];
        });
        
    } failureBlock:^(NSError *error) {
        myfailtureBlock(error,self);
        [lib release];
    }];
}
@end
