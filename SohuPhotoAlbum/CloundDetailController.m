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
@synthesize assetDictionaary,sectionArray;
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
        NSString * strUrl = [NSString stringWithFormat:@"%@",[[self.assetsArray objectAtIndex:self.curPageNum] objectForKey:@"photo_url"]];
        [self writePicToAlbumWith:strUrl];
    }
    
}
- (void)showShareView
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"人人网",@"腾讯QQ空间", nil];
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
    NSString * lefttime = [self getleftTime];
    if (lefttime) {
        [RequestManager getTimePhtotWithAccessToken:[LoginStateManager currentToken] day:lefttime success:^(NSString *response) {
            NSArray * array = [[response JSONValue] objectForKey:@"photos"];
            if (array && array.count) {
                NSMutableArray * finalArray = [NSMutableArray arrayWithArray:array];
                [finalArray addObjectsFromArray:self.assetsArray];
                self.curPageNum += array.count;
                self.assetsArray = finalArray;
            }
        } failure:^(NSString *error) {
            
        }];
    }
}
- (void)getMoreAssetsBeforeCurNum
{
    NSString * lefttime = [self getleftTime];
    if (lefttime) {
        [RequestManager getTimePhtotWithAccessToken:[LoginStateManager currentToken] day:lefttime success:^(NSString *response) {
            NSArray * array = [[response JSONValue] objectForKey:@"photos"];
            if (array && array.count) {
                [self.assetsArray addObjectsFromArray:array];
            }
        } failure:^(NSString *error) {
            
        }];
    }else{
        NSString * time = [[self.sectionArray lastObject] objectForKey:@"day"];
        [RequestManager getTimeStructWithAccessToken:[LoginStateManager currentToken] withtime:time success:^(NSString *response) {
            NSArray * array = [[response JSONValue] objectForKey:@"days"];
            if (array && array.count) {
                [self.sectionArray addObjectsFromArray:array];
            }
        } failure:^(NSString *error) {
        }];
    }
}
- (NSString *)getleftTime
{
    if (leftBoundsDays > 0) {
        NSDictionary * dic = [self.sectionArray objectAtIndex:leftBoundsDays - 1];
        return [dic objectForKey:@"day"];
    }
   return nil;
}
- (NSString *)getRithtTime
{
    if (rightBoudsDays < self.sectionArray.count - 1) {
        NSDictionary * dic = [self.sectionArray objectAtIndex:rightBoudsDays + 1];
        return [dic objectForKey:@"day"];
    }
    return nil;
}
@end
