//
//  CountLabel.h
//  SohuCloudPics
//
//  Created by sohu on 13-1-23.
//
//

#import <UIKit/UIKit.h>

@interface CountLabel : UILabel
{
    UIImageView * _bgImageView;
    UILabel * _baseLabel;
    UIImageView * _iconImageView;
    BOOL isIconModel;
}
@property(strong,nonatomic)UIImage * iconImage;
- (id)initIconLabeWithFrame:(CGRect)frame;
@end
