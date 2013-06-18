//
//  CloudAlbumController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-6-17.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CloudAlbumController.h"

@interface CloudAlbumController ()
//总的专辑资源
@property(nonatomic,strong)NSMutableArray *assetGroups;
//对应的tableview的分类资源
@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@end

@implementation CloudAlbumController
@synthesize assetGroups;
@synthesize dataSourceArray;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.backgroundColor = LOCALBACKGORUNDCOLOR;
    _refreshTableView = [[EGRefreshTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _refreshTableView.pDelegate = self;
    _refreshTableView.dataSource = self;
    [self.view addSubview:_refreshTableView];
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
}

#pragma mark
- (void)pullingreloadTableViewDataSource:(id)sender
{
    [_refreshTableView performSelector:@selector(didFinishedLoadingTableViewData) withObject:nil afterDelay:0.3];
}
- (void)pullingreloadMoreTableViewData:(id)sender
{
    [_refreshTableView performSelector:@selector(didFinishedLoadingTableViewData) withObject:nil afterDelay:0.3];
}

- (void)refreshDataSoureRatherThenGetMore:(BOOL)isRefresh
{
    if (isRefresh)
        self.dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i< self.assetGroups.count ; i+=2) {
        PhotoAlbumCellDataSource * dataSource = [[PhotoAlbumCellDataSource alloc] init];
        dataSource.leftGroup = [self.assetGroups objectAtIndex:i];
        if (i+1 < self.assetGroups.count) {
            dataSource.rightGroup = [self.assetGroups objectAtIndex:i+1];
        }else{
            dataSource.rightGroup = nil;
        }
        [self.dataSourceArray addObject:dataSource];
    }
    [_refreshTableView reloadData];
}

#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //性能
    return [PhotoAlbumCellDataSource cellHight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"CELLID";
    PhotoAlbumCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell  = [[PhotoAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate  = self;
    }
    if (indexPath.row < self.dataSourceArray.count)
        cell.dataSource =[self.dataSourceArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = LOCALBACKGORUNDCOLOR;
}

#pragma mark CellDelegate
- (void)photoAlbumCell:(PhotoAlbumCell *)photoCell clickCoverGroup:(id)group
{
    if ([group isKindOfClass:[NSDictionary class]]) {
        
    }
}


@end
