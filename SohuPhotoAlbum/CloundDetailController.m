//
//  CloundDetailController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

//height = 960;
//id = 94580671967932416;
//"multi_frames" = 0;
//"photo_url" = "http://img.itc.cn/ph0/ogIYYoPUQVd";
//"taken_at" = 1366872495000;
//"taken_id" = 5733078775651119104;
//"upload_at" = 1366872495000;
//width = 640;

#import "CloundDetailController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

#import "RequestManager.h"
#import "AppDelegate.h"

@implementation CloundDetailController
@synthesize sectionArray;
@synthesize leftBoundsDays,rightBoudsDays;

- (id)initWithAssetsArray:(NSArray *)array andCurAsset:(NSDictionary *)asset
{
    self = [super init];
    if (self) {
        self.assetsArray = [NSMutableArray arrayWithArray:array];
        self.curPageNum = [array indexOfObject:asset];
        self.wantsFullScreenLayout = YES;
        _curImageArray = [NSMutableArray arrayWithCapacity:0];
        _isHidingBar = NO;
        _isInit = YES;
        _isRotating = NO;
        _hasMoreAssets = YES;
        _hasLessAssets = YES;
    }
    return self;
}
- (void)cusTabBar:(CustomizetionTabBar *)bar buttonClick:(UIButton *)button
{
    if (button.tag == TABBARCANCEL){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (button.tag == TABBARDELETE) {
        [self showDeletePhotoesView];
    }
    if (button.tag == TABBARSHARETAG){        //分享图片
        if (!_shareBox){
            _shareBox = [[ShareBox alloc] init];
            _shareBox.delegate = self;
        }
        [_shareBox showShareViewWithWeixinShow:YES photoWall:YES andWriteImage:NO OnView:self.view];
    }
    if (button.tag == TABBARLOADPIC){        //下载图片
        NSString * strUrl = [NSString stringWithFormat:@"%@",[[self.assetsArray objectAtIndex:self.curPageNum] objectForKey:@"photo_url"]];
        [self writePicToAlbumWith:strUrl];
    }
}
#pragma mark  Delete
- (void)showDeletePhotoesView
{
    PopAlertView * alertView = [[PopAlertView alloc] initWithTitle:nil message:@"确认删除图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
    [alertView show];
    return;
}

- (void)popAlertView:(PopAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    if (buttonIndex == 1) {
        NSString * photoId = [NSString stringWithFormat:@"%@",[[self.assetsArray objectAtIndex:self.curPageNum] objectForKey:@"id"]];
        [RequestManager deletePhotosWithaccessToken:[LoginStateManager currentToken] photoIds:[NSArray arrayWithObject:photoId]success:^(NSString *response) {
            [self.assetsArray removeObject:[self.assetsArray objectAtIndex:self.curPageNum]];
            [self refreshScrollView];
            [self showPopAlerViewRatherThentasView:NO WithMes:@"删除成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:DELETEPHOTO object:nil];
        } failure:^(NSString *error) {
            [self showPopAlerViewRatherThentasView:NO WithMes:@"删除失败"];
        }];
    }
}
#pragma mark - Share
- (void)shareBoxViewWeiXinShareToScene:(enum WXScene)scene
{
    [self respImageContentToSence:scene];
}
- (void)shareBoxViewShareTo:(KShareModel)model
{
    //三方分享
    self.isPushView = YES;
    [self.navigationController pushViewController:[[ShareViewController alloc] initWithModel:model bgPhotoUrl:[[self.assetsArray objectAtIndex:self.curPageNum] objectForKey:@"photo_url"] andDelegate:self] animated:YES];
}
- (void)shareViewcontrollerDidShareClick:(ShareViewController *)controller withDes:(NSString *)des shareMode:(KShareModel)model
{
    NSString * phtotId = [NSString stringWithFormat:@"%@",[[self.assetsArray objectAtIndex:self.curPageNum] objectForKey:@"id"]];
    [RequestManager sharePhotosWithAccesstoken:[LoginStateManager currentToken]  photoIDs:[NSArray arrayWithObject:phtotId] share_to:model shareAccestoken:nil  optionalTitle:nil desc:des success:^(NSString *response) {
        [self showPopAlerViewRatherThentasView:NO WithMes:@"分享成功"];
    } failure:^(NSString *error) {
        [self showPopAlerViewRatherThentasView:NO WithMes:error];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Weixin
- (void)onResp:(BaseResp *)resp
{
    if (resp.errCode == 0) {
        [self showPopAlerViewRatherThentasView:NO WithMes:@"发送成功"];
    }else{
        [self showPopAlerViewRatherThentasView:NO WithMes:@"发送失败"];
    }
}
- (void) respImageContentToSence:(enum WXScene)scene
{
    //发送内容给微信
    NSDictionary * info = [self.assetsArray objectAtIndex:self.curPageNum];
    NSString * thumbUrl = [NSString stringWithFormat:@"%@_c100",[info objectForKey:@"photo_url"]];
    WXMediaMessage * message = [WXMediaMessage message];
    UIImage  * tuumbail = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbUrl]]];
    [message setThumbImage:tuumbail];
    
    WXImageObject *ext = [WXImageObject object];
    NSString * photoUrl = [info objectForKey:@"photo_url"];
    if (!imageCache)
        imageCache  = [[SDImageCache alloc] init];
    UIImage * image = [imageCache imageFromKey:[NSString stringWithFormat:@"%@_w640",photoUrl]];
    if (image) {
        ext.imageData = UIImageJPEGRepresentation(image, 0.5);
    }else{
        ext.imageUrl = photoUrl;
    }
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}

#pragma mark OverLoad
#pragma mark - GetIdentifyImageSizeWithImageView
- (CGSize)getIdentifyImageSizeWithImageView:(ImageScaleView *)scaleView isPortraitorientation:(BOOL)isPortrait
{
    NSDictionary * dic = [scaleView asset];
    if (!dic) return CGSizeZero;
    CGFloat w = [[dic objectForKey:@"width"] floatValue];
    CGFloat h = [[dic objectForKey:@"height"] floatValue];
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
    [scaleView.imageView startLoading];
    __weak ImageScaleView * weakImage = scaleView;
    NSString * strUrl = [NSString stringWithFormat:@"%@_w640",[asset objectForKey:@"photo_url"]];
    [scaleView.imageView setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:nil success:^(UIImage *image){
        [weakImage.imageView stopLoading];
    } failure:^(NSError *error) {
        [weakImage.imageView stopLoading];
    }];
}

#pragma mark - GetActualImage
- (void)setImageView:(ImageScaleView *)scaleView ActualImage:(id)asset andOrientation:(UIImageOrientation)orientation
{
    
}
#pragma mark GetMoreAssets
- (void)getMoreAssetsAfterCurNum
{
    if (!_hasMoreAssets) return;
    NSString * lefttime = [self getRithtTime];
    self.isLoading = YES;
    
    if (lefttime) {
        [RequestManager getTimePhtotWithAccessToken:[LoginStateManager currentToken] day:lefttime success:^(NSString *response) {
            NSArray * array = [[response JSONValue] objectForKey:@"photos"];
            if (array && array.count) {
                [self.assetsArray addObjectsFromArray:array];
                self.isLoading = NO;
            }else{
                self.isLoading = NO;
                _hasMoreAssets = NO;
            }
        } failure:^(NSString *error) {
            self.isLoading = NO;
        }];
    }else{
        NSString * time = [[self.sectionArray lastObject] objectForKey:@"day"];
        [RequestManager getTimeStructWithAccessToken:[LoginStateManager currentToken] withtime:time success:^(NSString *response) {
            NSArray * array = [[response JSONValue] objectForKey:@"days"];
            if (array && array.count) {
                [self.sectionArray addObjectsFromArray:array];
                self.isLoading = NO;
            }else{
                self.isLoading = NO;
                _hasLessAssets = NO;
            }
        } failure:^(NSString *error) {
            self.isLoading = NO;
        }];
    }

}
- (void)getMoreAssetsBeforeCurNum
{
    if (!_hasLessAssets) return;
    NSString * lefttime = [self getleftTime];
    if (lefttime) {
        self.isLoading = YES;
        [RequestManager getTimePhtotWithAccessToken:[LoginStateManager currentToken] day:lefttime success:^(NSString *response) {
            NSArray * array = [[response JSONValue] objectForKey:@"photos"];
            if (array && array.count) {
                NSMutableArray * tempArray = [NSMutableArray arrayWithArray:array];
                [tempArray addObjectsFromArray:self.assetsArray];
                self.assetsArray = tempArray;
                self.curPageNum += array.count;
                self.isLoading = NO;
            }else{
                self.isLoading = NO;
                _hasMoreAssets = NO;
            }
        } failure:^(NSString *error) {
            self.isLoading = NO;
        }];
    }else{
        //左边没有section
        _hasLessAssets = NO;
    }
}
- (NSString *)getleftTime
{
    if (leftBoundsDays > 0) {
        NSDictionary * dic = [self.sectionArray objectAtIndex:leftBoundsDays - 1];
        leftBoundsDays--;
        return [dic objectForKey:@"day"];
    }
   return nil;
}
- (NSString *)getRithtTime
{
    if (rightBoudsDays < self.sectionArray.count - 1) {
        NSDictionary * dic = [self.sectionArray objectAtIndex:rightBoudsDays + 1];
        rightBoudsDays++;
        return [dic objectForKey:@"day"];
    }
    return nil;
}
@end
