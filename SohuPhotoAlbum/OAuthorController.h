//
//  SCPAuthorizeViewController.h
//  SohuCloudPics
//
//  Created by sohu on 13-1-8.
//
//

#import <UIKit/UIKit.h>
#import "URLLibaray.h"

typedef enum {
    BingModelView,
    LoginModelView
}ViewShowModel;


@class OAuthorController;
@protocol OAuthorControllerDelegate <NSObject>
@optional
- (void)oauthorController:(OAuthorController *)controller loginSucessInfo:(NSDictionary *)dic;
- (void)oauthorController:(OAuthorController *)controlle  loginFailture:(NSString *)error;
- (void)oauthorController:(OAuthorController *)controller bingSucessInfo:(NSDictionary *)dic;
- (void)oauthorController:(OAuthorController *)controlle  bindFailture:(NSString *)error;
- (void)oauthorControllerCancel:(OAuthorController *)controlle;
@end

@interface OAuthorController : UIViewController<UIWebViewDelegate>
{
    MBProgressHUD * _progessView;
    NSString * state;
    NSString * code;
    NSString *  sohu_token;
//    NSString * grantcode;
//    NSString * sohu_accessToken;
    ViewShowModel viewModel;
    KShareModel shareModel;
}
@property(nonatomic,weak)id<OAuthorControllerDelegate> delegate;
@property(assign,nonatomic)KShareModel shareModel;
- (id)initWithMode:(KShareModel)hareModel ViewModel:(ViewShowModel)model;
@end
