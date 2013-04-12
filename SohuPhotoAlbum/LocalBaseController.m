//
//  BaseViewController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "LocalBaseController.h"
#import "AppDelegate.h"
//#import "BaseNaviController.h"
@interface LocalBaseController ()

@end

@implementation LocalBaseController
@synthesize viewState = _viewState;
@synthesize myTableView = _myTableView;

- (id)init
{
    self = [super init];
    if (self) {
        _viewState = NomalState;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
}
- (void)viewDidDisappear:(BOOL)animated
{
    if (_cusBar.superview){
        [UIView animateWithDuration:0.0 animations:^{
            [_cusBar removeFromSuperview];
        }];
    }
}
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button
{
    //for reload
}
- (CGRect)subTableViewRect
{
//    NSLog(@"subTableViewRect:%@",NSStringFromCGRect(self.view.frame));
    CGRect rect = self.view.bounds;
    rect.size.height -= 44;
    return rect;
}

#pragma mark - Uplaod
- (BOOL)canUpload
{
    return _selectedArray.count;
}
- (void)uploadPicTureWithArray:(NSMutableArray *)assetArray
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (ALAsset * asset in assetArray) {
        TaskUnit * unit = [[TaskUnit alloc] init];
        unit.asset = asset;
        unit.description = nil;
        [array addObject:unit];
        [unit release];
    }
    [self showPopAlerViewnotTotasView:NO WithMes:@"图片已在后台上传"];
    AlbumTaskList * album = [[[AlbumTaskList alloc] initWithTaskList:array album_id:@"once"] autorelease];
    [[UploadTaskManager currentManager] addTaskList:album];
}
#pragma mark ShowAlert
- (void)showPopAlerViewnotTotasView:(BOOL)isPopView WithMes:(NSString *)mesage
{
    if (isPopView) {
        PopAlertView * popA = [[[PopAlertView alloc] initWithTitle:mesage message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil] autorelease];
        [popA show];
    }else{
        ToastAlertView * alertView = [[[ToastAlertView alloc] initWithTitle:mesage] autorelease];
        [alertView show];
    }
}
@end
