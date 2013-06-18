//
//  EGRefreshTableView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-6-17.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "EGRefreshTableView.h"

#pragma mark - EGOManager
@interface EGOManager : NSObject <EGORefreshTableHeaderDelegate, UITableViewDelegate,SCPMoreTableFootViewDelegate>
{
    @package
    EGORefreshTableHeaderView *_headerView;
    EGRefreshTableView *_tableView;
    SCPMoreTableFootView *_footMoreView;
    BOOL _isLoading;
}
@end

@implementation EGOManager
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}
- (void)reloadTableViewDataSource
{
    if ([_tableView.pDelegate respondsToSelector:@selector(pullingreloadTableViewDataSource:)]) {
        [_tableView.pDelegate pullingreloadTableViewDataSource:_tableView];
        _isLoading = YES;
    }
}

- (void)doneRefrshLoadingTableViewData
{
    _isLoading = NO;
    [_headerView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _isLoading;
}

#pragma mark - more
- (void)scpMoreTableFootViewDelegateDidTriggerRefresh:(SCPMoreTableFootView *)view
{
    [self moreTableViewDataSource];
}
- (BOOL)scpMoreTableFootViewDelegateDataSourceIsLoading:(SCPMoreTableFootView *)view
{
    return _isLoading;
}

- (void)moreTableViewDataSource
{
    if ([_tableView.pDelegate respondsToSelector:@selector(pullingreloadMoreTableViewData:)]) {
        [_tableView.pDelegate pullingreloadMoreTableViewData:_tableView];
        _isLoading = YES;
    }
}
- (void)doneMoreLoadingTableViewData
{
    _isLoading = NO;
    [_footMoreView scpMoreScrollViewDataSourceDidFinishedLoading:_tableView];
}

#pragma mark -
- (void)didFinishedLoadingTableViewData
{
    _isLoading = NO;
    [self doneMoreLoadingTableViewData];
    [self doneRefrshLoadingTableViewData];
}
#pragma mark UIScrollViewDelegate
#pragma mark Responding to Scrolling and Dragging
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headerView egoRefreshScrollViewDidScroll:scrollView];
    [_footMoreView scpMoreScrollViewDidScroll:scrollView isAutoLoadMore:YES WithIsLoadingPoint:&_isLoading];
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
        [_tableView.pDelegate scrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
        [_tableView.pDelegate scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
        [_tableView.pDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_headerView egoRefreshScrollViewDidEndDragging:scrollView];
    [_footMoreView scpMoreScrollViewDidEndDragging:scrollView];
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [_tableView.pDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
        return [_tableView.pDelegate scrollViewShouldScrollToTop:scrollView];
    
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
        [_tableView.pDelegate scrollViewDidScrollToTop:scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [_headerView egoRefreshScrollViewDidEndDragging:scrollView];
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
        [_tableView.pDelegate scrollViewWillBeginDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [_tableView.pDelegate scrollViewDidEndDecelerating:scrollView];
}


#pragma mark Managing Zooming
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([_tableView.pDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)])
        return [_tableView.pDelegate viewForZoomingInScrollView:scrollView];
    
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
        [_tableView.pDelegate scrollViewWillBeginZooming:scrollView withView:view];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
        [_tableView.pDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewDidZoom:)])
        [_tableView.pDelegate scrollViewDidZoom:scrollView];
}


#pragma mark Responding to Scrolling Animations
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([_tableView.pDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
        [_tableView.pDelegate scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark - UITableViewDelegate
#pragma mark Configuring Rows for the Table View
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
        return [_tableView.pDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    
    return 44.f;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)])
        return [_tableView.pDelegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
        [_tableView.pDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

#pragma mark Managing Accessory Views
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
        [_tableView.pDelegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

#pragma mark Managing Selections
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)])
        return [_tableView.pDelegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        [_tableView.pDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)])
        return [_tableView.pDelegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
        [_tableView.pDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

#pragma mark Modifying the Header and Footer of Sections
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
        return [_tableView.pDelegate tableView:tableView viewForHeaderInSection:section];
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)])
        return [_tableView.pDelegate tableView:tableView viewForFooterInSection:section];
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
        return [_tableView.pDelegate tableView:tableView heightForHeaderInSection:section];
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)])
        return [_tableView.pDelegate tableView:tableView heightForFooterInSection:section];
    return 0.0;
}

#pragma mark Editing Table Rows
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)])
        [_tableView.pDelegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)])
        [_tableView.pDelegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)])
        return [_tableView.pDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    
    return UITableViewCellEditingStyleNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)])
        return [_tableView.pDelegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)])
        return [_tableView.pDelegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    
    return YES;
}

#pragma mark Reordering Table Rows
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)])
        return [_tableView.pDelegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    
    return nil;
}

#pragma mark Copying and Pasting Row Content
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)])
        return [_tableView.pDelegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)])
        return [_tableView.pDelegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([_tableView.pDelegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)])
        [_tableView.pDelegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
}
@end

@implementation EGRefreshTableView

@synthesize pDelegate = _pDelegate;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
        _egoManager = [[EGOManager alloc] init];
        
        self.delegate = _egoManager;
        _refresHeadView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, - 60, 320, 60) arrowImageName:nil textColor:[UIColor grayColor] backGroundColor:[UIColor clearColor]];
        _refresHeadView.delegate = _egoManager;
        [self addSubview:_refresHeadView];
        
        _moreFootView = [[SCPMoreTableFootView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) WithLodingImage:[UIImage imageNamed:@"load_more_pics.png"] endImage:[UIImage imageNamed:@"end_bg.png"] WithBackGroud:[UIColor clearColor]];
        _moreFootView.delegate = _egoManager;
        _egoManager->_tableView = self;
        _egoManager->_headerView = _refresHeadView;
        _egoManager->_footMoreView = _moreFootView;
        
    }
    return self;
}
- (void)didFinishedLoadingTableViewData
{
    [_egoManager didFinishedLoadingTableViewData];
}
@end
