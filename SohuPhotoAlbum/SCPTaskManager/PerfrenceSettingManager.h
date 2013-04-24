//
//  SCPPerfrencdStoreManager.h
//  SohuCloudPics
//
//  Created by sohu on 13-2-1.
//
//

#import <Foundation/Foundation.h>

@interface PerfrenceSettingManager : NSObject


+ (NSNumber *)isUploadJPEGImage;
+ (void)setIsUploadJPEGImage:(BOOL)ture;

+(NSNumber *)isAutoUpload;
+(void)setIsAutoUpload:(BOOL)ture;

+ (void)archivedDataWithRootObject:(id)object withKey:(NSString *)key;
+ (id)unarchiveObjectWithDataWithKey:(NSString *)key;

@end
