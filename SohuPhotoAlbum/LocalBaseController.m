//
//  BaseViewController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "LocalBaseController.h"
#import "AppDelegate.h"


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
#pragma mark Life Circle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [_cusBar removeFromSuperview];
}
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload
{
    //for override
}
- (void)upLoadController:(UPLoadController *)upload didclickContinue:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self setViewState:UPloadState];
}
- (CGRect)subTableViewRect
{
    CGRect rect = self.view.bounds;
    rect.size.height -= 44;
    return rect;
}

#pragma mark - Uplaod
- (BOOL)canUpload
{
    return selectedArray.count;
}

- (void)uploadPicTureWithArray:(NSMutableArray *)assetArray
{
    [[UploadTaskManager currentManager] uploadPicTureWithArray:assetArray];
}

#pragma mark SetViewState
- (void)setViewState:(viewState)viewState
{
    if (viewState == _viewState) return;
    _viewState = viewState;
    [_cusBar switchBarStateToUpload:_viewState != NomalState];
    if (_viewState != NomalState) {
        self.viewDeckController.panningMode = IIViewDeckNoPanning;
    }else{
        self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    }
    if (selectedArray.count)
        [selectedArray removeAllObjects];
    [self.myTableView reloadData];
}

@end
