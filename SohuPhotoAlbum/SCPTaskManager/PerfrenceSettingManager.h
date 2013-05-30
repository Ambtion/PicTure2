//
//  SCPPerfrencdStoreManager.h
//  SohuCloudPics
//
//  Created by sohu on 13-2-1.
//
//

#import <Foundation/Foundation.h>

@interface PerfrenceSettingManager : NSObject


+ (BOOL)isUploadJPEGImage;
+ (void)setIsUploadJPEGImage:(BOOL)ture;

+ (BOOL)isAutoUpload;
+ (void)setIsAutoUpload:(BOOL)ture;

+ (BOOL)WifiLimitedAutoUpload;
+ (void)setWifiLimited:(BOOL)ture;

//+ (void)archivedDataWithRootObject:(id)object withKey:(NSString *)key;
//+ (id)unarchiveObjectWithDataWithKey:(NSString *)key;

@end
