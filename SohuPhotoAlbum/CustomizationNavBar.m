//
//  CusNavigationBar.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CustomizationNavBar.h"

@implementation GIFButton

- (UIImageView *)upLoadimageView
{
    return (UIImageView *)[self viewWithTag:100];
}
+ (id)buttonWithType:(UIButtonType)buttonType
{
    UIButton * button = [super buttonWithType:buttonType];
    button.clipsToBounds = YES;
    UIImageView * uploadImageView = [[UIImageView alloc] initWithFrame:button.bounds];
    uploadImageView.backgroundColor = [UIColor clearColor];
    uploadImageView.tag = 100;
    uploadImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"upload.png"],
                                       [UIImage imageNamed:@"upload1.png"],[UIImage imageNamed:@"upload2.png"],
                                       [UIImage imageNamed:@"upload3.png"],[UIImage imageNamed:@"upload4.png"],nil];
    uploadImageView.backgroundColor=  [UIColor clearColor];
    uploadImageView.animationDuration = 0.8f;
    uploadImageView.animationRepeatCount = 0;
    uploadImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [uploadImageView setHidden:YES];
    [button addSubview:uploadImageView];
    return button;
}
- (void)dealloc
{
    [self removeObserverOnCenter];
}
#pragma mark Notification upload
- (void)setButtoUploadState:(BOOL)isUploadStateButton
{
    if (isUploadStateButton) {
        [self addObserVerOnCenter];
        if ([[UploadTaskManager currentManager] isUploading]) {
            [self albumTaskStart:nil];
        }
    }
}
- (void)addObserVerOnCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumTaskStart:) name:ALBUMTUPLOADSTART object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumChange:) name:ALBUMTASKCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(albumTaskOver:) name:ALBUMUPLOADOVER object:nil];
}
- (void)removeObserverOnCenter
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALBUMTUPLOADSTART  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALBUMTASKCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALBUMUPLOADOVER  object:nil];
}

- (BOOL)isUploadStateButton
{
    return ![[self upLoadimageView] isHidden];
}
- (void)albumTaskStart:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self upLoadimageView] setHidden:NO];
        [[self upLoadimageView] startAnimating];
    });
}
- (void)albumTaskOver:(NSNotification *)notification
{
    DLog(@"Finished");
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self upLoadimageView] stopAnimating];
        [[self upLoadimageView] setHidden:YES];
    });
    
}
- (void)albumChange:(NSNotification *)notification
{
    DLog(@"Change");
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self upLoadimageView] setHidden:NO];
        [[self upLoadimageView] startAnimating];
    });}
@end
@implementation CustomizationNavBar
@synthesize nLeftButton,nLabelImage,nLabelText,nRightButton1,nRightButton2,nRightButton3,sLabelText,sAllSelectedbutton,sRightStateButton,sLeftButton;
@synthesize normalBar = _normalBar;
- (id)initwithDelegate:(id<CusNavigationBarDelegate>)Adelegate
{
    self.delegate = Adelegate;
    return [self initWithFrame:CGRectMake(0, 0, 320, 44)];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (self) {
        [self setUserInteractionEnabled:YES];
        
        _normalBar = [[UIImageView alloc] initWithFrame:self.bounds];
        [_normalBar setUserInteractionEnabled:YES];
        _normalBar.image = [UIImage imageNamed:@"navbar.png"];
        
        self.nLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nLeftButton.frame = CGRectMake(0, 0, 44, 44);
        nLeftButton.tag = LEFTBUTTON;
        [nLeftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_normalBar addSubview:nLeftButton];
        
        self.nLabelImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, 90, 44)];
        [_normalBar addSubview:nLabelImage];
        self.nLabelText = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 200, 44)];
        self.nLabelText.backgroundColor = [UIColor clearColor];
        self.nLabelText.textColor = [UIColor blackColor];
        [_normalBar addSubview:nLabelText];
        [self addRightButtonsOnNormalBar];
        [self addSubview:_normalBar];
        [self initStateBar];
    }
    return self;
}
- (void)initStateBar
{
    _stateBar = [[UIImageView alloc] initWithFrame:self.bounds];
    [_stateBar setUserInteractionEnabled:YES];
    _stateBar.image = [UIImage imageNamed:@"navbar.png"];
    
    self.sLabelText = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 200, 44)];
    self.sLabelText.backgroundColor = [UIColor clearColor];
    self.sLabelText.textColor = [UIColor blackColor];
    [_stateBar addSubview:sLabelText];

    sLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sLeftButton.frame = CGRectMake(0, 0, 44, 44);
    sLeftButton.tag = CANCELBUTTONTAG;
    [sLeftButton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [sLeftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_stateBar addSubview:sLeftButton];
    
    self.sRightStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sRightStateButton.frame = CGRectMake(320 - 44, 0, 44, 44);
    sRightStateButton.tag = RIGHTSELECTEDTAG;
    [sRightStateButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_stateBar addSubview:sRightStateButton];
}

- (void)addRightButtonsOnNormalBar
{
    self.nRightButton1 = [GIFButton buttonWithType:UIButtonTypeCustom];
    [self.nRightButton1 addTarget:self action:@selector(gifButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nRightButton1.frame = CGRectMake(320 - 44, 0, 44, 44);
    nRightButton1.tag = RIGHT1BUTTON;
    [_normalBar addSubview:nRightButton1];
    
    self.nRightButton2 = [GIFButton buttonWithType:UIButtonTypeCustom];
    [self.nRightButton2 addTarget:self action:@selector(gifButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    nRightButton2.frame = CGRectMake(320 - 88, 0, 44, 44);
    nRightButton2.tag = RIGHT2BUTTON;
    [_normalBar addSubview:nRightButton2];
    
}

#pragma mark - 
- (void)switchBarStateToUpload:(BOOL)isUploadState
{
    if (isUploadState) {
        [self addSubview:_stateBar];
    }else{
        [_stateBar removeFromSuperview];
    }
}
- (void)buttonClick:(GIFButton *)button
{
    if ([_delegate respondsToSelector:@selector(cusNavigationBar:buttonClick: isUPLoadState:)]) {
        [_delegate cusNavigationBar:self buttonClick:button isUPLoadState:NO];
    }
}
- (void)gifButtonClick:(GIFButton *)button
{
    if ([_delegate respondsToSelector:@selector(cusNavigationBar:buttonClick: isUPLoadState:)]) {
        [_delegate cusNavigationBar:self buttonClick:button isUPLoadState:[button isUploadStateButton]];
    }
}
- (void)setBackgroundImage:(UIImage *)image
{
    [_normalBar setImage:image];
}
@end
