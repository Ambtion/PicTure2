//
//  UIViewController+DivideAssett.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "UIViewController+Method.h"
#import "AppDelegate.h"
#import "CloudPictureCell.h"
#import "PhotoesCell.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@implementation UIViewController (Method)
#pragma mark Data divideAssettByDayTime

- (void)cloundDivideAssettByDayTimeWithAssetArray:(NSMutableArray *)_assetsArray exportToassestionArray:(NSMutableArray *)assetsSection assetSectionisShow:(NSMutableArray *)_assetSectionisShow dataScource:(NSMutableArray *)dataSourceArray
{
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < _assetsArray.count; i++) {
        NSDictionary * asset = [_assetsArray objectAtIndex:i];
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:[[asset objectForKey:@"taken_at"] longLongValue] / 1000.f];
        NSString * dateString = [self stringFromdate:date];
        if (![self array:assetsSection hasTimeString:dateString]){
            [assetsSection addObject:dateString];
            NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
            [array addObject:asset];
            [tempArray addObject:array];
            [_assetSectionisShow addObject:[NSNumber numberWithBool:YES]];
        }else{
            NSMutableArray * array = [tempArray objectAtIndex:[assetsSection indexOfObject:dateString]];
            [array addObject:asset];
        }
    }
    for (NSMutableArray * array in tempArray )
        [dataSourceArray addObject:[self cloundCoverAssertToDataSource:array]];
}
- (NSMutableArray *)cloundCoverAssertToDataSource:(NSMutableArray *)array
{
    NSMutableArray * finalArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i+=4) {
        CloudPictureCellDataSource * source = [[CloudPictureCellDataSource alloc] init];
        source.firstDic = [array objectAtIndex:i];
        if (i + 3 < array.count) {
            source.secoundDic = [array objectAtIndex:i+1];
            source.thridDic  = [array objectAtIndex:i+2];
            source.lastDic = [array objectAtIndex:i+3];
        }else if (i + 2 < array.count){
            source.secoundDic = [array objectAtIndex:i+1];
            source.thridDic = [array objectAtIndex:i+2];
            source.lastDic = nil;
        }else if (i + 1 < array.count){
            source.secoundDic = [array objectAtIndex:i+1];
            source.lastDic = nil;
            source.thridDic = nil;
        }
        [finalArray addObject:source];
    }
    return finalArray;
}
- (NSString *)stringFromdate:(NSDate *)date
{
    //转化日期格式
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}
- (BOOL)array:(NSMutableArray *)array hasTimeString:(NSString *)date
{
    //获得的string time是否有重复;
    for (NSString * str in array) {
        if ([str isEqualToString:date])
            return YES;
    }
    return NO;
}

#pragma mark Local
- (void)localDivideAssettByDayTimeWithAssetArray:(NSMutableArray *)assetsArray exportToassestionArray:(NSMutableArray *)assetsSection assetSectionisShow:(NSMutableArray *)assetSectionisShow dataScource:(NSMutableArray *)dataSourceArray
{
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < assetsArray.count; i++) {
        ALAsset * asset = [assetsArray objectAtIndex:i];
        NSDate * date = [asset valueForProperty:ALAssetPropertyDate];
        NSString * dateString = [self stringFromdate:date];
        if (![self array:assetsSection hasTimeString:dateString]){
            [assetsSection addObject:dateString];
            NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
            [array addObject:asset];
            [tempArray addObject:array];
            [assetSectionisShow addObject:[NSNumber numberWithBool:YES]];
        }else{
            NSMutableArray * array = [tempArray objectAtIndex:[assetsSection indexOfObject:dateString]];
            [array addObject:asset];
        }
    }
    for (NSMutableArray * array in tempArray )
        [dataSourceArray addObject:[self coverAssertToDataSource:array]];
}

- (NSMutableArray *)coverAssertToDataSource:(NSMutableArray *)array
{
    NSMutableArray * finalArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i+=4) {
        PhotoesCellDataSource * source = [[PhotoesCellDataSource alloc] init];
        source.firstAsset = [array objectAtIndex:i];
        if (i + 3 < array.count) {
            source.secoundAsset = [array objectAtIndex:i+1];
            source.thridAsset = [array objectAtIndex:i+2];
            source.lastAsset = [array objectAtIndex:i+3];
        }else if (i + 2 < array.count){
            source.secoundAsset = [array objectAtIndex:i+1];
            source.thridAsset = [array objectAtIndex:i+2];
            source.lastAsset = nil;
        }else if (i + 1 < array.count){
            source.secoundAsset = [array objectAtIndex:i+1];
            source.lastAsset = nil;
            source.thridAsset = nil;
        }
        [finalArray addObject:source];
    }
    return finalArray;
}

#pragma mark Srot
- (NSMutableArray *)sortArrayByTime:(NSMutableArray *)array
{
    return [[array sortedArrayUsingFunction:sort context:nil] mutableCopy];
}
NSInteger sort( ALAsset *asset1,ALAsset *asset2,void *context)
{
    //日期由近到远排序
    double key1 = [[asset1 valueForProperty:ALAssetPropertyDate] timeIntervalSinceReferenceDate];
    double key2 = [[asset2 valueForProperty:ALAssetPropertyDate] timeIntervalSinceReferenceDate];
    if (key1 < key2 ) {
        //key1大于key2
        return NSOrderedDescending;
    }else if (key1 == key2) {
        //相同
        return NSOrderedSame;
    }else {
        return NSOrderedAscending;
    }
}
#pragma mark SectionView
- (UIView *)getSectionView:(NSInteger)section withImageCount:(NSInteger)count ByisShow:(BOOL)isShowRow WithTimeText:(NSString *)labelText
{
    if (section == -1) return nil;
    UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 28)];
    [view setUserInteractionEnabled:YES];
    UITapGestureRecognizer * tap  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapInSection:)];
    [view addGestureRecognizer:tap];
    view.tag = section;
    
    UIImageView * iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 3, 22, 22)];
    [view addSubview:iconImage];
    //label
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, 100, 24)];
    label.font = [UIFont boldSystemFontOfSize:12.f];
    label.backgroundColor = [UIColor clearColor];
    label.text = labelText;
    [view addSubview:label];
    UILabel * countLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 2, 55, 24)];
    countLabel.font = [UIFont boldSystemFontOfSize:12.f];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.textAlignment = UITextAlignmentRight;
    countLabel.text = [NSString stringWithFormat:@"%d",count];
    [view addSubview:countLabel];
    
    if (isShowRow) {
        label.textColor = [UIColor colorWithRed:189.f/255 green:189.f/255 blue:189.f/255 alpha:1.f];
        countLabel.textColor  =[UIColor colorWithRed:189.f/255 green:189.f/255 blue:189.f/255 alpha:1.f];
        iconImage.image = [UIImage imageNamed:@"sectionIcon.png"];
        view.image = [UIImage imageNamed:@"section.png"];
    }else{
        label.textColor = [UIColor colorWithRed:100.f/255 green:100.f/255 blue:100.f/255 alpha:1.f];
        countLabel.textColor = [UIColor colorWithRed:100.f/255 green:100.f/255 blue:100.f/255 alpha:1.f];
        iconImage.image = [UIImage imageNamed:@"sectionIconNo.png"];
        view.image = [UIImage imageNamed:@"sectionNo.png"];
    }
    return view;
}
@end

@implementation UIViewController(Private)
- (void)showLoginViewWithMethodNav:(BOOL)isNav
{
    LoginViewController * loginView = [[LoginViewController alloc] init];
    loginView.delegate = (UIViewController<LoginViewControllerDelegate> *)self;
    if (isNav) {
        [self.navigationController pushViewController:loginView animated:YES];
    }else{
        [self presentModalViewController:loginView animated:YES];
    }
}
- (void)showBingViewWithShareModel:(KShareModel)model delegate:(id<OAuthorControllerDelegate>)Adelegete andShowWithNav:(BOOL)isNav
{
    OAuthorController * ouatuor = [[OAuthorController alloc] initWithMode:model ViewModel:BingModelView];
    ouatuor.delegate = Adelegete;
    if (isNav) {
        [self.navigationController pushViewController:ouatuor animated:YES];
        
    }else{
        [self presentModalViewController:[[UINavigationController alloc] initWithRootViewController:ouatuor] animated:YES];
    }
}
#pragma alertView
- (MBProgressHUD *)waitForMomentsWithTitle:(NSString*)str withView:(UIView *)view
{
    
    MBProgressHUD * progressView = [[MBProgressHUD alloc] initWithView:self.view];
    progressView.animationType = MBProgressHUDAnimationZoomOut;
    progressView.labelText = str;
    [self.view addSubview:progressView];
    [progressView show:YES];
    return progressView;
    
}
-(void)stopWaitProgressView:(MBProgressHUD *)view
{
    if (view)
        [view removeFromSuperview];
    else
        for (UIView * view in self.view.subviews) {
            if ([view isKindOfClass:[MBProgressHUD class]]) {
                [view removeFromSuperview];
            }
        }
}
@end

@implementation UIViewController(writeImage)

- (void)writePicToAlbumWith:(NSString *)imageStr
{
    [self waitForMomentsWithTitle:@"保存到本地..." withView:self.view];
    UIImageView * view = [[UIImageView alloc] init];
    [view setImageWithURL:[NSURL URLWithString:imageStr] success:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        });
    } failure:^(NSError *error) {
        [self stopWaitProgressView:nil];
        [self showPopAlerViewRatherThentasView:NO WithMes:[NSString stringWithFormat:@"%@",@"保存失败"]];
    }];
}
- (void)image: (UIImage *) image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo
{
    [self stopWaitProgressView:nil];
    if (error) {
        [self showPopAlerViewRatherThentasView:NO WithMes:[NSString stringWithFormat:@"%@",error]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:WRITEIMAGE object:nil];
        [self showPopAlerViewRatherThentasView:NO WithMes:@"图片已保存到本地"];
    }
}
@end

@implementation UIViewController(libiary)
- (ALAssetsLibrary *)libiary
{
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] assetsLibrary];
}
@end

@implementation UIViewController(isMine)
- (BOOL)isMineWithOwnerId:(NSString *)ownerID
{
    return [LoginStateManager isLogin] && [[LoginStateManager currentUserId] isEqualToString:ownerID];
}
@end

@implementation UIViewController(share)
- (AppDelegate *)Appdelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)shareNewsToWeixinWithUrl:(NSString *)url ToSence:(enum WXScene)scene Title:(NSString *)title photoUrl:(NSString *)photoUrl des:(NSString *)des
{
    //发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = des;
    if (photoUrl) {
        [message setThumbData:[self getImgaeDateWithUrl:photoUrl]];
    }else{
        [message setThumbImage:[UIImage imageNamed:@"Icon.png"]];
    }
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    message.mediaObject = ext;
    SendMessageToWXReq* req =[[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

- (NSData *)getImgaeDateWithUrl:(NSString *)string
{
    NSString * photoUrl = [NSString stringWithFormat:@"%@_c90",string];
    return [NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl]];
}
- (void)shareImageToWeixinWithUrl:(NSString *)imageURL ToSence:(enum WXScene)scene
{
    //发送内容给微信
    WXMediaMessage * message = [WXMediaMessage message];
    UIImage  * tuumbail = [UIImage imageWithData:[self getImgaeDateWithUrl:imageURL]];
    [message setThumbImage:tuumbail];
    WXImageObject *ext = [WXImageObject object];
    SDImageCache * imageCache  = [[SDImageCache alloc] init];
    UIImage * image = [imageCache imageFromKey:[NSString stringWithFormat:@"%@_w640",imageURL]];
    if (image) {
        ext.imageData = UIImageJPEGRepresentation(image, 0.5);
    }else{
        ext.imageUrl = imageURL;
    }
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}
@end

@implementation UIViewController(Login)
- (void)handleInfoWithshareModel:(KShareModel)shareModel infoDic:(NSDictionary *)dic
{
    NSDictionary * third_dic = [NSDictionary dictionaryWithObject:[dic objectForKey:@"third_access_token"] forKey:@"access_token"];
    switch (shareModel) {
        case QQShare:
            [LoginStateManager storeQQTokenInfo:third_dic];
            break;
        case SinaWeiboShare:
            [LoginStateManager storeSinaTokenInfo:third_dic];
            break;
        case RenrenShare:
            [LoginStateManager storeRenRenTokenInfo:third_dic];;
            break;
        default:
            break;
    }
}

@end