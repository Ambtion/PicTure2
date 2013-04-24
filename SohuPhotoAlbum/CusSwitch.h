//
//  ImageQualitySwitch.h
//  SohuCloudPics
//
//  Created by sohu on 12-12-29.
//
//

#import <UIKit/UIKit.h>
@class CusSwitch;
@protocol CusSwitchDelegate <NSObject>
- (void)cusSwitchValueChange:(CusSwitch *)cusSwitch;
@end
@interface CusSwitch : UIImageView
{
    UIButton * _button;
    UIImage * tureImage;
    UIImage * falueImage;
}
@property(nonatomic,assign) BOOL isTure;
@property(nonatomic,weak)id<CusSwitchDelegate> delegate;
- (id)initWithFrame:(CGRect)frame IconImage:(UIImage *)Aimage TureImage:(UIImage *)AtureImage falueimage:(UIImage *)AfalueImage;
@end
