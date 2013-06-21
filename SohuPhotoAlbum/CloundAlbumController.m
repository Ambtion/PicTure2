//
//  CloudAlbumController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-6-17.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CloundAlbumController.h"
#import "CloundAlbumPhotosController.h"
#import "LeftMenuController.h"
#import "CQSegmentControl.h"

@interface CloundAlbumController ()
//总的专辑资源
@property(nonatomic,strong)NSMutableArray *assetGroups;
//对应的tableview的分类资源
@property(nonatomic,strong)NSMutableArray * dataSourceArray;

@property(nonatomic,strong)NSMutableArray * selectedArray;
@end

@implementation CloundAlbumController
@synthesize assetGroups;
@synthesize dataSourceArray;
@synthesize selectedArray = _selectedArray;
@synthesize viewState = _viewState;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = LOCALBACKGORUNDCOLOR;
    _refreshTableView = [[EGRefreshTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _refreshTableView.pDelegate = self;
    _refreshTableView.dataSource = self;
    [self.view addSubview:_refreshTableView];
    _selectedArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self refreshFromNetWork];
}
- (void)addsegmentOnView:(UIView *)view
{
    if (!segControll) {
        NSArray * items = [NSArray arrayWithObjects:@"手机备份",@"网络相册", nil];
        segControll = [[CQSegmentControl alloc] initWithItemsAndStype:items stype:TitleAndImageSegmented];
        [segControll addTarget:self action:@selector(segMentChnageValue:) forControlEvents:UIControlEventValueChanged];
        segControll.frame = CGRectMake(83, 8, 154, 27);
        segControll.selectedSegmentIndex = 1;
    }
    if (segControll.superview != view)
        [view addSubview:segControll];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!_cusBar){
        _cusBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [_cusBar.nRightButton1 setHidden:YES];
        [_cusBar.sRightStateButton setImage:[UIImage imageNamed:@"ensure.png"] forState:UIControlStateNormal];
        [self addsegmentOnView:_cusBar];
    }
    if (!_cusBar.superview)
        [self.navigationController.navigationBar addSubview:_cusBar];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    segControll.selectedSegmentIndex = 1;
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [_cusBar removeFromSuperview];
//}
#pragma mark
- (void)pullingreloadTableViewDataSource:(id)sender
{
    [self refreshFromNetWork];
}
- (void)pullingreloadMoreTableViewData:(id)sender
{
    [self getMoreFromNetWork];
}

- (void)refreshDataSoure:(NSArray *)soureArray RatherThenGetMore:(BOOL)isRefresh
{
    if (isRefresh)
        self.assetGroups = [NSMutableArray arrayWithCapacity:0];
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    [self.assetGroups addObjectsFromArray:soureArray];
    
    for (int i = 0; i< self.assetGroups.count ; i+=2 ) {
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

- (void)refreshFromNetWork
{
    [RequestManager getFoldersWithAccessToken:[LoginStateManager currentToken] start:0 count:20 success:^(NSString *response) {
        NSArray * array = [[response JSONValue] objectForKey:@"folders"];
        DLog(@"array %@",[array lastObject]);
        [self refreshDataSoure:array RatherThenGetMore:YES];
        [_refreshTableView didFinishedLoadingTableViewData];
    } failure:^(NSString *error) {
        [self showPopAlerViewRatherThentasView:NO WithMes:error];
        [_refreshTableView didFinishedLoadingTableViewData];
    }];
}

- (void)getMoreFromNetWork
{
    [RequestManager getFoldersWithAccessToken:[LoginStateManager currentToken] start:assetGroups.count  count:20 success:^(NSString *response) {
        NSArray * array = [[response JSONValue] objectForKey:@"folders"];
        [self refreshDataSoure:array RatherThenGetMore:NO];
        [_refreshTableView didFinishedLoadingTableViewData];
    } failure:^(NSString *error) {
        [self showPopAlerViewRatherThentasView:NO WithMes:error];
        [_refreshTableView didFinishedLoadingTableViewData];
    }];
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
    [cell showNomalState:_viewState == NomalState];
    [cell isSelectedinSeletedArray:_selectedArray];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = LOCALBACKGORUNDCOLOR;
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

#pragma mark CellDelegate

- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload
{
    if (button.tag == LEFTBUTTON) {
        [self.viewDeckController toggleLeftViewAnimated:YES];
    }
    if (button.tag == CANCELBUTTONTAG) {        //取消
        [self setViewState:NomalState];
    }
    if (button.tag == RIGHTSELECTEDTAG) {       //确认
        [self handleEnsureClick];
    }
}

- (void)segMentChnageValue:(UISegmentedControl *)seg
{
    DLog(@"%d",seg.selectedSegmentIndex);
    if (seg.selectedSegmentIndex == 1) {
        return;
    }
    LeftMenuController * leftCon = (LeftMenuController *)self.viewDeckController.leftController;
    self.viewDeckController.centerController = leftCon.cloudController;
}
- (void)photoAlbumCell:(PhotoAlbumCell *)photoCell clickCoverGroup:(id)group
{
    if ([group isKindOfClass:[NSDictionary class]]) {
        if (_viewState == NomalState) {
            NSString * folderId = [NSString stringWithFormat:@"%@",[group objectForKey:@"id"]];
            NSString * _folderName = [group objectForKey:@"folder_name"];
            [self.navigationController pushViewController:[[CloundAlbumPhotosController alloc] initWithFoldersId:folderId folderName:_folderName] animated:YES];
        }else{
            [_selectedArray removeAllObjects];
            if ([_selectedArray containsObject:group]){
                [_selectedArray removeObject:group];
            }else{
                [_selectedArray addObject:group];
            }
            [_refreshTableView reloadData];
        }
    }
}
- (void)handleEnsureClick
{
    if (!_selectedArray.count) {
        [self showPopAlerViewRatherThentasView:YES WithMes:@"请选择图片"];
        return;
    }
//    if (_viewState == DeleteState) {
//        [self showDeletePhotoesView];
//        return;
//    }
}

//#pragma mark - Delete Photos
//- (void)showDeletePhotoesView
//{
//    PopAlertView * alertView = [[PopAlertView alloc] initWithTitle:nil message:@"确认删除相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
//    [alertView show];
//    return;
//}
//- (void)popAlertView:(PopAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        [RequestManager deleteFoldersWithAccessToken:[LoginStateManager currentToken] folderId:[[_selectedArray lastObject] valueForKey:@"id"] success:^(NSString *response){
//             [self refreshFromNetWork];
//             [self showPopAlerViewRatherThentasView:NO WithMes:@"删除成功"];
//             [self setViewState:NomalState];
//         } failure:^(NSString *error) {
//             [self showPopAlerViewRatherThentasView:NO WithMes:@"删除失败"];
//             [self setViewState:NomalState];
//         }];
//    }
//}

@end
