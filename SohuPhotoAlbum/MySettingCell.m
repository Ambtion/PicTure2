//
//  SCPMySettingCell.m
//  SohuCloudPics
//
//  Created by sohu on 12-10-15.
//
//

#import "MySettingCell.h"

@implementation MySettingCell
@synthesize c_Label = _c_Label;
@synthesize d_Label = _d_Label;
@synthesize accessoryImage = _accessoryImage;
@synthesize lineImageView = _lineImageView;
@synthesize cusSwitch = _cusSwitch;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        offset = 0.f;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addsubVies];
    }
    return self;
}
- (void)addsubVies
{
    
    self.c_Label = [[UILabel alloc] initWithFrame:CGRectMake(8, 19 + offset , 200, 16)];
    self.c_Label.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:14];
    self.c_Label.backgroundColor = [UIColor clearColor];
    self.c_Label.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1];
    [self.contentView addSubview:self.c_Label];
    
    self.d_Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 19 + offset + 18, 200, 12)];
    self.d_Label.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1];
    self.d_Label.backgroundColor = [UIColor clearColor];
    self.d_Label.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.d_Label];
    self.accessoryImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.accessoryImage.backgroundColor = [UIColor clearColor];
    self.accessoryImage.image = [UIImage imageNamed:@"settings_arrow.png"];
    [self.contentView addSubview:self.accessoryImage];
    
    _cusSwitch = [[CusSwitch alloc] initWithFrame:CGRectMake(0 ,0 , 54, 22) IconImage:[UIImage imageNamed:@"iconImage.png"] TureImage:[UIImage imageNamed:@"tureImage.png"] falueimage:[UIImage imageNamed:@"falureImage.png"]];
    _cusSwitch.delegate = self;
    [self.contentView addSubview:_cusSwitch];
    _lineImageView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingLine.png"]];
    _lineImageView.frame = CGRectZero;
    [self.contentView addSubview:_lineImageView];
    [self createSectionViewWithTitle];
}
- (void)layoutMySubViews
{
    self.c_Label.frame = CGRectMake(8, 19 + offset , 200, 16);
    self.d_Label.frame = CGRectMake(10, 19 + offset + 18, 200, 12);
    self.accessoryImage.frame = CGRectMake(290 , 16 + offset, 21, 21);
    _lineImageView.frame = CGRectMake(0, 53 + offset, 320, 1);
    _cusSwitch.frame = CGRectMake(320 - 62, 16 + offset , 54, 22);
}

- (void)setSectionTitle:(NSString *)title
{
    if (title) {
        [self.contentView addSubview:titleView];
        offset  = titleView.frame.size.height + titleView.frame.origin.y;
        UILabel * label = (UILabel *)[titleView viewWithTag:1000];
        label.text = title;
    }else{
        [titleView removeFromSuperview];
        offset = 0;
    }
    [self layoutMySubViews];
}

- (void)createSectionViewWithTitle
{
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 320, 25)];
    titleView.backgroundColor = [UIColor clearColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 300, 23)];
    label.textAlignment = UITextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:126.f/255 green:184.f/255 blue:255.f alpha:1];
    label.tag = 1000;
    [titleView addSubview:label];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 23, 320, 2)];
    [imageView setImage:[UIImage imageNamed:@"settingBlueLine.png"]];
    [titleView addSubview:imageView];
}
- (CGFloat)offset
{
    return offset;
}
- (void)cusSwitchValueChange:(CusSwitch *)cusSwitch
{
    if (cusSwitch.isHidden) return;
    if ([_delegate respondsToSelector:@selector(mySettingCell:didSwitchValueChange:)]) {
        [_delegate mySettingCell:self didSwitchValueChange:cusSwitch];
    }
}
@end
