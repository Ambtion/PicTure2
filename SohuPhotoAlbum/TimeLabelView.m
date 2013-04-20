//
//  TimeViewLabel.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-19.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "TimeLabelView.h"

@implementation TimeLabelView
@synthesize daysLabel,yesDayLabel,mouthsLabel;

- (id)initWithFrame:(CGRect)frame
{
    frame.size.width = 78;
    frame.size.height = 28;
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"timeLabel.png"];
        self.backgroundColor = [UIColor clearColor];
        self.daysLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self setDaysLabel];
        [self addSubview:self.daysLabel];
        self.mouthsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.yesDayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:self.mouthsLabel];
        [self addSubview:self.yesDayLabel];
        [self setmouthAndYearsLabel];
    }
    return self;
}
- (void)setmouthAndYearsLabel
{
    self.mouthsLabel.frame = CGRectMake(30, 0, 40, 12);
    self.mouthsLabel.textColor = [UIColor whiteColor];
    self.mouthsLabel.font = [UIFont systemFontOfSize:10];
    self.mouthsLabel.textAlignment = UITextAlignmentCenter;
    self.mouthsLabel.backgroundColor = [UIColor clearColor];

    self.yesDayLabel.frame = CGRectMake(30, 12, 40, 12);
    self.yesDayLabel.textColor = [UIColor whiteColor];
    self.yesDayLabel.font = [UIFont systemFontOfSize:10];
    self.yesDayLabel.textAlignment = UITextAlignmentCenter;
    self.yesDayLabel.backgroundColor = [UIColor clearColor];

}
- (void)setDaysLabel
{
    self.daysLabel.frame = CGRectMake(4, 0, 25, 25);
    self.daysLabel.textColor = [UIColor whiteColor];
    self.daysLabel.font = [UIFont boldSystemFontOfSize:12];
    self.daysLabel.textAlignment = UITextAlignmentCenter;
    self.daysLabel.backgroundColor = [UIColor clearColor];
}
@end
