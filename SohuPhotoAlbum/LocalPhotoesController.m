//
//  LocalPhotoseController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "LocalPhotoesController.h"

@interface LocalPhotoesController ()
@property(nonatomic,retain)NSMutableArray *assetGroups;
@property(nonatomic,retain)NSMutableArray *assetsArray;
@property(nonatomic,retain)NSMutableArray *dataSourceArray;
@property(nonatomic,retain)NSMutableArray *assetsSection;
@end

@implementation LocalPhotoesController
@synthesize assetGroups,assetsArray,dataSourceArray,assetsSection;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_myTableView release];
    [_library release];
    [assetGroups release];
    [assetsArray release];
    [dataSourceArray release];
    [assetsSection release];
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
#pragma mark - read data
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
        PhotoesCellDataSource * source = [[[PhotoesCellDataSource alloc] init] autorelease];
        source.firstAsset = [self.assetsArray objectAtIndex:i];
        if (i + 1 < self.assetsArray.count)
            source.secoundAsset = [self.assetsArray objectAtIndex:i+1];
        if (i + 2 < self.assetsArray.count)
            source.thridAsset = [self.assetsArray objectAtIndex:i+2];
        if (i + 3 < self.assetsArray.count)
            source.lastAsset = [self.assetsArray objectAtIndex:i+3];
        [finalArray addObject:source];
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.assetsSection objectAtIndex:section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataSourceArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoesCellDataSource * source = [[self.dataSourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
    return cell;
}

@end
