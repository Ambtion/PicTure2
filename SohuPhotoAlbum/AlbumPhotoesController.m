//
//  PhotoesViewController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "AlbumPhotoesController.h"
#import "PhotoDetailController.h"
#import "AppDelegate.h"

#define BACKGORUNDCOLOR [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1.f]

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
- (id)initWithAssetGroup:(ALAssetsGroup *)AnAssetGroup andViewState:(viewState)state
{
    if (self = [super init]) {
        self.assetGroup = AnAssetGroup;
        _viewState = state;
        if (state == UPloadState) {
            isInitUpload = YES;
        }else{
            isInitUpload = NO;
        }
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
    _myTableView.backgroundColor = BACKGORUNDCOLOR;
    [_myTableView setScrollsToTop:YES];
    [self.view addSubview:_myTableView];
}

#pragma mark - NavigationBar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_cusBar){
        _cusBar = [[CusNavigationBar alloc] initwithDelegate:self];
        [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [_cusBar.nLabelText setText:[NSString stringWithFormat:@"%@",[self.assetGroup valueForProperty:ALAssetsGroupPropertyName]]];
        [_cusBar.nRightButton1 setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
        [_cusBar.nRightButton2 setUserInteractionEnabled:NO];
        [_cusBar.nRightButton2 setUserInteractionEnabled:NO];
        
        [_cusBar.sLabelText setText:[NSString stringWithFormat:@"%@",[self.assetGroup valueForProperty:ALAssetsGroupPropertyName]]];
        [_cusBar.sRightStateButton setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
        if (_viewState == UPloadState)
            [_cusBar switchBarState];
    }
    if (!_cusBar.superview)
        [self.navigationController.navigationBar addSubview:_cusBar];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self readPhotoAssetes];
}

- (void)cusNavigationBar:(CusNavigationBar *)bar buttonClick:(UIButton *)button
{
    if (button.tag == LEFTBUTTON) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (button.tag == RIGHT1BUTTON) {
        //上传页面
        _viewState = UPloadState;
        [_cusBar switchBarState];

    }
    if(button.tag == CANCELBUTTONTAG){
        if (isInitUpload) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        _viewState = NomalState;
        [_cusBar switchBarState];
    }
}
- (void)readPhotoAssetes
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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = BACKGORUNDCOLOR;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoesCellDataSource * source = [self.dataSourceArray objectAtIndex:indexPath.row];
    if (indexPath.row == self.dataSourceArray.count - 1) {
        return [source cellLastHigth];
    }
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
