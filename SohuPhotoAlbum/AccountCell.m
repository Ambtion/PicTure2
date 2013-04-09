//
//  AccountCell.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-28.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "AccountCell.h"

@implementation AccountCell
@synthesize labelText = _labelText;
- (void)dealloc
{
    [_bgView release];
    [_labelText release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        _bgView.image = [UIImage imageNamed:@"accountBar.png"];
        [self.contentView addSubview:_bgView];
        _labelText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 40)];
        _labelText.backgroundColor = [UIColor clearColor];
        _labelText.font = [UIFont systemFontOfSize:19.f];
        _labelText.textColor = [UIColor colorWithRed:171.f/255.f green:171.f/255.f blue:171.f/255.f alpha:1.f];
        [self.contentView addSubview:_labelText];
//        UIImageView * lineimage = [[[UIImageView alloc] initWithFrame:CGRectMake(0,self.bounds.size.height - 1 , 320, 1)] autorelease];
//        lineimage.image = [UIImage imageNamed:@"line.png"];
//        [self.contentView addSubview:lineimage];
    }
    return self;
}

@end
