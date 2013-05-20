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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 320, 48);
        UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenuHigthed.png"]];
        image.frame = self.bounds;
        self.selectedBackgroundView = image;
        leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, (self.bounds.size.height - 44)/2.f, 44, 44)];
        [self.contentView addSubview:leftImage];
        labelText = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 260, 48)];
        labelText.backgroundColor = [UIColor clearColor];
        labelText.font = [UIFont systemFontOfSize:19.f];
        labelText.textColor = [UIColor colorWithRed:171.f/255.f green:171.f/255.f blue:171.f/255.f alpha:1.f];
        labelText.shadowColor = [UIColor colorWithRed:15.f/255 green:15.f/255 blue:15.f/255 alpha:1.0];
        labelText.shadowOffset = CGSizeMake(0, 1);
        [self.contentView addSubview:labelText];
        
//        UIImageView * lineimage = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.bounds.size.height , 320, 1)];
//        lineimage.image = [UIImage imageNamed:@"line.png"];
//        [self.contentView addSubview:lineimage];
    }
    return self;
}

@end
