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
@synthesize shareModel;

- (id)initWithMode:(KShareModel)AshareModel ViewModel:(ViewShowModel)model
{
    self = [super init];
    if (self) {
        viewModel = model;
        shareModel = AshareModel;
        if (viewModel == BingModelView) {
            switch (shareModel) {
                case SinaWeiboShare: //weibo
                    url_string = [NSString stringWithFormat:@"%@/bind/mobile/weibo",BASICURL];
                    title = @"微博登录";
                    provider = @"weibo";
                    break;
                case QQShare: //qq
                    url_string = [NSString stringWithFormat:@"%@/bind/mobile/qq",BASICURL];
                    title = @"QQ登录";
                    provider = @"qq";
                    break;
                case RenrenShare: //renren
                    url_string = [NSString stringWithFormat:@"%@/bind/mobile/renren",BASICURL];
                    title = @"人人登录";
                    provider = @"renren";
                    break;
                default:
                    break;
            }
            url_string = [url_string stringByAppendingFormat:@"?access_token=%@",[LoginStateManager currentToken]];
        }else{
            switch (shareModel) {
                case SinaWeiboShare: //weibo
                    url_string = [NSString stringWithFormat:@"%@/auth/mobile/weibo",BASICURL];
                    title = @"微博登录";
                    provider = @"weibo";
                    break;
                case QQShare: //qq
                    url_string = [NSString stringWithFormat:@"%@/auth/mobile/qq",BASICURL];
                    title = @"QQ登录";
                    provider = @"qq";
                    break;
                case RenrenShare: //renren
                    url_string = [NSString stringWithFormat:@"%@/auth/mobile/renren",BASICURL];
                    title = @"人人登录";
                    provider = @"renren";
                    break;
                default:
                    break;
            }
        }
        DLog(@"bingURL :: %@",url_string);
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
    _progessView  = [self waitForMomentsWithTitle:@"加载中..." withView:self.view];
}

- (void)webviewCancelLogin:(id)sender
{
    if (self.navigationController && self.navigationController.presentingViewController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.navigationController.presentingViewController) {
        [self.navigationController.presentingViewController dismissModalViewControllerAnimated:YES];
    }
    if ([_delegate respondsToSelector:@selector(oauthorControllerCancel:)])
        [_delegate oauthorControllerCancel:self];
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
    [request setPostValue:sohu_token forKey:@"token"];
    
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
    DLog(@"");
    NSString * url_s = nil;
    switch (shareModel) {
        case QQShare:
            url_s  = @"http://pp.sohu.com/bind/mobile/qq/callback";
            break;
        case SinaWeiboShare:
            url_s  = @"http://pp.sohu.com/bind/mobile/weibo/callback";
            break;
        case RenrenShare:
            url_s  = @"http://pp.sohu.com/bind/mobile/renren/callback";
            break;
        default:
            break;
    }
    
//    url_s = [url_s stringByAppendingFormat:@"?state=%@&access_token=%@&token=%@",state,sohu_accessToken,sohu_token];
    url_s  = [url_s stringByAppendingFormat:@"?state=%@&code=%@",state,code];
    DLog(@"bingWithCode:%@",url_s);
    __weak ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url_s]];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setRequestMethod:@"GET"];
    [request setCompletionBlock:^{
        [self handleBingInfo:request];
//        if ([request responseStatusCode]>= 200 && [request responseStatusCode] <= 300 )
//            [self handleBingInfo:[[request responseString] JSONValue]];
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
    
}

#pragma mark handle bingInfo
- (void)handleBingInfo:(ASIFormDataRequest *)request
{
    DLog(@"requestValue %@ %d",[[request responseString] JSONValue],[request responseStatusCode]);
//    if ([info objectForKey:@"code"] && [[info objectForKey:@"code"] intValue] == 0) {
    if (request.responseStatusCode == 200) {
//        [AccountLoginResquest setBindingInfo];
        [self handleInfoWithshareModel:shareModel infoDic:[[request responseString] JSONValue]];
        if (self.navigationController && self.navigationController.presentingViewController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        if (self.navigationController.presentingViewController) {
            [self.navigationController.presentingViewController dismissModalViewControllerAnimated:YES];
        }
        if ([_delegate respondsToSelector:@selector(oauthorController:bingSucessInfo:)]) {
            [_delegate oauthorController:self bingSucessInfo:nil];
        }
    }else{
        if (self.navigationController && self.navigationController.presentingViewController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        if (self.navigationController.presentingViewController) {
            [self.navigationController.presentingViewController dismissModalViewControllerAnimated:YES];
        }
        if ([_delegate respondsToSelector:@selector(oauthorController:bindFailture:)]) {
            [_delegate oauthorController:self bindFailture:@"绑定失败"];
        }
    }
}

#pragma mark webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString * str = [request.URL absoluteString];
    NSLog(@"all 302 ::%@",str);
    if ([[[str componentsSeparatedByString:@"?"] objectAtIndex:0] hasPrefix:@"http://pp.sohu.com/bind/mobile/"]) {
        str  = [[str componentsSeparatedByString:@"?"] lastObject];
        NSDictionary * dic = [self putMasWithString:str];
//        grantcode  = [dic objectForKey:@"grantcode"];
//        sohu_accessToken = [dic objectForKey:@"accesstoken"];
//        sohu_token = [dic objectForKey:@"token"];
        state = [dic objectForKey:@"state"];
        code = [dic objectForKey:@"code"];
        if (viewModel == LoginModelView) {
            [self loginWithCode];
        }else{
            [self bingWithCode];
        }
        return NO;
    }
    if ([str isEqualToString:@"http://pp.sohu.com/auth/mobile/failure"]) {
        [self showPopAlerViewRatherThentasView:NO WithMes:@"绑定失败"];
        return NO;
    }
    return YES;
}

- (NSDictionary *)putMasWithString:(NSString *)string
{
    NSArray * array = [string componentsSeparatedByString:@"&"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    for (NSString * str in array) {
        NSRange rang = [str rangeOfString:@"="];
        NSString * key  = [str substringToIndex:rang.location];
        NSString * value = [str substringFromIndex:rang.length + rang.location];
        [dic setValue:value forKey:key];
    }
    DLog(@"%@",dic);
    return dic;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self stopWaitProgressView:_progessView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self stopWaitProgressView:_progessView];
}

@end
