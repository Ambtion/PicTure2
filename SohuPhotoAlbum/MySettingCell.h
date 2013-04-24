//
//  SCPMySettingCell.h
//  SohuCloudPics
//
//  Created by sohu on 12-10-15.
//
//

#import <UIKit/UIKit.h>
#import "CusSwitch.h"

@class MySettingCell;
@protocol MySettingCellDelegate <NSObject>
- (void)mySettingCell:(MySettingCell *)cell didSwitchValueChange:(CusSwitch *)Aswitch;
@end
@interface MySettingCell : UITableViewCell<CusSwitchDelegate>
{
    CGFloat offset ;
    UIView * titleView;
}

@property(nonatomic,strong)UILabel* c_Label;
@property(nonatomic,strong)UIImageView * accessoryImage;
@property(nonatomic,strong)UIImageView * lineImageView;
@property(nonatomic,strong)CusSwitch * cusSwitch;
@property(weak,nonatomic)id<MySettingCellDelegate> delegate;
- (CGFloat)offset;
- (void)setSectionTitle:(NSString *)title;
@end
