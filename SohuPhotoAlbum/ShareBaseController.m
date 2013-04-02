//
//  ShareBaseController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-1.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "ShareBaseController.h"

@implementation AccountButton
@synthesize labelText;
- (void)dealloc
{
    self.labelText  =nil;
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self) {
        self.labelText  = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 15, self.frame.size.width, 15)];
        self.labelText.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.autoresizesSubviews = YES;
        [self addSubview:self.labelText];
    }
    return self;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (!self.labelText) {
        self.labelText  = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 19, self.frame.size.width, 13)];
        self.labelText.font = [UIFont systemFontOfSize:12];
        self.labelText.textAlignment = UITextAlignmentCenter;
        self.labelText.backgroundColor = [UIColor clearColor];
        self.labelText.textColor = [UIColor colorWithRed:103/255.f green:103/255.f blue:103/255.f alpha:1.f];
        self.labelText.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.autoresizesSubviews = YES;
        [self addSubview:self.labelText];
    }else{
        self.labelText.frame  = CGRectMake(0, self.frame.size.height - 19, self.frame.size.width, 13);
    }
}
@end

@implementation ShareBaseController
@synthesize sinaAcountBtn,renrenAcountBtn,weixinAcountBtn,qqAcountBtn,uploadAsset = _uploadAsset;

- (id)initWithUpLoadAsset:(ALAsset *)aseet
{
    self = [super init];
    if (self) {
        self.uploadAsset = aseet;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BACKGORUNDCOLOR;
    CGFloat offset = 20.f;
    
    UIImageView * bgIVw = [[UIImageView alloc] initWithFrame:CGRectMake((320 - 144)/2.f, 8 + offset, 144, 144)];
    bgIVw.image = [UIImage imageNamed:@"share_pic_frame.png"];
    UIImageView * imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 124, 124)] autorelease];
    imageView.image = [UIImage imageWithCGImage:[[self.uploadAsset defaultRepresentation] fullScreenImage]];
    [bgIVw addSubview:imageView];
    [self.view addSubview:bgIVw];
    
    UIImageView * shareImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_sns.png"]] autorelease];
    shareImage.frame = CGRectMake(110, 163.f + offset, 100, 14);
    [self.view addSubview:shareImage];
    
    self.sinaAcountBtn = [AccountButton buttonWithType:UIButtonTypeCustom];
    sinaAcountBtn.tag = kSinaTag;
    sinaAcountBtn.frame = CGRectMake(30.f, 195.f + offset, 65, 65);
    [sinaAcountBtn addTarget:self action:@selector(upPicture:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sinaAcountBtn];
    
    self.renrenAcountBtn = [AccountButton buttonWithType:UIButtonTypeCustom];
    renrenAcountBtn.tag = kRenrenTag;
    renrenAcountBtn.frame = CGRectMake(30.f + 65, 195.f + offset, 65, 65);
    [renrenAcountBtn addTarget:self action:@selector(upPicture:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:renrenAcountBtn];
    
    self.weixinAcountBtn = [AccountButton buttonWithType:UIButtonTypeCustom];
    weixinAcountBtn.tag = kWeixinTag;
    weixinAcountBtn.frame = CGRectMake(30.f + 130, 195.f + offset, 65, 65);
    [weixinAcountBtn addTarget:self action:@selector(upPicture:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinAcountBtn];
    
    self.qqAcountBtn = [AccountButton buttonWithType:UIButtonTypeCustom];
    qqAcountBtn.tag = kQQTag;
    qqAcountBtn.frame = CGRectMake(30.f + 195, 195.f + offset, 65, 65);
    [qqAcountBtn addTarget:self action:@selector(upPicture:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqAcountBtn];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_cusBar){
        _cusBar = [[CusNavigationBar alloc] initwithDelegate:self];
        [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [_cusBar.nLabelImage setImage:[UIImage imageNamed:@"localAlbums.png"]];
        [_cusBar.nRightButton1 setUserInteractionEnabled:NO];
        [_cusBar.nRightButton1 setUserInteractionEnabled:NO];
        [_cusBar.nRightButton3 setUserInteractionEnabled:NO];
    }
    if (!_cusBar.superview)
        [self.navigationController.navigationBar addSubview:_cusBar];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
}
- (void)cusNavigationBar:(CusNavigationBar *)bar buttonClick:(UIButton *)button
{
    if (button.tag == LEFTBUTTON) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)upPicture:(UIButton *)button
{
    //reload 
}
- (void)dealloc
{
    [sinaAcountBtn release];
    [renrenAcountBtn release];
    [weixinAcountBtn release];
    [qqAcountBtn release];
    [_uploadAsset release];
    [super dealloc];
}


@end
