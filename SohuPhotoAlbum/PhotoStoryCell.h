//
//  PhotoStoryCell.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-17.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentView.h"
#import "StoryFootView.h"

@interface PhotoStoryCellDataSource : NSObject
@property(strong,nonatomic)NSString * imageID;
@property(strong,nonatomic)NSString * imageDes;
@property(strong,nonatomic)NSArray * commentInfoArray;
@property(assign,nonatomic)NSInteger allCommentCount;
@property(assign,nonatomic)NSInteger likeCount;
- (CGFloat)cellHeigth;
@end

@class PhotoStoryCell;
@protocol PhotoStoryCellDelegate <NSObject>
- (void)photoStoryCell:(PhotoStoryCell *)cell commentClickAtIndex:(NSInteger)index;
- (void)photoStoryCell:(PhotoStoryCell *)cell footViewClickAtIndex:(NSInteger)index;

@end
@interface PhotoStoryCell : UITableViewCell<StoryFootViewDelegate>
{
    UIImageView * _bgImageView;
    UIImageView * _photoView;
    UILabel * _desLabel;
    NSMutableArray * _commentArray;
    UILabel * _commentCount;
    StoryFootView * _footView;
    PhotoStoryCellDataSource * _dataSource;
}
@property(strong,nonatomic)PhotoStoryCellDataSource * dataSource;
@property(weak,nonatomic)id<PhotoStoryCellDelegate> delegate;
@end
