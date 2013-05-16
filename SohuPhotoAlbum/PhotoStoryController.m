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
#import "LoginStateManager.h"
#import "PhotoWallController.h"
#import "UIImageView+WebCache.h"

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
    _refresHeadView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -60, 320, 60) arrowImageName:nil textColor:[UIColor grayColor] backGroundColor:[UIColor clearColor]];
    _refresHeadView.delegate = self;
    [_myTableView addSubview:_refresHeadView];
    [self.view addSubview:_myTableView];
    
    _moreFootView = [[SCPMoreTableFootView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) WithLodingImage:[UIImage imageNamed:@"load_more_pics.png"] endImage:[UIImage imageNamed:@"end_bg.png"] WithBackGroud:[UIColor clearColor]];
    _moreFootView.delegate = self;
    _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    [self refrshDataFromNetWork];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    if (!_navBar){
        _navBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        [_navBar.nLeftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [_navBar.nLabelText setText:@"图片墙"];
        [_navBar.nRightButton1 setImage:[UIImage imageNamed:@"shareBtn_nomal.png"] forState:UIControlStateNormal];
    }
    if (!_navBar.superview)
        [self.navigationController.navigationBar addSubview:_navBar];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_navBar removeFromSuperview];
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_navBar removeFromSuperview];
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
    [RequestManager getAllPhototInStoryWithOwnerId:self.ownerID stroyId:self.storyID start:0 count:20 success:^(NSString *response) {
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
    [RequestManager getAllPhototInStoryWithOwnerId:self.ownerID stroyId:self.storyID start:[_dataSourceArray count] count:20 success:^(NSString *response) {
        [self addSoruceFromArray:[[response JSONValue] objectForKey:@"photos"]];
        [self doneMoreLoadingTableViewData];
    } failure:^(NSString *error) {
        [self doneMoreLoadingTableViewData];
    }];}
- (void)addSoruceFromArray:(NSArray *)array
{
    for (NSDictionary * info in array)
        [_dataSourceArray addObject:[self getdataSourceFromInfo:info]];
    [_myTableView reloadData];
}
- (PhotoStoryCellDataSource *)getdataSourceFromInfo:(NSDictionary *)info
{
    PhotoStoryCellDataSource * dataSource = [[PhotoStoryCellDataSource alloc] init];
    dataSource.photoId = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
    dataSource.imageUrl = [info objectForKey:@"photo_url"];
    dataSource.higth = [[info objectForKey:@"height"] floatValue];
    dataSource.weigth = [[info objectForKey:@"width"] floatValue];
    dataSource.imageDes = [info objectForKey:@"description"];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    NSArray * commentarray = [info objectForKey:@"comments"];
    for (int i = 0; i < commentarray.count; i++) {
        StoryCommentViewDataSource * cds = [[StoryCommentViewDataSource alloc] init];
        NSDictionary * dic = [commentarray objectAtIndex:i];
        cds.userName =[dic objectForKey:@"user_nick"];
        cds.potraitImage = [dic objectForKey:@"avatar"];
        cds.shareTime = @"6个小时前";
        cds.comment = [dic objectForKey:@"content"];
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
    [_moreFootView scpMoreScrollViewDidScroll:scrollView isAutoLoadMore:YES WithIsLoadingPoint:&_isLoading];
}

#pragma mark DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoStoryCellDataSource * soruce = [_dataSourceArray objectAtIndex:indexPath.row];
    if (indexPath.row == [_dataSourceArray count] - 1) {
        return [soruce lastCellHeigth];
    }
    return [soruce cellHeigth];
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
        [self showShareViewIsAllshare:YES];
    }
}
- (void)photoStoryCell:(PhotoStoryCell *)cell footViewClickAtIndex:(NSInteger)index
{
    DLog(@"%d",index);
    switch (index) {
        case 0: //评论
            [self.navigationController pushViewController:[[CommentController alloc] initWithSourceId:[[cell dataSource] photoId] andSoruceType:KSourcePhotos withBgImageURL:[[cell dataSource] imageUrl] WithOwnerID:self.ownerID] animated:YES];
            break;
        case 1: //喜欢
            [self likeClickOnCell:cell];
            break;
        case 2:
            //分享
            [self sharePhotoStroy:cell];
            break;
        case 3:
            //删除
            [self delePhtotFromStroy:cell];
            break;
        default:
            break;
    }
}
-(void)photoStoryCell:(PhotoStoryCell *)cell commentClickAtIndex:(NSIndexPath *)index
{
    DLog(@"%@",index);
    //最多3条评论
    if (index.row == 0) {
        NSString * ownerId = [[[[cell dataSource] commentInfoArray] objectAtIndex:index.section] userId];
        PhotoWallController * wall = [[PhotoWallController alloc] initWithOwnerID:ownerId isRootController:NO];
        [self.navigationController pushViewController:wall animated:YES];
        return;
    }
    //评论
    [self.navigationController pushViewController:[[CommentController alloc] initWithSourceId:[cell.dataSource photoId] andSoruceType:KSourcePhotos withBgImageURL:cell.dataSource.imageUrl WithOwnerID:self.ownerID] animated:YES];
}
- (void)likeClickOnCell:(PhotoStoryCell *)cell
{
    if (![LoginStateManager isLogin]) {
        [self showLoginViewWithMethodNav:YES];
        return;
    }
    if (cell.dataSource.isLiking) {
        [RequestManager unlikeWithSourceId:[[cell dataSource] photoId] source:KSourcePhotos OwnerID:self.ownerID Accesstoken:[LoginStateManager currentToken] success:^(NSString *response) {
            cell.dataSource.isLiking = NO;
            [cell updateAllSubViewsFrames];
        } failure:^(NSString *error) {
            
        }];
    }else{
        [RequestManager likeWithSourceId:[[cell dataSource] photoId] source:KSourcePhotos OwnerID:self.ownerID Accesstoken:[LoginStateManager currentToken] success:^(NSString *response) {
            cell.dataSource.isLiking = YES;
            [cell updateAllSubViewsFrames];
        } failure:^(NSString *error) {
            
        }];
    }
}
- (void)sharePhotoStroy:(PhotoStoryCell *)cell
{
    _shareDateSource = cell.dataSource;
    [self showShareViewIsAllshare:NO];
}
- (void)delePhtotFromStroy:(PhotoStoryCell *)cell
{
    if (![LoginStateManager isLogin]) {
        [self showLoginViewWithMethodNav:YES];
        return;
    }
    [RequestManager deletePhotoFromStoryWithAccessToken:[LoginStateManager currentToken] stroyid:self.storyID photoId:[[cell dataSource] photoId]success:^(NSString *response) {
        [_dataSourceArray removeObject:[cell dataSource]];
        NSIndexPath * path = [_myTableView  indexPathForCell:cell];
        [_myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
        [_myTableView reloadData];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

#pragma mark Share
- (void)showShareViewIsAllshare:(BOOL)isShareAll
{
    _isShareAll = isShareAll;
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"人人网",@"腾讯QQ空间",@"保存到本地相册", nil];
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            model = SinaWeiboShare;
            break;
        case 1:
            model = RenrenShare;
            break;
        case 2:
            model = QQShare;
            break;
        case 3:
            model = NoShare;
//            UIImageWriteToSavedPhotosAlbum(<#UIImage *image#>, <#id completionTarget#>, <#SEL completionSelector#>, <#void *contextInfo#>)
            break;
        default:
            return;
            break;
    }
    if (model == NoShare) {
        NSString * bgPhotoUrl = [_shareDateSource imageUrl];
        [self writePicToAlbumWith:bgPhotoUrl];
        return;
    }
    if (_dataSourceArray.count) {
        if (_isShareAll) {//分享story
            PhotoStoryCellDataSource * source = [_dataSourceArray objectAtIndex:0];
            NSString * bgPhotoUrl = [source imageUrl];
            ShareViewController * sv = [[ShareViewController alloc] initWithModel:model bgPhotoUrl:bgPhotoUrl andDelegate:nil];
            sv.ownerId = self.ownerID;
            sv.storyId = self.storyID;
            [self.navigationController pushViewController:sv animated:YES];
        }else{ //分享单张图片
            NSString * bgPhotoUrl = [_shareDateSource imageUrl];
            ShareViewController * sv = [[ShareViewController alloc] initWithModel:model bgPhotoUrl:bgPhotoUrl andDelegate:nil];
            sv.ownerId = self.ownerID;
            sv.storyId = self.storyID;
            sv.photosArray = [NSArray arrayWithObject:_shareDateSource.photoId];
            [self.navigationController pushViewController:sv animated:YES];
        }
    }
}

@end
