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
    _refresHeadView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, - 60, 320, 60) arrowImageName:nil textColor:[UIColor grayColor] backGroundColor:[UIColor clearColor]];
    _refresHeadView.delegate = self;
    [self.myTableView addSubview:_refresHeadView];
    [self.view addSubview:self.myTableView];
    
    _moreFootView = [[SCPMoreTableFootView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) WithLodingImage:[UIImage imageNamed:@"load_more_pics.png"] endImage:[UIImage imageNamed:@"end_bg.png"] WithBackGroud:[UIColor clearColor]];
    _moreFootView.delegate = self;
    //    self.myTableView.tableFooterView = _moreFootView;
    [self initDataContainer];
    [self refrshDataFromNetWork];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cloudDetailDidDeletePhoto:) name:DELETEPHOTO object:nil];
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

    NSString * time = [[self.assetsSection lastObject] objectForKey:@"day"];
    [RequestManager getTimeStructWithAccessToken:[LoginStateManager currentToken] withtime:time success:^(NSString *response) {
        NSArray * array = [[response JSONValue] objectForKey:@"days"];
        DLog(@"%@",array);
        if (array && array.count) {
            [self.assetsSection addObjectsFromArray:array];
            [self reloadTableViewWithAssetsSection:self.assetsSection andRefresh:YES];
            [self.myTableView reloadData];
        }
        [self doneMoreLoadingTableViewData];
        
    } failure:^(NSString *error) {
        [self doneMoreLoadingTableViewData];
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
//    [self.myTableView reloadData];
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:[gesture view].tag] withRowAnimation:UITableViewRowAnimationAutomatic];
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
        [_cusBar.nRightButton1 setImage:[UIImage imageNamed:@"shareBtn_nomal.png"] forState:UIControlStateNormal];
        //上传按钮
        [_cusBar.nRightButton2 setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [_cusBar.nRightButton3 setUserInteractionEnabled:NO];
        [_cusBar.sRightStateButton setImage:[UIImage imageNamed:@"ensure.png"] forState:UIControlStateNormal];
    }
    if (!_cusBar.superview)
        [self.navigationController.navigationBar addSubview:_cusBar];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    if (_shouldRefreshOnce) {
        [self refrshDataFromNetWork];
        _shouldRefreshOnce = NO;
    }
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
    NSInteger  leftTime = 0;
    NSInteger  rightTime = 0;
    NSArray *  array = [self commentcontinuousTimeFormcurtimeSection:path.section ArrayAndSetLeftTime:&leftTime
                                                           RinghTime:&rightTime];
    CloundDetailController * cd = [[CloundDetailController alloc] initWithAssetsArray:array andCurAsset:dic];
    cd.sectionArray = self.assetsSection;
    cd.leftBoundsDays = leftTime;
    cd.rightBoudsDays = rightTime;
    [self.navigationController pushViewController:cd animated:YES];
}
- (NSArray *)commentcontinuousTimeFormcurtimeSection:(NSInteger)section ArrayAndSetLeftTime:(int *)lefttime RinghTime:(int *)rightTime
{
    
    NSMutableArray * rightarray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * leftArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = section - 1; i >=0 ; i--) {
        NSString * days = [[self.assetsSection objectAtIndex:i] objectForKey:@"day"];
        NSArray * array = [self.assetDictionary objectForKey:days];
        if (array) {
            * lefttime = i;
            [leftArray addObjectsFromArray:array];
        }else{
            break;
        }
    }
    for (int i = section + 1; i < self.assetsSection.count; i++) {
        NSString * days = [[self.assetsSection objectAtIndex:i] objectForKey:@"day"];
        NSArray * array = [self.assetDictionary objectForKey:days];
        if (array) {
            * rightTime = i;
            [rightarray addObjectsFromArray:array];
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
    PopAlertView * alertView = [[PopAlertView alloc] initWithTitle:nil message:@"确认删除图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
    return;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
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
- (void)shareBoxViewShareTo:(shareModel)model
{
    [self.navigationController pushViewController:[[ShareViewController alloc] initWithModel:model bgPhotoUrl:[[selectedArray objectAtIndex:0] objectForKey:@"photo_url"] andDelegate:self] animated:YES];
}
- (void)shareBoxViewWeiXinShareToScene:(enum WXScene)scene
{
    [self respImageContentToSence:scene];
}

- (void)shareViewcontrollerDidShareClick:(ShareViewController *)controller withDes:(NSString *)des shareMode:(shareModel)model
{
    [RequestManager sharePhotosWithAccesstoken:[LoginStateManager currentToken]  photoIDs:[self photosIdArray] share_to:model shareAccestoken:nil  optionalTitle:@"title" desc:des success:^(NSString *response) {
        [self showPopAlerViewRatherThentasView:NO WithMes:@"分享成功"];
        [selectedArray removeAllObjects];
        [self setViewState:NomalState];
    } failure:^(NSString *error) {
        [self showPopAlerViewRatherThentasView:NO WithMes:error];
    }];
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - Weixin
-(void) onReq:(BaseReq*)req
{
    
}
- (void) respImageContentToSence:(enum WXScene)scene
{
//    //发送内容给微信
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = @"麦当劳“销售过期食品”其实不是卫生问题";
//    message.description = @"3.15晚会播出当晚，麦当劳该店所在辖区的卫生、工商部门就连夜登门调查，并对腾讯财经等媒体公布初步结果；而尽管未接到闭店处罚通知，麦当劳中国总部还是在发布道歉声明后暂停了该店营业。\
//    \
//    不得不承认，麦当劳“销售过期食品”固然是事实，但这个“过期”仅仅是他们自己定义的过期，普通中国家庭也不会把刚炸出来30分钟的鸡翅拿去扔掉。麦当劳在食品卫生上的严格程度，不仅远远超出了一般国内企业，而且也超出了一般中国民众的心理预期和生活想象。大多数人以前并不知道，麦当劳厨房的食品架上还有计时器，辣鸡翅等大多数食品存放半个小时之后，按规定就应该扔掉。也正因如此，甚至有网友认为央视3.15晚会的曝光是给麦当劳做的软广告。\
//    \
//    央视视频中反映的情况，除了掉到地上的的食品未经任何处理继续加工显得很过分外，其它的问题都源于麦当劳自己制定的标准远远超出了国内一般快餐店的标准。比如北京市卫生监督所相关负责人介绍，麦当劳内部要求熟菜在70℃环境下保存2小时，是为了保存食品风味，属于企业内部卫生规范。目前的检查结果显示，麦当劳的保温盒温度在93℃，但在这种环境下保存的熟菜即便超过2小时，对公众也没有危害。也就是说麦当劳的一些保持时间标准是基于保持其食品的独特风味的要求，并非食品发生变质可能损害消费者身体健康的标准，麦当劳这家门店超时存放食品的行为，违反的是企业制定的内部标准，并不违反食品安全规定，政府应该依据法律法规来监管食品卫生，而不是按照食品公司自己制定的标准，从这个角度来看，麦当劳在食品卫生上没有责任（除了使用掉在地上的食物）。…[详细]\
//    \
//    但三里屯麦当劳的行为确实违背了诚信\
//    麦当劳的内部卫生规定虽然并未被作为卖点进行宣扬，但洋快餐在中国是便捷和卫生的代名词，却是不争的事实。谁也不是活雷锋，麦当劳制定的严苛内部标准，为的是树立自己的品牌优势，进而在市场定位上取得明显的价格优势，或者说让自己“贵得有理由”。但如果他的员工在执行上不能贯彻这一企业标准，相对于其价格水平而言，就有欺诈和损害消费者权益之嫌，这也是不言而喻的。从这个意义上来说，央视曝光麦当劳的问题并无不妥，麦当劳至少涉嫌消费欺诈，因为它没有向消费者提供它向人们承诺的标准的食品。也就是说，工商部门而非食品卫生监管部门约谈麦当劳，也并非师出无名。";
//    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
//    WXWebpageObject *ext = [WXWebpageObject object];
//    ext.webpageUrl = @"http://view.news.qq.com/zt2012/mdl/index.htm";
//    message.mediaObject = ext;
//    SendMessageToWXReq* req =[[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    req.message = message;
//    req.scene = scene;
//    [WXApi sendReq:req];
}
@end
