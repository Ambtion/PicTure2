//
//  SCPReadDealController.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-13.
//
//

#import "ReadSohuDealController.h"


@implementation ReadSohuDealController
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    CGRect rect = self.view.bounds;
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:rect];
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 5700/2.f)];
    imageview.image = [UIImage imageNamed:@"serviceitem.png"];
    imageview.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:imageview];
    [scrollView setContentSize:imageview.bounds.size];
    [self.view addSubview:scrollView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backbutton.frame = CGRectMake(5, 2, 44, 44);
    [_backbutton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_backbutton setImage:[UIImage imageNamed:@"back_press.png"] forState:UIControlStateHighlighted];
    [_backbutton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backbutton];
}
#pragma mark View Appear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)back:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
