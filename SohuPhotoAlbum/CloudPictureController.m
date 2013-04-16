//
//  CloudPictureController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CloudPictureController.h"

@interface CloudPictureController()
@property(strong,nonatomic)NSMutableArray * dataSourceArray;
@property(strong,nonatomic)NSMutableArray * selectedArray;
@end

@implementation CloudPictureController
@synthesize dataSourceArray = _dataSourceArray;
@synthesize selectedArray = _selectedArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGORUNDCOLOR;
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _refresHeadView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -60, 320, 60) arrowImageName:nil textColor:[UIColor redColor]];
    _refresHeadView.delegate = self;
    [_myTableView addSubview:_refresHeadView];
    [self.view addSubview:_myTableView];
    
    _moreFootView = [[SCPMoreTableFootView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) WithLodingImage:[UIImage imageNamed:@"load_more_pics.png"] endImage:[UIImage imageNamed:@"end_bg.png"]];
    _moreFootView.delegate = self;
    _myTableView.tableFooterView = _moreFootView;
    _selectedArray = [NSMutableArray arrayWithCapacity:0];
    
    //dataSource
    _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < 100; i++)
        [_dataSourceArray addObject:@"mmm"];
    
    [_myTableView reloadData];
}

#pragma mark View LifeCircle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_navBar){
        _navBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        [_navBar.nLeftButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [_navBar.nLabelText setText:@"云备份"];
        [_navBar.nRightButton1 setImage:[UIImage imageNamed:@"full_screen_share_icon.png"] forState:UIControlStateNormal];
        
        //上传按钮
        [_navBar.nRightButton2 setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [_navBar.nRightButton3 setUserInteractionEnabled:NO];
        [_navBar.sRightStateButton setImage:[UIImage imageNamed:@"YES.png"] forState:UIControlStateNormal];
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
    [self performSelector:@selector(doneRefrshLoadingTableViewData) withObject:nil afterDelay:3];
}
- (void)getMoreFromNetWork
{
    [self performSelector:@selector(doneMoreLoadingTableViewData) withObject:nil afterDelay:3];
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
        [_moreFootView moreImmediately];
        _isLoading = YES;
    }
}
#pragma mark DataSource
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
    if (indexPath.row == [_dataSourceArray count]) {
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
    if (_isSelectedState){
        [cell showCellSelectedStatus];
        [cell cloudPictureCellisShow:[_selectedArray containsObject:cell.dataSource.firstDic] selectedDic:cell.dataSource.firstDic];
        [cell cloudPictureCellisShow:[_selectedArray containsObject:cell.dataSource.secoundDic] selectedDic:cell.dataSource.secoundDic];
        [cell cloudPictureCellisShow:[_selectedArray containsObject:cell.dataSource.thridDic] selectedDic:cell.dataSource.thridDic];
        [cell cloudPictureCellisShow:[_selectedArray containsObject:cell.dataSource.lastDic] selectedDic:cell.dataSource.lastDic];
    }else{
        [cell hiddenCellSelectedStatus];
    }

    cell.dataSource = [[CloudPictureCellDataSource alloc] init];
    return cell;
}
#pragma mark Action
- (void)setViewToSelectedState:(BOOL)selectedState
{
    if (_isSelectedState == selectedState) return;
    _isSelectedState = selectedState;
    [_navBar switchBarStateToUpload:_isSelectedState];
    if (_isSelectedState) {
        self.viewDeckController.panningMode = IIViewDeckNoPanning;
    }else{
        self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    }
    if (_selectedArray.count)
        [_selectedArray removeAllObjects];
    [_myTableView reloadData];
}
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button
{
    if (button.tag == LEFTBUTTON) {
        [self.viewDeckController toggleLeftViewAnimated:YES];
    }
    if (button.tag == RIGHT1BUTTON) {           //分享
        [self setViewToSelectedState:YES];
    }
    if (button.tag == RIGHT2BUTTON) {           //删除
        [self setViewToSelectedState:YES];
    }
    if (button.tag == CANCELBUTTONTAG) {        //取消
        [self setViewToSelectedState:NO];
    }
    if (button.tag == RIGHTSELECTEDTAG) {       //确认

    }
}
- (void)cloudPictureCell:(CloudPictureCell *)cell clickInfo:(NSDictionary *)dic
{
    DLog(@"%s",__FUNCTION__);
}
- (void)cloudPictureCell:(CloudPictureCell *)cell clickInfo:(NSDictionary *)dic Select:(BOOL)isSelected
{
    if (isSelected) {
        [_selectedArray addObject:dic];
    }else if([_selectedArray containsObject:dic]){
        [_selectedArray removeObject:dic];
    }
//    if (_selectedArray.count) {
//        [_navBar.sLabelText setText:[NSString stringWithFormat:@"已选择%d张照片",_selectedArray.count]];
//    }else{
////        [_navBar.sLabelText setText:SLABELTEXT];
//    }
}

@end
