//
//  CloudAlbumPhotosController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-6-18.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CloudAlbumPhotosController.h"
#import "RequestManager.h"

@interface CloudAlbumPhotosController()
@property(nonatomic,strong)NSMutableArray * assetsSource;
@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong)NSMutableArray * selectedArray;
@end

@implementation CloudAlbumPhotosController
@synthesize folderId = _folderId;
@synthesize assetsSource = _assetsSource;
@synthesize dataSource = _dataSource;
@synthesize selectedArray = _selectedArray;

- (id)initWithFoldersId:(NSString *)folderId
{
    if (self = [super init]) {
        self.folderId = folderId;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = LOCALBACKGORUNDCOLOR;
    _refreshTableView = [[EGRefreshTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _refreshTableView.pDelegate = self;
    _refreshTableView.dataSource = self;
    [self.view addSubview:_refreshTableView];
    [self initDataContainer];
    [self refrshDataFromNetWork];
}
- (void)initDataContainer
{
    _assetsSource = [NSMutableArray arrayWithCapacity:0];
    _selectedArray = [NSMutableArray arrayWithCapacity:0];
    _dataSource = [NSMutableArray arrayWithCapacity:0];
}

#pragma mark ViewLifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_cusBar){
        _cusBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
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
- (void)viewWillDisappear:(BOOL)animated
{
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [_cusBar removeFromSuperview];
}

#pragma mark refresh
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
    [RequestManager getfoldersPicWithAccessToken:[LoginStateManager currentToken] folderId:self.folderId start:0 count:100 success:^(NSString *response) {
        NSArray * array = [[response JSONValue] objectForKey:@"photos"];
        if (array && array.count) {
            [_assetsSource removeAllObjects];
            DLog(@"%@",array);
            [self addArrayTodataSource:array];
            [_refreshTableView reloadData];
            [_refreshTableView didFinishedLoadingTableViewData];
        }
    } failure:^(NSString * error) {
        [self showPopAlerViewRatherThentasView:NO WithMes:error];
        [_refreshTableView didFinishedLoadingTableViewData];
    }];
}
- (void)getMoreFromNetWork
{
    [RequestManager getfoldersPicWithAccessToken:[LoginStateManager currentToken] folderId:self.folderId start:[[self dataSource] count] count:100 success:^(NSString *response) {
        NSArray * array = [[response JSONValue] objectForKey:@"photos"];
        if (array && array.count) {
            [self addArrayTodataSource:array];
            [_refreshTableView reloadData];
            [_refreshTableView didFinishedLoadingTableViewData];
        }
    } failure:^(NSString * error) {
        [self showPopAlerViewRatherThentasView:NO WithMes:error];
        [_refreshTableView didFinishedLoadingTableViewData];
    }];
}
- (void)addArrayTodataSource:(NSArray *)photoInfo
{
    [_assetsSource addObjectsFromArray:photoInfo];
    NSInteger count = photoInfo.count;
    NSInteger last = count % 4;
    [_dataSource removeAllObjects];
    for (int i = 0; i < count - last; i+=4) {
        CloudPictureCellDataSource * soure  = [[CloudPictureCellDataSource alloc] init];
        soure.firstDic  = [photoInfo objectAtIndex:i];
        soure.secoundDic = [photoInfo objectAtIndex:i + 1];
        soure.thridDic = [photoInfo objectAtIndex:i + 2];
        soure.lastDic = [photoInfo objectAtIndex:i + 3];
        [_dataSource addObject:soure];
    }
    if (last) {
        CloudPictureCellDataSource * soure  = [[CloudPictureCellDataSource alloc] init];
        switch (last) {
            case 3:
                soure.thridDic = [photoInfo objectAtIndex:(count / 4)*4 + 2];
            case 2:
                soure.secoundDic =  [photoInfo objectAtIndex:(count / 4)*4  + 1];
            case 1:
                soure.firstDic = [photoInfo objectAtIndex:(count / 4) * 4 ];
                break;
            default:
                break;
        }
        [_dataSource addObject:soure];
    }
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil([[self dataSource] count] / 4.0);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = LOCALBACKGORUNDCOLOR;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.dataSource count] - 1) {
        return [CloudPictureCellDataSource cellLastHigth];
    }
    return [CloudPictureCellDataSource cellHigth];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CloudPictureCellDataSource * source = nil;
    if (indexPath.row < self.dataSource.count)
        source = [[self dataSource] objectAtIndex:indexPath.row];
    CloudPictureCell * cell = [tableView dequeueReusableCellWithIdentifier:cloudIdentify[[source sourceNumber]]];
    if (!cell) {
        cell = [[CloudPictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[source sourceNumber]];
        cell.delegate = self;
    }
    cell.dataSource = source;
    if (_viewState != NomalState){
        [cell showCellSelectedStatus];
        [cell cloudPictureCellisShow:[_selectedArray containsObject:cell.dataSource.firstDic] selectedDic:cell.dataSource.firstDic];
        [ cell cloudPictureCellisShow:[_selectedArray containsObject:cell.dataSource.secoundDic] selectedDic:cell.dataSource.secoundDic];
        [cell cloudPictureCellisShow:[_selectedArray containsObject:cell.dataSource.thridDic] selectedDic:cell.dataSource.thridDic];
        [cell cloudPictureCellisShow:[_selectedArray containsObject:cell.dataSource.lastDic] selectedDic:cell.dataSource.lastDic];
    }else{
        [cell hiddenCellSelectedStatus];
    }
    return cell;
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
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload
{
    if (button.tag == LEFTBUTTON) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (button.tag == RIGHT1BUTTON) {           //分享
        [self setViewState:ShareState];
    }
    if (button.tag == RIGHT2BUTTON) {           //删除
        [self setViewState:DeleteState];
    }
    if (button.tag == CANCELBUTTONTAG) {        //取消
        [self setViewState:NomalState];
    }
    if (button.tag == RIGHTSELECTEDTAG) {       //确认
            [self handleEnsureClick];
    }
}

- (void)handleEnsureClick
{
    if (!_selectedArray.count) {
        [self showPopAlerViewRatherThentasView:YES WithMes:@"请选择图片"];
        return;
    }
    if (_viewState == DeleteState) {
        [self showDeletePhotoesView];
        return;
    }
    if (_viewState == ShareState) {
        if (!_shareBox){
            _shareBox = [[ShareBox alloc] init];
            _shareBox.delegate = self;
        }
        [_shareBox showShareViewWithWeixinShow:NO photoWall:YES  andWriteImage:NO OnView:self.view];
    }
}

#pragma mark - Delete Photos
- (void)showDeletePhotoesView
{
    PopAlertView * alertView = [[PopAlertView alloc] initWithTitle:nil message:@"确认删除图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
    [alertView show];
    return;
}
- (void)popAlertView:(PopAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [RequestManager deleteFoldersPhotosWithAccessToken:[LoginStateManager currentToken] folderId:self.folderId photos:[self photosIdArray] success:^(NSString *response)
         {
             [self refrshDataFromNetWork];
             [self showPopAlerViewRatherThentasView:NO WithMes:@"删除成功"];
             [self setViewState:NomalState];
         } failure:^(NSString *error) {
             [self showPopAlerViewRatherThentasView:NO WithMes:@"删除失败"];
             [self setViewState:NomalState];
         }];
    }
}
- (NSArray *)photosIdArray
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic in _selectedArray) {
        [array addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"photo_id"]]];
    }
    return array;
}

#pragma mark Share
- (void)shareBoxViewShareTo:(KShareModel)model
{
    [self.navigationController pushViewController:[[ShareViewController alloc] initWithModel:model bgPhotoUrl:[[_selectedArray objectAtIndex:0] objectForKey:@"photo_url"] andDelegate:self] animated:YES];
}

- (void)shareBoxViewWeiXinShareToScene:(enum WXScene)scene
{
    //云端无微信分享
    //    [self respImageContentToSence:scene];
}

- (void)shareViewcontrollerDidShareClick:(ShareViewController *)controller withDes:(NSString *)des shareMode:(KShareModel)model
{

  [RequestManager sharePhotosWithAccesstoken:[LoginStateManager currentToken]  photoIDs:[self photosIdArray] share_to:model shareAccestoken:[[LoginStateManager getTokenInfo:model] objectForKey:@"access_token"] optionalTitle:nil desc:des success:^(NSString *response) {
        [self showPopAlerViewRatherThentasView:NO WithMes:@"分享成功"];
        [_selectedArray removeAllObjects];
        [self setViewState:NomalState];
    } failure:^(NSString *error) {
        [self showPopAlerViewRatherThentasView:NO WithMes:@"分享失败"];
    }];
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark 
- (void)cloudPictureCell:(CloudPictureCell *)cell clickInfo:(NSDictionary *)dic Select:(BOOL)isSelected
{
    if (isSelected) {
        [_selectedArray addObject:dic];
    }else if([_selectedArray containsObject:dic]){
        [_selectedArray removeObject:dic];
    }
}
- (void)cloudPictureCell:(CloudPictureCell *)cell clickInfo:(NSDictionary *)dic
{
    //点击
    
}

@end
