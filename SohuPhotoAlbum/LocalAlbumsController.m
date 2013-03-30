//
//  LocalPhotoesController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "LocalAlbumsController.h"
#import "AlbumPhotoesController.h"

#define BACKGORUNDCOLOR [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1.f]

@interface LocalAlbumsController ()
@property(nonatomic,retain)NSMutableArray *assetGroups;
@property(nonatomic,retain)NSMutableArray *dataSourceArray;
@end

@implementation LocalAlbumsController
@synthesize assetGroups = _assetGroups;
@synthesize dataSourceArray = _dataSourceArray;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_cusBar release];
    [_myTableView release];
    [_library release];
    [_assetGroups release];
    [_dataSourceArray release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _myTableView = [[UITableView alloc] initWithFrame:[self subTableViewRect] style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorColor = [UIColor clearColor];
    _myTableView.backgroundColor = BACKGORUNDCOLOR;
    [_myTableView setScrollsToTop:YES];
    [self.view addSubview:_myTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}
#pragma mark - CUSBar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self readAlbum];
    if (!_cusBar){
        _cusBar = [[CusNavigationBar alloc] initwithDelegate:self];
        [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [_cusBar.nLabelImage setImage:[UIImage imageNamed:@"localAlbums.png"]];
        [_cusBar.nRightButton1 setImage:[UIImage imageNamed:@"grid-view.png"] forState:UIControlStateNormal];
        [_cusBar.nRightButton2 setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
        [_cusBar.nRightButton3 setUserInteractionEnabled:NO];
        _cusBar.sLabelText.text = @"请选择专辑";
        [_cusBar.sRightStateButton setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
        [_cusBar.sRightStateButton setHidden:YES];
        [_cusBar.sAllSelectedbutton setHidden:YES];
    }
    if (!_cusBar.superview)
        [self.navigationController.navigationBar addSubview:_cusBar];
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)cusNavigationBar:(CusNavigationBar *)bar buttonClick:(UIButton *)button
{
    if (button.tag == LEFTBUTTON) {
        [self.viewDeckController toggleLeftViewAnimated:YES];
    }
    if (button.tag == RIGHT1BUTTON) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    if (button.tag == RIGHT2BUTTON) {
        _viewState = UPloadState;
        [_cusBar switchBarState];
    }
    if (button.tag == CANCELBUTTONTAG) {
        _viewState = NomalState;
        [_cusBar switchBarState];
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
    
    if (!_library)
        _library = [[ALAssetsLibrary alloc] init];
	self.assetGroups = [NSMutableArray arrayWithCapacity:0];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    // Load Albums into assetGroups
    [_library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group == nil)
        {
            //finished
            dispatch_async(dispatch_get_main_queue(), ^{
                [self prepareData];
            });
            return ;
        }
        if ([group numberOfAssets]){
            [self.assetGroups addObject:group];
        }
            
    } failureBlock:^(NSError *error) {
        
    }];
    [pool drain];
}

- (void)prepareData
{
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i< self.assetGroups.count ; i+=2) {
        PhotoAlbumCellDataSource * dataSource = [[[PhotoAlbumCellDataSource alloc] init] autorelease];
        dataSource.leftGroup = [self.assetGroups objectAtIndex:i];
        if (i+1 < self.assetGroups.count) {
            dataSource.rightGroup = [self.assetGroups objectAtIndex:i+1];
        }else{
            dataSource.rightGroup = nil;
        }
        [self.dataSourceArray addObject:dataSource];
    }
    [_myTableView reloadData];
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
    PhotoAlbumCellDataSource * dataSource = [self.dataSourceArray objectAtIndex:indexPath.row];
    return [dataSource cellHight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"CELLID";
    PhotoAlbumCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell  = [[[PhotoAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        cell.delegate  = self;
    }
    if (indexPath.row < self.dataSourceArray.count)
        cell.dataSource =[self.dataSourceArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = BACKGORUNDCOLOR;
}

#pragma mark CellDelegate
- (void)photoAlbumCell:(PhotoAlbumCell *)photoCell clickCoverGroup:(ALAssetsGroup *)group
{
    [self.navigationController pushViewController:[[[AlbumPhotoesController alloc] initWithAssetGroup:group andViewState:_viewState] autorelease] animated:YES];
}
@end
