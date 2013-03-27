//
//  LocalPhotoesController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "LocalAlbumsController.h"
#import "AlbumPhotoesController.h"

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
    [_myTableView release];
    [_library release];
    [_assetGroups release];
    [_dataSourceArray release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customerNavigationBar];
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    _myTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_myTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self readAlbum];
}
- (void)customerNavigationBar
{
    UIButton *leftBtn = [[[UIButton alloc] init] autorelease];
    [leftBtn setImage:[UIImage imageNamed:@"LeftSideViewIcon.png"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0.0, 0.0, 53.0, 30.0);
    [leftBtn addTarget:self action:@selector(leftButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:leftBtn] autorelease];
}
- (void)leftButtonClickHandler:(id)sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}
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
//            NSLog(@"%@",[group valueForProperty:ALAssetsGroupPropertyName]);
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
#pragma mark CellDelegate
- (void)photoAlbumCell:(PhotoAlbumCell *)photoCell clickCoverGroup:(ALAssetsGroup *)group
{
    NSLog(@"%@",[group valueForProperty:ALAssetsGroupPropertyName]);
    [self.navigationController pushViewController:[[[AlbumPhotoesController alloc] initWithAssetGroup:group] autorelease] animated:YES];
}
@end
