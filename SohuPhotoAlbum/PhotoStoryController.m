//
//  DetailPhotoStoryController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-17.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PhotoStoryController.h"
#import "RequestManager.h"
#import "CommentController.h"

@implementation PhotoStoryController
@synthesize storyID,ownerID;

- (id)initWithStoryId:(NSString *)AstoryID ownerID:(NSString *)AownerID
{
    if (self = [super init]) {
        self.storyID = AstoryID;
        self.ownerID = AownerID;
    }
    return self;
}

#pragma mark View LifeCircle
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
    _refresHeadView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -60, 320, 60) arrowImageName:nil textColor:[UIColor redColor] backGroundColor:[UIColor clearColor]];
    _refresHeadView.delegate = self;
    [_myTableView addSubview:_refresHeadView];
    [self.view addSubview:_myTableView];
    
    _moreFootView = [[SCPMoreTableFootView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) WithLodingImage:[UIImage imageNamed:@"load_more_pics.png"] endImage:[UIImage imageNamed:@"end_bg.png"] WithBackGroud:[UIColor clearColor]];
    _moreFootView.delegate = self;
    _myTableView.tableFooterView = _moreFootView;
    _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    
    [self refrshDataFromNetWork];
    //    //测试用
    //    for (int i = 0; i < 20; i++) {
    //        PhotoStoryCellDataSource * dataSource = [[PhotoStoryCellDataSource alloc] init];
    //
    //        dataSource.imageID = @"1.jpg";
    //        dataSource.imageDes = @"我啦对法拉第飞啊记得发,你是挨打发对法拉飞.挨打放假的了";
    //        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    //        int n = arc4random() % 3;
    //        for (int i = 0; i <= n; i++) {
    //            CommentViewDataSource * cds = [[CommentViewDataSource alloc] init];
    //            cds.userName = @"游客踩踩";
    //            cds.potraitImage = @"1.jpg";
    //            cds.shareTime = @"6个小时前";
    //            cds.comment = @"ASDFA,adf就啊了的控件飞,加啊克里斯蒂法律人阿的江";
    //            [array addObject:cds];
    //        }
    //        dataSource.commentInfoArray = array;
    //        dataSource.likeCount = 100;
    //        [_dataSourceArray addObject:dataSource];
    //    }
    //    [_myTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    if (!_navBar){
        _navBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        [_navBar.nLeftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [_navBar.nLabelText setText:@"故事"];
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
    [RequestManager getAllPhototInStroyWithOwnerId:self.ownerID stroyId:self.storyID start:0 count:20 success:^(NSString *response) {
        [_dataSourceArray removeAllObjects];
        [self addSoruceFromArray:[[response JSONValue] objectForKey:@"photos"]];
        [self doneRefrshLoadingTableViewData];
    } failure:^(NSString *error) {
        [self doneRefrshLoadingTableViewData];
    }];
}
- (void)getMoreFromNetWork
{
    if (_dataSourceArray.count % 20) {
        [_moreFootView setMoreFunctionOff:YES];
        [self doneMoreLoadingTableViewData];
        return;
    }
    [_moreFootView setMoreFunctionOff:NO];
    [RequestManager getAllPhototInStroyWithOwnerId:self.ownerID stroyId:self.storyID start:[_dataSourceArray count] count:20 success:^(NSString *response) {
        [self addSoruceFromArray:[[response JSONValue] objectForKey:@"photos"]];
        [self doneMoreLoadingTableViewData];
    } failure:^(NSString *error) {
        [self doneMoreLoadingTableViewData];
    }];}
- (void)addSoruceFromArray:(NSArray *)array
{
    DLog(@"%@",[array lastObject]);
    for (NSDictionary * info in array)
        [_dataSourceArray addObject:[self getCellSourceFromInfo:info]];
    [_myTableView reloadData];
}
- (PhotoStoryCellDataSource *)getCellSourceFromInfo:(NSDictionary *)info
{
    PhotoStoryCellDataSource * dataSource = [[PhotoStoryCellDataSource alloc] init];
    dataSource.photoId = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
    dataSource.imageUrl = [info objectForKey:@"photo_url"];
    dataSource.imageDes = [info objectForKey:@"description"];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    int n = arc4random() % 3;
    for (int i = 0; i <= n; i++) {
        CommentViewDataSource * cds = [[CommentViewDataSource alloc] init];
        cds.userName = @"游客踩踩";
        cds.potraitImage = @"1.jpg";
        cds.shareTime = @"6个小时前";
        cds.comment = @"ASDFA,adf就啊了的控件飞,加啊克里斯蒂法律人阿的江";
        [array addObject:cds];
    }
    dataSource.commentInfoArray = array;
    dataSource.allCommentCount = [[info objectForKey:@"comment_num"] integerValue];
    return dataSource;
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

#pragma mark DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [(PhotoStoryCellDataSource *)[_dataSourceArray objectAtIndex:indexPath.row] cellHeigth];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = BASEWALLCOLOR;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"CELLID";
    PhotoStoryCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[PhotoStoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.delegate  = self;
    }
    cell.dataSource = [_dataSourceArray objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark Action
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload
{
    if (button.tag == LEFTBUTTON) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (button.tag == RIGHT1BUTTON) { //分享
        
    }
}
- (void)photoStoryCell:(PhotoStoryCell *)cell footViewClickAtIndex:(NSInteger)index
{
    DLog(@"photoStoryCell %d",index);
    switch (index) {
        case 0: //评论
            [self.navigationController pushViewController:[[CommentController alloc] init] animated:YES];
            break;
        case 1: //喜欢
            break;
        case 2:
            break;
                //分享
        case 3:
            break;
                //删除
        default:
            break;
    }
    
}
-(void)photoStoryCell:(PhotoStoryCell *)cell commentClickAtIndex:(NSInteger)index
{
    DLog(@"photoStoryCell %d",index);
}
@end
