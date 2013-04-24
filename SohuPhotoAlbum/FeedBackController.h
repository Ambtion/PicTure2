//
//  SCPFeedBackController.h
//  SohuCloudPics
//
//  Created by sohu on 13-1-7.
//
//

#import <UIKit/UIKit.h>

@interface FeedBackController : UIViewController<UITextViewDelegate,UIGestureRecognizerDelegate>
{
    UITextView * _textView;
    UITextField * _placeHolder;
    UIButton * _saveButton;
    UIView * _textView_bg;
}
@end
