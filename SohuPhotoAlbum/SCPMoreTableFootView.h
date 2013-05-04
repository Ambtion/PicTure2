//
//  SPCMoreTableFootView.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-10.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCPMoreTableFootView;
@protocol SCPMoreTableFootViewDelegate <NSObject>
@required
- (void)scpMoreTableFootViewDelegateDidTriggerRefresh:(SCPMoreTableFootView*)view;
- (BOOL)scpMoreTableFootViewDelegateDataSourceIsLoading:(SCPMoreTableFootView*)view;
@end

@interface SCPMoreTableFootView : UIView
{
    BOOL _willLodingMore;
    UIView * closeView;
    UIView * openView;
}
@property(nonatomic,weak)id<SCPMoreTableFootViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame WithLodingImage:(UIImage *)lodingImage endImage:(UIImage *)endImage WithBackGroud:(UIColor *)color;
- (void)scpMoreScrollViewDidScroll:(UIScrollView *)scrollView isAutoLoadMore:(BOOL)isAuto WithIsLoadingPoint:(BOOL *)isload;
- (void)scpMoreScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)scpMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (BOOL)canLoadingMore;
- (void)setMoreFunctionOff:(BOOL)isOFF;
@end
