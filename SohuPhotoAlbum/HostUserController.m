//
//  HostUserController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-23.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "HostUserController.h"
#import "AppDelegate.h"
#import "HostUserCell.h"
#import "RequestManager.h"
#import "PhotoWallController.h"

@interface HostUserController()
@property(nonatomic,strong)NSMutableArray * dataSourceArray;
@end
@implementation HostUserController
@synthesize dataSourceArray = _dataSourceArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = LOCALBACKGORUNDCOLOR;
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _refresHeadView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -60, 320, 60) arrowImageName:nil textColor:[UIColor grayColor] backGroundColor:[UIColor clearColor]];
    _refresHeadView.delegate = self;
    [self.myTableView addSubview:_refresHeadView];
    [self.view addSubview:self.myTableView];
    
    _moreFootView = [[SCPMoreTableFootView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) WithLodingImage:[UIImage imageNamed:@"load_more_pics.png"] endImage:[UIImage imageNamed:@"end_bg.png"] WithBackGroud:[UIColor clearColor]];
    _moreFootView.delegate = self;
    selectedArray = [NSMutableArray arrayWithCapacity:0];
    _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    [self refrshDataFromNetWork];
}
#pragma mark - CusNavigatinBar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_cusBar){
        _cusBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        _cusBar.normalBar.image = [UIImage imageNamed:@"navbarnoline.png"];
        _cusBar.nLabelText.text = @"星用户";
        [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
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

#pragma mark refrshDataFromNetWork
- (void)refrshDataFromNetWork
{
    [RequestManager getRecomendusersWithsuccess:^(NSString *response) {
        [_dataSourceArray removeAllObjects];
        [self addDataSourceWithArray:[[response JSONValue] objectForKey:@"users"]];
        [self doneRefrshLoadingTableViewData];
    } failure:^(NSString *error) {
        [self doneRefrshLoadingTableViewData];

    }];
}
- (void)getMoreFromNetWork
{
    [self doneMoreLoadingTableViewData];
}
- (void)addDataSourceWithArray:(NSArray *)array
{
    for (int i = 0; i < array.count; i++)
        [_dataSourceArray addObject:[self getDataSourceFromInfo:[array objectAtIndex:i]]];
    [self.myTableView reloadData];
}
- (HostUserCellDataSource *)getDataSourceFromInfo:(NSDictionary *)info
{
    HostUserCellDataSource * dataSource = [[HostUserCellDataSource alloc] init];
    dataSource.userId = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
    dataSource.userName = [info objectForKey:@"nick"];
    dataSource.accountName = [NSString stringWithFormat:@"@%@",[info objectForKey:@"sname"]];
    dataSource.portrait = [info objectForKey:@"avatar"];
    return dataSource;
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
    [_moreFootView scpMoreScrollViewDidScroll:scrollView isAutoLoadMore:YES WithIsLoadingPoint:&_isLoading];
}

#pragma mark - tableViewdelgate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = LOCALBACKGORUNDCOLOR;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"HostCell";
    HostUserCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[HostUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.dataSource = [_dataSourceArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark Action
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload
{
    if (button.tag == LEFTBUTTON) {
        [self.viewDeckController toggleLeftViewAnimated:YES];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HostUserCellDataSource * souece = [_dataSourceArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[[PhotoWallController alloc] initWithOwnerID:souece.userId isRootController:NO] animated:YES];
}
@end
