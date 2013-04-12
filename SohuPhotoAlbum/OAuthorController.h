//
//  SCPAuthorizeViewController.h
//  SohuCloudPics
//
//  Created by sohu on 13-1-8.
//
//

#import <UIKit/UIKit.h>

#import "URLLibaray.h"

typedef enum{
    LoginModelSina = 0,
    LoginModelQQ,
    LoginModelRenRen
}LoginModel;

@class OAuthorController;
@protocol OAuthorControllerDelegate <NSObject>
@optional
- (void)oauthorController:(OAuthorController *)controller loginSucessInfo:(NSDictionary *)dic;
- (void)oauthorController:(OAuthorController *)controlle  loginFailture:(NSString *)error;
@end

@interface OAuthorController : UIViewController<UIWebViewDelegate>
{
    MBProgressHUD * _alterView;
    NSString * code;
}
@property(nonatomic,assign)id<OAuthorControllerDelegate> delegate;

- (id)initWithMode:(LoginModel)loginMode;
@end
