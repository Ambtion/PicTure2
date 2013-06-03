//
//  RootViewController.m
//  test
//
//  Created by sohu on 13-4-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PhotoWallController.h"
#import "PhotoStoryController.h"
#import "CommentController.h"
#import "LoginStateManager.h"

@implementation PhotoWallController
@synthesize ownerID;

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (id)initWithOwnerID:(NSString *)ownID isRootController:(BOOL)isRoot
{
    self = [super init];
    if (self) {
        self.ownerID = ownID;
        _isRoot = isRoot;
    }
    return self;
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorColor = [UIColor clearColor];
    _myTableView.backgroundColor = BASEWALLCOLOR;

    _myTableView.showsVerticalScrollIndicator = NO;
    _refresHeadView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -60, 320, 60) arrowImageName:nil textColor:[UIColor grayColor] backGroundColor:[UIColor clearColor]];
    _refresHeadView.delegate = self;
    [_myTableView addSubview:_refresHeadView];
    [self.view addSubview:_myTableView];
    _moreFootView = [[SCPMoreTableFootView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) WithLodingImage:[UIImage imageNamed:@"load_more_pics.png"] endImage:[UIImage imageNamed:@"end_bg.png"] WithBackGroud:[UIColor clearColor]];
    _moreFootView.delegate = self;
    //    _myTableView.tableFooterView = _moreFootView;
    _timelabel = [[TimeLabelView alloc] initWithFrame:CGRectMake(320 - 78, 5, 77, 20)];
    [_timelabel setHidden:YES];
    [self.view addSubview:_timelabel];
    
    [self initContainer];
    [self refrshDataFromNetWork];
    
}
- (void)initContainer
{
    _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
}
- (void)addDataSourceWith:(NSArray *)array
{
    if (array.count)
        DLog(@"ownId:%@ %@",ownerID,[array lastObject]);
    for (int i = 0; i < array.count; i++) {
        PhotoWallCellDataSource * source = [self getCellDataSourceFromDic:[array objectAtIndex:i]];
        if (source)
            [_dataSourceArray addObject:source];
    }
    [self resetLabel];
    [_myTableView reloadData];
}
- (PhotoWallCellDataSource *)getCellDataSourceFromDic:(NSDictionary *)dic
{
    PhotoWallCellDataSource * dataSource = [[PhotoWallCellDataSource alloc] init];
    dataSource.wallId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    dataSource.showId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"show_id"]];
    NSArray * phtotArray = [dic objectForKey:@"photos"];
    if (!phtotArray || !phtotArray.count) return nil;
    dataSource.imageWallInfo = phtotArray;
    dataSource.wallDescription = [dic objectForKey:@"description"];
    dataSource.stroyName = [dic objectForKey:@"name"];
    dataSource.shareTime = [self stringFromdate:[NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"updated_at"] longLongValue]/ 1000.f]];
    dataSource.likeCount = [[dic objectForKey:@"like_count"] intValue];
    dataSource.talkCount =[[dic objectForKey:@"comment_num"] intValue];
    dataSource.photoCount = [[dic objectForKey:@"photo_num"] intValue];
    dataSource.isLiking = [[dic objectForKey:@"is_liked"] boolValue];
    dataSource.isMine = [self isMineWithOwnerId:self.ownerID];
    return dataSource;
}

- (NSString *)stringFromdate:(NSDate *)date
{
    //转化日期格式
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyy-MM-dd-hh:mma"];
    return [dateFormatter stringFromDate:date];
}
#pragma mark View LifeCircle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_navBar){
        _navBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        [_navBar.nLabelText setText:@"图片墙"];
        [_navBar.nRightButton1 setImage:[UIImage imageNamed:@"shareBtn_nomal.png"] forState:UIControlStateNormal];
    }
    if (_isRoot) {
        [_navBar.nLeftButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    }else{
        [_navBar.nLeftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    }
    if (![self isMineWithOwnerId:self.ownerID]) {
        [_navBar.nLabelText setText:nil];
        if (!_titleAccoutView) {
            _titleAccoutView = [[TitleAccountView alloc] initWithFrame:CGRectMake(46, 0, 200, 44)];
            _titleAccoutView.userId = self.ownerID;
            [_navBar addSubview:_titleAccoutView];
        }
    }
    [self getuserInfoWithRefresh:NO];
    if (!_navBar.superview)
        [self.navigationController.navigationBar addSubview:_navBar];
    
}

- (void)getuserInfoWithRefresh:(BOOL)isRefresh
{
    if (!isRefresh){
        [_titleAccoutView refreshUserInfoWithDic:_userInfo];
        return;
    }
    [RequestManager getUserInfoWithId:self.ownerID  success:^(NSString *response) {
        _userInfo = [response JSONValue];
        if (_titleAccoutView) {
            [_titleAccoutView refreshUserInfoWithDic:_userInfo];
        }
    } failure:^(NSString *error) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationItem setHidesBackButton:YES];
    if (!_pushView) {
        [_navBar removeFromSuperview];
        _pushView = NO;
    }
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
}
- (void)viewDidDisappear:(BOOL)animated
{
//    [super viewWillDisappear:animated];
    [_navBar removeFromSuperview];
}
#pragma mark - refresh
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
    [_refresHeadView egoRefreshScrollViewDataSourceDidFinishedLoading:_myTableView];
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
//    [self resetLabel];
//}
//
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
    [_moreFootView scpMoreScrollViewDataSourceDidFinishedLoading:_myTableView];
}

#pragma mark refrshDataFromNetWork
- (void)refrshDataFromNetWork
{
    NSString * token = nil;
    if ([LoginStateManager isLogin])
        token = [LoginStateManager currentToken];
    [self getuserInfoWithRefresh:YES];
    [RequestManager getTimePhtotWallStorysWithOwnerId:self.ownerID withAccessToken:token start:0 count:20  success:^(NSString *response) {
        [_dataSourceArray removeAllObjects];
        [self addDataSourceWith:[[response JSONValue] objectForKey:@"portfolios"]];
        [self doneRefrshLoadingTableViewData];
    } failure:^(NSString *error) {
        [self doneRefrshLoadingTableViewData];
    }];
}

- (void)getMoreFromNetWork
{
    if (_dataSourceArray.count % 20 != 0) {
        [_moreFootView setMoreFunctionOff:YES];
        [self doneMoreLoadingTableViewData];
        return;
    }
    [_moreFootView setMoreFunctionOff:NO];
    NSString * token = nil;
    if ([LoginStateManager isLogin])
        token = [LoginStateManager currentToken];
    [RequestManager getTimePhtotWallStorysWithOwnerId:self.ownerID withAccessToken:token start:[_dataSourceArray count] count:20 success:^(NSString *response) {
        [self addDataSourceWith:[[response JSONValue] objectForKey:@"portfolios"]];
        [self doneMoreLoadingTableViewData];
    } failure:^(NSString *error) {
        [self doneMoreLoadingTableViewData];
    }];
}

#pragma mark TableView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_timelabel  setHidden:YES];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refresHeadView egoRefreshScrollViewDidEndDragging:scrollView];
    [_moreFootView scpMoreScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( scrollView.contentSize.height >= scrollView.frame.size.height)
        [self updataLabelWithScrollView:scrollView];
    [_refresHeadView egoRefreshScrollViewDidScroll:scrollView];
    [_moreFootView scpMoreScrollViewDidScroll:scrollView isAutoLoadMore:YES WithIsLoadingPoint:&_isLoading];
}

- (void)resetLabel
{
    if (_dataSourceArray.count) {
        [self setLabelTimeWithTime:[[_dataSourceArray objectAtIndex:0] shareTime]];
    }else{
        [_timelabel setHidden:YES];
        _timelabel.daysLabel.text = nil;
        _timelabel.mouthsLabel.text = nil;
        _timelabel.yesDayLabel.text = nil;
    }
}

- (void)updataLabelWithScrollView:(UIScrollView *)aScrollView
{
    if (!_dataSourceArray.count) {
        [self resetLabel];
        return;
    }
    [_timelabel  setHidden:NO];
    NSArray * cells = _myTableView.visibleCells;
    _timelabel.frame = [self getLabelRectWithOffset:aScrollView.contentOffset.y];
    for (PhotoWallCell * cell in cells) {
        CGRect cellRect = [self.view convertRect:cell.frame fromView:cell.superview];
        if (CGRectContainsRect(cellRect, _timelabel.frame)) {
            NSString * shareTime = [[cell dataSource] shareTime];
            [self setLabelTimeWithTime:shareTime];
        }
    }
}

- (void)setLabelTimeWithTime:(NSString *)time
{
    NSArray * array = [time componentsSeparatedByString:@"-"];
    _timelabel.daysLabel.text = [array objectAtIndex:2];
    _timelabel.yesDayLabel.text = [NSString stringWithFormat:@"%@年",[array objectAtIndex:0]];
    _timelabel.mouthsLabel.text = [NSString stringWithFormat:@"%@月",[array objectAtIndex:1]];
}
- (CGRect)getLabelRectWithOffset:(CGFloat)pointY
{
    CGFloat ratioInTableView = pointY / (_myTableView.contentSize.height - _myTableView.frame.size.height);
    CGRect rect = _timelabel.frame;
    rect.origin.y = _myTableView.frame.origin.y + 5 + ratioInTableView * (_myTableView.frame.size.height - rect.size.height - 10);
    return rect;
}

#pragma mark DataSource
- (PhotoWallCellDataSource *)dataScourForindexPath:(NSIndexPath *)path
{
    if (!_dataSourceArray.count || path.row >= _dataSourceArray.count) return nil;
    return [_dataSourceArray objectAtIndex:path.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoWallCellDataSource * dataSoure = [self dataScourForindexPath:indexPath];
    if (!dataSoure) return 0.f;
    if (indexPath.row == _dataSourceArray.count - 1) {
        return [dataSoure  getLastCellHeigth];
    }
    return dataSoure ? [dataSoure getCellHeigth]: 0.f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = BASEWALLCOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoWallCellDataSource * dataSoure = [self dataScourForindexPath:indexPath];
    NSInteger num = [dataSoure numOfCellStragey];
    PhotoWallCell * cell = [tableView dequeueReusableCellWithIdentifier:identify[num]];
    if (cell == nil) {
        cell = [[PhotoWallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifierNum:num];
        cell.delegate = self;
//        cell.dataSource = dataSoure;
//        [cell resetImageWithAnimation:YES];
    }
    cell.dataSource = dataSoure;
    return cell;
}
#pragma mark Share
- (void)showShareView
{
    if (!_dataSourceArray.count) return;
    if (!_shareBox){
        _shareBox = [[ShareBox alloc] init];
        _shareBox.delegate = self;
    }
    [_shareBox showShareViewWithWeixinShow:YES photoWall:NO andWriteImage:NO OnView:self.view];
}
- (void)shareBoxViewWeiXinShareToScene:(enum WXScene)scene
{
    [self respNewsContentToSence:scene];
}

- (void)shareBoxViewShareTo:(KShareModel)model
{
    _pushView = YES;
    PhotoWallCellDataSource * source = [_dataSourceArray objectAtIndex:0];
    NSString * photoString = [NSString stringWithFormat:@"%@",[[source.imageWallInfo objectAtIndex:0] objectForKey:@"photo_url"]];
    [self.navigationController pushViewController:[[ShareViewController alloc] initWithModel:model bgPhotoUrl:photoString andDelegate:self] animated:YES];
}

- (void)shareViewcontrollerDidShareClick:(ShareViewController *)controller withDes:(NSString *)des shareMode:(KShareModel)model
{
    //分享
    [RequestManager shareUserHomeWithAccesstoken:[LoginStateManager currentToken] ownerId:self.ownerID share_to:model shareAccestoken:[[LoginStateManager getTokenInfo:model] objectForKey:@"access_token"] desc:des success:^(NSString *response) {
        [self.navigationController popViewControllerAnimated:YES];
        [self showPopAlerViewRatherThentasView:NO WithMes:@"分享成功"];
    } failure:^(NSString *error) {
        [self.navigationController popViewControllerAnimated:YES];
        [self showPopAlerViewRatherThentasView:NO WithMes:error];
    }];
}

- (void) respNewsContentToSence:(enum WXScene)scene
{
    NSString * contentURl = [NSString stringWithFormat:@"http://pp.sohu.com/u/%@",self.ownerID];
    NSString * title = [NSString stringWithFormat:@"分享%@的图片墙",[_userInfo objectForKey:@"user_nick"]];
    PhotoWallCellDataSource * source = [_dataSourceArray objectAtIndex:0];
    NSString * photoUrl = [[[source imageWallInfo] objectAtIndex:0] objectForKey:@"photo_url"];
    [self shareNewsToWeixinWithUrl:contentURl ToSence:scene Title:title photoUrl:photoUrl des:[_userInfo objectForKey:@"user_desc"]];
}
- (void)onResp:(BaseResp *)resp
{
    if (resp.errCode == 0) {
        [self showPopAlerViewRatherThentasView:NO WithMes:@"分享成功"];
    }else{
        [self showPopAlerViewRatherThentasView:NO WithMes:@"分享失败"];
    }
}

#pragma mark Action
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload
{
    if (button.tag == LEFTBUTTON) {
        if (_isRoot)
            [self.viewDeckController toggleLeftViewAnimated:YES];
        else
            [self.navigationController popViewControllerAnimated:YES];
    }
    if (button.tag == RIGHT1BUTTON) { //分享
        [self showShareView];
    }
}

- (void)photoWallCell:(PhotoWallCell *)cell talkClick:(UIButton *)button
{
    if (![LoginStateManager isLogin]) {
        [self showLoginViewWithMethodNav:YES];
        return;
    }
    NSDictionary * dic = [[[cell dataSource] imageWallInfo] objectAtIndex:0];
    NSString * urlStr = [dic objectForKey:@"photo_url"];
    [self.navigationController pushViewController:[[CommentController alloc] initWithSourceId:[[cell dataSource] wallId] andSoruceType:KSourcePortfolios withBgImageURL:urlStr WithOwnerID:self.ownerID] animated:YES];
}
- (void)photoWallCell:(PhotoWallCell *)cell deleteClick:(UIButton *)button
{
    tempCellForDelete = cell;
    [self showDeleteView];
}
#pragma mark  Delete
- (void)showDeleteView
{
    PopAlertView * alertView = [[PopAlertView alloc] initWithTitle:nil message:@"确认删除图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
    [alertView show];
    return;
}
- (void)popAlertView:(PopAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //若出现,这是个人页面
        [RequestManager deleteStoryFromWallWithaccessToken:[LoginStateManager currentToken] StoryId:[tempCellForDelete.dataSource wallId] success:^(NSString *response) {
            [self showPopAlerViewRatherThentasView:NO WithMes:@"删除成功"];
            [_dataSourceArray removeObject:tempCellForDelete.dataSource];
            NSIndexPath * path =  [_myTableView indexPathForCell:tempCellForDelete];
            [_myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
            [self updataLabelWithScrollView:_myTableView];
            //删除成功
        }  failure:^(NSString *error) {
            [self showPopAlerViewRatherThentasView:NO WithMes:@"删除失败"];
        }];
    }
}

- (void)photoWallCell:(PhotoWallCell *)cell likeClick:(UIButton *)button
{
    if (![LoginStateManager isLogin]) {
        [self showLoginViewWithMethodNav:YES];
        return;
    }
    if (cell.dataSource.isLiking) {
        [RequestManager unlikeWithSourceId:[[cell dataSource] wallId] source:KSourcePortfolios OwnerID:self.ownerID Accesstoken:[LoginStateManager currentToken] success:^(NSString *response) {
            cell.dataSource.isLiking = NO;
            cell.dataSource.likeCount--;
            cell.dataSource.likeCount = MAX(cell.dataSource.likeCount, 0);
            [cell updataLikeState];
        } failure:^(NSString *error) {
            
        }];
    }else{
        [RequestManager likeWithSourceId:[[cell dataSource] wallId] source:KSourcePortfolios OwnerID:self.ownerID Accesstoken:[LoginStateManager currentToken] success:^(NSString *response) {
            cell.dataSource.isLiking = YES;
            cell.dataSource.likeCount ++;
            [cell updataLikeState];
        } failure:^(NSString *error) {
            
        }];
    }
}
- (void)photoWallCell:(PhotoWallCell *)cell photosClick:(id)sender
{
    PhotoWallCellDataSource * source = cell.dataSource;
    PhotoStoryController * phS = [[PhotoStoryController alloc] initWithStoryId:source.wallId ownerID:self.ownerID];
    phS.showID = source.showId;
    phS.storyName = source.stroyName;
    phS.storyDes = source.wallDescription;
    phS.userInfo = _userInfo;
    [self.navigationController pushViewController:phS animated:YES];
}

@end
