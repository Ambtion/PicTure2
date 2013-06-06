//
//  PhotoesViewController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "AlbumPhotoesController.h"
#import "LocalDetailController.h"

#define SLABELTEXT @"请选择照片"

@interface AlbumPhotoesController ()

@property(nonatomic,strong)NSMutableArray * assetsArray;
@property(nonatomic,strong)NSMutableArray * dataSourceArray;
@end

@implementation AlbumPhotoesController
@synthesize assetGroup = _assetGroup;
@synthesize assetsArray = _assetsArray;
@synthesize dataSourceArray = _dataSourceArray;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithAssetGroup:(ALAssetsGroup *)AnAssetGroup andViewState:(viewState)state 
{
    if (self = [super init]) {
        self.assetGroup = AnAssetGroup;
        selectedArray = [[NSMutableArray alloc] initWithCapacity:0];
        _viewState = state;
        
        if (state == UPloadState) {
            _isInitUpload = YES;
        }else{
            _isInitUpload = NO;
        }
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = LOCALBACKGORUNDCOLOR;
    self.myTableView = [[UITableView alloc] initWithFrame:[self subTableViewRect] style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorColor = [UIColor clearColor];
    self.myTableView.backgroundColor = [UIColor clearColor];
    [self.myTableView setScrollsToTop:YES];
    [self.view addSubview:self.myTableView];
    [self readPhotoAssetes];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumDidwriteImage:) name:WRITEIMAGE object:nil];
}

#pragma mark - NavigationBar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationItem setHidesBackButton:YES animated:NO];
    if (!_cusBar){
        
        _cusBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [_cusBar.nLabelText setText:[NSString stringWithFormat:@"%@",[self.assetGroup valueForProperty:ALAssetsGroupPropertyName]]];
        [_cusBar.nRightButton1 setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
        [_cusBar.nRightButton1 setButtoUploadState:YES];
        [_cusBar.nRightButton2 setUserInteractionEnabled:NO];
        [_cusBar.nRightButton2 setUserInteractionEnabled:NO];
        
        if (_viewState == UPloadState) {
            [_cusBar.sLabelText setText:SLABELTEXT];
            [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"cancal.png"] forState:UIControlStateNormal];
            [_cusBar.sRightStateButton setImage:[UIImage imageNamed:@"ensure.png"] forState:UIControlStateNormal];
        }else{
            [_cusBar.sLabelText setText:[NSString stringWithFormat:@"%@",[self.assetGroup valueForProperty:ALAssetsGroupPropertyName]]];
            [_cusBar.sRightStateButton setImage:[UIImage imageNamed:@"ensure.png"] forState:UIControlStateNormal];
        }
        [_cusBar switchBarStateToUpload:_viewState == UPloadState];
    }
    if (!_cusBar.superview)
        [self.navigationController.navigationBar addSubview:_cusBar];
    if (needReadonce) {
        [self readPhotoAssetes];
        needReadonce = NO;
    }
}

#pragma mark ReadData
- (void)albumDidwriteImage:(NSNotification *)notification
{
    needReadonce = YES;
}
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self readPhotoAssetes];
}
- (void)readPhotoAssetes
{
    if (_isReading) return;
    _isReading = YES;
  
    self.assetsArray = [NSMutableArray arrayWithCapacity:0];
    [[self libiary] readPhotoIntoAssetsContainer:self.assetsArray fromGroup:self.assetGroup sucess:^{
        self.assetsArray = [self revertObjectArray:self.assetsArray];
        [self prepareDataWithTimeOrder];
    }];
}
- (void)prepareDataWithTimeOrder
{
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.assetsArray.count; i+=4) {
        PhotoesCellDataSource * source = [[PhotoesCellDataSource alloc] init];
        source.firstAsset = [self.assetsArray objectAtIndex:i];
        if (i + 1 < self.assetsArray.count)
            source.secoundAsset = [self.assetsArray objectAtIndex:i+1];
        if (i + 2 < self.assetsArray.count)
            source.thridAsset = [self.assetsArray objectAtIndex:i+2];
        if (i + 3 < self.assetsArray.count)
            source.lastAsset = [self.assetsArray objectAtIndex:i+3];
        [self.dataSourceArray addObject:source];
    }
    [self.myTableView reloadData];
    _isReading = NO;
}
- (NSMutableArray *)revertObjectArray:(NSMutableArray *)array
{
    NSMutableArray * finalArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = array.count - 1; i >= 0; i--)
        [finalArray addObject:[array objectAtIndex:i]];
    return finalArray;
}

#pragma mark - tableDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = LOCALBACKGORUNDCOLOR;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataSourceArray.count - 1) {
        return [PhotoesCellDataSource cellLastHigth];
    }
    return [PhotoesCellDataSource cellHigth];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"photoCELLId";
    PhotoesCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[PhotoesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.delegate = self;
    }
    if (indexPath.row < self.dataSourceArray.count)
        cell.dataSource = [[self dataSourceArray] objectAtIndex:indexPath.row];
    if (_viewState != NomalState){
        [cell showCellSelectedStatus];
        [cell isShow:[selectedArray containsObject:cell.dataSource.firstAsset] SelectedAsset:cell.dataSource.firstAsset];
        [cell isShow:[selectedArray containsObject:cell.dataSource.secoundAsset] SelectedAsset:cell.dataSource.secoundAsset];
        [cell isShow:[selectedArray containsObject:cell.dataSource.thridAsset] SelectedAsset:cell.dataSource.thridAsset];
        [cell isShow:[selectedArray containsObject:cell.dataSource.lastAsset] SelectedAsset:cell.dataSource.lastAsset];
    }else{
        [cell hiddenCellSelectedStatus];
    }
    return cell;
}
#pragma mark - NavigationBarDelegate
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload
{
    if (isupload) {
        UPLoadController * uploadView = [[UPLoadController alloc] init];
        uploadView.delegate  = self;
        [self.navigationController pushViewController:uploadView animated:YES];
        return;
    }
    if (button.tag == LEFTBUTTON) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (button.tag == RIGHT1BUTTON) { //上传
        if (![LoginStateManager isLogin]) {
            [self showLoginViewWithMethodNav:YES];
            return;
        }
        [self setViewState:UPloadState];

//        if ([LoginStateManager isLogin]) {
//        }else{
//            [self setViewState:UPloadState];
//            //不会出现;
//            [self showLoginViewWithMethodNav:YES];
//        }
    }
    if (button.tag == CANCELBUTTONTAG) {
        if (_isInitUpload) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [self setViewState:NomalState];
    }
    
    if (button.tag == RIGHTSELECTEDTAG) {
        if ([self canUpload]) {
            [self uploadPicTureWithArray:selectedArray];
            if (_isInitUpload) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self setViewState:NomalState];
            }
        }else{
            [self showPopAlerViewRatherThentasView:YES WithMes:@"请选择上传图片"];
        }
    }
}

#pragma mark photoClick
- (void)photoesCell:(PhotoesCell *)cell clickAsset:(ALAsset *)asset
{
    LocalDetailController * ph = [[LocalDetailController alloc] initWithAssetsArray:self.assetsArray andCurAsset:asset andAssetGroup:self.assetGroup];
    [self.navigationController pushViewController:ph animated:YES];
}
- (void)photoesCell:(PhotoesCell *)cell clickAsset:(ALAsset *)asset Select:(BOOL)isSelected
{
    
    if (isSelected) {
        [selectedArray addObject:asset];
    }else if([selectedArray containsObject:asset]){
        [selectedArray removeObject:asset];
    }
    if (selectedArray.count) {
        [_cusBar.sLabelText setText:[NSString stringWithFormat:@"已选择%d张照片",selectedArray.count]];
    }else{
        [_cusBar.sLabelText setText:SLABELTEXT];
    }
}
@end
