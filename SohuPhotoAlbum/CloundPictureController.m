//
//  CloudPictureController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CloundPictureController.h"
#import "CloundDetailController.h"
#import "ShareViewController.h"
#import "CloundAlbumController.h"

@interface CloundPictureController()
@property(strong,nonatomic)NSMutableArray * dataSourceArray;
@property(strong,nonatomic)NSMutableArray * assetsArray;
@property(strong,nonatomic)NSMutableArray * assetsSection;
@property(strong,nonatomic)NSMutableArray * assetSectionisShow;
@property(strong,nonatomic)NSMutableArray * selectedArray;
@end

@implementation CloundPictureController
@synthesize dataSourceArray = _dataSourceArray;
@synthesize assetsSection = _assetsSection;
@synthesize assetSectionisShow = _assetSectionisShow;
@synthesize assetDictionary = _assetDictionary;
@synthesize selectedArray = _selectedArray;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.backgroundColor = LOCALBACKGORUNDCOLOR;
    _refreshTableView = [[EGRefreshTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _refreshTableView.pDelegate = self;
    _refreshTableView.dataSource = self;
    [self.view addSubview:_refreshTableView];
    [self initDataContainer];
    [self refrshDataFromNetWorkThenAddImage:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cloudDetailDidDeletePhoto:) name:DELETEPHOTO object:nil];
}

- (void)initDataContainer
{
    _selectedArray = [NSMutableArray arrayWithCapacity:0];
    _assetDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    _assetsSection = [NSMutableArray arrayWithCapacity:0];
    _assetSectionisShow = [NSMutableArray arrayWithCapacity:0];
    _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
}

#pragma mark - refrshDataFromNetWork
- (void)pullingreloadTableViewDataSource:(id)sender
{
    [self refrshDataFromNetWorkThenAddImage:NO];
}
- (void)pullingreloadMoreTableViewData:(id)sender
{
    [self getMoreFromNetWork];
}
- (void)refrshDataFromNetWorkThenAddImage:(BOOL)addImage
{
    [RequestManager getTimeStructWithAccessToken:[LoginStateManager currentToken] withtime:nil asynchronou:YES  success:^(NSString *response) {
        [self initDataContainer];
        [self.assetsSection addObjectsFromArray:[[response JSONValue] objectForKey:@"days"]];
        [self reloadTableViewWithAssetsSection:self.assetsSection andRefresh:YES];
        [_refreshTableView reloadData];
        if (addImage) {
            [self scrollViewDidEndDecelerating:_refreshTableView];
            return ;
        }
        [_refreshTableView didFinishedLoadingTableViewData];
    } failure:^(NSString *error) {
        [self showPopAlerViewRatherThentasView:NO WithMes:error];
        [_refreshTableView didFinishedLoadingTableViewData];
    }];
}
- (void)getMoreFromNetWork
{
    NSString * time = [[self.assetsSection lastObject] objectForKey:@"day"];
    [RequestManager getTimeStructWithAccessToken:[LoginStateManager currentToken] withtime:time asynchronou:YES  success:^(NSString *response) {
        NSArray * array = [[response JSONValue] objectForKey:@"days"];
        if (array && array.count) {
            [self.assetsSection addObjectsFromArray:array];
            [self reloadTableViewWithAssetsSection:self.assetsSection andRefresh:YES];
            [_refreshTableView reloadData];
        }
        [_refreshTableView didFinishedLoadingTableViewData];
    } failure:^(NSString *error) {
        [self showPopAlerViewRatherThentasView:NO WithMes:error];
        [_refreshTableView didFinishedLoadingTableViewData];
    }];
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
        CloundPictureCellDataSource * soure = [[CloundPictureCellDataSource alloc] init];
        soure.firstDic  = soure.secoundDic = soure.thridDic = soure.lastDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [tempArray addObject:soure];
    }
    CloundPictureCellDataSource * soure = [[CloundPictureCellDataSource alloc] init];
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
    [_refreshTableView reloadSections:[NSIndexSet indexSetWithIndex:[gesture view].tag] withRowAnimation:UITableViewRowAnimationAutomatic];
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
        NSArray * cellArray = [_refreshTableView visibleCells];
        for (UITableViewCell * vsCell in cellArray) {
            NSIndexPath * path = [_refreshTableView indexPathForCell:vsCell];
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
    if ([_assetDictionary objectForKey:days]) { //存在就不加载....
        return;
    }
    __block NSInteger section_b = section;
    [RequestManager getTimePhtotWithAccessToken:[LoginStateManager currentToken] day:days success:^(NSString *response) {
        NSMutableArray * array = [_dataSourceArray objectAtIndex:section];
        NSArray * photoArray = [[response JSONValue] objectForKey:@"photos"];
        if ((!photoArray) || (!photoArray.count)) return;
        [_assetDictionary setObject:photoArray forKey:days];
        [self insertInfo:photoArray intoDataSourceArray:array];
        DLog(@"LLLL:%@ %d %d",[photoArray lastObject],section_b,_refreshTableView.numberOfSections);
        //        return;
        [_refreshTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(NSString *error) {
        //加载图片不提示错误
    }];
}

- (void)insertInfo:(NSArray *)photoInfo intoDataSourceArray:(NSArray *)sourceArray
{
    NSInteger count = photoInfo.count;
    NSInteger last = count % 4;
    for (int i = 0; i < count - last; i+=4) {
        CloundPictureCellDataSource * soure  = nil;
        if (i / 4 < sourceArray.count)
            soure = [sourceArray objectAtIndex:i / 4];
        soure.firstDic  = [photoInfo objectAtIndex:i];
        soure.secoundDic = [photoInfo objectAtIndex:i + 1];
        soure.thridDic = [photoInfo objectAtIndex:i + 2];
        soure.lastDic = [photoInfo objectAtIndex:i + 3];
    }
    if (last && count / 4 < sourceArray.count) {
        CloundPictureCellDataSource * soure = [sourceArray objectAtIndex:count / 4];
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

#pragma mark DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    photoAssert(nil);
    if (!self.assetSectionisShow.count || !self.assetsSection) return nil;
    return [self getSectionView:section withImageCount:[[[_assetsSection objectAtIndex:section] objectForKey:@"count"] intValue] ByisShow:[[self.assetSectionisShow objectAtIndex:section] boolValue] WithTimeText:[[self.assetsSection objectAtIndex:section] objectForKey:@"day"]];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _assetsSection.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    photoAssert(0);
    return [[self.assetSectionisShow objectAtIndex:section] boolValue] ? [(NSMutableArray *)[self.dataSourceArray objectAtIndex:section] count]: 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = LOCALBACKGORUNDCOLOR;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    photoAssert(0.f);
    if (indexPath.row == [(NSMutableArray *)[self.dataSourceArray objectAtIndex:indexPath.section] count] - 1) {
        return [CloundPictureCellDataSource cellLastHigth];
    }
    return [CloundPictureCellDataSource cellHigth];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CloundPictureCellDataSource * source = nil;
    if (indexPath.section < self.dataSourceArray.count
        && indexPath.row < [(NSMutableArray *)[self.dataSourceArray objectAtIndex:indexPath.section] count])
        source = [[[self dataSourceArray] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    CloundPictureCell * cell = [tableView dequeueReusableCellWithIdentifier:cloudIdentify[[source sourceNumber]]];
    if (!cell) {
        cell = [[CloundPictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[source sourceNumber]];
        cell.delegate = self;
    }
    cell.dataSource = source;
    if (_viewState != NomalState){
        [cell showCellSelectedStatus];
        [cell cloudPictureCellisShow:[_selectedArray containsObject:cell.dataSource.firstDic] selectedDic:cell.dataSource.firstDic];
        [ cell cloudPictureCellisShow:[_selectedArray containsObject:cell.dataSource.secoundDic] selectedDic:cell.dataSource.secoundDic];
        [cell cloudPictureCellisShow:[_selectedArray containsObject:cell.dataSource.thridDic] selectedDic:cell.dataSource.thridDic];
        [cell cloudPictureCellisShow:[_selectedArray containsObject:cell.dataSource.lastDic] selectedDic:cell.dataSource.lastDic];
    }else{
        [cell hiddenCellSelectedStatus];
    }
    return cell;
}

#pragma mark View LifeCycle
- (void)cloudDetailDidDeletePhoto:(NSNotification*)notification
{
    _shouldRefreshOnce = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_cusBar){
        _cusBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [_cusBar.nLabelText setText:@"云备份"];
        
        [_cusBar.nRightButton1 setImage:[UIImage imageNamed:@"timeline-view.png"] forState:UIControlStateNormal];
        [_cusBar.nRightButton2 setImage:[UIImage imageNamed:@"shareBtn_nomal.png"] forState:UIControlStateNormal];
        [_cusBar.nRightButton3 setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        
        [_cusBar.sRightStateButton setImage:[UIImage imageNamed:@"ensure.png"] forState:UIControlStateNormal];
    }
    if (!_cusBar.superview)
        [self.navigationController.navigationBar addSubview:_cusBar];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    if (_shouldRefreshOnce) {
        [self refrshDataFromNetWorkThenAddImage:YES];
        _shouldRefreshOnce = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [_cusBar removeFromSuperview];
}

#pragma mark Action
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
    if (_selectedArray.count)
        [_selectedArray removeAllObjects];
    [_refreshTableView reloadData];
}
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload
{
    if (button.tag == LEFTBUTTON) {
        [self.viewDeckController toggleLeftViewAnimated:YES];
    }
    if (button.tag == RIGHT1BUTTON) {           //切换
        if (!cloudAlbumsConroller)
            cloudAlbumsConroller = [[CloundAlbumController alloc] init];
        self.viewDeckController.centerController = cloudAlbumsConroller;
    }
    if (button.tag == RIGHT2BUTTON) {           //分享
        [self setViewState:ShareState];
    }
    if (button.tag == RIGHT3BUTTON) {           //删除
        [self setViewState:DeleteState];
    }
    if (button.tag == CANCELBUTTONTAG) {        //取消
        [self setViewState:NomalState];
    }
    if (button.tag == RIGHTSELECTEDTAG) {       //确认
        [self handleEnsureClick];
    }
}

- (void)cloudPictureCell:(CloundPictureCell *)cell clickInfo:(NSDictionary *)dic
{
    NSIndexPath * path = [_refreshTableView indexPathForCell:cell];
    NSInteger  leftTime = path.section;
    NSInteger  rightTime = path.section;
    NSArray *  array = [self commentcontinuousTimeFormcurtimeSection:path.section ArrayAndSetLeftTime:&leftTime
                                                           RinghTime:&rightTime];
    CloundDetailController * cd = [[CloundDetailController alloc] initWithAssetsArray:array andCurAsset:dic];
    cd.sectionArray = self.assetsSection;
    DLog(@"%d %d ",leftTime,rightTime);
    cd.leftBoundsDays = leftTime;
    cd.rightBoudsDays = rightTime;
    [self.navigationController pushViewController:cd animated:YES];
}

- (NSArray *)commentcontinuousTimeFormcurtimeSection:(NSInteger)section ArrayAndSetLeftTime:(int *)lefttime RinghTime:(int *)rightTime
{
    DLog(@"%@",self.assetsSection);
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * rightarray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * leftArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = section - 1; i >=0 ; i--) {
        NSString * days = [[self.assetsSection objectAtIndex:i] objectForKey:@"day"];
        NSArray * array = [self.assetDictionary objectForKey:days];
        if (array) {
            (* lefttime) --;
            [leftArray addObjectsFromArray:array];
            [tempArray addObject:days];
        }else{
            break;
        }
    }
    for (int i = section + 1; i < self.assetsSection.count; i++) {
        NSString * days = [[self.assetsSection objectAtIndex:i] objectForKey:@"day"];
        NSArray * array = [self.assetDictionary objectForKey:days];
        if (array) {
            ( * rightTime) ++ ;
            [rightarray addObjectsFromArray:array];
            [tempArray addObject:days];
        }else{
            break;
        }
    }
    NSString * days = [[self.assetsSection objectAtIndex:section] objectForKey:@"day"];
    NSArray * array = [self.assetDictionary objectForKey:days];
    [leftArray addObjectsFromArray:array];
    [leftArray  addObjectsFromArray:rightarray];
    return leftArray;
}

- (void)cloudPictureCell:(CloundPictureCell *)cell clickInfo:(NSDictionary *)dic Select:(BOOL)isSelected
{
    if (isSelected) {
        [_selectedArray addObject:dic];
    }else if([_selectedArray containsObject:dic]){
        [_selectedArray removeObject:dic];
    }
}
- (void)handleEnsureClick
{
    if (!_selectedArray.count) {
        [self showPopAlerViewRatherThentasView:YES WithMes:@"请选择图片"];
        return;
    }
    if (_viewState == DeleteState) {
        [self showDeletePhotoesView];
        return;
    }
    if (_viewState == ShareState) {
        if (!_shareBox){
            _shareBox = [[ShareBox alloc] init];
            _shareBox.delegate = self;
        }
        [_shareBox showShareViewWithWeixinShow:NO photoWall:YES  andWriteImage:NO OnView:self.view];
    }
}

#pragma mark - Delete Photos
- (void)showDeletePhotoesView
{
    PopAlertView * alertView = [[PopAlertView alloc] initWithTitle:nil message:@"确认删除图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
    [alertView show];
    return;
}
- (void)popAlertView:(PopAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [RequestManager deletePhotosWithaccessToken:[LoginStateManager currentToken] photoIds:[self photosIdArray] success:^(NSString *response)
         {
             [self refrshDataFromNetWorkThenAddImage:YES];
             [self showPopAlerViewRatherThentasView:NO WithMes:@"删除成功"];
             [self setViewState:NomalState];
         } failure:^(NSString *error) {
             [self showPopAlerViewRatherThentasView:NO WithMes:@"删除失败"];
             [self setViewState:NomalState];
         }];
    }
}
- (NSArray *)photosIdArray
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic in _selectedArray) {
        [array addObject:[dic objectForKey:@"id"]];
    }
    return array;
}

#pragma mark Share
- (void)shareBoxViewShareTo:(KShareModel)model
{
    [self.navigationController pushViewController:[[ShareViewController alloc] initWithModel:model bgPhotoUrl:[[_selectedArray objectAtIndex:0] objectForKey:@"photo_url"] andDelegate:self] animated:YES];
}

- (void)shareBoxViewWeiXinShareToScene:(enum WXScene)scene
{
    //云端无微信分享
    //    [self respImageContentToSence:scene];
}

- (void)shareViewcontrollerDidShareClick:(ShareViewController *)controller withDes:(NSString *)des shareMode:(KShareModel)model
{
    [RequestManager sharePhotosWithAccesstoken:[LoginStateManager currentToken]  photoIDs:[self photosIdArray] share_to:model shareAccestoken:[[LoginStateManager getTokenInfo:model] objectForKey:@"access_token"] optionalTitle:nil desc:des success:^(NSString *response) {
        [self showPopAlerViewRatherThentasView:NO WithMes:@"分享成功"];
        [_selectedArray removeAllObjects];
        [self setViewState:NomalState];
    } failure:^(NSString *error) {
        [self showPopAlerViewRatherThentasView:NO WithMes:@"分享失败"];
    }];
    [self.navigationController popViewControllerAnimated:YES];
    
}
//#pragma mark - Weixin
//-(void) onReq:(BaseReq*)req
//{
//
//}
//- (void) respImageContentToSence:(enum WXScene)scene
//{
//    
//}
@end
