//
//  LocalDetailController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-11.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "LocalDetailController.h"

@implementation LocalDetailController
@synthesize cache = _cache, group = _group;

- (id)initWithAssetsArray:(NSArray *)array andCurAsset:(ALAsset *)asset andAssetGroup:(ALAssetsGroup *)group
{
    self = [super init];
    if (self) {
        
        self.wantsFullScreenLayout = YES;
        _curImageArray = [NSMutableArray arrayWithCapacity:0];
        _isHidingBar = NO;
        _isInit = YES;
        _isRotating = NO;
        self.cache = [[SDImageCache alloc] init];
        self.curPageNum = [array indexOfObject:asset];
        self.assetsArray = [array copy];
        self.group = group;
    }
    return self;
}

#pragma mark Overide applicationDidBecomeActive
- (void)viewDidLoad
{
    [super viewDidLoad];
    //fix tabBar
    [self.tabBar.loadButton setImage:[UIImage imageNamed:@"TabBarUpLoad.png"] forState:UIControlStateNormal];
    [self.tabBar.deleteButton setHidden:YES];
    [self.tabBar.shareButton setHidden:YES];
}
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self readPhotoes];
}
- (void)readPhotoes
{
    NSURL * assetUrl = [[[self.assetsArray objectAtIndex:self.curPageNum] defaultRepresentation] url];
    self.assetsArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * tempArry = [NSMutableArray arrayWithCapacity:0];
    if (!self.group) {
        [[self libiary] readAlbumIntoGroupContainer:tempArry assetsContainer:self.assetsArray sucess:^{
            [self resetCurNumWhenAssetArryChangeWithPreAsset:assetUrl];
        } failture:^(NSError *error) {
            
        }];
    }else{
        [[self libiary] readPhotoIntoAssetsContainer:self.assetsArray fromGroup:self.group sucess:^{
            [self resetCurNumWhenAssetArryChangeWithPreAsset:assetUrl];
        }];
    }
}

- (NSMutableArray *)revertObjectArray:(NSMutableArray *)array
{
    NSMutableArray * finalArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = array.count - 1; i >= 0; i--)
        [finalArray addObject:[array objectAtIndex:i]];
    return finalArray;
}
- (void)resetCurNumWhenAssetArryChangeWithPreAsset:(NSURL *)assetUrl
{
    self.assetsArray = [self sortArrayByTime:self.assetsArray]; //逆序排序
    NSUInteger curnum = [self indexWithAssetUrl:assetUrl.absoluteString];
    if (curnum == NSNotFound) {
        self.curPageNum = [self validPageValue:self.curPageNum];
    }else{
        self.curPageNum =  curnum;
    }
    [self refreshScrollView];
}
- (NSInteger)indexWithAssetUrl:(NSString *)assetString
{
    for (int i = 0; i < self.assetsArray.count; i++) {
        ALAsset * asset  =[self.assetsArray objectAtIndex:i];
        if ([assetString isEqualToString:[[[asset defaultRepresentation] url] absoluteString]]) {
            return i;
        }
    }
    return NSNotFound;
}
#pragma mark - GetIdentifyImageSizeWithImageView
- (CGSize)getIdentifyImageSizeWithImageView:(ImageScaleView *)scaleView isPortraitorientation:(BOOL)isPortrait
{
    UIImageView * imageView  = scaleView.imageView;
    if (!imageView.image) return CGSizeZero;
    CGFloat w = imageView.image.size.width;
    CGFloat h = imageView.image.size.height;
    CGRect frameRect = CGRectZero;
    CGRect  screenFrame = [[UIScreen mainScreen] bounds];
    if (isPortrait) {
        frameRect = screenFrame;
    }else{
        frameRect = CGRectMake(0, 0, screenFrame.size.height, screenFrame.size.width);
    }
    CGRect rect = CGRectZero;
    CGFloat scale = MIN(frameRect.size.width / w, frameRect.size.height / h);
    rect = CGRectMake(0, 0, w * scale, h * scale);
    return rect.size;
}
#pragma mark -  GetImageFromAsset
- (void)setImageView:(ImageScaleView *)scaleView imageFromAsset:(id)asset
{
    [super setImageView:scaleView imageFromAsset:asset];
    UIImageView * imageView = scaleView.imageView;
//    UIImage * image = [self getImageFromCacheWithKey:[[[(ALAsset * )asset defaultRepresentation] url] absoluteString]];
    UIImage * image = [self.cache imageFromKey:[[[(ALAsset * )asset defaultRepresentation] url] absoluteString]];
    if (!image) {
        image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
    }
    imageView.image = image;
}
//- (UIImage *)getImageFromCacheWithKey:(id)aKey
//{
//    NSData * imageData = [self.cache objectForKey:aKey];
//    return [UIImage imageWithData:imageData];
//}

#pragma mark - GetActualImage
- (void)setImageView:(ImageScaleView *)scaleView ActualImage:(id)asset andOrientation:(UIImageOrientation)orientation
{
    UIImageView * imageView = scaleView.imageView;
//    UIImage * image = [self getImageFromCacheWithKey:[[[asset defaultRepresentation] url] absoluteString]];
    UIImage * image = [self.cache imageFromKey:[[[(ALAsset * )asset defaultRepresentation] url] absoluteString]];
    if (!image) {
        image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:1.0f orientation:orientation];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self.cache setObject:UIImagePNGRepresentation(image) forKey:[[[asset defaultRepresentation] url] absoluteString]];
            [self.cache storeImage:image forKey:[[[asset defaultRepresentation] url] absoluteString]];
        });
    }
    imageView.image = image;
}

#pragma mark - cusTabBarDelegate
- (void)cusTabBar:(CustomizetionTabBar *)bar buttonClick:(UIButton *)button
{
    if (button.tag == TABBARCANCEL){
        self.isPushView = YES;
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (![LoginStateManager isLogin]) {
        self.isPushView = YES;
        [self showLoginViewWithMethodNav:YES];
        return;
    }
    if (button.tag == TABBARSHARETAG){        //分享图片
        [self showShareView];
    }
    if (button.tag == TABBARLOADPIC){        //上传图片
        ALAsset * asset = [self.assetsArray objectAtIndex:self.curPageNum];
        [[UploadTaskManager currentManager] uploadPicTureWithALasset:asset];
    }
}
- (void)showShareView
{
    if (!_shareBox) {
        _shareBox = [[ShareBox alloc] init];
        _shareBox.delegate = self;
    }
    [_shareBox showShareViewWithWeixinShow:YES photoWall:NO andWriteImage:NO OnView:self.view];
}

- (void)shareBoxViewShareTo:(KShareModel)model
{
    [self upPicture:model];
}
- (void)shareBoxViewWeiXinShareToScene:(enum WXScene)scene
{
    [self respImageContentToSence:scene];
}

#pragma mark - ShareWithDes
- (void)localShareDesView:(LocalShareDesView *)view shareTo:(KShareModel)model withDes:(NSString *)text
{
    [UIView animateWithDuration:0.2 animations:^{
        [view removeFromSuperview];
    }];
    switch (model) {
        case SinaWeiboShare:
            [self sinaUploadPicWithDes:text];
            break;
        case RenrenShare:
            [self renrenUPlaodPicWithDes:text];
            break;
        case QQShare:
            [self qqUploadPicWithDes:text];
            break;
        default:
            break;
    }
}

#pragma mark Action
- (AppDelegate *)Appdelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)upPicture:(KShareModel)model
{
    switch (model) {
        case SinaWeiboShare:
            [[self Appdelegate] sinaLoginWithDelegate:self];
            break;
          case RenrenShare:
            [[self Appdelegate] renrenLoginWithDelegate:self];
            break;
        case QQShare:
            [[self Appdelegate] qqLoginWithDelegate:self];
            break;
        case WeixinShare:
            [[self Appdelegate] weiXinregisterWithDelegate:self];
            [self weixinUploadPic];
            break;
        default:
            break;
    }
}

#pragma mark - SINA UPloadPic
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self.view addSubview:[[LocalShareDesView alloc] initWithModel:SinaWeiboShare thumbnail:[UIImage imageWithCGImage:[[self.assetsArray objectAtIndex:self.curPageNum] thumbnail]] andDelegate:self]];
//    [self sinaUploadPic];
}
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    [self showInvalidTokenOrOpenIDMessageWithMes:[error description]];
}
- (void)sinaUploadPicWithDes:(NSString *)des
{
    //uplaod image
    [[[self Appdelegate] sinaweibo] requestWithURL:@"statuses/upload.json"
                                            params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                    des, @"status",
                                                    [UIImage imageWithCGImage:[[[self.assetsArray objectAtIndex:self.curPageNum] defaultRepresentation] fullScreenImage]], @"pic", nil]
                                        httpMethod:@"POST"
                                          delegate:self];
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    //发送
    if ([request.url hasSuffix:@"statuses/upload"])
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
    DLog(@"%@",error);
    [self showInvalidTokenOrOpenIDMessageWithMes:[error description]];
}

#pragma mark RenRen upload
- (void)renrenDidLogin:(Renren *)renren
{
     [self.view addSubview:[[LocalShareDesView alloc] initWithModel:RenrenShare thumbnail:[UIImage imageWithCGImage:[[self.assetsArray objectAtIndex:self.curPageNum] thumbnail]] andDelegate:self]];
}
- (void)renrenDidLogout:(Renren *)renren
{

}
- (void)renren:(Renren *)renren loginFailWithError:(ROError *)error
{
    
}
- (void)renrenUPlaodPicWithDes:(NSString *)des
{
    ROPublishPhotoRequestParam * param = [[ROPublishPhotoRequestParam alloc] init];
    param.imageFile = [UIImage imageWithCGImage:[[[self.assetsArray objectAtIndex:self.curPageNum] defaultRepresentation] fullScreenImage]];
    param.caption = des;
    [[Renren sharedRenren] publishPhoto:param andDelegate:self];
}

- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse *)response
{
    if (response.error) {
        [self showInvalidTokenOrOpenIDMessageWithMes:[[response error] localizedDescription]];
    }else{
        [self showInvalidTokenOrOpenIDMessageWithMes:@"OK"];
    }
}
#pragma mark - QQ UPloadPic
- (void)tencentDidLogin
{
     [self.view addSubview:[[LocalShareDesView alloc] initWithModel:QQShare thumbnail:[UIImage imageWithCGImage:[[self.assetsArray objectAtIndex:self.curPageNum] thumbnail]] andDelegate:self]];
}
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    
}
- (void)tencentDidNotNetWork
{
    //网络条件问题
}
- (void)qqUploadPicWithDes:(NSString *)des
{
	UIImage * img = [UIImage imageWithCGImage:[[[self.assetsArray objectAtIndex:self.curPageNum] defaultRepresentation] fullScreenImage]];
    TCUploadPicDic * params = [TCUploadPicDic dictionary];
    params.paramPicture = img;
    params.paramPhotodesc = des;
    params.paramMobile = @"1";
    params.paramNeedfeed = @"1";
    
	if(![[[self Appdelegate] tencentOAuth] uploadPicWithParams:params]){
        [self showInvalidTokenOrOpenIDMessageWithMes:@"error"];
    }
}
- (void)uploadPicResponse:(APIResponse*) response
{
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
							  
													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
		[alert show];
	}
	
}

#pragma mark - Weixin
-(void)weixinUploadPic
{
    //本地分享功能隐藏
    if ([WXApi isWXAppInstalled]) {
        UIActionSheet * act = [[UIActionSheet alloc] initWithTitle:@"发送到" delegate:self cancelButtonTitle:@"Cancal" destructiveButtonTitle:nil otherButtonTitles:@"朋友圈",@"会话", nil];
        act.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [act showInView:self.view];
    }else{
        [self showInvalidTokenOrOpenIDMessageWithMes:@"请确认安装微信"];
    }
}
- (void)onResp:(BaseResp *)resp
{
    if (resp.errCode == 0) {
        [self showPopAlerViewRatherThentasView:NO WithMes:@"分享成功"];
    }else{
        [self showPopAlerViewRatherThentasView:NO WithMes:@"分享失败"];
    }
}
- (void) respImageContentToSence:(enum WXScene)scene
{
    //发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageWithCGImage:[[self.assetsArray objectAtIndex:self.curPageNum] aspectRatioThumbnail]]];
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = [self getDataFromAsset:[self.assetsArray objectAtIndex:self.curPageNum]];
    message.mediaObject = ext;
    SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}

- (NSData *)getDataFromAsset:(ALAsset *)asset
{
    CGImageRef imageRef = [[asset defaultRepresentation] fullScreenImage];
    UIImage * image = [UIImage imageWithCGImage:imageRef];
    return UIImageJPEGRepresentation(image, 0.5);
}

#pragma mark UpFailture
- (void)showInvalidTokenOrOpenIDMessageWithMes:(NSString *)Amessage
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:Amessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
@end
