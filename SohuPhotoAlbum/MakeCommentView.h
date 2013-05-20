//
//  ComentView.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-4.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@class MakeCommentView;
@protocol MakeCommentViewDelegate <NSObject>
- (void)makeCommentView:(MakeCommentView *)view commentClick:(UIButton *)button;
@end
@interface MakeCommentView : UIView<UITextViewDelegate,UIGestureRecognizerDelegate,HPGrowingTextViewDelegate>

@property(nonatomic,weak )id<MakeCommentViewDelegate> delegte;
@property(strong,nonatomic)HPGrowingTextView * textView;

- (void)addresignFirTapOnView:(UIView *)view;
@end
