//
//  ShareViewController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-7.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "ShareViewController.h"
#import "UIImageView+WebCache.h"

@implementation ShareViewController
@synthesize bgPhotoUrl = _bgPhotoUrl;
@synthesize ownerId,storyboard,photosArray;
@synthesize delegate = _delegate;

- (id)initWithModel:(DesViewShareModel )model bgPhotoUrl:(NSString *)bgPhotoUrl andDelegate:(id<ShareViewControllerDelegate>)Adelegete
{
    self = [super init];
    if (self) {
        self.bgPhotoUrl = bgPhotoUrl;
        _sharemodel = model;
    }
    return self;
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

#pragma mark - 
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wantsFullScreenLayout = YES;
    
    [self addBgView];
    NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_c95",_bgPhotoUrl]]];
    LocalShareDesView * localView = [[LocalShareDesView alloc] initWithModel:_sharemodel thumbnail:[UIImage imageWithData:data] andDelegate:self offsetY:20.f];
    localView.frame = self.view.bounds;
    localView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:localView];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    DLog(@"self.view:%@",NSStringFromCGRect(self.view.frame));
    DLog(@"self.bgView:%@",NSStringFromCGRect(_myBgView.frame));         
}
- (void)addBgView
{
    self.view.frame = [[UIScreen mainScreen] bounds];
    _myBgView  = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _myBgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_myBgView];
    self.view.clipsToBounds = YES;
    __weak UIImageView * bgViewSelf = _myBgView;
    __weak ShareViewController * weakSelf = self;
    
    [_myBgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_w640",self.bgPhotoUrl]] placeholderImage:[UIImage imageNamed:@"1.png"] success:^(UIImage *image) {
        CGSize size = [weakSelf getIdentifyImageSizeWithImageView:image];
        bgViewSelf.frame = (CGRect){0,0,size};
        bgViewSelf.center = CGPointMake(weakSelf.view.bounds.size.width /2.f, weakSelf.view.bounds.size.height /2.f);
    } failure:^(NSError *error) {
        
    }];
}
- (CGSize)getIdentifyImageSizeWithImageView:(UIImage *)image
{
    if (!image) return CGSizeZero;
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    CGRect frameRect = self.view.bounds;
    CGRect rect = CGRectZero;
    CGFloat scale = MAX(frameRect.size.width / w, frameRect.size.height / h);
    rect = CGRectMake(0, 0, w * scale, h * scale);
    DLog(@"%@ %f,%f",NSStringFromCGRect(rect),w,h );
    return rect.size;
}
#pragma mark DesShareDelegate
- (void)localShareDesView:(LocalShareDesView *)view shareTo:(DesViewShareModel)model withDes:(NSString *)text
{
    return;
    if ([_delegate respondsToSelector:@selector(shareViewcontrollerDidShareSucess:)]) {
        [_delegate shareViewcontrollerDidShareSucess:self];
    }
    if ([_delegate respondsToSelector:@selector(shareViewcontrollerDidSharefailture:)]) {
        [_delegate shareViewcontrollerDidSharefailture:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)localShareDesViewcancelShare:(LocalShareDesView *)view
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
