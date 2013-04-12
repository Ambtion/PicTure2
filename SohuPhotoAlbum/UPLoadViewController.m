//
//  UPLoadViewController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-12.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "UPLoadViewController.h"

@implementation UPLoadViewController

- (void)dealloc
{
    [self removeObserverOnCenter];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserVerOnCenter];
    [self initSubviews];
}
- (void)initSubviews
{
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_cusBar){
        _cusBar = [[CustomizationNavBar alloc] initwithDelegate:self];
        [_cusBar.nLeftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [_cusBar.nLabelText setText:@"上传进度"];
    }
    if (!_cusBar.superview)
        [self.navigationController.navigationBar addSubview:_cusBar];
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
}
- (void)albumTaskOver:(NSNotification *)notification
{
    DLog(@"Finished");
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
