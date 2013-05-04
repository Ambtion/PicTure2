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

- (id)initWithFrame:(CGRect)frame WithLodingImage:(UIImage *)lodingImage endImage:(UIImage *)endImage WithBackGroud:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        //暂时写死了,以后更改
//        self.frame = CGRectMake(0, 0, 320, 60) ;
        self.backgroundColor = color;
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(realLoadingMore:)];
        [self addGestureRecognizer:gesture];
        [self addOpenViewWithLoadingImage:lodingImage];
        [self addCloseViewWithEnddingImage:endImage];
        [self setMoreFunctionOff:NO];
    }
    return self;
}
- (void)addOpenViewWithLoadingImage:(UIImage *)image
{
    openView = [[UIView alloc] initWithFrame:self.bounds];
    openView.backgroundColor = [UIColor clearColor];
    
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(110, (self.bounds.size.height - 18)/2.f, 18, 18)];
    imageview.image = image;
    [openView addSubview:imageview];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(66  + 10, 0, 320 - 142, self.bounds.size.height)];
    label.tag = 100;
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithRed:98.f/255 green:98.f/255 blue:98.f/255 alpha:1];
    label.text = @"加载更多...";
    label.backgroundColor = [UIColor clearColor];
    [openView addSubview:label];
    
    UIActivityIndicatorView * active = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    active.tag = 200;
    active.center = CGPointMake(320 - 66, self.frame.size.height /2.f);
    active.color = [UIColor blackColor];
    active.hidesWhenStopped = YES;
    [active stopAnimating];
    [openView addSubview:active];
    [self addSubview:openView];
}
- (void)addCloseViewWithEnddingImage:(UIImage *)endImage
{
    UIImageView * bg_imageview = [[UIImageView alloc] initWithFrame:CGRectMake((320 - 30)/2.f,15.f, 30.f, 30.f)];
    bg_imageview.image = endImage ? endImage :[UIImage imageNamed:@"end_bg.png"];
    closeView = [[UIView alloc] initWithFrame:self.bounds];
    closeView.backgroundColor = [UIColor clearColor];
    [closeView addSubview:bg_imageview];
    [self addSubview:closeView];
}
- (void)realLoadingMore:(id)sender
{
    BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(scpMoreTableFootViewDelegateDataSourceIsLoading:)]) {
		_loading = [_delegate scpMoreTableFootViewDelegateDataSourceIsLoading:self];
	}
    if (_loading || closeView.superview) return;
    [self showLoadingMore];
    if ([_delegate respondsToSelector:@selector(scpMoreTableFootViewDelegateDidTriggerRefresh:)]) {
        [_delegate scpMoreTableFootViewDelegateDidTriggerRefresh:self];
    }
}
- (void)showLoadingMore
{
    UILabel * label = (UILabel *)[openView viewWithTag:100];
    UIActivityIndicatorView * acv  = (UIActivityIndicatorView *)[openView viewWithTag:200];
    label.text = @"加载中...";
    [acv startAnimating];
}
- (void)scpMoreScrollViewDidScroll:(UIScrollView *)scrollView isAutoLoadMore:(BOOL)isAuto WithIsLoadingPoint:(BOOL *)isload
{
    if (isAuto) {
        if (scrollView.contentSize.height - scrollView.frame.size.height -  scrollView.contentOffset.y < 100 && scrollView.contentSize.height > scrollView.frame.size.height) {
            [self moreImmediately];
            * isload = YES;
        }else{
            * isload = NO;
        }
    }else{
        if (scrollView.contentOffset.y <= scrollView.contentSize.height - scrollView.frame.size.height || scrollView.contentSize.height <= scrollView.frame.size.height) {
            if (_willLodingMore) {
                _willLodingMore = NO;
                [self realLoadingMore:nil];
            }
        }
    }
}
- (void)scpMoreScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(scpMoreTableFootViewDelegateDataSourceIsLoading:)]) {
		_loading = [_delegate scpMoreTableFootViewDelegateDataSourceIsLoading:self];
	}
    if(scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + 44 && scrollView.contentOffset.y >= 44 && !_loading && !closeView.superview) {
        _willLodingMore = YES;
    }
}
- (void)scpMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    UILabel * label = (UILabel *)[openView viewWithTag:100];
    label.text  = @"加载更多...";
    UIActivityIndicatorView * act = (UIActivityIndicatorView *)[openView viewWithTag:200];
    [act stopAnimating];
}
- (BOOL)canLoadingMore
{
    return closeView.superview ? NO : YES;
}
- (void)moreImmediately
{
    [self realLoadingMore:nil];
}
- (void)setMoreFunctionOff:(BOOL)isOFF
{
    if (isOFF) {
        [self addSubview:closeView];
        [openView removeFromSuperview];
    }else{
        [self addSubview:openView];
        [closeView removeFromSuperview];
    }
}
@end
