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
    //    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //    self.myTableView.delegate = self;
    //    self.myTableView.dataSource = self;
    //    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _refresHeadView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -60, 320, 60) arrowImageName:nil textColor:[UIColor grayColor] backGroundColor:[UIColor clearColor]];
    //    _refresHeadView.delegate = self;
    //    [self.myTableView addSubview:_refresHeadView];
    //    [self.view addSubview:self.myTableView];
    //
    //    _moreFootView = [[SCPMoreTableFootView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) WithLodingImage:[UIImage imageNamed:@"load_more_pics.png"] endImage:[UIImage imageNamed:@"end_bg.png"] WithBackGroud:[UIColor clearColor]];
    //    _moreFootView.delegate = self;
    _refreshTableView = [[EGRefreshTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _refreshTableView.pDelegate = self;
    _refreshTableView.dataSource = self;
    [self.view addSubview:_refreshTableView];
    _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    [self refrshDataFromNetWork];
}
#pragma mark - CusNavigatinBar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!_cusBar){
        _cusBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        _cusBar.nLabelText.text = @"星用户";
        [_cusBar.nRightButton1 setHidden:YES];
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

#pragma mark refrshDataFromNetWork
- (void)pullingreloadTableViewDataSource:(id)sender
{
    [self refrshDataFromNetWork];
}
- (void)pullingreloadMoreTableViewData:(id)sender
{
    [self getMoreFromNetWork];
}
- (void)refrshDataFromNetWork
{
    [RequestManager getRecomendusersWithsuccess:^(NSString *response) {
        [_dataSourceArray removeAllObjects];
        [self addDataSourceWithArray:[[response JSONValue] objectForKey:@"users"]];
        [_refreshTableView didFinishedLoadingTableViewData];
    } failure:^(NSString *error) {
        [self showPopAlerViewRatherThentasView:NO WithMes:error];
        [_refreshTableView didFinishedLoadingTableViewData];
    }];
}

- (void)getMoreFromNetWork
{
    //星公户一次全部加载,无需更多
    [_refreshTableView didFinishedLoadingTableViewData];
}
- (void)addDataSourceWithArray:(NSArray *)array
{
    for (int i = 0; i < array.count; i++)
        [_dataSourceArray addObject:[self getDataSourceFromInfo:[array objectAtIndex:i]]];
    [_refreshTableView reloadData];
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
