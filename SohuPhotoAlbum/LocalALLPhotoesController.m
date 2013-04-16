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
#import "LoginStateManager.h"


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
    self.myTableView = [[UITableView alloc] initWithFrame:[self subTableViewRect] style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorColor = [UIColor clearColor];
    self.myTableView.backgroundColor = BACKGORUNDCOLOR;
    _selectedArray = [NSMutableArray arrayWithCapacity:0];
    [self.view addSubview:self.myTableView];
    [self readAlbum];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
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
        [_cusBar.sRightStateButton setImage:[UIImage imageNamed:@"YES.png"] forState:UIControlStateNormal];
    }
    if (!_cusBar.superview)
        [self.navigationController.navigationBar addSubview:_cusBar];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
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
        [self prepareDataWithTimeOrder];
    } failture:^(NSError *error) {
        
    }];
}

#pragma mark -  DataSort
- (void)prepareDataWithTimeOrder
{
    //asserts按日期大小排序;
    self.assetsArray = [[self.assetsArray sortedArrayUsingFunction:sort context:nil] mutableCopy];
    //对asset分组
    [self divideAssettByDayTime];
    DLog(@"myTableView reload");
    [self.myTableView reloadData];
    _isReading = NO;
}
- (void)divideAssettByDayTime
{
    DLog(@"start divide");
    self.assetsSection = [NSMutableArray arrayWithCapacity:0];
    self.assetSectionisShow = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.assetsArray.count; i++) {
        ALAsset * asset = [self.assetsArray objectAtIndex:i];
        NSDate * date = [asset valueForProperty:ALAssetPropertyDate];
        NSString * dateString = [self stringFromdate:date];
        if (![self array:self.assetsSection hasTimeString:dateString]){
            [self.assetsSection addObject:dateString];
            NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
            [array addObject:asset];
            [tempArray addObject:array];
            [assetSectionisShow addObject:[NSNumber numberWithBool:YES]];
        }else{
            NSMutableArray * array = [tempArray objectAtIndex:[self.assetsSection indexOfObject:dateString]];
            [array addObject:asset];
        }
    }
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    for (NSMutableArray * array in tempArray )
        [self.dataSourceArray addObject:[self coverAssertToDataSource:array]];
    DLog(@"start end");
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
- (void)setSectionTimeofAssertsIntoArray
{
    //获取不同天数的日期(string)
    self.assetsSection = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.assetsArray.count; i++) {
        NSDate * date = [[self.assetsArray objectAtIndex:i] valueForProperty:ALAssetPropertyDate];
        NSString * dateString = [self stringFromdate:date];
        if (![self array:self.assetsSection hasTimeString:dateString])
            [self.assetsSection addObject:dateString];
    }
    
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
#pragma mark - SectionClick
- (void)handleTapInSection:(UITapGestureRecognizer *)gesture
{
    NSNumber * num = [self.assetSectionisShow objectAtIndex:[gesture view].tag];
    BOOL isShow = ![num boolValue];
    [self.assetSectionisShow replaceObjectAtIndex:[gesture view].tag withObject:[NSNumber numberWithBool:isShow]];
    [self.myTableView reloadData];
}

#pragma mark - TableDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 24)];
    view.image = [UIImage imageNamed:@"index-bar.png"];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, 314, 24)];
    [view setUserInteractionEnabled:YES];
    UITapGestureRecognizer * tap  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapInSection:)    ];
    [view addGestureRecognizer:tap];
    view.tag = section;
    label.textAlignment = UITextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13.f];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:98.f/255.f green:98.f/255.f blue:98.f/255.f alpha:1.f];
    label.text = [self.assetsSection objectAtIndex:section];
    [view addSubview:label];
    return view;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = BACKGORUNDCOLOR;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.assetSectionisShow objectAtIndex:section] boolValue] ? [(NSMutableArray *)[self.dataSourceArray objectAtIndex:section] count]: 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    PhotoesCellDataSource * source = [[self.dataSourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.row == [(NSMutableArray *)[self.dataSourceArray objectAtIndex:indexPath.section] count] - 1) {
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
    if (indexPath.section < self.dataSourceArray.count
        && indexPath.row < [(NSMutableArray *)[self.dataSourceArray objectAtIndex:indexPath.section] count])
        cell.dataSource = [[[self dataSourceArray] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (_viewState != NomalState){
        [cell showCellSelectedStatus];
        [cell isShow:[_selectedArray containsObject:cell.dataSource.firstAsset] SelectedAsset:cell.dataSource.firstAsset];
        [cell isShow:[_selectedArray containsObject:cell.dataSource.secoundAsset] SelectedAsset:cell.dataSource.secoundAsset];
        [cell isShow:[_selectedArray containsObject:cell.dataSource.thridAsset] SelectedAsset:cell.dataSource.thridAsset];
        [cell isShow:[_selectedArray containsObject:cell.dataSource.lastAsset] SelectedAsset:cell.dataSource.lastAsset];
    }else{
        [cell hiddenCellSelectedStatus];
    }
    return cell;
}

#pragma mark - NavigationBarDelegate
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button
{
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
    //全选
//    if (button.tag == ALLSELECTEDTAG) {
//        if (_selectedArray.count != self.assetsArray.count ){
//            [_selectedArray removeAllObjects];
//            [_selectedArray addObjectsFromArray:self.assetsArray];
//        }else{
//            [_selectedArray removeAllObjects];
//        }
//        [self.myTableView reloadData];
//    }
    if (button.tag == RIGHTSELECTEDTAG) {
        if ([self canUpload]) {
            [self uploadPicTureWithArray:_selectedArray];
            [self setViewState:NomalState];
        }else{
            [self showPopAlerViewnotTotasView:YES WithMes:@"请选择上传图片"];
        }
    }
}
- (void)setViewState:(viewState)viewState
{
    if (viewState == _viewState) return;
    _viewState = viewState;
    [_cusBar switchBarStateToUpload:_viewState == UPloadState];
    if (_viewState == UPloadState) {
        self.viewDeckController.panningMode = IIViewDeckNoPanning;
    }else{
        self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    }
    if (_selectedArray.count)
        [_selectedArray removeAllObjects];
    [self.myTableView reloadData];
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
        [_selectedArray addObject:asset];
    }else if([_selectedArray containsObject:asset]){
        [_selectedArray removeObject:asset];
    }
    if (_selectedArray.count) {
        [_cusBar.sLabelText setText:[NSString stringWithFormat:@"已选择%d张照片",_selectedArray.count]];
    }else{
        [_cusBar.sLabelText setText:SLABELTEXT];
    }
}

@end
