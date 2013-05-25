//
//  AccountSystem.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-22.
//
//


#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "URLLibaray.h"


@interface AccountLoginResquest : NSObject

#pragma mark sohu Acount
+ (void)sohuLoginWithuseName:(NSString *)useName password:(NSString *)password sucessBlock:(void (^)(NSDictionary  * response))success failtureSucess:(void (^)(NSString * error))faiture;
+ (void)resigiterWithuseName:(NSString *)useName password:(NSString *)password nickName:(NSString *)nick sucessBlock:(void (^)(NSDictionary  * response))success failtureSucess:(void (^)(NSString * error))faiture;
+ (BOOL)resigiterDevice;

+ (BOOL)setBindingInfo;

+ (BOOL)unBinging:(KShareModel)shareModel;
#pragma DeviceToken For Push
+ (BOOL)upDateDeviceToken;

+ (BOOL)deleteDeviceToken;
@end
