//
//  PhotoesViewController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "AlbumPhotoesController.h"
#import "PhotoDetailController.h"
#import "AppDelegate.h"
#import "LoginStateManager.h"

#define SLABELTEXT @"请选择照片"

@interface AlbumPhotoesController ()

@property(nonatomic,retain)NSMutableArray * assetsArray;
@property(nonatomic,retain)NSMutableArray * dataSourceArray;
@property(nonatomic,retain)NSMutableArray * selectedArray;
@end

@implementation AlbumPhotoesController
@synthesize assetGroup = _assetGroup;
@synthesize assetsArray = _assetsArray;
@synthesize dataSourceArray = _dataSourceArray;
@synthesize selectedArray = _selectedArray;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_assetGroup release];
    [_myTableView release];
    [_assetsArray release];
    [_dataSourceArray release];
    [_selectedArray release];
    [_libiary release];
    [super dealloc];
}
- (id)initWithAssetGroup:(ALAssetsGroup *)AnAssetGroup andViewState:(viewState)state
{
    if (self = [super init]) {
        self.assetGroup = AnAssetGroup;
        _selectedArray = [[NSMutableArray alloc] initWithCapacity:0];
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
    _myTableView = [[UITableView alloc] initWithFrame:[self subTableViewRect] style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorColor = [UIColor clearColor];
    _myTableView.backgroundColor = BACKGORUNDCOLOR;
    [_myTableView setScrollsToTop:YES];
    [self.view addSubview:_myTableView];
    [self readPhotoAssetes];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - NavigationBar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_cusBar){
        _cusBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [_cusBar.nLabelText setText:[NSString stringWithFormat:@"%@",[self.assetGroup valueForProperty:ALAssetsGroupPropertyName]]];
        
        [_cusBar.nRightButton1 setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
        [_cusBar.nRightButton2 setUserInteractionEnabled:NO];
        [_cusBar.nRightButton2 setUserInteractionEnabled:NO];

        if (_viewState == UPloadState) {
            [_cusBar.sLabelText setText:SLABELTEXT];
            [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"cancal.png"] forState:UIControlStateNormal];
            [_cusBar.sRightStateButton setImage:[UIImage imageNamed:@"YES.png"] forState:UIControlStateNormal];
        }else{
            [_cusBar.sLabelText setText:[NSString stringWithFormat:@"%@",[self.assetGroup valueForProperty:ALAssetsGroupPropertyName]]];
            [_cusBar.sRightStateButton setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];

        }
        if (_viewState == UPloadState)
            [_cusBar switchBarState];
    }
    if (!_cusBar.superview)
        [self.navigationController.navigationBar addSubview:_cusBar];
    [self.navigationItem setHidesBackButton:YES animated:NO];
}
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self readPhotoAssetes];
}
- (void)readPhotoAssetes
{
    if (_isReading) return;
    _isReading = YES;
    if (!_libiary)
        _libiary = [[ALAssetsLibrary alloc] init];
    
    self.assetsArray = [NSMutableArray arrayWithCapacity:0];
    [_libiary readPhotoIntoAssetsContainer:self.assetsArray fromGroup:self.assetGroup sucess:^{
        self.assetsArray = [self revertObjectArray:self.assetsArray];
        [self prepareDataWithTimeOrder];
    }];
}
- (void)prepareDataWithTimeOrder
{
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.assetsArray.count; i+=4) {
        PhotoesCellDataSource * source = [[[PhotoesCellDataSource alloc] init] autorelease];
        source.firstAsset = [self.assetsArray objectAtIndex:i];
        if (i + 1 < self.assetsArray.count)
            source.secoundAsset = [self.assetsArray objectAtIndex:i+1];
        if (i + 2 < self.assetsArray.count)
            source.thridAsset = [self.assetsArray objectAtIndex:i+2];
        if (i + 3 < self.assetsArray.count)
            source.lastAsset = [self.assetsArray objectAtIndex:i+3];
        [self.dataSourceArray addObject:source];
    }
    [_myTableView reloadData];
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
    cell.backgroundColor = BACKGORUNDCOLOR;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoesCellDataSource * source = [self.dataSourceArray objectAtIndex:indexPath.row];
    if (indexPath.row == self.dataSourceArray.count - 1) {
        return [source cellLastHigth];
    }
    return [source cellHigth];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"photoCELLId";
    PhotoesCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[PhotoesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.delegate = self;
    }
    if (indexPath.row < self.dataSourceArray.count)
        cell.dataSource = [[self dataSourceArray] objectAtIndex:indexPath.row];
    if (_viewState != NomalState){
        [cell showCellSelectedStatus];
        [cell isShow:[self.selectedArray containsObject:cell.dataSource.firstAsset] SelectedAsset:cell.dataSource.firstAsset];
        [cell isShow:[self.selectedArray containsObject:cell.dataSource.secoundAsset] SelectedAsset:cell.dataSource.secoundAsset];
        [cell isShow:[self.selectedArray containsObject:cell.dataSource.thridAsset] SelectedAsset:cell.dataSource.thridAsset];
        [cell isShow:[self.selectedArray containsObject:cell.dataSource.lastAsset] SelectedAsset:cell.dataSource.lastAsset];
    }else{
        [cell hiddenCellSelectedStatus];
    }
    return cell;
}

#pragma mark - NavigationBarDelegate
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button
{
    if (button.tag == LEFTBUTTON) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (button.tag == RIGHT1BUTTON) { //上传
        if ([LoginStateManager isLogin]) {
            [_cusBar switchBarState];
            _viewState = UPloadState;
            [_myTableView reloadData];
        }else{
            
            [self.navigationController pushViewController:[[[LoginViewController alloc] init] autorelease] animated:YES];
        }
    }
    if (button.tag == CANCELBUTTONTAG) {
        if (_isInitUpload) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [_cusBar switchBarState];
        [self.selectedArray removeAllObjects];
        _viewState = NomalState;
        [_myTableView reloadData];
    }
    if (button.tag == ALLSELECTEDTAG) {
        if (self.selectedArray.count != self.assetsArray.count ){
            [self.selectedArray removeAllObjects];
            [self.selectedArray addObjectsFromArray:self.assetsArray];
        }else{
            [self.selectedArray removeAllObjects];
        }
        [_myTableView reloadData];
    }
}

#pragma mark photoClick
- (void)photoesCell:(PhotoesCell *)cell clickAsset:(ALAsset *)asset
{
    PhotoDetailController * ph = [[[PhotoDetailController alloc] initWithAssetsArray:self.assetsArray andCurAsset:asset andAssetGroup:self.assetGroup] autorelease];
    [self.navigationController pushViewController:ph animated:YES];
}
- (void)photoesCell:(PhotoesCell *)cell clickAsset:(ALAsset *)asset Select:(BOOL)isSelected
{
    
    if (isSelected) {
        [self.selectedArray addObject:asset];
    }else if([self.selectedArray containsObject:asset]){
        [self.selectedArray removeObject:asset];
    }
    if (self.selectedArray.count) {
        [_cusBar.sLabelText setText:[NSString stringWithFormat:@"已选择%d张照片",_selectedArray.count]];
    }else{
        [_cusBar.sLabelText setText:SLABELTEXT];
    }
}
@end
