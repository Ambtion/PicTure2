//
//  LocalPhotoesController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "LocalAlbumsController.h"
#import "AlbumPhotoesController.h"
#import "LocalALLPhotoesController.h"
#import "LeftMenuController.h"

@interface LocalAlbumsController ()
@property(nonatomic,strong)NSMutableArray *assetGroups;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@end

@implementation LocalAlbumsController
@synthesize assetGroups = _assetGroups;
@synthesize dataSourceArray = _dataSourceArray;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumDidwriteImage:) name:WRITEIMAGE object:nil];
    [self readAlbum];
}

#pragma mark - CUSBar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated]; //删除bar上所有子视图
    
    if (!_cusBar){
        _cusBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [_cusBar.nRightButton1 setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
        [_cusBar.nRightButton1 setButtoUploadState:YES];
        [_cusBar.sLeftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [self addsegmentOnView:_cusBar];
        _cusBar.sLabelText.text = @"请选择照片";
    }
    if (!_cusBar.superview)
        [self.navigationController.navigationBar addSubview:_cusBar];
    //界面出现,bar恢复normal状态
    [self setViewState:NomalState];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    if (needReadonce) {
        [self readAlbum];
        needReadonce = NO;
    }
    segControll.selectedSegmentIndex = 1; 
}
- (void)addsegmentOnView:(UIView *)view
{
    if (!segControll) {
        NSArray * items = [NSArray arrayWithObjects:@"时间线",@"相册", nil];
        segControll = [[CQSegmentControl alloc] initWithItemsAndStype:items stype:TitleAndImageSegmented];
        [segControll addTarget:self action:@selector(segMentChnageValue:) forControlEvents:UIControlEventValueChanged];
        segControll.frame = CGRectMake(83, 8, 154, 27);
    }
    if (segControll.superview != view)
        [view addSubview:segControll];
    segControll.selectedSegmentIndex = 1;
}
- (void)segMentChnageValue:(UISegmentedControl *)seg
{
    if (seg.selectedSegmentIndex == 1) {
        return;
    }
    LeftMenuController * leftCon = (LeftMenuController *)self.viewDeckController.leftController;
    self.viewDeckController.centerController = leftCon.localAllController;
}

- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload
{
    if (isupload) {
        UPLoadController * uploadView = [[UPLoadController alloc] init];
        uploadView.delegate  = self;
        [self.navigationController pushViewController:uploadView animated:YES];
        return;
    }
    if (button.tag == LEFTBUTTON) {
        [self.viewDeckController toggleLeftViewAnimated:YES];
    }
    
    if (button.tag == RIGHT1BUTTON) { //上传
        if (![LoginStateManager isLogin]) {
            [self showLoginViewWithMethodNav:YES];
            return;
        }
        [self setViewState:UPloadState];
    }
    if (button.tag == CANCELBUTTONTAG) {
        [self setViewState:NomalState];
    }
}

#pragma mark - ReadData
- (void)albumDidwriteImage:(NSNotification *)notification
{
    needReadonce = YES;
}
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self readAlbum];
}
- (void) readAlbum
{
    if (_isReading) return;
    _isReading = YES;
    
	self.assetGroups = [NSMutableArray arrayWithCapacity:0];
    [[self libiary] readAlbumsIntoGroupArray:self.assetGroups sucess:^{
        [self prepareData];
    } failture:^(NSError *error) {
        
    }];
}

- (void)prepareData
{
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
    [self.myTableView reloadData];
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
    if ([group isKindOfClass:[ALAssetsGroup class]]) {
            [self.navigationController pushViewController:[[AlbumPhotoesController alloc] initWithAssetGroup:group andViewState:_viewState] animated:YES];
    }
}

@end
