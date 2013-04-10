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
}
@property(nonatomic,assign)id<SCPMoreTableFootViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame WithLodingImage:(UIImage *)lodingImage endImage:(UIImage *)endImage;

- (void)scpMoreScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scpMoreScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)scpMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

- (void)moreImmediately;
@end
