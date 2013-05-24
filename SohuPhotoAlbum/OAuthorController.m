//
//  SCPAuthorizeViewController.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-8.
//
//

#import "OAuthorController.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

static NSString * url_string = nil;
static NSString * title = nil;
static NSString * provider = nil;

@interface OAuthorController()
- (void)webviewCancelLogin:(id)sender;
@end
@implementation OAuthorController
@synthesize delegate = _delegate;


- (id)initWithMode:(KShareModel)AshareModel ViewModel:(ViewShowModel)model
{
    self = [super init];
    if (self) {
        viewModel = model;
        switch (AshareModel) {
            case SinaWeiboShare: //weibo
                url_string = WEIBOOAUTHOR2URL;
                title = @"微博登录";
                provider = @"weibo";
                break;
            case QQShare: //qq
                url_string = QQOAUTHOR2URL;
                title = @"QQ登录";
                provider = @"qq";
                break;
            case RenrenShare: //renren
                url_string = RENRENAUTHOR2URL;
                title = @"人人登录";
                provider = @"renren";
                break;
            default:
                break;
        }
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem * cancelLogin = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(webviewCancelLogin:)];
    self.navigationItem.leftBarButtonItem = cancelLogin;
    self.title = title;
    [self OAuth2authorize];
}

- (void)OAuth2authorize
{
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url_string] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:20]];
    webView.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
    webView.scrollView.bounces = NO;
    webView.delegate = self;
    [self.view addSubview:webView];
    [self waitForMomentsWithTitle:@"加载中..."];
}

- (void)webviewCancelLogin:(id)sender
{
    if (self.navigationController && self.navigationController.presentingViewController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.navigationController.presentingViewController) {
        [self.navigationController.presentingViewController dismissModalViewControllerAnimated:YES];
    }
    if ([_delegate respondsToSelector:@selector(oauthorController:bindFailture:)])
        [_delegate oauthorController:self bindFailture:nil];
}

- (void)loginWithCode
{
     NSString * url_s = [NSString stringWithFormat:@"%@/oauth2/access_token",BASICURL];
    __weak ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url_s]];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setPostValue:@"third_party_code" forKey:@"grant_type"];
    [request setPostValue:CLIENT_ID forKey:@"client_id"];
    [request setPostValue:provider forKey:@"provider"];
    [request setPostValue:state forKey:@"state"];
    [request setPostValue:grantcode forKey:@"code"];
    [request setCompletionBlock:^{
        DLog(@"%d %@",[request responseStatusCode],[request responseString]);
        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 ) {
            if ([_delegate respondsToSelector:@selector(oauthorController:loginSucessInfo:)])
                [_delegate oauthorController:self loginSucessInfo:[[request responseString] JSONValue]];
            
        }else{
            if ([_delegate respondsToSelector:@selector(loginFailture:)]) {
                [_delegate performSelector:@selector(loginFailture:) withObject:[NSString stringWithFormat:@"%d,未知错误",[request responseStatusCode]]];
            }
        }
    }];
    [request setFailedBlock:^{
        if ([_delegate respondsToSelector:@selector(loginFailture:)]) {
            [_delegate performSelector:@selector(loginFailture:) withObject:@"连接失败"];
        }
    }];
    [request startAsynchronous];
}
- (void)bingWithCode
{
    
}
#pragma mark webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString * str = [request.URL absoluteString];
    str  = [[str componentsSeparatedByString:@"?"] lastObject];
    if ([str rangeOfString:@"grantcode"].length && [str rangeOfString:@"token="].length) {
        NSArray * array = [str componentsSeparatedByString:@"&"];
        for (NSString * str in array) {
            if ([str rangeOfString:@"state"].length) {
                state = [[str componentsSeparatedByString:@"="] lastObject];
            }
            if ([str rangeOfString:@"grantcode"].length) {
                grantcode  = [[str componentsSeparatedByString:@"="] lastObject];
            }
        }
        if (viewModel == LoginModelView) {
            
            [self loginWithCode];
        }else{
            [self bingWithCode];
        }
        return NO;
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self stopWait];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self stopWait];
}
#pragma alertView
-(void)waitForMomentsWithTitle:(NSString*)str
{
    if (!_alterView) {
        _alterView = [[MBProgressHUD alloc] initWithView:self.view];
        _alterView.animationType = MBProgressHUDAnimationZoomOut;
        _alterView.labelText = str;
        [self.view addSubview:_alterView];
    }
    [_alterView show:YES];
}
-(void)stopWait
{
    [_alterView hide:YES];
}

@end
