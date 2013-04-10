//
//  SCPPerfrencdStoreManager.h
//  SohuCloudPics
//
//  Created by sohu on 13-2-1.
//
//

#import <Foundation/Foundation.h>

@interface PerfrenceSettingManager : NSObject

+ (NSString *)homeBackGroundImageName;
+ (void)resetHomeBackGroudImageName:(NSString *)newName;

+ (NSNumber *)isUploadJPEGImage;
+ (void)setIsUploadJPEGImage:(BOOL)ture;

+ (NSNumber *)isShowingGridView;
+ (void)setIsShowingGridView:(BOOL)ture;


+ (void)archivedDataWithRootObject:(id)object withKey:(NSString *)key;
+ (id)unarchiveObjectWithDataWithKey:(NSString *)key;
@end
