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
#import "RequestManager.h"

@implementation CloundDetailController

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
        NSString * photoId = [NSString stringWithFormat:@"%@",[[self.assetsArray objectAtIndex:self.curPageNum] objectForKey:@"id"]];
        [RequestManager deletePhotosWithaccessToken:[LoginStateManager currentToken] photoIds:[NSArray arrayWithObject:photoId]success:^(NSString *response) {
            [self.assetsArray removeObject:[self.assetsArray objectAtIndex:self.curPageNum]];
            [self refreshScrollView];
            [self showPopAlerViewRatherThentasView:NO WithMes:@"删除成功"];
        } failure:^(NSString *error) {
            [self showPopAlerViewRatherThentasView:NO WithMes:@"删除失败"];
        }];
    }
    if (button.tag == TABBARSHARETAG){        //分享图片
        [self showShareView];
    }
    if (button.tag == TABBARLOADPIC){        //下载图片
        [self writePicToAlbumWith:[self.assetsArray objectAtIndex:self.curPageNum]];
    }
    
}
- (void)writePicToAlbumWith:(NSDictionary *)dic
{
    UIImageView * view = [[UIImageView alloc] init];
    NSString * strUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"photo_url"]];
    [view setImageWithURL:[NSURL URLWithString:strUrl] success:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        });
    } failure:^(NSError *error) {
        [self showPopAlerViewRatherThentasView:NO WithMes:[NSString stringWithFormat:@"%@",error]];
    }];
}
- (void)image: (UIImage *) image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo
{
    if (error) {
        [self showPopAlerViewRatherThentasView:NO WithMes:[NSString stringWithFormat:@"%@",error]];
    }else{
        [self showPopAlerViewRatherThentasView:NO WithMes:@"图片已保存到本地"];
    }
}
- (void)showShareView
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"人人网",@"微信发送",@"腾讯QQ空间", nil];
    [sheet showInView:self.view];
    sheet.tag = 100;
}
#pragma mark - ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self upPicture:buttonIndex];
}
- (void)upPicture:(shareModel)model
{
    switch (model) {
        case SinaWeiboShare:
            
            break;
        case RenrenShare:
            
            break;
        case QQShare:
            
            break;
        
        default:
            break;
    }
}

#pragma mark overLoad
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
    NSString * strUrl = [NSString stringWithFormat:@"%@_w640",[asset objectForKey:@"photo_url"]];
    [scaleView.imageView setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"1.jpg"] options:SDWebImageRetryFailed];
}

#pragma mark - GetActualImage
- (void)setImageView:(ImageScaleView *)scaleView ActualImage:(id)asset andOrientation:(UIImageOrientation)orientation
{
    
}
#pragma mark GetMoreAssets
- (void)getMoreAssets
{
//    [RequestManager getTimePhtotWithAccessToken:[LoginStateManager currentToken] beforeTime:[[[self.assetsArray lastObject] objectForKey:@"taken_id"] longLongValue] count:100 success:^(NSString *response) {
//        NSArray * photoArray = [[response JSONValue] objectForKey:@"photos"];
//        if (!photoArray || !photoArray.count) _hasMoreAssets = NO;
//        [self.assetsArray addObjectsFromArray:photoArray];
//        [self refreshScrollView];
//    } failure:^(NSString *error) {
//        [self showPopAlerViewRatherThentasView:NO WithMes:error];
//    }];
}
@end
