//
//  ComentView.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-4.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakeCommentView : UIView<UITextViewDelegate,UIGestureRecognizerDelegate>
{
    UIButton * _comentButton;
    UITextField * _placeHolder;
    CGFloat startWidth;
}
@property(nonatomic,strong)UITextView * textView;
@property(nonatomic,assign)NSInteger textCountLimit;
@property(nonatomic,strong)UIButton * comentButton;
- (void)addresignFirTapOnView:(UIView *)view;
- (void)commentbuttonAddtar:(id)target action:(SEL)action;
@end
