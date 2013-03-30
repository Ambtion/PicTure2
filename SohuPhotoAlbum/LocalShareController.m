//
//  LocalShareController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-30.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "LocalShareController.h"
#import "AppDelegate.h"

@interface LocalShareController ()

@end

@implementation LocalShareController
- (void)dealloc
{
    [_tencentOAuth release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 20, 50, 40);
    [button addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self initOauhtorizes];
}
- (void)initOauhtorizes
{
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAPPID andDelegate:self];
    [[self sinaweibo] setDelegate:self];
}
- (void)Login:(UIButton *)sender
{
    if (!sender.tag) {
//        [self qqLogin];
    }else{
//        [self qqUploadPic];
    }
    sender.tag = !sender.tag;
}
#pragma mark - SINA UPloadPic
- (SinaWeibo *)sinaweibo
{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}
- (void)sinaLogin
{
    [[self sinaweibo] logIn];
}
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    
}
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    
}
- (void)sinaUploadPic
{
    
}

#pragma mark - QQ UPloadPic
- (void)qqLogin
{
    NSArray * qqPermissions = [[NSArray arrayWithObjects:
                       kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                       kOPEN_PERMISSION_ADD_PIC_T, /** 上传图片并发表消息到腾讯微博 */
                       kOPEN_PERMISSION_UPLOAD_PIC,  /** 上传一张照片到QQ空间相册(<b>需要申请权限</b>) */
                     nil] retain];
	[_tencentOAuth authorize:qqPermissions inSafari:NO];
}
- (void)tencentDidLogin
{
    
}
- (void)tencentDidNotLogin:(BOOL)cancelled
{

}
- (void)tencentDidNotNetWork
{
    //网络条件问题
}
- (void)qqUploadPic
{
	NSString *path = @"http://img1.gtimg.com/tech/pics/hv1/95/153/847/55115285.jpg";
	NSURL *url = [NSURL URLWithString:path];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *img  = [[UIImage alloc] initWithData:data];
    TCUploadPicDic * params = [TCUploadPicDic dictionary];
    params.paramPicture = img;
    params.paramTitle = @"风云乔布斯";
    params.paramPhotodesc = @"比天皇巨星还天皇巨星的天皇巨星";
    params.paramMobile = @"1";
    params.paramNeedfeed = @"1";
    params.paramX = @"39.909407";
    params.paramY = @"116.397521";
    
	if(![_tencentOAuth uploadPicWithParams:params]){
        [self showInvalidTokenOrOpenIDMessage];
    }
	[img release];
	
}
- (void)uploadPicResponse:(APIResponse*) response {
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
        [alert release];
	}
	
}

#pragma mark UpFailture
- (void)showInvalidTokenOrOpenIDMessage
{
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"api调用失败" message:@"可能授权已过期，请重新获取" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
    [alert show];
}
@end
