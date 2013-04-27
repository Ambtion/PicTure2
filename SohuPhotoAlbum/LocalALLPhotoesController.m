//
//  LocalPhotoseController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "LocalALLPhotoesController.h"
#import "LocalAlbumsController.h"
#import "LocalDetailController.h"

#define SLABELTEXT @"请选择照片"

@interface LocalALLPhotoesController ()
@property(nonatomic,strong)NSMutableArray *assetGroups;
@property(nonatomic,strong)NSMutableArray *assetsArray;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)NSMutableArray *assetsSection;
@property(nonatomic,strong)NSMutableArray *assetSectionisShow;
@end

@implementation LocalALLPhotoesController
@synthesize assetGroups,assetsArray,dataSourceArray,assetsSection,assetSectionisShow;
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self.view addSubview:self.myTableView];
    
    [self initDataContainer];
    [self readAlbum];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)initDataContainer
{
    selectedArray = [NSMutableArray arrayWithCapacity:0];
    assetsSection = [NSMutableArray arrayWithCapacity:0];
    assetSectionisShow = [NSMutableArray arrayWithCapacity:0];
    assetsArray  = [NSMutableArray arrayWithCapacity:0];
    dataSourceArray = [NSMutableArray arrayWithCapacity:0];
}

#pragma mark - CusNavigatinBar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_cusBar){
        _cusBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [_cusBar.nLabelImage setImage:[UIImage imageNamed:@"localAlbums.png"]];
        [_cusBar.nRightButton1 setImage:[UIImage imageNamed:@"timeline-view.png"] forState:UIControlStateNormal];
        //上传按钮
        [_cusBar.nRightButton2 setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
        [_cusBar.nRightButton2 setButtoUploadState:YES];
        
        [_cusBar.nRightButton3 setUserInteractionEnabled:NO];
        [_cusBar.sLabelText setText:SLABELTEXT];
        [_cusBar.sRightStateButton setImage:[UIImage imageNamed:@"ensure.png"] forState:UIControlStateNormal];
    }
    if (!_cusBar.superview)
        [self.navigationController.navigationBar addSubview:_cusBar];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.assetsArray.count) {
        [self autoUplaodPic];
    }
}
#pragma mark - ReadData
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self readAlbum];
}

- (void) readAlbum
{
    if (_isReading) return;
    _isReading = YES;
    if (!_library)
        _library = [[ALAssetsLibrary alloc] init];
	self.assetGroups = [NSMutableArray arrayWithCapacity:0];
    self.assetsArray = [NSMutableArray arrayWithCapacity:0];
    [_library readAlbumIntoGroupContainer:assetGroups assetsContainer:assetsArray sucess:^{
        [self autoUplaodPic];
        [self prepareDataWithTimeOrder];
    } failture:^(NSError *error) {
        
    }];
}
- (void)autoUplaodPic
{
    //自动上传
    if ([LoginStateManager isLogin] && [PerfrenceSettingManager isAutoUpload]) {
        if (![[UploadTaskManager currentManager] isAutoUploading]) {
            [[UploadTaskManager currentManager] autoUploadAssets:self.assetsArray ToTaskExceptIsUPloadAlready:YES];
        }
    }
}
#pragma mark -  DataSort
- (void)prepareDataWithTimeOrder
{
    //asserts按日期大小排序;
    self.assetsArray = [self sortArrayByTime:self.assetsArray];
    //对asset分组
    [self localDivideAssettByDayTimeWithAssetArray:self.assetsArray exportToassestionArray:self.assetsSection assetSectionisShow:self.assetSectionisShow dataScource:self.dataSourceArray];
    [self.myTableView reloadData];
    _isReading = NO;
}

#pragma mark - SectionClick
- (void)handleTapInSection:(UITapGestureRecognizer *)gesture
{
    NSNumber * num = [self.assetSectionisShow objectAtIndex:[gesture view].tag];
    BOOL isShow = ![num boolValue];
    [self.assetSectionisShow replaceObjectAtIndex:[gesture view].tag withObject:[NSNumber numberWithBool:isShow]];
    [self.myTableView reloadData];
}

#pragma mark - TableDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self getSectionView:section ByisShow:[[self.assetSectionisShow objectAtIndex:section] boolValue] WithTimeText:[self.assetsSection objectAtIndex:section]];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.assetSectionisShow.count) return 0;
    return [[self.assetSectionisShow objectAtIndex:section] boolValue] ? [(NSMutableArray *)[self.dataSourceArray objectAtIndex:section] count]: 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [(NSMutableArray *)[self.dataSourceArray objectAtIndex:indexPath.section] count] - 1) {
        return [PhotoesCellDataSource cellLastHigth];
    }
    return [PhotoesCellDataSource cellHigth];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = LOCALBACKGORUNDCOLOR;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"photoCELLId";
    PhotoesCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[PhotoesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.delegate = self;
    }
    if (indexPath.section < self.dataSourceArray.count
        && indexPath.row < [(NSMutableArray *)[self.dataSourceArray objectAtIndex:indexPath.section] count])
        cell.dataSource = [[[self dataSourceArray] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
        uploadView.delegate = self;
        [self.navigationController pushViewController:uploadView animated:YES];
        return;
    }
    if (button.tag == LEFTBUTTON) {
        [self.viewDeckController toggleLeftViewAnimated:YES];
    }
    if (button.tag == RIGHT1BUTTON) { //切换页面
        self.viewDeckController.centerController = [[LocalAlbumsController alloc] init];
    }
    if (button.tag == RIGHT2BUTTON) { //上传
        if ([LoginStateManager isLogin]) {
            [self setViewState:UPloadState];
        }else{
            LoginViewController * lvc  = [[LoginViewController alloc] init];
            lvc.delegate = self;
            [self.navigationController pushViewController:lvc animated:YES];
        }
    }
    if (button.tag == CANCELBUTTONTAG) {
        [self setViewState:NomalState];
    }
    if (button.tag == RIGHTSELECTEDTAG) {
        if ([self canUpload]) {
            [self uploadPicTureWithArray:selectedArray];
            [self setViewState:NomalState];
        }else{
            [self showPopAlerViewnotTotasView:YES WithMes:@"请选择上传图片"];
        }
    }
}

#pragma mark photoClick
- (void)photoesCell:(PhotoesCell *)cell clickAsset:(ALAsset *)asset
{
    LocalDetailController * ph = [[LocalDetailController alloc] initWithAssetsArray:self.assetsArray andCurAsset:asset andAssetGroup:nil];
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
