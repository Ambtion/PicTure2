//
//  SCPFeedBackController.h
//  SohuCloudPics
//
//  Created by sohu on 13-1-7.
//
//

#import <UIKit/UIKit.h>
#import "UMAppKey.h"

@interface FeedBackController : UIViewController<UITextViewDelegate,UIGestureRecognizerDelegate,UMFeedbackDataDelegate>
{
    UITextView * _textView;
    UITextField * _placeHolder;
    UIButton * _saveButton;
    UIView * _textView_bg;
    
}
@end
