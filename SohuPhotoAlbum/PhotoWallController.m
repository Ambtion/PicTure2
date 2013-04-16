//
//  RootViewController.m
//  test
//
//  Created by sohu on 13-4-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PhotoWallController.h"
#import <ImageIO/ImageIO.h>
@interface PhotoWallController ()

@end

@implementation PhotoWallController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    //测试用
//    UIBarButtonItem * bu = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(refeshOnce:)];
//    self.navigationItem.leftBarButtonItem = bu;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 120, 20)];
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];

    
    _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 20; i++) {
        PhotoWallCellDataSource * dataSource = [[PhotoWallCellDataSource alloc] init];
        int n = arc4random() % 6 + 1;
        NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
        for (int j = 1; j <= n; j++) {
            [tempArray addObject:@"1.jpg"];
        }
        dataSource.imageWallInfo = tempArray;
        dataSource.wallDescription = @"我啦对法拉第飞啊记得发,你是挨打发对法拉飞.挨打放假的了";
        dataSource.shareTime = [NSString stringWithFormat:@"2013年12月%d日",i];
        dataSource.likeCount = 100;
        dataSource.talkCount = 200;
        [_dataSourceArray addObject:dataSource];
    }
    [self resetLabel];
    [_myTableView reloadData];
}

#pragma mark View LifeCircle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_navBar){
        _navBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        [_navBar.nLeftButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [_navBar.nLabelText setText:@"图片墙"];
        [_navBar.nRightButton1 setImage:[UIImage imageNamed:@"full_screen_share_icon.png"] forState:UIControlStateNormal];
        
//        //上传按钮
//        [_navBar.nRightButton2 setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
//        [_navBar.nRightButton3 setUserInteractionEnabled:NO];
//        [_navBar.sRightStateButton setImage:[UIImage imageNamed:@"YES.png"] forState:UIControlStateNormal];
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
    [self performSelector:@selector(doneRefrshLoadingTableViewData) withObject:nil afterDelay:3];
}
- (void)getMoreFromNetWork
{
    [self performSelector:@selector(doneMoreLoadingTableViewData) withObject:nil afterDelay:3];
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
        label.text = [[_dataSourceArray objectAtIndex:0] shareTime];
    }else{
        label.text = nil;
    }
}
- (void)updataLabelWithScrollView:(UIScrollView *)aScrollView
{
    NSArray * cells = _myTableView.visibleCells;
//    if (aScrollView.contentOffset.y <= 0) {
//        CGRect rect = label.frame;
//        rect.origin.y = ([(UITableViewCell *)[cells objectAtIndex:0] frame].size.height - rect.size.height)/2.f - aScrollView.contentOffset.y;
//        label.frame = rect;
//        return;
//    }
    label.frame = [self getLabelRectWithOffset:aScrollView.contentOffset.y];
    for (UITableViewCell * cell in cells) {
        CGRect cellRect = [self.view convertRect:cell.frame fromView:cell.superview];
        if (CGRectContainsRect(cellRect, label.frame)) {
            label.text = [[(PhotoWallCell*)cell dataSource] shareTime];
        }
    }
}
- (CGRect)getLabelRectWithOffset:(CGFloat)pointY
{
    CGFloat ratioInTableView = pointY / _myTableView.contentSize.height;
    CGRect rect = label.frame;
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
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button
{
    if (button.tag == LEFTBUTTON) {
        [self.viewDeckController toggleLeftViewAnimated:YES];
    }
    if (button.tag == RIGHT1BUTTON) { //分享
        
    }
}
- (void)photoWallCell:(PhotoWallCell *)cell talkClick:(UIButton *)button
{
    DLog(@"%s",__FUNCTION__);

}
- (void)photoWallCell:(PhotoWallCell *)cell likeClick:(UIButton *)button
{
    DLog(@"%s",__FUNCTION__);

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"%s",__FUNCTION__);
}
@end
