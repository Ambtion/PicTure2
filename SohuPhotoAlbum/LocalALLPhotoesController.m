//
//  LocalPhotoseController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "LocalALLPhotoesController.h"
#import "LocalAlbumsController.h"
#import "PhotoDetailController.h"

#define BACKGORUNDCOLOR [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1.f]

@interface LocalALLPhotoesController ()
@property(nonatomic,retain)NSMutableArray *assetGroups;
@property(nonatomic,retain)NSMutableArray *assetsArray;
@property(nonatomic,retain)NSMutableArray *dataSourceArray;
@property(nonatomic,retain)NSMutableArray *assetsSection;
@property(nonatomic,retain)NSMutableArray *selectedArray;
@end

@implementation LocalALLPhotoesController
@synthesize assetGroups,assetsArray,dataSourceArray,assetsSection,selectedArray;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_myTableView release];
    [_library release];
    [assetGroups release];
    [assetsArray release];
    [dataSourceArray release];
    [assetsSection release];
    [selectedArray release];
    [_cusBar release];
    
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    _myTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorColor = [UIColor clearColor];
    _myTableView.backgroundColor = BACKGORUNDCOLOR;
    [_myTableView setScrollsToTop:YES];
    self.selectedArray = [NSMutableArray arrayWithCapacity:0];
    [self.view addSubview:_myTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - CusNavigatinBar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self readAlbum];
    if (!_cusBar){
        _cusBar = [[CusNavigationBar alloc] initwithDelegate:self];
        [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [_cusBar.nLabelImage setImage:[UIImage imageNamed:@"localAlbums.png"]];
        [_cusBar.nRightButton1 setImage:[UIImage imageNamed:@"timeline-view.png"] forState:UIControlStateNormal];
//        [_cusBar.rightButton2 setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [_cusBar.nRightButton2 setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
        [_cusBar.nRightButton3 setUserInteractionEnabled:NO];
    }
    if (!_cusBar.superview)
        [self.navigationController.navigationBar addSubview:_cusBar];
}

- (void)cusNavigationBar:(CusNavigationBar *)bar buttonClick:(UIButton *)button
{
    if (button.tag == LEFTBUTTON) {
        [self.viewDeckController toggleLeftViewAnimated:YES];
    }
    if (button.tag == RIGHT1BUTTON) { //切换页面
        LocalAlbumsController * lcA = [[[LocalAlbumsController alloc] init] autorelease];
        [self.navigationController pushViewController:lcA animated:NO];
    }
    if (button.tag == RIGHT2BUTTON) { //上传
        [_cusBar.sRightStateButton setImage:[UIImage imageNamed:@"upload.png"] forState:UIControlStateNormal];
        [_cusBar switchBarState];
        _viewState = UPloadState;
        [_myTableView reloadData];
    }
    if (button.tag == CANCELBUTTONTAG) {
        [_cusBar switchBarState];
        _viewState = NomalState;
        [_myTableView reloadData];
    }
}

#pragma mark - read data
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
                [self readPhotoes];
            });
            return ;
        }
        if ([group numberOfAssets])
            [self.assetGroups addObject:group];
    } failureBlock:^(NSError *error) {
        
    }];
    [pool drain];
}
- (void)readPhotoes
{
    self.assetsArray = [NSMutableArray arrayWithCapacity:0];
    [self readPhotoesWithgroup:self.assetGroups];
}
- (void)readPhotoesWithgroup:(NSMutableArray *)groupArray
{
    if (!groupArray.count) {
        [self prepareDataWithTimeOrder];
        return;
    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [[groupArray lastObject] enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
     {
         if(result == nil){
             dispatch_async(dispatch_get_main_queue(), ^{
                 [groupArray removeLastObject];
                 [self readPhotoesWithgroup:groupArray];
             });
             return;
         }
         [self.assetsArray addObject:result];
     }];
    [pool release];
}
#pragma mark dataSort
- (void)prepareDataWithTimeOrder
{
    //asserts按日期大小排序;
    self.assetsArray = [[[self.assetsArray sortedArrayUsingFunction:sort context:nil] mutableCopy] autorelease];
    
    //对asset分组
    [self divideAssettByDayTime];
    [_myTableView reloadData];
}
- (void)divideAssettByDayTime
{
    NSLog(@"start divide");
    self.assetsSection = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.assetsArray.count; i++) {
        ALAsset * asset = [self.assetsArray objectAtIndex:i];
        NSDate * date = [asset valueForProperty:ALAssetPropertyDate];
        NSString * dateString = [self stringFromdate:date];
        if (![self array:self.assetsSection hasTimeString:dateString]){
            [self.assetsSection addObject:dateString];
            NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
            [array addObject:asset];
            [tempArray addObject:array];
        }else{
            NSMutableArray * array = [tempArray objectAtIndex:[self.assetsSection indexOfObject:dateString]];
            [array addObject:asset];
        }
    }
    self.dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    for (NSMutableArray * array in tempArray )
        [self.dataSourceArray addObject:[self coverAssertToDataSource:array]];
    NSLog(@"divide end");
}
- (NSMutableArray *)coverAssertToDataSource:(NSMutableArray *)array
{
    NSMutableArray * finalArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i+=4) {
        PhotoesCellDataSource * source = [[PhotoesCellDataSource alloc] init];
        source.firstAsset = [self.assetsArray objectAtIndex:i];
        if (i + 3 < array.count) {
            source.secoundAsset = [array objectAtIndex:i+1];
            source.thridAsset = [array objectAtIndex:i+2];
            source.lastAsset = [array objectAtIndex:i+3];
        }else if (i + 2 < array.count){
            source.secoundAsset = [array objectAtIndex:i+1];
            source.thridAsset = [array objectAtIndex:i+2];
            source.lastAsset = nil;
        }else if (i + 1 < array.count){
            source.secoundAsset = [array objectAtIndex:i+1];
            source.lastAsset = nil;
            source.thridAsset = nil;
        }
        [finalArray addObject:source];
        [source release];
    }
    return finalArray;
}
- (void)setSectionTimeofAssertsIntoArray
{
    //获取不同天数的日期(string)
    self.assetsSection = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.assetsArray.count; i++) {
        NSDate * date = [[self.assetsArray objectAtIndex:i] valueForProperty:ALAssetPropertyDate];
        NSString * dateString = [self stringFromdate:date];
        if (![self array:self.assetsSection hasTimeString:dateString])
            [self.assetsSection addObject:dateString];
    }
}
- (NSString *)stringFromdate:(NSDate *)date
{
    //转化日期格式
    NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}
- (BOOL)array:(NSMutableArray *)array hasTimeString:(NSString *)date
{
    //获得的string time是否有重复;
    for (NSString * str in array) {
        if ([str isEqualToString:date])
            return YES;
    }
    return NO;
}
NSInteger sort( ALAsset *asset1,ALAsset *asset2,void *context)
{
    //日期由近到远排序
    double key1 = [[asset1 valueForProperty:ALAssetPropertyDate] timeIntervalSinceReferenceDate];
    double key2 = [[asset2 valueForProperty:ALAssetPropertyDate] timeIntervalSinceReferenceDate];
    if (key1 < key2 ) {
        //key1大于key2
        return NSOrderedDescending;
    }else if (key1 == key2) {
        //相同
        return NSOrderedSame;
    }else {
        return NSOrderedAscending;
    }
}

#pragma mark - tableDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView * view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 24)] autorelease];
    view.image = [UIImage imageNamed:@"index-bar.png"];
    UILabel * label = [[[UILabel alloc] initWithFrame:CGRectMake(6, 0, 314, 24)] autorelease];
    label.textAlignment = UITextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13.f];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:98.f/255.f green:98.f/255.f blue:98.f/255.f alpha:1.f];
    label.text = [self.assetsSection objectAtIndex:section];
    [view addSubview:label];
    return view;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = BACKGORUNDCOLOR;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataSourceArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoesCellDataSource * source = [[self.dataSourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (indexPath.row == [[self.dataSourceArray objectAtIndex:indexPath.section] count] - 1) {
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
    if (indexPath.section < self.dataSourceArray.count
        && indexPath.row < [[self.dataSourceArray objectAtIndex:indexPath.section] count])
        cell.dataSource = [[[self dataSourceArray] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (_viewState != NomalState){
        [cell showCellSelectedStatus];
    }else{
        [cell hiddenCellSelectedStatus];
    }
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
    if (isSelected) {
        [self.selectedArray addObject:asset];
    }else if([self.selectedArray containsObject:asset]){
        [self.selectedArray removeObject:asset];
    }
}
@end
