//
//  StoryFootView.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-17.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoryFootView;
@protocol StoryFootViewDelegate <NSObject>
- (void)storyFootView:(StoryFootView *)view clickButtonAtIndex:(NSInteger)index;
@end
@interface StoryFootView : UIImageView
@property(weak,nonatomic)id<StoryFootViewDelegate> delegate;
@end
