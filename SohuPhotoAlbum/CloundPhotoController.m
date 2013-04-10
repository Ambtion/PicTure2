//
//  RootViewController.m
//  test
//
//  Created by sohu on 13-4-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CloundPhotoController.h"
#import <ImageIO/ImageIO.h>
@interface CloundPhotoController ()

@end

@implementation CloundPhotoController

- (void)dealloc
{
    [_myTableView release];
    [_refresHeadView release];
    [_dataSourceArray release];

    [super dealloc];
}
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
    UIBarButtonItem * bu = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(refeshOnce:)] autorelease];
    self.navigationItem.leftBarButtonItem = bu;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(270, 10, 50, 20)];
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    [self resetLabel];
    [self.view addSubview:label];

    
    _dataSourceArray = [[NSMutableArray arrayWithCapacity:0] retain];
    for (int i = 0; i < 10; i++) {
        NSMutableArray * arra = [NSMutableArray arrayWithCapacity:0];
        for (int j = 0; j < 20; j++) {
            NSString * str = [NSString stringWithFormat:@"%d段%d行",i,j];
            [arra addObject:str];
        }
        [_dataSourceArray addObject:arra];
    }
    [_myTableView reloadData];
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
    [self resetLabel];
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
    label.text = @"0段";
}
- (void)updataLabelWithScrollView:(UIScrollView *)aScrollView
{
    NSArray * cells = _myTableView.visibleCells;
    if (aScrollView.contentOffset.y <= 0) {
        CGRect rect = label.frame;
        rect.origin.y = ([(UITableViewCell *)[cells objectAtIndex:0] frame].size.height - rect.size.height)/2.f - aScrollView.contentOffset.y;
        label.frame = rect;
        return;
    }
    
    label.frame = [self getLabelRectWithOffset:aScrollView.contentOffset.y];
    for (UITableViewCell * cell in cells) {
        CGRect cellRect = [self.view convertRect:cell.frame fromView:cell.superview];
        if (CGRectContainsRect(cellRect, label.frame)) {
            NSRange range = [cell.textLabel.text rangeOfString:@"段"];
            label.text = [cell.textLabel.text substringToIndex:range.location + range.length];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataSourceArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSMutableArray *)[_dataSourceArray objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:@"LL"];
    if (!cell) {
        cell = [[[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LL"] autorelease];
    }
    cell.textLabel.text = [[_dataSourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
