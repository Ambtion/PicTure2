//
//  CommentController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CommentController.h"
#import "UIImageView+WebCache.h"

@interface CommentController ()

@end

@implementation CommentController
@synthesize sourceId;
@synthesize imageUrl;

- (id)initWithSourceId:(NSString *)AsourceId andSoruceType:(source_type)Atype withBgImageURL:(NSString * )bgUrl
{
    self = [super init];
    if (self) {
        self.sourceId = AsourceId;
        type = Atype;
        self.imageUrl = bgUrl;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = BASEWALLCOLOR;
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorColor = [UIColor clearColor];
    _myTableView.backgroundColor = [UIColor clearColor];
    _myBgView  = [[UIImageView alloc] initWithFrame:_myTableView.bounds];
    _myBgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_myBgView];
    self.view.clipsToBounds = YES;
    DLog(@"MMM %@",[NSString stringWithFormat:@"%@w640",self.imageUrl]);
    __weak UIImageView * bgViewSelf = _myBgView;
    __weak UITableView * tableViewSelf = _myTableView;
    __weak CommentController * weakSelf = self;
    [_myBgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_w640",self.imageUrl]] placeholderImage:[UIImage imageNamed:@"1.png"] success:^(UIImage *image) {
        CGSize size = [weakSelf getIdentifyImageSizeWithImageView:image];
        bgViewSelf.frame = (CGRect ){0,0,size};
        bgViewSelf.center = CGPointMake(tableViewSelf.bounds.size.width /2.f, tableViewSelf.bounds.size.height /2.f);
    } failure:^(NSError *error) {
        
    }];
    
    _refresHeadView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, - 60, 320, 60) arrowImageName:nil textColor:[UIColor redColor] backGroundColor:[UIColor clearColor]];
    _refresHeadView.delegate = self;
    [_myTableView addSubview:_refresHeadView];
    [self.view addSubview:_myTableView];
    
    _moreFootView = [[SCPMoreTableFootView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) WithLodingImage:[UIImage imageNamed:@"load_more_pics.png"] endImage:[UIImage imageNamed:@"end_bg.png"] WithBackGroud:[UIColor clearColor]];
    _moreFootView.delegate = self;
    _myTableView.tableFooterView = _moreFootView;
    _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    [self getMoreFromNetWork];
}
- (CGSize)getIdentifyImageSizeWithImageView:(UIImage *)image
{
    if (!image) return CGSizeZero;
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    CGRect frameRect = self.view.bounds;
    CGRect rect = CGRectZero;
    CGFloat scale = MAX(frameRect.size.width / w, frameRect.size.height / h);
    rect = CGRectMake(0, 0, w * scale, h * scale);
    DLog(@"%@ %f,%f",NSStringFromCGRect(rect),w,h );
    return rect.size;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    if (!_navBar){
        _navBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        _navBar.normalBar.image = [UIImage imageNamed:@"full_screen_title-bar.png"];
        [_navBar.nLeftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        _navBar.nLabelText.text = @"评论";
        _navBar.nLabelText.textColor = [UIColor whiteColor];
    }
    if (!_navBar.superview)
        [self.navigationController.navigationBar addSubview:_navBar];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_navBar removeFromSuperview];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
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
    for (int i = 0; i< 20; i++) {
        [_dataSourceArray addObject:[self getCellDataSourceFromInfo:nil]];
    }
    [self doneRefrshLoadingTableViewData];
    //    [self performSelector:@selector(doneRefrshLoadingTableViewData) withObject:nil afterDelay:3];
    
}
- (CommentCellDeteSource *)getCellDataSourceFromInfo:(NSDictionary *)info
{
    CommentCellDeteSource * data = [[CommentCellDeteSource alloc] init];
    data.userName = @"ok";
    data.commentStr = @"我整的没法描述这个耳温计,也不,你是吗,asdf就,,啊知道说是吗.,,,";
    return data;
}
- (void)getMoreFromNetWork
{
//    [self performSelector:@selector(doneMoreLoadingTableViewData) withObject:nil afterDelay:3];
    [RequestManager getCommentWithSourceType:type andSourceID:sourceId success:^(NSString *response) {
        DLog(@"%@",response);
    } failure:^(NSString *error) {
        
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
    [_refresHeadView egoRefreshScrollViewDidScroll:scrollView];
    [_moreFootView scpMoreScrollViewDidScroll:scrollView];
    if (scrollView.contentSize.height - scrollView.frame.size.height -  scrollView.contentOffset.y < 100) {
        [_moreFootView moreImmediately];
        _isLoading = YES;
    }
}
#pragma mark -tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _dataSourceArray.count){
        CommentCellDeteSource * source = [_dataSourceArray objectAtIndex:indexPath.row];
        return [source cellHeigth];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentify = @"CELL";
    CommentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    if (indexPath.row < _dataSourceArray.count)
        cell.dataSource = [_dataSourceArray objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark Action
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload
{
    if (button.tag == LEFTBUTTON) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
