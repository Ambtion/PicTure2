//
//  ComentView.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-4.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MakeCommentView;
@protocol MakeCommentViewDelegate <NSObject>
- (void)makeCommentView:(MakeCommentView *)view commentClick:(UIButton *)button;
@end
@interface MakeCommentView : UIView<UITextViewDelegate,UIGestureRecognizerDelegate>
{
    UIButton * _comentButton;
    UITextField * _placeHolder;
    CGFloat startWidth;
    UIImageView * _commenBgView;
}
@property(nonatomic,strong)UITextView * textView;
@property(nonatomic,assign)NSInteger textCountLimit;
@property(nonatomic,strong)UIButton * comentButton;
@property(nonatomic,weak )id<MakeCommentViewDelegate> delegte;
- (void)addresignFirTapOnView:(UIView *)view;
@end
