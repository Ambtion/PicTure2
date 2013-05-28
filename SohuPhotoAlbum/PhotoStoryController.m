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
#import "AlBumDetailController.h"
#import "SDImageCache.h"

@implementation PhotoStoryController
@synthesize storyID,ownerID,showID,storyName,storyDes,userInfo = _userInfo;

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
    _assetArray = [NSMutableArray arrayWithCapacity:0];
    [self refrshDataFromNetWork];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationItem setHidesBackButton:YES];
    if (!_navBar){
        _navBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        [_navBar.nLeftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        
        [_navBar.nLabelText setText:(self.storyName && ![self.storyName isEqualToString:@""]) ?[NSString stringWithFormat:@"%@",self.storyName]: @"图片集" ];
        [_navBar.nRightButton1 setImage:[UIImage imageNamed:@"shareBtn_nomal.png"] forState:UIControlStateNormal];
    }
    if (![self isMineWithOwnerId:self.ownerID]) {
        [_navBar.nLabelText setText:nil];
        if (!_titleAccoutView) {
            _titleAccoutView = [[TitleAccountView alloc] initWithFrame:CGRectMake(46, 0, 200, 44)];
            _titleAccoutView.userId = self.ownerID;
            [_navBar addSubview:_titleAccoutView];
        }
    }
    [self getuserInfoWithRefresh:NO];
    if (!_navBar.superview)
        [self.navigationController.navigationBar addSubview:_navBar];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_navBar removeFromSuperview];
}
- (void)getuserInfoWithRefresh:(BOOL)isRefresh
{
    if (!isRefresh){
        [_titleAccoutView refreshUserInfoWithDic:_userInfo];
        return;
    }
    [RequestManager getUserInfoWithId:self.ownerID  success:^(NSString *response) {
        _userInfo = [response JSONValue];
        if (_titleAccoutView) {
            [_titleAccoutView refreshUserInfoWithDic:_userInfo];
        }
    } failure:^(NSString *error) {
        
    }];
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
    [self getuserInfoWithRefresh:YES];
    [RequestManager getAllPhototInStoryWithOwnerId:self.ownerID stroyId:self.storyID start:0 count:20 success:^(NSString *response) {
        [_dataSourceArray removeAllObjects];
        [_assetArray removeAllObjects];
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
    }];
}

- (void)addSoruceFromArray:(NSArray *)array
{
    if (array.count)
        NSLog(@"%@",[array objectAtIndex:0]);
    [_assetArray addObjectsFromArray:array];
    for (NSDictionary * info in array)
        [_dataSourceArray addObject:[self getdataSourceFromInfo:info]];
    [_myTableView reloadData];
}

- (PhotoStoryCellDataSource *)getdataSourceFromInfo:(NSDictionary *)info
{
    
    PhotoStoryCellDataSource * dataSource = [[PhotoStoryCellDataSource alloc] init];
    dataSource.photoId = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
    dataSource.imageUrl = [info objectForKey:@"photo_url"];
    dataSource.photoShowID = [NSString stringWithFormat:@"%@",[info objectForKey:@"show_id"]];
    dataSource.higth = [[info objectForKey:@"height"] floatValue];
    dataSource.weigth = [[info objectForKey:@"width"] floatValue];
    dataSource.imageDes = [info objectForKey:@"description"];
    dataSource.isLiking = [[info objectForKey:@"is_liked"] boolValue];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    NSArray * commentarray = [info objectForKey:@"comments"];
    for (int i = 0; i < commentarray.count; i++) {
        StoryCommentViewDataSource * cds = [[StoryCommentViewDataSource alloc] init];
        NSDictionary * dic = [commentarray objectAtIndex:i];
        cds.userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"user_id"]];
        cds.userName =[dic objectForKey:@"user_nick"];
        cds.potraitImage = [dic objectForKey:@"avatar"];
        cds.shareTime =[dic objectForKey:@"created_desc"];
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
        cell = [[PhotoStoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str thenHiddeDeleteButton:![self isMineWithOwnerId:self.ownerID]];
        cell.delegate  = self;
//        cell.dataSource = [_dataSourceArray objectAtIndex:indexPath.row];
    }
    cell.dataSource = [_dataSourceArray objectAtIndex:indexPath.row];
//    [cell resetImageWithAnimation:YES];
    return cell;
}
#pragma mark Action
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload
{
    if (button.tag == LEFTBUTTON) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (button.tag == RIGHT1BUTTON) { //分享
        if (!_dataSourceArray.count) return;
        [self showShareViewIsAllshare:YES];
    }
}
- (void)photoStoryCellImageClick:(PhotoStoryCell *)cell
{
    NSIndexPath * path = [_myTableView indexPathForCell:cell];
    NSDictionary  * dic = [_assetArray objectAtIndex:path.row];
    AlBumDetailController * detailController = [[AlBumDetailController alloc] initWithAssetsArray:_assetArray andCurAsset:dic];
    detailController.ownerId = self.ownerID;
    detailController.storyID = self.storyID;
    //    detailController.show
    [self.navigationController pushViewController:detailController animated:YES];
}
- (void)photoStoryCell:(PhotoStoryCell *)cell footViewClickAtIndex:(NSInteger)index
{
    if (![LoginStateManager isLogin]) {
        [self showLoginViewWithMethodNav:YES];
        return;
    }
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
    
    //最多3条评论
    if (index.row == 0) {
        NSString * ownerId = [[[[cell dataSource] commentInfoArray] objectAtIndex:index.section] userId];
        NSLog(@"%@",ownerId);
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
    tempCellForDelete = cell;
    [self showDeleteView];
    
}

#pragma mark Deleget
- (void)showDeleteView
{
    PopAlertView * alertView = [[PopAlertView alloc] initWithTitle:nil message:@"确认删除图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
    [alertView show];
    return;
}
- (void)popAlertView:(AHAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [RequestManager deletePhotoFromStoryWithAccessToken:[LoginStateManager currentToken] stroyid:self.storyID photoId:[[tempCellForDelete dataSource] photoId]success:^(NSString *response) {
            [_dataSourceArray removeObject:[tempCellForDelete dataSource]];
            NSIndexPath * path = [_myTableView  indexPathForCell:tempCellForDelete];
            [_myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationFade];
            [_myTableView reloadData];
            [self showPopAlerViewRatherThentasView:NO WithMes:@"删除成功"];
        } failure:^(NSString *error) {
            [self showPopAlerViewRatherThentasView:NO WithMes:@"删除失败"];
        }];
    }
}

#pragma mark Share
- (void)showShareViewIsAllshare:(BOOL)isShareAll
{
    
    _isShareAll = isShareAll;
    if (!_shareBox) {
        _shareBox = [[ShareBox alloc] init];
        _shareBox.delegate = self;
    }
    if (_isShareAll) {
        [_shareBox showShareViewWithWeixinShow:YES photoWall:NO andWriteImage:NO OnView:self.view];
    }else{
        [_shareBox showShareViewWithWeixinShow:YES photoWall:NO andWriteImage:YES OnView:self.view];
    }
}

- (void)shareBoxViewShareTo:(KShareModel)model
{
    //    _pushView = YES;
    PhotoStoryCellDataSource * source = [_dataSourceArray objectAtIndex:0];
    if (_isShareAll)
         _shareDateSource = source;
    NSString * photoString = [NSString stringWithFormat:@"%@",[_shareDateSource imageUrl]];
    [self.navigationController pushViewController:[[ShareViewController alloc] initWithModel:model bgPhotoUrl:photoString andDelegate:self] animated:YES];
}
- (void)shareBoxViewWeiXinShareToScene:(enum WXScene)scene
{
    [self respImageNewsContentToSence:scene];
}
- (void)shareBoxViewWriteImageTolocal
{
    
    NSString * bgPhotoUrl = [_shareDateSource imageUrl];
    [self writePicToAlbumWith:bgPhotoUrl];
}
#pragma mark -
- (void)shareViewcontrollerDidShareClick:(ShareViewController *)controller withDes:(NSString *)des shareMode:(KShareModel)model
{
    if (_isShareAll) {
//        //分享
        [RequestManager sharePortFoliosWithAccesstoken:[LoginStateManager currentToken] ownerId:self.ownerID portfilosId:self.storyID share_to:model shareAccestoken:[[LoginStateManager getTokenInfo:model] objectForKey:@"access_token"] desc:des success:^(NSString *response) {
            [self.navigationController popViewControllerAnimated:YES];
            [self showPopAlerViewRatherThentasView:NO WithMes:@"分享成功"];
        } failure:^(NSString *error) {
            [self.navigationController popViewControllerAnimated:YES];
            [self showPopAlerViewRatherThentasView:NO WithMes:@"分享失败"];
        }];
    }else{
        NSString * str = [NSString stringWithFormat:@"%@_w640",[_shareDateSource imageUrl]];
        SDImageCache * cache = [[SDImageCache alloc] init];
        UIImage * image = [cache imageFromKey:str];
        NSAssert(image == nil, @"image must not nil");
        [RequestManager sharePhoto:image share_to:model desc:des success:^(NSString *response) {
            [self.navigationController popViewControllerAnimated:YES];
            [self showPopAlerViewRatherThentasView:NO WithMes:@"分享成功"];
        } failure:^(NSString *error) {
            [self.navigationController popViewControllerAnimated:YES];
            [self showPopAlerViewRatherThentasView:NO WithMes:error];
        }];
    }
}

#pragma mark share
- (void) respImageNewsContentToSence:(enum WXScene)scene
{
    DLog(@"%d",_isShareAll);
    //发送内容给微信
    if (_isShareAll) {
        [self shareAllSourceWithWeixin:scene];
    }else{
        [self shareOneSourceWithWeiXin:scene];
    }
}

- (void)shareAllSourceWithWeixin:(enum WXScene)scene
{
    NSString * commentNews = [NSString stringWithFormat:@"http://pp.sohu.com/u/%@/w%@",self.ownerID,self.showID];
    //    [self shareNewsToWeixinWithUrl:commentNews ToSence:scene];
    
    NSString * title = [NSString stringWithFormat:@"分享%@的图集",[_userInfo objectForKey:@"user_nick"]];
    if (self.storyName && ![self.storyName isEqualToString:@""]) title = [title stringByAppendingFormat:@"[%@]",self.storyName];
    PhotoStoryCellDataSource * source = [_dataSourceArray objectAtIndex:0];
    [self shareNewsToWeixinWithUrl:commentNews ToSence:scene Title:title photoUrl:[source imageUrl] des:self.storyDes];
}
- (void)shareOneSourceWithWeiXin:(enum WXScene)scene
{
    [self shareImageToWeixinWithUrl:[_shareDateSource imageUrl] ToSence:scene];
}

- (void)onResp:(BaseResp *)resp
{
    if (resp.errCode == 0) {
        [self showPopAlerViewRatherThentasView:NO WithMes:@"分享成功"];
    }else{
        [self showPopAlerViewRatherThentasView:NO WithMes:@"分享失败"];
    }
}


@end
