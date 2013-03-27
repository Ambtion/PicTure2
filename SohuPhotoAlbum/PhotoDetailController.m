//
//  PhotoDetailController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PhotoDetailController.h"
#define OFFSETX 20

@interface PhotoDetailController ()
@property(nonatomic,retain)NSArray * assetsArray;
@property(nonatomic,assign)NSInteger curPageNum;
@end

@implementation PhotoDetailController
@synthesize assetsArray = _assetsArray;
@synthesize curPageNum = _curPageNum;

- (void)dealloc
{
    [_assetsArray release];
    [_curImageArray release];
    [_scrollView release];
    [super dealloc];
}

- (id)initWithAssetsArray:(NSArray *)array andCurAsset:(ALAsset *)asset
{
    self = [super init];
    if (self) {
        self.curPageNum = [array indexOfObject:asset];
        self.assetsArray = [[array copy] autorelease];
        NSLog(@"assetArray:%d, cunum:%d",_assetsArray.count,_curPageNum);
        _curImageArray = [[NSMutableArray arrayWithCapacity:0] retain];
    }
    return self;
}

#pragma mark - initSubView
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizingBar];
    [self initSubViews];
    [self setScrollViewProperty];
    [self refreshScrollView];
}
- (void)customizingBar
{
    //cus
//    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    UITabBarItem * tab = [[UITabBarItem alloc] initWithTitle:@"titile" image:nil tag:0];
    self.tabBarItem = tab;
}
- (void)initSubViews
{
    CGRect rect = self.view.bounds;
    rect.size.width += OFFSETX * 2;
    rect.origin.x -= OFFSETX;
    _scrollView = [[UIScrollView alloc] initWithFrame:rect];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _fontScaleImage = [[ImageScaleView alloc] initWithFrame:CGRectMake(OFFSETX,0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _fontScaleImage.imageView.backgroundColor = [UIColor redColor];
    _curScaleImage = [[ImageScaleView alloc]initWithFrame:CGRectMake(OFFSETX + _scrollView.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _rearScaleImage = [[ImageScaleView alloc] initWithFrame:CGRectMake(OFFSETX + _scrollView.bounds.size.width * 2, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [_scrollView addSubview:_fontScaleImage];
    [_scrollView addSubview:_curScaleImage];
    [_scrollView addSubview:_rearScaleImage];
}
- (void)setScrollViewProperty
{
    _scrollView.pagingEnabled = YES;
//    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3 , _scrollView.bounds.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
}

#pragma mark - Refresh ScrollView
- (void)refreshScrollView
{
    self.title = [NSString stringWithFormat:@"%d/%d",_curPageNum + 1,_assetsArray.count];
    if (_assetsArray.count <= 3) {
        [self refreshScrollViewWhenPhotonumLessThree];
    }else if (_curPageNum == 0) {
        [self refreshScrollViewOnMinBounds];
    }else if (_curPageNum == _assetsArray.count - 1) {
        [self refreshScrollViewOnMaxBounds];
    }else{
        [self refreshScrollViewNormal];
    }
}
- (void)refreshScrollViewOnMinBounds
{
    _fontScaleImage.imageView.image = [self getImageFromAsset:[_assetsArray objectAtIndex:0]];
    _curScaleImage.imageView.image = [self getImageFromAsset:[_assetsArray objectAtIndex:1]];
    _rearScaleImage.imageView.image = [self getImageFromAsset:[_assetsArray objectAtIndex:2]];
    [self resetAllImagesFrame];
    [_scrollView setContentOffset:CGPointZero];
    Imagestate = AtLess;
}
- (void)refreshScrollViewOnMaxBounds
{
    _fontScaleImage.imageView.image = [self getImageFromAsset:[_assetsArray objectAtIndex:_assetsArray.count - 3]];
    _curScaleImage.imageView.image = [self getImageFromAsset:[_assetsArray objectAtIndex:_assetsArray.count - 2]];
    _rearScaleImage.imageView.image = [self getImageFromAsset:[_assetsArray objectAtIndex:_assetsArray.count - 1]];
    [self resetAllImagesFrame];
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * 2,0)];
    Imagestate = AtMore;
}
- (void)refreshScrollViewWhenPhotonumLessThree
{
    _fontScaleImage.imageView.image = [self getImageFromAsset:[_assetsArray objectAtIndex:0]];
    if (_assetsArray.count == 2) {
        _curScaleImage.imageView.image = [self getImageFromAsset:[_assetsArray objectAtIndex:1]];
    }else if(_assetsArray.count == 3){
        _curScaleImage.imageView.image = [self getImageFromAsset:[_assetsArray objectAtIndex:1]];
        _rearScaleImage.imageView.image = [self getImageFromAsset:[_assetsArray objectAtIndex:2]];
    }else{
        _curScaleImage.imageView.image = nil;
        _rearScaleImage.imageView.image = nil;
    }
    [self resetAllImagesFrame];
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * _curPageNum, 0)];
}
- (void)refreshScrollViewNormal
{
    if ([self getDisplayImagesWithCurpage:_curPageNum])
    {
        //read images into curImages
        _fontScaleImage.imageView.image = [self getImageFromAsset:[_curImageArray objectAtIndex:0]];
        _curScaleImage.imageView.image = [self getImageFromAsset:[_curImageArray objectAtIndex:1]];
        _rearScaleImage.imageView.image = [self getImageFromAsset:[_curImageArray objectAtIndex:2]];
        [self resetAllImagesFrame];
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }
    Imagestate = AtNomal;
}


#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
//    if (![aScrollView isDragging] || !_assetsArray || !_assetsArray.count)      return;
    if (_assetsArray.count <= 3) {
        _curPageNum = _scrollView.contentOffset.x / _scrollView.frame.size.width;
        return;
    }
    int x = aScrollView.contentOffset.x;
    if (x == aScrollView.frame.size.width) {
        if (Imagestate != AtNomal) {
            if (Imagestate == AtLess) _curPageNum++;
            if (Imagestate == AtMore) _curPageNum--;
            Imagestate = AtNomal;
            [self refreshScrollView];
        }
        return;
    }
    if(x == (aScrollView.frame.size.width * 2)) {
        _curPageNum = [self validPageValue:_curPageNum + 1];
        [self refreshScrollView];
        return;
    }
    if(x == 0) {
        _curPageNum = [self validPageValue:_curPageNum - 1];
        [self refreshScrollView];
    }
}

#pragma mark - Function
- (void)resetAllImagesFrame
{
    //设置图片的大小
}
- (UIImage *)getImageFromAsset:(ALAsset *)asset
{
    return [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
}
- (NSArray *)getDisplayImagesWithCurpage:(int)page
{    
    int pre = [self validPageValue:_curPageNum -1];
    int last = [self validPageValue:_curPageNum+1];
    if([_curImageArray count] != 0) [_curImageArray removeAllObjects];
    [_curImageArray addObject:[_assetsArray objectAtIndex:pre]];
    [_curImageArray addObject:[_assetsArray objectAtIndex:_curPageNum]];
    [_curImageArray addObject:[_assetsArray objectAtIndex:last]];
    
    return _curImageArray;
}
- (int)validPageValue:(NSInteger)value
{
    if(value <= 0) value = 0;                   // value＝1为第一张，value = 0为前面一张
    if(value >= _assetsArray.count) value = _assetsArray.count - 1;
    return value;
}

@end
