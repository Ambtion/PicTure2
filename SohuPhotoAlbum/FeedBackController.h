//
//  SCPFeedBackController.h
//  SohuCloudPics
//
//  Created by sohu on 13-1-7.
//
//

#import <UIKit/UIKit.h>
#import "UMAppKey.h"
#import "CustomizationNavBar.h"

@interface FeedBackController : UIViewController<UITextViewDelegate,UIGestureRecognizerDelegate,UMFeedbackDataDelegate,CusNavigationBarDelegate>
{
    UITextView * _textView;
    UITextField * _placeHolder;
    UIButton * _saveButton;
    UIView * _textView_bg;
    CustomizationNavBar * _bavBar;
}
@end
