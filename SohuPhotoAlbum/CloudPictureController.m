//
//  CloudPictureController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CloudPictureController.h"
#import "CloundDetailController.h"
#import "ShareViewController.h"

@interface CloudPictureController()
@property(strong,nonatomic)NSMutableArray * dataSourceArray;
@property(strong,nonatomic)NSMutableArray * assetsArray;
@property(strong,nonatomic)NSMutableArray *assetsSection;
@property(strong,nonatomic)NSMutableArray *assetSectionisShow;
@end

@implementation CloudPictureController
@synthesize dataSourceArray = _dataSourceArray;
@synthesize assetsSection = _assetsSection;
@synthesize assetSectionisShow = _assetSectionisShow;
@synthesize assetDictionary = _assetDictionary;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = LOCALBACKGORUNDCOLOR;
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _refresHeadView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, - 60, 320, 60) arrowImageName:nil textColor:[UIColor redColor] backGroundColor:[UIColor clearColor]];
    _refresHeadView.delegate = self;
    [self.myTableView addSubview:_refresHeadView];
    [self.view addSubview:self.myTableView];
    
//    _moreFootView = [[SCPMoreTableFootView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) WithLodingImage:[UIImage imageNamed:@"load_more_pics.png"] endImage:[UIImage imageNamed:@"end_bg.png"] WithBackGroud:[UIColor clearColor]];
//    _moreFootView.delegate = self;
//    self.myTableView.tableFooterView = _moreFootView;
    
    [self initDataContainer];
    [self refrshDataFromNetWork];
}
- (void)initDataContainer
{
    selectedArray = [NSMutableArray arrayWithCapacity:0];
    _assetDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    _assetsSection = [NSMutableArray arrayWithCapacity:0];
    _assetSectionisShow = [NSMutableArray arrayWithCapacity:0];
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
    [RequestManager getTimeStructWithAccessToken:[LoginStateManager currentToken] withtime:nil success:^(NSString *response) {
        [self initDataContainer];
        [self.assetsSection addObjectsFromArray:[[response JSONValue] objectForKey:@"days"]];
        [self reloadTableViewWithAssetsSection:self.assetsSection andRefresh:YES];
        [self.myTableView reloadData];
        [self doneRefrshLoadingTableViewData];
        [self scrollViewDidEndDecelerating:self.myTableView];
    } failure:^(NSString *error) {
        [self doneRefrshLoadingTableViewData];
    }];
}
- (void)getMoreFromNetWork
{
//    [RequestManager getTimeStructWithAccessToken:[LoginStateManager currentToken] withtime:nil success:^(NSString *response) {
//        [self.assetsSection addObjectsFromArray:[[response JSONValue] objectForKey:@"days"]];
//        [self reloadTableViewWithAssetsSection:self.assetsSection andRefresh:YES];
//        [self.myTableView reloadData];
//        [self doneMoreLoadingTableViewData];
//    } failure:^(NSString *error) {
//        [self doneMoreLoadingTableViewData];
//    }];
}
- (void)reloadTableViewWithAssetsSection:(NSMutableArray *)asssetSection andRefresh:(BOOL)isRefresh
{
    NSInteger numberSource = _dataSourceArray.count;
    NSInteger numberAssection = asssetSection.count;
    for (int i = numberSource; i < numberAssection; i++) {
        NSDictionary * dic = [asssetSection objectAtIndex:i];
        [_dataSourceArray addObject:[self sectionSourceArrayWithSectionInfo:dic]];
        [self.assetSectionisShow addObject:[NSNumber numberWithBool:YES]];
    }
    
}
- (NSMutableArray *)sectionSourceArrayWithSectionInfo:(NSDictionary *)info
{
    NSInteger count = [[info objectForKey:@"count"] intValue];
    NSInteger last = count % 4;
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < count / 4; i++) {
        CloudPictureCellDataSource * soure = [[CloudPictureCellDataSource alloc] init];
        soure.firstDic  = soure.secoundDic = soure.thridDic = soure.lastDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [tempArray addObject:soure];
    }
    CloudPictureCellDataSource * soure = [[CloudPictureCellDataSource alloc] init];
    switch (last) {
        case 3:
            soure.thridDic =  [NSMutableDictionary dictionaryWithCapacity:0];
        case 2:
            soure.secoundDic =  [NSMutableDictionary dictionaryWithCapacity:0];
        case 1:
            soure.firstDic =  [NSMutableDictionary dictionaryWithCapacity:0];
            break;
        default:
            break;
    }
    if (soure.firstDic) {
        [tempArray addObject:soure];
    }
    return tempArray;
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
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSArray * array = [self arraySectionForVisibleCell];
    for (NSNumber * number in array) {
        [self insertDataSourceWithDays:[number integerValue]];
    }
}

- (NSArray *)arraySectionForVisibleCell
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    if (_dataSourceArray.count) {
        NSArray * cellArray = [self.myTableView visibleCells];
        for (UITableViewCell * vsCell in cellArray) {
            NSIndexPath * path = [self.myTableView indexPathForCell:vsCell];
            if (![array containsObject:[NSNumber numberWithInteger:path.section]]) {
                [array addObject:[NSNumber numberWithInteger:path.section]];
            }
        }
    }
    return array;
}
- (void)insertDataSourceWithDays:(NSInteger )section
{
    NSDictionary * dic = [self.assetsSection objectAtIndex:section];
    NSString * days = [dic objectForKey:@"day"];
    if ([_assetDictionary objectForKey:days]) {
        return;
    }
    [RequestManager getTimePhtotWithAccessToken:[LoginStateManager currentToken] day:days success:^(NSString *response) {
        NSMutableArray * array = [_dataSourceArray objectAtIndex:section];
        NSArray * photoArray = [[response JSONValue] objectForKey:@"photos"];
        [_assetDictionary setObject:photoArray forKey:days];
        [self insertInfo:photoArray intoDataSourceArray:array]; 
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(NSString *error) {
        
    }];
}

- (void)insertInfo:(NSArray *)photoInfo intoDataSourceArray:(NSArray *)sourceArray
{
    NSInteger count = photoInfo.count;
    NSInteger last = count % 4;
    for (int i = 0; i < count - last; i+=4) {
        CloudPictureCellDataSource * soure  = nil;
        if (i / 4 < sourceArray.count)
                soure = [sourceArray objectAtIndex:i / 4];
        soure.firstDic  = [photoInfo objectAtIndex:i];
        soure.secoundDic = [photoInfo objectAtIndex:i + 1];
        soure.thridDic = [photoInfo objectAtIndex:i + 2];
        soure.lastDic = [photoInfo objectAtIndex:i + 3];
    }
    if (last && count / 4 < sourceArray.count) {
        CloudPictureCellDataSource * soure = [sourceArray objectAtIndex:count / 4];
        switch (last) {
            case 3:
                soure.thridDic = [photoInfo objectAtIndex:(count / 4)*4 + 2];
            case 2:
                soure.secoundDic =  [photoInfo objectAtIndex:(count / 4)*4  + 1];
            case 1:
                soure.firstDic = [photoInfo objectAtIndex:(count / 4) * 4 ];
                break;
            default:
                break;
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refresHeadView egoRefreshScrollViewDidEndDragging:scrollView];
    [_moreFootView scpMoreScrollViewDidEndDragging:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refresHeadView egoRefreshScrollViewDidScroll:scrollView];
    [_moreFootView scpMoreScrollViewDidScroll:scrollView isAutoLoadMore:YES WithIsLoadingPoint:&_isLoading];
}
#pragma mark DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self getSectionView:section withImageCount:[[[_assetsSection objectAtIndex:section] objectForKey:@"count"] intValue] ByisShow:[[self.assetSectionisShow objectAtIndex:section] boolValue] WithTimeText:[[self.assetsSection objectAtIndex:section] objectForKey:@"day"]];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _assetsSection.count;
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
    NSIndexPath * path = [self.myTableView indexPathForCell:cell];
    CloundDetailController * cd = [[CloundDetailController alloc] initWithAssetsArray:self.assetsArray andCurAsset:dic];
//    [self.navigationController pushViewController:cd animated:YES];
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
        [self showPopAlerViewRatherThentasView:YES WithMes:@"请选择图片"];
        return;
    }
   
    if (_viewState == DeleteState) {
        [RequestManager deletePhotosWithaccessToken:[LoginStateManager currentToken] photoIds:[self photosIdArray] success:^(NSString *response)
         {
             [self refrshDataFromNetWork];
             [self showPopAlerViewRatherThentasView:NO WithMes:@"删除成功"];
             [self setViewState:NomalState];
         } failure:^(NSString *error) {
             [self showPopAlerViewRatherThentasView:NO WithMes:error];
             [self setViewState:NomalState];
         }];
    }
    if (_viewState == ShareState) {
        [self showShareView];
    }
}
- (NSArray *)photosIdArray
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic in selectedArray) {
        [array addObject:[dic objectForKey:@"id"]];
    }
    return array;
}
#pragma mark Share
- (void)showShareView
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"人人网",@"腾讯QQ空间", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            _cloudmodel = SinaWeiboShare;
            break;
        case 1:
            _cloudmodel = RenrenShare;
            break;
        case 2:
            _cloudmodel = QQShare;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:[[ShareViewController alloc] initWithModel:_cloudmodel bgPhotoUrl:[[selectedArray objectAtIndex:0] objectForKey:@"photo_url"] andDelegate:self] animated:YES];
}
- (void)shareViewcontrollerDidShareClick:(ShareViewController *)controller withDes:(NSString *)des shareMode:(shareModel)model
{
    [RequestManager sharePhtotsWithAccesstoken:[LoginStateManager currentToken]  photoIDs:[self photosIdArray] share_to:model shareAccestoken:nil  optionalTitle:@"adf" desc:des success:^(NSString *response) {
               DLog(@"%@",response);
              [self showPopAlerViewRatherThentasView:NO WithMes:@"分享成功"];
               [selectedArray removeAllObjects];
              [self setViewState:NomalState];
           } failure:^(NSString *error) {
                DLog(@"%@",error);
                [self showPopAlerViewRatherThentasView:NO WithMes:error];
       
    }];
    [self.navigationController popViewControllerAnimated:YES];

}

@end
