//
//  LocalShareController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-30.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "LocalShareController.h"
#import "AppDelegate.h"

//#define BACKGORUNDCOLOR [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1.f]


@implementation LocalShareController
@synthesize uploadAsset = _uploadAsset;

- (void)dealloc
{
    [_cusBar release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.sinaAcountBtn setImage:[UIImage imageNamed:@"share_sina.png"] forState:UIControlStateNormal];
    [self.sinaAcountBtn setImage:[UIImage imageNamed:@"share_sina_press.png"] forState:UIControlStateHighlighted];
    self.sinaAcountBtn.labelText.text =@"新浪分享";
    
    [self.renrenAcountBtn setImage:[UIImage imageNamed:@"share_renren.png"] forState:UIControlStateNormal];
    [self.renrenAcountBtn setImage:[UIImage imageNamed:@"share_renren_press.png"] forState:UIControlStateHighlighted];
    self.renrenAcountBtn.labelText.text =@"人人";
    
    [self.weixinAcountBtn setImage:[UIImage imageNamed:@"share_weixin.png"] forState:UIControlStateNormal];
    [self.weixinAcountBtn setImage:[UIImage imageNamed:@"share_weixin_press.png"] forState:UIControlStateHighlighted];
    self.weixinAcountBtn.labelText.text =@"微信";
    
    [self.qqAcountBtn setImage:[UIImage imageNamed:@"share_Q_zone.png"] forState:UIControlStateNormal];
    [self.qqAcountBtn setImage:[UIImage imageNamed:@"share_Q_zone_press.png"] forState:UIControlStateHighlighted];
    self.qqAcountBtn.labelText.text =@"QQ空间";
}
#pragma mark Action
- (AppDelegate *)Appdelegate
{
    return [[UIApplication sharedApplication] delegate];
}
- (void)upPicture:(UIButton *)button
{
    if (button.tag == kSinaTag) {
        [[self Appdelegate] sinaLoginWithDelegate:self];
    }
    if (button.tag == kRenrenTag) {
        [self renrenUPlaodPic];
    }
    if (button.tag == kQQTag) {
        [[self Appdelegate] qqLoginWithDelegate:self];
    }
    if (button.tag == kWeixinTag) {
        [[self Appdelegate] weiXinregisterWithDelegate:self];
        [self weixinUploadPic];
        
    }
}
#pragma mark - SINA UPloadPic
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self sinaUploadPic];
}
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    [self showInvalidTokenOrOpenIDMessageWithMes:[error description]];
}

- (void)sinaUploadPic
{
    //uplaod image
    [[[self Appdelegate] sinaweibo] requestWithURL:@"statuses/upload.json"
                              params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @"要发表的内容", @"status",
                                      [UIImage imageWithCGImage:[[self.uploadAsset defaultRepresentation] fullScreenImage]], @"pic", nil]
                          httpMethod:@"POST"
                            delegate:self];
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    
    //发送
    if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        if ([(NSDictionary *)result objectForKey:@"error"]) {
            [self showInvalidTokenOrOpenIDMessageWithMes:[(NSDictionary *)result objectForKey:@"error"]];
            return;
        }
    [self showInvalidTokenOrOpenIDMessageWithMes:[result objectForKey:@"text"]];
    }
}
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [self showInvalidTokenOrOpenIDMessageWithMes:[error description]];
}

#pragma mark RenRen upload
- (void)renrenUPlaodPic
{
    UIImage* image = [UIImage imageWithCGImage:[[self.uploadAsset defaultRepresentation] fullScreenImage]];
    NSString *caption = @"这是一张测试图片";
    [[Renren sharedRenren] publishPhotoSimplyWithImage:image caption:caption];
}
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse *)response
{
    if (response.error) {
        [self showInvalidTokenOrOpenIDMessageWithMes:[[response error] localizedDescription]];
    }
}

#pragma mark - QQ UPloadPic
- (void)tencentDidLogin
{
    [self qqUploadPic];
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
	UIImage * img = [UIImage imageWithCGImage:[[self.uploadAsset defaultRepresentation] fullScreenImage]];
    TCUploadPicDic * params = [TCUploadPicDic dictionary];
    params.paramPicture = img;
    params.paramTitle = @"风云乔布斯";
    params.paramPhotodesc = @"比天皇巨星还天皇巨星的天皇巨星";
    params.paramMobile = @"1";
    params.paramNeedfeed = @"1";
    params.paramX = @"39.909407";
    params.paramY = @"116.397521";
    
	if(![[[self Appdelegate] tencentOAuth] uploadPicWithParams:params]){
        [self showInvalidTokenOrOpenIDMessageWithMes:@"error"];
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

#pragma mark - Weixin
-(void)weixinUploadPic
{
    if ([WXApi isWXAppInstalled]) {
        UIActionSheet * act = [[[UIActionSheet alloc] initWithTitle:@"发送到" delegate:self cancelButtonTitle:@"Cancal" destructiveButtonTitle:nil otherButtonTitles:@"朋友圈",@"会话", nil] autorelease];
        [act showInView:self.view];
    }else{
        [self showInvalidTokenOrOpenIDMessageWithMes:@"请确认安装微信"];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self respImageContentToSence:WXSceneTimeline];
            break;
        case 1:
            [self respImageContentToSence:WXSceneSession];
            break;
        default:
            break;
    }
}
-(void) onReq:(BaseReq*)req
{
    
}
- (void) respImageContentToSence:(enum WXScene)scene
{
    //发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageWithCGImage:[self.uploadAsset aspectRatioThumbnail]]];
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = [self getDataFromAsset:self.uploadAsset];
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}
- (NSData *)getDataFromAsset:(ALAsset *)asset
{
//    ALAssetRepresentation * defaultRep = [asset defaultRepresentation];
//    Byte *buffer = (Byte*)malloc(defaultRep.size);
//    NSUInteger buffered = [defaultRep getBytes:buffer fromOffset:0.0 length:defaultRep.size error:nil];
//    NSData * data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
    CGImageRef imageRef = [[asset defaultRepresentation] fullScreenImage];
    UIImage * image = [UIImage imageWithCGImage:imageRef];
    return UIImageJPEGRepresentation(image, 1.f);
}
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
        NSString *strMsg = [NSString stringWithFormat:@"发送媒体消息结果:%d %@", resp.errCode,resp.errStr];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

#pragma mark UpFailture
- (void)showInvalidTokenOrOpenIDMessageWithMes:(NSString *)Amessage
{
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:nil message:Amessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease];
    [alert show];
}
@end
