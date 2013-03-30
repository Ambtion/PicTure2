//
//  PhotoDetailController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PhotoDetailController.h"
#import "LocalShareController.h"

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
    [_tabBar release];
    [_cusBar release];
    [_library release];
    [super dealloc];
}

- (id)initWithAssetsArray:(NSArray *)array andCurAsset:(ALAsset *)asset
{
    self = [super init];
    if (self) {
        self.wantsFullScreenLayout = YES;
        self.curPageNum = [array indexOfObject:asset];
        self.assetsArray = [[array copy] autorelease];
        _curImageArray = [[NSMutableArray arrayWithCapacity:0] retain];
        _isHidingBar = NO;
        _library = [[ALAssetsLibrary alloc] init];
    }
    return self;
}

#pragma mark - initSubView
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSubViews];
    [self setScrollViewProperty];
    [self refreshScrollView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (!_cusBar){
        _cusBar = [[CusNavigationBar alloc] initwithDelegate:self];
        _cusBar.frame = CGRectMake(0, 20, 320, 44);
        _cusBar.backgroundColor = [UIColor clearColor];
        [_cusBar setBackgroundImage:[UIImage imageNamed:@"full_screen_title-bar.png"]];
        [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"full_screen_back.png"] forState:UIControlStateNormal];
        _cusBar.nLabelText.textColor = [UIColor whiteColor];
        _cusBar.nLabelText.font = [UIFont systemFontOfSize:22];
        [self upCusTitle];
        [_cusBar.nRightButton1 setUserInteractionEnabled:NO];
        [_cusBar.nRightButton2 setUserInteractionEnabled:NO];
        [_cusBar.nRightButton3 setUserInteractionEnabled:NO];
    }
    if (!_cusBar.superview)
        [self.view addSubview:_cusBar];

    if (!_tabBar) {
        _tabBar  = [[CusTabBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 0, 0) delegate:self];
        //bar没有隐藏 view.higth = 416;
    }
    if (!_tabBar.superview) {
        [self.view addSubview:_tabBar];
    }
}

- (void)upCusTitle
{
    [_cusBar.nLabelText setText:[NSString stringWithFormat:@"%d/%d",_curPageNum, _assetsArray.count]];
}

- (void)initSubViews
{
    self.view.frame = [[UIScreen mainScreen] bounds];
    CGRect rect = self.view.bounds;
    rect.size.width += OFFSETX * 2;
    rect.origin.x -= OFFSETX;
    _scrollView = [[UIScrollView alloc] initWithFrame:rect];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    _fontScaleImage = [[ImageScaleView alloc] initWithFrame:CGRectMake(OFFSETX,0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _fontScaleImage.Adelegate = self;
    _curScaleImage = [[ImageScaleView alloc]initWithFrame:CGRectMake(OFFSETX + _scrollView.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _curScaleImage.Adelegate = self;
    _rearScaleImage = [[ImageScaleView alloc] initWithFrame:CGRectMake(OFFSETX + _scrollView.bounds.size.width * 2, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _rearScaleImage.Adelegate = self;
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
    if (!_assetsArray.count) return;
    [self upCusTitle];
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
        [self upCusTitle];
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
#pragma mark - BarDelegate
- (void)cusNavigationBar:(CusNavigationBar *)bar buttonClick:(UIButton *)button
{
    if (button.tag == LEFTBUTTON)
        [self.navigationController popViewControllerAnimated:YES];
}
- (void)cusTabBar:(CusTabBar *)bar buttonClick:(UIButton *)button
{
    if (button.tag == TABSHARETAG) {
        [self.navigationController pushViewController:[[[LocalShareController alloc] init] autorelease] animated:YES];
    }
    if (button.tag == TABDOWNLOADNTAG) {
        
    }
    if (button.tag == TABEDITTAG) {
        
    }
    if (button.tag == TABDELETETAG) {
        
    }
}

#pragma mark - handleGuesture
- (void)imageViewScale:(ImageScaleView *)imageScale clickCurImage:(UIImageView *)imageview
{
    if (_isHidingBar) {
        [self showBar];
    }else{
        [self hideBar];
    }
}
- (void)showBar
{
    [self.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
        CGRect navBar = CGRectMake(0, 20, 320, 44);
        CGRect tabBar = CGRectMake(0, self.view.frame.size.height - 44, 320, 44);
        _cusBar.frame = navBar;
        _tabBar.frame = tabBar;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    } completion:^(BOOL finished) {
        [self.view setUserInteractionEnabled:YES];
        _isHidingBar = NO;
    }];
}
- (void)hideBar
{
    [self.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
        CGRect navBar = CGRectMake(0, -44, 320, 44);
        CGRect tabBar = CGRectMake(0, self.view.frame.size.height, 320, 44);
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        _cusBar.frame = navBar;
        _tabBar.frame = tabBar;
    } completion:^(BOOL finished) {
        [self.view setUserInteractionEnabled:YES];
        _isHidingBar = YES;
    }];
}
@end
