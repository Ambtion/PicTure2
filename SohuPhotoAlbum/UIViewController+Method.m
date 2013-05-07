//
//  UIViewController+DivideAssett.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "UIViewController+Method.h"
#import "CloudPictureCell.h"
#import "PhotoesCell.h"

@implementation UIViewController (Method)
#pragma mark Data divideAssettByDayTime

- (void)cloundDivideAssettByDayTimeWithAssetArray:(NSMutableArray *)_assetsArray exportToassestionArray:(NSMutableArray *)assetsSection assetSectionisShow:(NSMutableArray *)_assetSectionisShow dataScource:(NSMutableArray *)dataSourceArray
{
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < _assetsArray.count; i++) {
        NSDictionary * asset = [_assetsArray objectAtIndex:i];
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:[[asset objectForKey:@"taken_at"] longLongValue] / 1000.f];
        NSString * dateString = [self stringFromdate:date];
        if (![self array:assetsSection hasTimeString:dateString]){
            [assetsSection addObject:dateString];
            NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
            [array addObject:asset];
            [tempArray addObject:array];
            [_assetSectionisShow addObject:[NSNumber numberWithBool:YES]];
        }else{
            NSMutableArray * array = [tempArray objectAtIndex:[assetsSection indexOfObject:dateString]];
            [array addObject:asset];
        }
    }
    for (NSMutableArray * array in tempArray )
        [dataSourceArray addObject:[self cloundCoverAssertToDataSource:array]];
}
- (NSMutableArray *)cloundCoverAssertToDataSource:(NSMutableArray *)array
{
    NSMutableArray * finalArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i+=4) {
        CloudPictureCellDataSource * source = [[CloudPictureCellDataSource alloc] init];
        source.firstDic = [array objectAtIndex:i];
        if (i + 3 < array.count) {
            source.secoundDic = [array objectAtIndex:i+1];
            source.thridDic  = [array objectAtIndex:i+2];
            source.lastDic = [array objectAtIndex:i+3];
        }else if (i + 2 < array.count){
            source.secoundDic = [array objectAtIndex:i+1];
            source.thridDic = [array objectAtIndex:i+2];
            source.lastDic = nil;
        }else if (i + 1 < array.count){
            source.secoundDic = [array objectAtIndex:i+1];
            source.lastDic = nil;
            source.thridDic = nil;
        }
        [finalArray addObject:source];
    }
    return finalArray;
}
- (NSString *)stringFromdate:(NSDate *)date
{
    //转化日期格式
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
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

#pragma mark Local
- (void)localDivideAssettByDayTimeWithAssetArray:(NSMutableArray *)assetsArray exportToassestionArray:(NSMutableArray *)assetsSection assetSectionisShow:(NSMutableArray *)assetSectionisShow dataScource:(NSMutableArray *)dataSourceArray
{
    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < assetsArray.count; i++) {
        ALAsset * asset = [assetsArray objectAtIndex:i];
        NSDate * date = [asset valueForProperty:ALAssetPropertyDate];
        NSString * dateString = [self stringFromdate:date];
        if (![self array:assetsSection hasTimeString:dateString]){
            [assetsSection addObject:dateString];
            NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
            [array addObject:asset];
            [tempArray addObject:array];
            [assetSectionisShow addObject:[NSNumber numberWithBool:YES]];
        }else{
            NSMutableArray * array = [tempArray objectAtIndex:[assetsSection indexOfObject:dateString]];
            [array addObject:asset];
        }
    }
    for (NSMutableArray * array in tempArray )
        [dataSourceArray addObject:[self coverAssertToDataSource:array]];
}
- (NSMutableArray *)coverAssertToDataSource:(NSMutableArray *)array
{
    NSMutableArray * finalArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i+=4) {
        PhotoesCellDataSource * source = [[PhotoesCellDataSource alloc] init];
        source.firstAsset = [array objectAtIndex:i];
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
    }
    return finalArray;
}

#pragma mark Srot
- (NSMutableArray *)sortArrayByTime:(NSMutableArray *)array
{
   return [[array sortedArrayUsingFunction:sort context:nil] mutableCopy];
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
#pragma mark SectionView
- (UIView *)getSectionView:(NSInteger)section withImageCount:(NSInteger)count ByisShow:(BOOL)isShowRow WithTimeText:(NSString *)labelText
{
    UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 28)];
    [view setUserInteractionEnabled:YES];
    UITapGestureRecognizer * tap  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapInSection:)    ];
    [view addGestureRecognizer:tap];
    view.tag = section;
    
    UIImageView * iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 3, 22, 22)];
    [view addSubview:iconImage];
    //label
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, 100, 24)];
    label.font = [UIFont boldSystemFontOfSize:12.f];
    label.backgroundColor = [UIColor clearColor];
    label.text = labelText;
    [view addSubview:label];
    UILabel * countLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 2, 55, 24)];
    countLabel.font = [UIFont boldSystemFontOfSize:12.f];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.textAlignment = UITextAlignmentRight;
    countLabel.text = [NSString stringWithFormat:@"%d",count];
    [view addSubview:countLabel];
    
    if (isShowRow) {
        label.textColor = [UIColor colorWithRed:189.f/255 green:189.f/255 blue:189.f/255 alpha:1.f];
        countLabel.textColor  =[UIColor colorWithRed:189.f/255 green:189.f/255 blue:189.f/255 alpha:1.f];
        iconImage.image = [UIImage imageNamed:@"sectionIcon.png"];
        view.image = [UIImage imageNamed:@"section.png"];
    }else{
        label.textColor = [UIColor colorWithRed:100.f/255 green:100.f/255 blue:100.f/255 alpha:1.f];
        countLabel.textColor = [UIColor colorWithRed:100.f/255 green:100.f/255 blue:100.f/255 alpha:1.f];
        iconImage.image = [UIImage imageNamed:@"sectionIconNo.png"];
        view.image = [UIImage imageNamed:@"sectionNo.png"];
    }
    return view;
}
@end

@implementation UIViewController(Private)
- (void)showLoginViewWithMethodNav:(BOOL)isNav
{
    LoginViewController * loginView = [[LoginViewController alloc] init];
    loginView.delegate = (UIViewController<LoginViewControllerDelegate> *)self;
    if (isNav) {
        [self.navigationController pushViewController:loginView animated:YES];
    }else{
        [self presentModalViewController:loginView animated:YES];
    }
}

@end