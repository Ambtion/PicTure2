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
    UIImageView * uploadImageView = [[UIImageView alloc] initWithFrame:button.bounds];
    uploadImageView.backgroundColor = [UIColor redColor];
    uploadImageView.tag = 100;
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
- (void)albumTaskStart:(NSNotification *)notification
{
    DLog(@"albumstart");
    [[self upLoadimageView] setHidden:NO];
}
- (void)albumTaskOver:(NSNotification *)notification
{
    DLog(@"Finished");
    [[self upLoadimageView] setHidden:YES];
}
- (void)albumChange:(NSNotification *)notification
{
//    NSDictionary * dic = [notification userInfo];
//    NSInteger total = [[dic objectForKey:@"Total"] intValue];
//    NSInteger finish = [[dic objectForKey:@"Finish"] intValue];
//    CGFloat pro = (CGFloat)((CGFloat)finish / (CGFloat)total);
//    DLog(@"%f", pro);
}
@end
@implementation CustomizationNavBar
@synthesize nLeftButton,nLabelImage,nLabelText,nRightButton1,nRightButton2,nRightButton3,sLabelText,sAllSelectedbutton,sRightStateButton,sLeftButton;
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
        self.nLeftButton = [GIFButton buttonWithType:UIButtonTypeCustom];
        nLeftButton.frame = CGRectMake(0, 0, 44, 44);
        nLeftButton.tag = LEFTBUTTON;
        [self.nLeftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_normalBar addSubview:nLeftButton];
        self.nLabelImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, 90, 44)];
        [_normalBar addSubview:nLabelImage];
        self.nLabelText = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 150, 44)];
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
    
    self.sLabelText = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 150, 44)];
    self.sLabelText.backgroundColor = [UIColor clearColor];
    self.sLabelText.textColor = [UIColor blackColor];
    [_stateBar addSubview:sLabelText];

    self.sLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sLeftButton.frame = CGRectMake(0, 0, 44, 44);
    sLeftButton.tag = CANCELBUTTONTAG;
    [sLeftButton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [sLeftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_stateBar addSubview:sLeftButton];
    
    //全选按钮
//    self.sAllSelectedbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    sAllSelectedbutton.frame = CGRectMake(200, 0, 44, 44);
//    sAllSelectedbutton.tag = ALLSELECTEDTAG;
//    [sAllSelectedbutton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_stateBar addSubview:sAllSelectedbutton];
    self.sRightStateButton = [GIFButton buttonWithType:UIButtonTypeCustom];
    sRightStateButton.frame = CGRectMake(320 - 50, 0, 44, 44);
    sRightStateButton.tag = RIGHTSELECTEDTAG;
    [sRightStateButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_stateBar addSubview:sRightStateButton];
}

- (void)addRightButtonsOnNormalBar
{
    self.nRightButton1 = [GIFButton buttonWithType:UIButtonTypeCustom];
    [self.nRightButton1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    nRightButton1.frame = CGRectMake(320 - 44, 0, 44, 44);
    nRightButton1.tag = RIGHT1BUTTON;
    [_normalBar addSubview:nRightButton1];
    
    self.nRightButton2 = [GIFButton buttonWithType:UIButtonTypeCustom];
    [self.nRightButton2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    nRightButton2.frame = CGRectMake(320 - 88, 0, 44, 44);
    nRightButton2.tag = RIGHT2BUTTON;
    [_normalBar addSubview:nRightButton2];
    
//    self.nRightButton3 = [GIFButton buttonWithType:UIButtonTypeCustom];
//    [self.nRightButton3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    nRightButton3.frame = CGRectMake(320 - 150, 0, 44, 44);
//    nRightButton3.tag = RIGHT3BUTTON;
//    [_normalBar addSubview:nRightButton3];
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
- (void)buttonClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(cusNavigationBar:buttonClick:)]) {
        [_delegate cusNavigationBar:self buttonClick:button];
    }
}
- (void)setBackgroundImage:(UIImage *)image
{
    [_normalBar setImage:image];
}
@end
