//
//  PhotoDetailController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PhotoDetailBaseController.h"
#import "LocalShareController.h"
#import "AppDelegate.h"

#define OFFSETX 20

static  UIDeviceOrientation PreOrientation = UIDeviceOrientationPortrait;

@implementation PhotoDetailBaseController
@synthesize assetsArray = _assetsArray;
@synthesize curPageNum = _curPageNum;
@synthesize scrollView = _scrollView,fontScaleImage = _fontScaleImage,curScaleImage = _curScaleImage,rearScaleImage = _rearScaleImage;
@synthesize tabBar = _tabBar;
//@synthesize cusBar = _cusBar;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - initSubView
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self reloadAllSubViews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setStatueBar];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resetStatueBar];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(listOrientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}
- (void)setStatueBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)resetStatueBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)upCusTitle
{
//    [_cusBar.nLabelText setText:[NSString stringWithFormat:@"%d/%d",_curPageNum + 1, _assetsArray.count]];
}

#pragma mark - ReloadSubViews
- (void)reloadAllSubViews
{
    [self initSubViews];
    [self setScrollViewProperty];
    [self refreshScrollView];
    if (_isInit || _isRotating) {
        _isInit = NO;
        _isRotating = NO;
        [self scrollViewDidEndDecelerating:self.scrollView];
    }
}
- (void)initSubViews
{
    NSArray * aray = [self.view subviews];
    [aray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.view.frame = self.view.bounds;

    CGRect rect = self.view.bounds;
    rect.size.width += OFFSETX * 2;
    rect.origin.x -= OFFSETX;
    self.scrollView = [[UIScrollView alloc] initWithFrame:rect];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    self.fontScaleImage = [[ImageScaleView alloc] initWithFrame:CGRectMake(OFFSETX,0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.fontScaleImage.Adelegate = self;
    self.curScaleImage = [[ImageScaleView alloc]initWithFrame:CGRectMake(OFFSETX + _scrollView.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.curScaleImage.Adelegate = self;
    self.rearScaleImage = [[ImageScaleView alloc] initWithFrame:CGRectMake(OFFSETX + _scrollView.bounds.size.width * 2, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
     self.rearScaleImage.Adelegate = self;
    [_scrollView addSubview:_fontScaleImage];
    [_scrollView addSubview:_curScaleImage];
    [_scrollView addSubview:_rearScaleImage];
    [self addBar];
}
- (void)addBar
{
//    self.cusBar = [[CustomizationNavBar alloc] initwithDelegate:self];
//    if (_isHidingBar) {
//        _cusBar.frame = CGRectMake(0, -44, 320, 44);
//    }else{
//        _cusBar.frame = CGRectMake(0, 20, 320, 44);
//    }
//    _cusBar.backgroundColor = [UIColor clearColor];
//    [_cusBar setBackgroundImage:[UIImage imageNamed:@"full_screen_title-bar.png"]];
//    [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"full_screen_back.png"] forState:UIControlStateNormal];
//    _cusBar.nLabelText.textColor = [UIColor whiteColor];
//    _cusBar.nLabelText.font = [UIFont systemFontOfSize:22];
//    [self upCusTitle];
//    [_cusBar.nRightButton1 setImage:[UIImage imageNamed:@"full_screen_download_icon.png"] forState:UIControlStateNormal];
//    [_cusBar.nRightButton2 setImage:[UIImage imageNamed:@"full_screen_share_icon.png"] forState:UIControlStateNormal];
//    [_cusBar.nRightButton3 setUserInteractionEnabled:NO];
//    [self.view addSubview:_cusBar];
    self.tabBar = [[CustomizetionTabBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49, 320, 49) delegate:self];
    if (CGAffineTransformEqualToTransform([self getTransfrom], CGAffineTransformIdentity) || !_isHidingBar)
        [self.view addSubview:_tabBar];
    if (_isHidingBar) {
        [self.tabBar hideBarWithAnimation:NO];
    }
}
- (void)setScrollViewProperty
{
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3 , _scrollView.bounds.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
}
#pragma mark - Ratation
- (CGAffineTransform )getTransfrom
{
    if (!_isHidingBar) return CGAffineTransformIdentity;
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
    if (UIInterfaceOrientationIsPortrait(orientation))
        return CGAffineTransformIdentity;
    if (orientation == UIInterfaceOrientationLandscapeLeft)
        return CGAffineTransformRotate(CGAffineTransformIdentity, - M_PI_2);
    if (orientation == UIInterfaceOrientationLandscapeRight)
        return CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
    return CGAffineTransformIdentity;
}

- (ImageScaleView *)getCurrentImageView
{
    ImageScaleView * view = nil;
    if (self.scrollView.contentOffset.x == 0)
        view = self.fontScaleImage;
    if (self.scrollView.contentOffset.x == self.scrollView.frame.size.width)
        view = self.curScaleImage;
    if (self.scrollView.contentOffset.x == self.scrollView.frame.size.width * 2)
        view = self.rearScaleImage;
    return view;
}
- (BOOL)isSupportOrientation
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (PreOrientation != orientation
        &&(UIDeviceOrientationIsPortrait(orientation)
           || UIDeviceOrientationIsLandscape(orientation))) {
            //可以旋转方向
            DLog(@"can rotation %d",orientation);
            if (UIDeviceOrientationIsLandscape(PreOrientation))
                return UIDeviceOrientationIsPortrait(orientation);
            if (UIDeviceOrientationIsPortrait(PreOrientation))
                return UIDeviceOrientationIsLandscape(orientation);
    }
    return NO;
}

- (void)listOrientationChanged:(NSNotification *)notification
{
    if (_isInit || !_isHidingBar ||![self isSupportOrientation]) return;
    PreOrientation = [[UIDevice currentDevice] orientation];
    [self.view setUserInteractionEnabled:NO];
    _isAnimating = YES;
    CGFloat scale = 1.0;
    CGAffineTransform transform = CGAffineTransformIdentity;
    [self getCurrentImageView].tapEnabled = NO;
    if (CGAffineTransformEqualToTransform([self getTransfrom], CGAffineTransformIdentity)) {
        transform = CGAffineTransformInvert(self.view.transform);
        CGSize identifySzie = [self getIdentifyImageSizeWithImageView:[self getCurrentImageView].imageView isPortraitorientation:YES];
        scale = MIN( identifySzie.width / [self getCurrentImageView].imageView.frame.size.width, identifySzie.height / [self getCurrentImageView].frame.size.height);
    }else{
        CGSize identifySzie = [self getIdentifyImageSizeWithImageView:[self getCurrentImageView].imageView isPortraitorientation:NO];
        scale = MIN( identifySzie.width / [self getCurrentImageView].imageView.frame.size.width, identifySzie.height / [self getCurrentImageView].imageView.frame.size.height);
        transform = [self getTransfrom];
    }
    transform  = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(scale, scale));
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut    animations:^{
        [self getCurrentImageView].imageView.transform = transform;
    } completion:^(BOOL finished) {
        self.view.transform = [self getTransfrom];
        if (CGAffineTransformEqualToTransform(self.view.transform, CGAffineTransformIdentity))
            self.view.frame = [UIScreen mainScreen].bounds;
        [self reloadAllSubViews];
        _isAnimating = NO;
        _isRotating = YES;
        [self.view setUserInteractionEnabled:YES];
    }];
}


#pragma mark - Refresh ScrollView
- (void)refreshScrollView
{
    if (!_assetsArray.count) return;
    _canGetActualImage = YES;
    //prevent than  when seting offset it can  scrollViewDidScroll
    _scrollView.delegate = nil;
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
    _scrollView.delegate = self;
}
- (void)refreshScrollViewOnMinBounds
{
    _fontScaleImage.imageView.image = [self getImageFromAsset:[_assetsArray objectAtIndex:0]];
    _curScaleImage.imageView.image = [self getImageFromAsset:[_assetsArray objectAtIndex:1]];
    _rearScaleImage.imageView.image = [self getImageFromAsset:[_assetsArray objectAtIndex:2]];

    [self resetAllImagesFrame];
    [_scrollView setContentOffset:CGPointZero];
    _imagestate = AtLess;
}
- (void)refreshScrollViewOnMaxBounds
{
    _fontScaleImage.imageView.image = [self getImageFromAsset:[_assetsArray objectAtIndex:_assetsArray.count - 3]];
    _curScaleImage.imageView.image = [self getImageFromAsset:[_assetsArray objectAtIndex:_assetsArray.count - 2]];
    _rearScaleImage.imageView.image = [self getImageFromAsset:[_assetsArray objectAtIndex:_assetsArray.count - 1]];

    [self resetAllImagesFrame];
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * 2,0)];
    _imagestate = AtMore;
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
        _fontScaleImage.imageView.image = [self getImageFromAsset:[_curImageArray objectAtIndex:0] ];
        _curScaleImage.imageView.image = [self getImageFromAsset:[_curImageArray objectAtIndex:1]];
        _rearScaleImage.imageView.image = [self getImageFromAsset:[_curImageArray objectAtIndex:2]];

        [self resetAllImagesFrame];
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }
    _imagestate = AtNomal;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    if (_isAnimating)  return;
    if (_assetsArray.count <= 3) {
        _curPageNum = _scrollView.contentOffset.x / _scrollView.frame.size.width;
        [self upCusTitle];
        return;
    }
    int  x = aScrollView.contentOffset.x;
    if (x == aScrollView.frame.size.width) {
        if (_imagestate != AtNomal) {
            if (_imagestate == AtLess) _curPageNum++;
            if (_imagestate == AtMore) _curPageNum--;
            _imagestate = AtNomal;
            [self refreshScrollView];
        }
        return;
    }
    if(x >= (aScrollView.frame.size.width * 2) && _curPageNum <= _assetsArray.count - 2) {
        _curPageNum = [self validPageValue:_curPageNum + 1];
        [self refreshScrollView];
        return;
    }
    if(x == (aScrollView.frame.size.width * 2) && _curPageNum == _assetsArray.count - 2) {
        _curPageNum = [self validPageValue:_curPageNum + 1];
        [self refreshScrollView];
        return;
    }
    if(x <= 0 && _curPageNum >= 1) {
        _curPageNum = [self validPageValue:_curPageNum - 1];
        [self refreshScrollView];
        return;
    }
    if(x == 0  && _curPageNum == 1) {
        _curPageNum = [self validPageValue:_curPageNum - 1];
        [self refreshScrollView];
        return;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self fixScrollViewOffset:scrollView];
    if (!_canGetActualImage)     return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self setActureImage];
    });
    _canGetActualImage =  NO;
}
- (void)fixScrollViewOffset:(UIScrollView *)scrollView
{
    CGPoint point = CGPointZero;
    point.y = 0;
    if (_curPageNum > 0 && _curPageNum < self.assetsArray.count - 1) {
        point.x = scrollView.frame.size.width;
    }else if(_curPageNum == 0){
        point.x = 0;
    }else{
        point.x = scrollView.frame.size.width * 2;
    }
    [scrollView setContentOffset:point animated:NO];
}

#pragma mark - GetImageFromAsset
- (void)setActureImage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_assetsArray.count <= 3) {
            switch (_assetsArray.count) {
                case 1:
                    _fontScaleImage.imageView.image = [self getActualImage:[_assetsArray objectAtIndex:0] andOrientation:0];
                    break;
                case 2:
                    _fontScaleImage.imageView.image = [self getActualImage:[_assetsArray objectAtIndex:0] andOrientation:0];
                    _curScaleImage.imageView.image = [self getActualImage:[_assetsArray objectAtIndex:1] andOrientation:0];
                    break;
                case 3:
                    _fontScaleImage.imageView.image = [self getActualImage:[_assetsArray objectAtIndex:0] andOrientation:0];
                    _curScaleImage.imageView.image = [self getActualImage:[_assetsArray objectAtIndex:1] andOrientation:0];
                    _rearScaleImage.imageView.image = [self getActualImage:[_assetsArray objectAtIndex:2] andOrientation:0];
                    break;
                default:
                    break;
            }
            return ;
        }
        if (_imagestate == AtLess) {
            _fontScaleImage.imageView.image = [self getActualImage:[_assetsArray objectAtIndex:0] andOrientation:0];
        }else if (_imagestate == AtMore) {
            _rearScaleImage.imageView.image = [self getActualImage:[_assetsArray lastObject] andOrientation:0];
        }else{
            _curScaleImage.imageView.image = [self getActualImage:[_assetsArray objectAtIndex:_curPageNum] andOrientation:0];
        }
    });
}

#pragma mark - Overload function
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    //    [self readPhotoes];
}
- (UIImage *)getImageFromAsset:(id)asset
{
    DLog(@"%s",__FUNCTION__);
//    UIImage * image = [self getImageFromCacheWithKey:[[[(ALAsset * )asset defaultRepresentation] url] absoluteString]];
//    if (!image) {
//        image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
//    }
//    return image;
    return nil;
}
- (UIImage *)getActualImage:(id)asset andOrientation:(UIImageOrientation)orientation
{
    DLog(@"%s",__FUNCTION__);
//    UIImage * image = [self getImageFromCacheWithKey:[[[asset defaultRepresentation] url] absoluteString]];
//    if (!image) {
//        image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:1.0f orientation:orientation];
//        
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//            [self.cache setObject:UIImagePNGRepresentation(image) forKey:[[[asset defaultRepresentation] url] absoluteString]];
//        });
//    }
//    return image;
    return nil;
}

- (CGSize)getIdentifyImageSizeWithImageView:(UIImageView *)imageView isPortraitorientation:(BOOL)isPortrait
{
    DLog(@"%s",__FUNCTION__);
//    CGFloat w = imageView.image.size.width;
//    CGFloat h = imageView.image.size.height;
//    CGRect frameRect = CGRectZero;
//    CGRect  screenFrame = [[UIScreen mainScreen] bounds];
//    if (isPortrait) {
//        frameRect = screenFrame;
//    }else{
//        frameRect = CGRectMake(0, 0, screenFrame.size.height, screenFrame.size.width);
//    }
//    CGRect rect = CGRectZero;
//    CGFloat scale = MIN(frameRect.size.width / w, frameRect.size.height / h);
//    rect = CGRectMake(0, 0, w * scale, h * scale);
//    return rect.size;
    return CGSizeZero;
}
#pragma mark - BarDelegate
- (void)cusNavigationBar:(CustomizationNavBar *)bar buttonClick:(UIButton *)button isUPLoadState:(BOOL)isupload
{
    DLog(@"%s",__FUNCTION__);

    //    if (button.tag == LEFTBUTTON)
    //        [self.navigationController popViewControllerAnimated:YES];
    //    if (button.tag == RIGHT1BUTTON)
    //        return ;
    //    if (button.tag == RIGHT2BUTTON)
    //         [self.navigationController pushViewController:[[[LocalShareController alloc] initWithUpLoadAsset:[self.assetsArray objectAtIndex:_curPageNum]] autorelease] animated:YES];
}

- (void)cusTabBar:(CustomizetionTabBar *)bar buttonClick:(UIButton *)button
{
    DLog(@"%s",__FUNCTION__);
}

#pragma mark - Function
- (void)resetImageRect:(UIImageView *)imageView
{
    CGSize size = [self getIdentifyImageSizeWithImageView:imageView isPortraitorientation:CGAffineTransformEqualToTransform(CGAffineTransformIdentity, [self getTransfrom])];
    CGSize ratationSize = [self.view bounds].size;
    if (imageView.image) {
        imageView.frame = (CGRect){0,0,size};
        imageView.center = CGPointMake(ratationSize.width / 2.f, ratationSize.height /2.f);
    }else{
        imageView.frame = CGRectMake(0, 0, size.width,size.height);
    }
}

- (void)resetAllImagesFrame
{
    //设置图片的大小
    _fontScaleImage.zoomScale = 1.f;
    _curScaleImage.zoomScale = 1.f;
    _rearScaleImage.zoomScale = 1.f;
    [self resetImageRect:_curScaleImage.imageView];
    [self resetImageRect:_fontScaleImage.imageView];
    [self resetImageRect:_rearScaleImage.imageView];
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

#pragma mark - handleGuesture
- (void)imageViewScale:(ImageScaleView *)imageScale clickCurImage:(UIImageView *)imageview
{
    if (_isHidingBar) {
        
        [self.tabBar showBarWithAnimation:YES];
    }else{
        [self.tabBar hideBarWithAnimation:YES];
    }
    _isHidingBar = !_isHidingBar;
}

@end
