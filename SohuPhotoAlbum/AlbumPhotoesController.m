//
//  PhotoesViewController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "AlbumPhotoesController.h"
#import "PhotoDetailController.h"

@interface AlbumPhotoesController ()

@property(nonatomic,retain)NSMutableArray * assetsArray;
@property(nonatomic,retain)NSMutableArray * dataSourceArray;

@end

@implementation AlbumPhotoesController
@synthesize assetGroup = _assetGroup;
@synthesize assetsArray = _assetsArray;
@synthesize dataSourceArray = _dataSourceArray;

- (void)dealloc
{
    [_assetGroup release];
    [_myTableView release];
    [_assetsArray release];
    [_dataSourceArray release];
    [super dealloc];
}
- (id)initWithAssetGroup:(ALAssetsGroup *)AnAssetGroup
{
    if (self = [super init]) {
        self.assetGroup = AnAssetGroup;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    _myTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_myTableView];
    [self readPhotoAssetes];
}
-(void)readPhotoAssetes
{
    self.assetsArray = [NSMutableArray arrayWithCapacity:0];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
     {
         if(result == nil){
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.assetsArray = [self revertObjectArray:self.assetsArray];
                 [self prepareDataWithTimeOrder];
             });
             return;
         }
         [self.assetsArray addObject:result];
    }];
    [pool release];
}
- (void)prepareDataWithTimeOrder
{
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.assetsArray.count; i+=4) {
        PhotoesCellDataSource * source = [[[PhotoesCellDataSource alloc] init] autorelease];
        source.firstAsset = [self.assetsArray objectAtIndex:i];
        if (i + 1 < self.assetsArray.count)
            source.secoundAsset = [self.assetsArray objectAtIndex:i+1];
        if (i + 2 < self.assetsArray.count)
            source.thridAsset = [self.assetsArray objectAtIndex:i+2];
        if (i + 3 < self.assetsArray.count)
            source.lastAsset = [self.assetsArray objectAtIndex:i+3];
        [self.dataSourceArray addObject:source];
    }
    [_myTableView reloadData];
}
- (NSMutableArray *)revertObjectArray:(NSMutableArray *)array
{
    NSMutableArray * finalArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = array.count - 1; i >= 0; i--)
        [finalArray addObject:[array objectAtIndex:i]];
    return finalArray;
}

#pragma mark - tableDataSource
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
    PhotoesCellDataSource * source = [self.dataSourceArray objectAtIndex:indexPath.row];
    return [source cellHigth];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"photoCELLId";
    PhotoesCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[PhotoesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.delegate = self;
    }
    if (indexPath.row < self.dataSourceArray.count)
        cell.dataSource = [[self dataSourceArray] objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark photoClick
- (void)photoesCell:(PhotoesCell *)cell clickAsset:(ALAsset *)asset
{
    PhotoDetailController * ph = [[[PhotoDetailController alloc] initWithAssetsArray:self.assetsArray andCurAsset:asset] autorelease];
    [self.navigationController pushViewController:ph animated:YES];
}
- (void)photoesCell:(PhotoesCell *)cell clickAsset:(ALAsset *)asset Select:(BOOL)isSelected
{
    
}
@end
