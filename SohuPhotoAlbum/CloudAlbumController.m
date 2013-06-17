//
//  CloudAlbumController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-6-17.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CloudAlbumController.h"


@implementation CloudAlbumController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.backgroundColor = LOCALBACKGORUNDCOLOR;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_cusBar){
        _cusBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [_cusBar.nLabelText setText:@"云备份"];
        [_cusBar.nRightButton1 setImage:[UIImage imageNamed:@"shareBtn_nomal.png"] forState:UIControlStateNormal];
        //上传按钮
        [_cusBar.nRightButton2 setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [_cusBar.nRightButton3 setUserInteractionEnabled:NO];
        [_cusBar.sRightStateButton setImage:[UIImage imageNamed:@"ensure.png"] forState:UIControlStateNormal];
    }
    if (!_cusBar.superview)
        [self.navigationController.navigationBar addSubview:_cusBar];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
}
@end
