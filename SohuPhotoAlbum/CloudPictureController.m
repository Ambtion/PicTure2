//
//  CloudPictureController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CloudPictureController.h"
#import "RequestManager.h"
#import "CloundDetailController.h"

@interface CloudPictureController()
@property(strong,nonatomic)NSMutableArray * dataSourceArray;
@property(strong,nonatomic)NSMutableArray * assetsArray;
@property(strong,nonatomic)NSMutableArray *assetsSection;
@property(strong,nonatomic)NSMutableArray *assetSectionisShow;
@end

@implementation CloudPictureController
@synthesize dataSourceArray = _dataSourceArray;
@synthesize assetsArray = _assetsArray;
@synthesize assetsSection = _assetsSection;
@synthesize assetSectionisShow = _assetSectionisShow;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = LOCALBACKGORUNDCOLOR;
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    _refresHeadView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, - 60, 320, 60) arrowImageName:nil textColor:[UIColor redColor] backGroundColor:[UIColor clearColor]];
    _refresHeadView.delegate = self;
    [self.myTableView addSubview:_refresHeadView];
    [self.view addSubview:self.myTableView];
    
    _moreFootView = [[SCPMoreTableFootView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) WithLodingImage:[UIImage imageNamed:@"load_more_pics.png"] endImage:[UIImage imageNamed:@"end_bg.png"] WithBackGroud:[UIColor clearColor]];
    _moreFootView.delegate = self;
    self.myTableView.tableFooterView = _moreFootView;
    
    [self initDataContainer];
    [self getMoreFromNetWork];
}
- (void)initDataContainer
{
    selectedArray = [NSMutableArray arrayWithCapacity:0];
    _assetsSection = [NSMutableArray arrayWithCapacity:0];
    _assetSectionisShow = [NSMutableArray arrayWithCapacity:0];
    _assetsArray  = [NSMutableArray arrayWithCapacity:0];
    _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
}
#pragma mark - Refresh
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}
- (void)reloadTableViewDataSource
{
    _isLoading = YES;
    [self refrshDataFromNetWork];
}
- (void)doneRefrshLoadingTableViewData
{
    _isLoading = NO;
    [_refresHeadView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _isLoading;
}
//- (void)refeshOnce:(id)sender
//{
//    [_refresHeadView refreshImmediately];
//    [self reloadTableViewDataSource];
//}
#pragma mark - more
- (void)scpMoreTableFootViewDelegateDidTriggerRefresh:(SCPMoreTableFootView *)view
{
    [self moreTableViewDataSource];
}
- (BOOL)scpMoreTableFootViewDelegateDataSourceIsLoading:(SCPMoreTableFootView *)view
{
    return _isLoading;
}
- (void)moreTableViewDataSource
{
    _isLoading = YES;
    [self getMoreFromNetWork];
}
- (void)doneMoreLoadingTableViewData
{
    _isLoading = NO;
    [_moreFootView scpMoreScrollViewDataSourceDidFinishedLoading:self.myTableView];
}

#pragma mark - refrshDataFromNetWork
- (void)refrshDataFromNetWork
{
    [RequestManager getTimePhtotWithAccessToken:[LoginStateManager currentToken] beforeTime:0 count:100 success:^(NSString *response) {
        [self.assetsArray removeAllObjects];
        NSArray * photos = [[response JSONValue] objectForKey:@"photos"];
        [self.assetsArray addObjectsFromArray:photos];
        [self reloadTableViewWithAssetsSource:self.assetsArray];
        [self doneRefrshLoadingTableViewData];
    } failure:^(NSString *error) {
        [self performSelector:@selector(doneRefrshLoadingTableViewData) withObject:nil afterDelay:0.f];
    }];
}

- (void)getMoreFromNetWork
{
    NSDictionary * dic = nil;
    if (self.assetsArray.count)
        dic =  [self.assetsArray lastObject];
    
    long long time = dic ? [[dic objectForKey:@"taken_id"] longLongValue] : 0;
    _isLoading = YES;
    [RequestManager getTimePhtotWithAccessToken:[LoginStateManager currentToken] beforeTime:time count:100 success:^(NSString *response) {
        NSArray * photos = [[response JSONValue] objectForKey:@"photos"];
        if (photos  && photos.count){
            [self.assetsArray addObjectsFromArray:photos];
            [self reloadTableViewWithAssetsSource:self.assetsArray];
            [_moreFootView setMoreFunctionOff:NO];
        }else{
            [_moreFootView setMoreFunctionOff:YES];
        }
        [self doneMoreLoadingTableViewData];
    } failure:^(NSString *error) {
        //        [self performSelector:@selector(doneMoreLoadingTableViewData) withObject:nil afterDelay:0.f];
    }];
}
- (void)reloadTableViewWithAssetsSource:(NSMutableArray *)assetArray
{
    [self initDataContainer];
    [self.assetsArray addObjectsFromArray:assetArray];
    [self cloundDivideAssettByDayTimeWithAssetArray:self.assetsArray exportToassestionArray:self.assetsSection assetSectionisShow:self.assetSectionisShow dataScource:self.dataSourceArray];
    [self.myTableView reloadData];
    
}
#pragma mark - SectionClick
- (void)handleTapInSection:(UITapGestureRecognizer *)gesture
{
    NSNumber * num = [self.assetSectionisShow objectAtIndex:[gesture view].tag];
    BOOL isShow = ![num boolValue];
    [self.assetSectionisShow replaceObjectAtIndex:[gesture view].tag withObject:[NSNumber numberWithBool:isShow]];
    [self.myTableView reloadData];
}
#pragma mark Refresh-More function
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refresHeadView egoRefreshScrollViewDidEndDragging:scrollView];
    [_moreFootView scpMoreScrollViewDidEndDragging:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refresHeadView egoRefreshScrollViewDidScroll:scrollView];
    [_moreFootView scpMoreScrollViewDidScroll:scrollView];
    if (scrollView.contentSize.height - scrollView.frame.size.height -  scrollView.contentOffset.y < 100) {
        if ([_moreFootView canLoadingMore]) {
            [_moreFootView moreImmediately];
            _isLoading = YES;
        }
    }
}
#pragma mark DataSource
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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = LOCALBACKGORUNDCOLOR;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataSourceArray.count) return 0;
    if (indexPath.row == [(NSMutableArray *)[self.dataSourceArray objectAtIndex:indexPath.section] count] - 1) {
        return [CloudPictureCellDataSource cellLastHigth];
    }
    return [CloudPictureCellDataSource cellHigth];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"photoCELLId";
    CloudPictureCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CloudPictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.delegate = self;
    }
    if (indexPath.section < self.dataSourceArray.count
        && indexPath.row < [(NSMutableArray *)[self.dataSourceArray objectAtIndex:indexPath.section] count])
        cell.dataSource = [[[self dataSourceArray] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (_viewState != NomalState){
        [cell showCellSelectedStatus];
        [cell cloudPictureCellisShow:[selectedArray containsObject:cell.dataSource.firstDic] selectedDic:cell.dataSource.firstDic];
        [ cell cloudPictureCellisShow:[selectedArray containsObject:cell.dataSource.secoundDic] selectedDic:cell.dataSource.secoundDic];
        [cell cloudPictureCellisShow:[selectedArray containsObject:cell.dataSource.thridDic] selectedDic:cell.dataSource.thridDic];
        [cell cloudPictureCellisShow:[selectedArray containsObject:cell.dataSource.lastDic] selectedDic:cell.dataSource.lastDic];
    }else{
        [cell hiddenCellSelectedStatus];
    }
    return cell;
}

#pragma mark View LifeCircle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_cusBar){
        _cusBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [_cusBar.nLabelText setText:@"云备份"];
        [_cusBar.nRightButton1 setImage:[UIImage imageNamed:@"shareBtn_nomal.png"] forState:UIControlStateNormal];
        //上传按钮
        [_cusBar.nRightButton2 setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [_cusBar.nRightButton3 setUserInteractionEnabled:NO];
        [_cusBar.sRightStateButton setImage:[UIImage imageNamed:@"ensure.png"] forState:UIControlStateNormal];
    }
    if (!_cusBar.superview)
        [self.navigationController.navigationBar addSubview:_cusBar];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
}

#pragma mark Action
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload
{
    
    if (button.tag == LEFTBUTTON) {
        [self.viewDeckController toggleLeftViewAnimated:YES];
    }
    if (button.tag == RIGHT1BUTTON) {           //分享
        [self setViewState:ShareState];
    }
    if (button.tag == RIGHT2BUTTON) {           //删除
        [self setViewState:DeleteState];
    }
    if (button.tag == CANCELBUTTONTAG) {        //取消
        [self setViewState:NomalState];
    }
    if (button.tag == RIGHTSELECTEDTAG) {       //确认
        [self handleEnsureClick];
    }
}

- (void)cloudPictureCell:(CloudPictureCell *)cell clickInfo:(NSDictionary *)dic
{
    CloundDetailController * cd = [[CloundDetailController alloc] initWithAssetsArray:self.assetsArray andCurAsset:dic];
    [self.navigationController pushViewController:cd animated:YES];
}
- (void)cloudPictureCell:(CloudPictureCell *)cell clickInfo:(NSDictionary *)dic Select:(BOOL)isSelected
{
    if (isSelected) {
        [selectedArray addObject:dic];
    }else if([selectedArray containsObject:dic]){
        [selectedArray removeObject:dic];
    }
}
- (void)handleEnsureClick
{
    if (!selectedArray.count) {
        [self showPopAlerViewnotTotasView:YES WithMes:@"请选择图片"];
        return;
    }
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic in selectedArray) {
        [array addObject:[dic objectForKey:@"id"]];
    }
    if (_viewState == DeleteState) {
        [RequestManager deletePhotosWithaccessToken:[LoginStateManager currentToken] photoIds:array success:^(NSString *response)
        {
            [self.assetsArray removeObjectsInArray:selectedArray];
            [self reloadTableViewWithAssetsSource:self.assetsArray];
            [self showPopAlerViewnotTotasView:NO WithMes:@"删除成功"];
            [self setViewState:NomalState];
        } failure:^(NSString *error) {
            [self showPopAlerViewnotTotasView:NO WithMes:error];
            [self setViewState:NomalState];
        }];
    }
}
@end
