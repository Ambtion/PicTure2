//
//  UPLoadViewController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-12.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "UPLoadController.h"

@implementation UPLoadController
@synthesize delegate = _delegate;
- (void)dealloc
{
    [self removeObserverOnCenter];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserVerOnCenter];
    self.view.backgroundColor = [UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1.f];
    [self initSubviews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)initSubviews
{
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image = [[UIImage imageNamed:@"uploadBgView.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(300, 160, 160, 60)];
    bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:bgView];
    [bgView setUserInteractionEnabled:YES];
    
    //返回按钮
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(cancelLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    _waitNum = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 150, 40)];
    _waitNum.backgroundColor = [UIColor clearColor];
    _waitNum.textColor = [UIColor colorWithRed:57.f/255 green:125.f/255 blue:219.f/255 alpha:1];
    _waitNum.textAlignment = UITextAlignmentCenter;
    _waitNum.font = [UIFont boldSystemFontOfSize:35.f];
    [self.view addSubview:_waitNum];
    
    _uploadNum = [[UILabel alloc] initWithFrame:CGRectMake(160, 100, 150, 40)];
    _uploadNum.backgroundColor = [UIColor clearColor];
    _uploadNum.textColor = [UIColor grayColor];
    _uploadNum.textAlignment = UITextAlignmentCenter;
    _uploadNum.font = [UIFont boldSystemFontOfSize:35.f];
    [self.view addSubview:_uploadNum];
    UIButton * continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    continueButton.frame = CGRectMake(10, 175, 150, 42);
    [continueButton setImage:[UIImage imageNamed:@"continueUp_btn_nomal.png"] forState:UIControlStateNormal];
    [continueButton addTarget:self action:@selector(continueUpload:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueButton];
    
    UIButton * cancelUp = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelUp.frame = CGRectMake(160, 175, 150, 42);
    [cancelUp setImage:[UIImage imageNamed:@"cancelUp_btn_nomal.png"] forState:UIControlStateNormal];
    [cancelUp addTarget:self action:@selector(cancelUplaod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelUp];
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.frame = CGRectMake(12, 171, 296, 2);
    [_progressView setProgressImage:[UIImage imageNamed:@"progressView.png"]];
    [_progressView setTrackImage:[UIImage imageNamed:@"progressViewTrack.png"]];
    [self.view addSubview:_progressView];
    [self updataProgessViewProgessWithDic:[[UploadTaskManager currentManager] currentTaskInfo]];
}

- (void)cancelLogin:(UIButton *)button
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.presentingViewController) {
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    }
}
#pragma mark - Action
- (void)continueUpload:(id)sender
{
    if ([_delegate respondsToSelector:@selector(upLoadController:didclickContinue:)])
        [_delegate upLoadController:self didclickContinue:sender];
}
- (void)cancelUplaod:(id)sender
{
    [[UploadTaskManager currentManager] cancelAllOperation];
    [self resetProgeress];
}
- (void)resetProgeress
{
    _uploadNum.text = @"0";
    _waitNum.text = @"0";
    _progressView.progress = 0.f;
}
#pragma mark - ObserVer
- (void)addObserVerOnCenter
{
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumTaskStart:) name:ALBUMTUPLOADSTART object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumChange:) name:ALBUMTASKCHANGE object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumTaskOver:) name:ALBUMUPLOADOVER object:nil];
}

- (void)removeObserverOnCenter
{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALBUMTUPLOADSTART  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALBUMTASKCHANGE object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALBUMUPLOADOVER  object:nil];
}
//- (void)albumTaskStart:(NSNotification *)notification
//{
//    DLog(@"albumstart");
//}
//- (void)albumTaskOver:(NSNotification *)notification
//{
//    DLog(@"Finished");
//}
- (void)albumChange:(NSNotification *)notification
{
    NSDictionary * dic = [notification userInfo];
    [self updataProgessViewProgessWithDic:dic];
}
- (void)updataProgessViewProgessWithDic:(NSDictionary *)dic
{
    NSInteger total = [[dic objectForKey:@"Total"] intValue];
    NSInteger finish = [[dic objectForKey:@"Finish"] intValue];
    CGFloat pro = (CGFloat)((CGFloat)finish / (CGFloat)total);
    _waitNum.text = [NSString stringWithFormat:@"%d",total - finish];
    _uploadNum.text = [NSString stringWithFormat:@"%d",finish];
    _progressView.progress = pro;
}
@end
