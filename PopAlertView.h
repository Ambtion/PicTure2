//
//  SCPAlertView_LoginTip.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-28.
//
//

#import <UIKit/UIKit.h>
#import "AHAlertView.h"

@class PopAlertView;
@protocol PopAlertViewDeleagte <NSObject>
@optional
- (void)popAlertView:(PopAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
@interface PopAlertView : NSObject
{
    id<PopAlertViewDeleagte> _delegate;
    AHAlertView * alert;
}
@property(nonatomic,strong)NSDictionary * userinfo;
@property(nonatomic,strong)NSString * identifyMes;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<PopAlertViewDeleagte>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle;
- (void)show;
@end
