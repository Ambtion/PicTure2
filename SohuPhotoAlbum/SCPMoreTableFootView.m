//
//  SPCMoreTableFootView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-10.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "SCPMoreTableFootView.h"

@implementation SCPMoreTableFootView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame WithLodingImage:(UIImage *)lodingImage endImage:(UIImage *)endImage;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //暂时写死了,以后更改
//        self.frame = CGRectMake(0, 0, 320, 60) ;
        self.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1];
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(realLoadingMore:)];
        [self addGestureRecognizer:gesture];
        
        UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(110, (self.bounds.size.height - 18)/2.f, 18, 18)];
        imageview.image = lodingImage;
        [self addSubview:imageview];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(66  + 10, 0, 320 - 142, self.bounds.size.height)];
        label.tag = 100;
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:98.f/255 green:98.f/255 blue:98.f/255 alpha:1];
        label.text = @"加载更多...";
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        
        UIActivityIndicatorView * active = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        active.tag = 200;
        active.center = CGPointMake(320 - 66, self.frame.size.height /2.f);
        active.color = [UIColor blackColor];
        active.hidesWhenStopped = YES;
        [active stopAnimating];
        [self addSubview:active];

//        UIImageView * bg_imageview = [[[UIImageView alloc] initWithFrame:CGRectMake((320 - 30)/2.f,15.f, 30.f, 30.f)]autorelease];
////        bg_imageview.image =[UIImage imageNamed:@"end_bg.png"];
//        bg_imageview.image = endImage;
//        UIView * view = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
//        view.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
//        [view addSubview:bg_imageview];
//        [view addSubview:self];
    }
    return self;
}
- (void)realLoadingMore:(id)sender
{
    BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(scpMoreTableFootViewDelegateDataSourceIsLoading:)]) {
		_loading = [_delegate scpMoreTableFootViewDelegateDataSourceIsLoading:self];
	}
    if (_loading) return;
    NSLog(@"%s",__FUNCTION__);
    [self showLoadingMore];
    if ([_delegate respondsToSelector:@selector(scpMoreTableFootViewDelegateDidTriggerRefresh:)]) {
        [_delegate scpMoreTableFootViewDelegateDidTriggerRefresh:self];
    }
}
- (void)showLoadingMore
{
    UILabel * label = (UILabel *)[self viewWithTag:100];
    UIActivityIndicatorView * acv  = (UIActivityIndicatorView *)[self viewWithTag:200];
    label.text = @"加载中...";
    [acv startAnimating];
}
- (void)scpMoreScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= scrollView.contentSize.height - scrollView.frame.size.height || scrollView.contentSize.height <= scrollView.frame.size.height) {
        if (_willLodingMore) {
            _willLodingMore = NO;
            [self realLoadingMore:nil];
        }
    }
}
- (void)scpMoreScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(scpMoreTableFootViewDelegateDataSourceIsLoading:)]) {
		_loading = [_delegate scpMoreTableFootViewDelegateDataSourceIsLoading:self];
	}
    if(scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + 44 && scrollView.contentOffset.y >= 44 && !_loading) {
        [self showLoadingMore];
        _willLodingMore = YES;
    }
}
- (void)scpMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    UILabel * label = (UILabel *)[self viewWithTag:100];
    label.text  = @"加载更多...";
    UIActivityIndicatorView * act = (UIActivityIndicatorView *)[self viewWithTag:200];
    [act stopAnimating];
}
- (void)moreImmediately
{
    [self realLoadingMore:nil];
}
@end
