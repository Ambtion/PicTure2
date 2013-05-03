//
//  RootViewController.m
//  test
//
//  Created by sohu on 13-4-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PhotoWallController.h"
#import "PhotoStoryController.h"
#import "RequestManager.h"
#import "CommentController.h"

@implementation PhotoWallController
@synthesize ownerID;
- (id)initWithOwnerID:(NSString *)ownID
{
    self = [super init];
    if (self) {
        self.ownerID = ownID;
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
    _refresHeadView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -60, 320, 60) arrowImageName:nil textColor:[UIColor redColor] backGroundColor:[UIColor clearColor]];
    _refresHeadView.delegate = self;
    [_myTableView addSubview:_refresHeadView];
    [self.view addSubview:_myTableView];
    _moreFootView = [[SCPMoreTableFootView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) WithLodingImage:[UIImage imageNamed:@"load_more_pics.png"] endImage:[UIImage imageNamed:@"end_bg.png"] WithBackGroud:[UIColor clearColor]];
    _moreFootView.delegate = self;
    _myTableView.tableFooterView = _moreFootView;
    
    _timelabel = [[TimeLabelView alloc] initWithFrame:CGRectMake(320 - 78, 10, 77, 20)];
    [_timelabel setHidden:YES];
    [self.view addSubview:_timelabel];
    
    [self initContainer];
    [self getMoreFromNetWork];
  
}
- (void)initContainer
{
    _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
}
- (void)addDataSourceWith:(NSArray *)array
{
    for (int i = 0; i < array.count; i++) {
        [_dataSourceArray addObject:[self getCellDataSourceFromDic:[array objectAtIndex:i]]];
    }
    [self resetLabel];
    [_myTableView reloadData];
}
- (PhotoWallCellDataSource *)getCellDataSourceFromDic:(NSDictionary *)dic
{
    PhotoWallCellDataSource * dataSource = [[PhotoWallCellDataSource alloc] init];
    dataSource.wallId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    NSArray * phtotArray = [dic objectForKey:@"photos"];
    dataSource.imageWallInfo = phtotArray;
    dataSource.wallDescription = nil;
    dataSource.shareTime = [self stringFromdate:[NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"updated_at"] longLongValue]/ 1000.f]];
    dataSource.likeCount = 100;
    dataSource.talkCount = 200;
    dataSource.photoCount = [[dic objectForKey:@"photo_num"] intValue];
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
        [_navBar.nLeftButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [_navBar.nLabelText setText:@"图片墙"];
        [_navBar.nRightButton1 setImage:[UIImage imageNamed:@"shareBtn_nomal.png"] forState:UIControlStateNormal];
    }
    if (!_navBar.superview)
        [self.navigationController.navigationBar addSubview:_navBar];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_navBar removeFromSuperview];
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
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

- (void)refeshOnce:(id)sender
{
    [_refresHeadView refreshImmediately];
    [self reloadTableViewDataSource];
    [self resetLabel];

}

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
    [RequestManager getTimePhtotWallStorysWithOwnerId:self.ownerID start:0 count:20 success:^(NSString *response) {
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
    [RequestManager getTimePhtotWallStorysWithOwnerId:self.ownerID start:[_dataSourceArray count] count:20 success:^(NSString *response) {
        [self addDataSourceWith:[[response JSONValue] objectForKey:@"portfolios"]];
        [self doneMoreLoadingTableViewData];
    } failure:^(NSString *error) {
        [self doneMoreLoadingTableViewData];
    }];
}

#pragma mark TableView Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refresHeadView egoRefreshScrollViewDidEndDragging:scrollView];
    [_moreFootView scpMoreScrollViewDidEndDragging:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updataLabelWithScrollView:scrollView];
    [_refresHeadView egoRefreshScrollViewDidScroll:scrollView];
    [_moreFootView scpMoreScrollViewDidScroll:scrollView];
    if (scrollView.contentSize.height - scrollView.frame.size.height -  scrollView.contentOffset.y < 100) {
        [_moreFootView moreImmediately];
        _isLoading = YES;
    }
}
- (void)resetLabel
{
    if (_dataSourceArray.count) {
        [_timelabel setHidden:NO];
        [self setLabelTimeWithTime:[[_dataSourceArray objectAtIndex:0] shareTime]];
    }else{
        _timelabel.daysLabel.text = nil;
        _timelabel.mouthsLabel.text = nil;
        _timelabel.yesDayLabel.text = nil;
    }
}
- (void)updataLabelWithScrollView:(UIScrollView *)aScrollView
{
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
    CGFloat ratioInTableView = pointY / _myTableView.contentSize.height;
    CGRect rect = _timelabel.frame;
    rect.origin.y = _myTableView.frame.origin.y + rect.size.height / 2.f + ratioInTableView * (_myTableView.frame.size.height - rect.size.height - _myTableView.tableFooterView.frame.size.height - rect.size.height / 2.f);
    return rect;
}

#pragma mark DataSource
- (PhotoWallCellDataSource *)dataScourForindexPath:(NSIndexPath *)path
{
    if (!_dataSourceArray.count) return nil;
    return [_dataSourceArray objectAtIndex:path.row];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoWallCellDataSource * dataSoure = [self dataScourForindexPath:indexPath];
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
    if (!cell) {
        cell = [[PhotoWallCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifierNum:num];\
        cell.delegate = self;
    }
//    DLog(@"data %d : frame:%@",dataSoure.imageWallInfo.count,cell.reuseIdentifier);
    cell.dataSource = dataSoure;
    return cell;
}
#pragma mark Action
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload
{
    if (button.tag == LEFTBUTTON) {
        [self.viewDeckController toggleLeftViewAnimated:YES];
    }
    if (button.tag == RIGHT1BUTTON) { //分享
        
    }
}
- (void)photoWallCell:(PhotoWallCell *)cell talkClick:(UIButton *)button
{
//    DLog(@"%s",__FUNCTION__);
    [self.navigationController pushViewController:[[CommentController alloc] init] animated:YES];
}
- (void)photoWallCell:(PhotoWallCell *)cell likeClick:(UIButton *)button
{
    DLog(@"%s",__FUNCTION__);
}
- (void)photoWallCell:(PhotoWallCell *)cell photosClick:(id)sender
{    
    PhotoWallCellDataSource * source = cell.dataSource;
    [self.navigationController pushViewController:[[PhotoStoryController alloc] initWithStoryId:source.wallId ownerID:self.ownerID] animated:YES];
}

@end
