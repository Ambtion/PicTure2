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
    self.view.backgroundColor = LOCALBACKGORUNDCOLOR;
    self.myTableView = [[UITableView alloc] initWithFrame:[self subTableViewRect] style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorColor = [UIColor clearColor];
    self.myTableView.backgroundColor = [UIColor clearColor];
    [self.myTableView setScrollsToTop:YES];
    [self.view addSubview:self.myTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self readAlbum];
}
#pragma mark - CUSBar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_cusBar){
        _cusBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [_cusBar.nLabelImage setImage:[UIImage imageNamed:@"localAlbums.png"]];
        [_cusBar.nRightButton1 setImage:[UIImage imageNamed:@"grid-view.png"] forState:UIControlStateNormal];
        
        [_cusBar.nRightButton2 setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
        [_cusBar.nRightButton2 setButtoUploadState:YES];
        
        [_cusBar.nRightButton3 setUserInteractionEnabled:NO];
        _cusBar.sLabelText.text = @"请选择专辑";
        
        [_cusBar.sLeftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        
    }
    if (!_cusBar.superview)
        [self.navigationController.navigationBar addSubview:_cusBar];
    //界面出现,bar恢复normal状态
    [self setViewState:NomalState];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
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
    if (button.tag == RIGHT1BUTTON) {
        self.viewDeckController.centerController  = [[LocalALLPhotoesController alloc] init];
    }
    if (button.tag == RIGHT2BUTTON) { //上传
        [self setViewState:UPloadState];
    }
    if (button.tag == CANCELBUTTONTAG) {
        [self setViewState:NomalState];
    }
}

#pragma mark - ReadData
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
- (void)photoAlbumCell:(PhotoAlbumCell *)photoCell clickCoverGroup:(ALAssetsGroup *)group
{
    
    [self.navigationController pushViewController:[[AlbumPhotoesController alloc] initWithAssetGroup:group andViewState:_viewState] animated:YES];
}

@end
