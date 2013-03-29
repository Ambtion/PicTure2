//
//  MenuCell.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-28.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell
@synthesize leftImage;
@synthesize labelText;
- (void)dealloc
{
    [labelText release];
    [leftImage release];
    [_myHigtView release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.frame = CGRectMake(0, 0, 320, 48);
        leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, (self.bounds.size.height - 44)/2.f, 44, 44)];
        [self.contentView addSubview:leftImage];
        labelText = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 260, 48)];
        labelText.backgroundColor = [UIColor clearColor];
        labelText.font = [UIFont systemFontOfSize:19.f];
        labelText.textColor = [UIColor colorWithRed:171.f/255.f green:171.f/255.f blue:171.f/255.f alpha:1.f];
        [self.contentView addSubview:labelText];
        
        UIImageView * lineimage = [[[UIImageView alloc] initWithFrame:CGRectMake(0,self.bounds.size.height - 1 , 320, 1)] autorelease];
        lineimage.image = [UIImage imageNamed:@"line.png"];
        [self.contentView addSubview:lineimage];
        
        _myHigtView = [[UIImageView alloc] initWithFrame:self.bounds];
        _myHigtView.image = [UIImage imageNamed:@"higlight.png"];
        self.selectedBackgroundView = _myHigtView;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    if (selected) {
//        [self.contentView addSubview:_myHigtView];
//        [self.contentView sendSubviewToBack:_myHigtView];
//    }else{
//        [_myHigtView removeFromSuperview];
//    }
    [super setSelected:selected animated:animated];
}

@end
