//
//  SCPAlert_CreateFolder.h
//  SohuCloudPics
//
//  Created by sohu on 13-3-6.
//
//

#import <UIKit/UIKit.h>

@class TextAlertView;

@protocol TextAlertViewDelegate <NSObject>
- (void)textAlertView:(TextAlertView *)view OKClicked:(UITextField *)textField;
@optional
- (void)textAlertView:(TextAlertView *)view cancelClicked:(UITextField *)textField;
@end

@interface TextAlertView : UIView<UITextFieldDelegate>
{
    UIImageView *_backgroundImageView;
    UIImageView *_alertboxImageView;
    UITextField *_renameField;
    UIButton * _okButton;
    id<TextAlertViewDelegate> _delegate;
}

- (id)initWithDelegate:(id<TextAlertViewDelegate>)delegate name:(NSString *)name;
- (void)show;


@end