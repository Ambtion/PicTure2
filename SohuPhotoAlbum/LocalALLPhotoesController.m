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
- (id)init
{
    self = [super init];
    if (self) {
        isinit = YES;
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
    [self.view addSubview:self.myTableView];
    if (isinit){
        isinit = NO;
        [self readAlbum];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumDidwriteImage:) name:WRITEIMAGE object:nil];
}

- (void)initDataContainer
{
    selectedArray = [NSMutableArray arrayWithCapacity:0];
    assetsArray = [NSMutableArray arrayWithCapacity:0];
    assetGroups = [NSMutableArray arrayWithCapacity:0];
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
        _cusBar.nLabelText.text = @"本地相册";
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
    if (needReadonce) {
        [self readAlbum];
        needReadonce = NO;
    }else{
        [self autoUplaodPic];
    }
}

#pragma mark - ReadData
- (void)albumDidwriteImage:(NSNotification *)notification
{
    needReadonce = YES;
}
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self readAlbum];
}
- (void) readAlbum
{
    if (_isReading) return;
    _isReading = YES;
    [self initDataContainer];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            [[self libiary] readAlbumIntoGroupContainer:assetGroups assetsContainer:assetsArray sucess:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self prepareDataWithTimeOrder];
                    [self autoUplaodPic];
                });
            } failture:^(NSError *error) {
                
            }];
        }
    });
}

- (void)autoUplaodPic
{
    
    if ([LoginStateManager isLogin] && [PerfrenceSettingManager isAutoUpload]) {
        if (![[UploadTaskManager currentManager] isAutoUploading]) {
            [[UploadTaskManager currentManager] autoUploadAssets:self.assetsArray ToTaskIncludeAssetThatUploaded:NO];
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
    photoAssert();
    NSNumber * num = [self.assetSectionisShow objectAtIndex:[gesture view].tag];
    BOOL isShow = ![num boolValue];
    [self.assetSectionisShow replaceObjectAtIndex:[gesture view].tag withObject:[NSNumber numberWithBool:isShow]];
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:[gesture view].tag] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - TableDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    photoAssert(nil);
    return [self getSectionView:section withImageCount:[self numberofPhtotsWithSection:section] ByisShow:[[self.assetSectionisShow objectAtIndex:section] boolValue] WithTimeText:[self.assetsSection objectAtIndex:section]];
}
- (NSInteger)numberofPhtotsWithSection:(NSInteger)section
{
    NSArray * array = [self.dataSourceArray objectAtIndex:section];
    PhotoesCellDataSource * source = [array lastObject];
    NSInteger number = [(NSMutableArray *)[self.dataSourceArray objectAtIndex:section] count] * 4;
    if (!source.secoundAsset) {
        number -= 3;
    }else if(!source.thridAsset){
        number -= 2;
    }else if(!source.lastAsset){
        number --;
    }
    return number;
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
        if (!localAlbumsConroller)
            localAlbumsConroller = [[LocalAlbumsController alloc] init];
        self.viewDeckController.centerController = localAlbumsConroller;
    }
    if (button.tag == RIGHT2BUTTON) { //上传
        if (![LoginStateManager isLogin]) {
            [self showLoginViewWithMethodNav:YES];
            return;
        }
        [self setCusBarLableState];
        [self setViewState:UPloadState];
    }
    if (button.tag == CANCELBUTTONTAG) {
        [self setViewState:NomalState];
    }
    if (button.tag == RIGHTSELECTEDTAG) {
        if ([self canUpload]) {
            [self uploadPicTureWithArray:selectedArray];
            [self setViewState:NomalState];
        }else{
            [self showPopAlerViewRatherThentasView:YES WithMes:@"请选择上传图片"];
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
    [self setCusBarLableState];
}
- (void)setCusBarLableState
{
    if (selectedArray.count) {
        [_cusBar.sLabelText setText:[NSString stringWithFormat:@"已选择%d张照片",selectedArray.count]];
    }else{
        [_cusBar.sLabelText setText:SLABELTEXT];
    }
}
@end
