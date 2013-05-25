//
//  TitileAccountView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "TitleAccountView.h"
#import "RequestManager.h"
#import "UIImageView+WebCache.h"

@implementation TitleAccountView

@synthesize userId,portraitImageView,nameLabel,sname;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        [self setUserInteractionEnabled:YES];
        //portrait
        portraitImageView = [[PortraitView alloc] initWithFrame:CGRectMake(5, 7, 30, 30)];
//        portraitImageView.clipsToBounds = YES;
//        portraitImageView.layer.cornerRadius = 15.f;
//        portraitImageView.layer.borderWidth = 1.f;
//        portraitImageView.layer.borderColor = [[UIColor blackColor] CGColor];
//        portraitImageView.backgroundColor = [UIColor clearColor];
        portraitImageView.layer.cornerRadius = 5.f;
        portraitImageView.layer.borderWidth = 1.f;
        portraitImageView.layer.borderColor = [[UIColor colorWithRed:210/255.f green:210/255.f blue:210/255.f alpha:1.f] CGColor];
        portraitImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:portraitImageView];
        
        nameLabel = [[UILabel alloc] initWithFrame:
                     CGRectMake(portraitImageView.frame.size.width + portraitImageView.  frame.origin.x + 10,
                                portraitImageView.frame.origin.y + 2,
                                self.frame.size.width - portraitImageView.frame.size.width - portraitImageView.frame.origin.x,
                                12)];
        [self setNameLabelPorperty];
        [self addSubview:nameLabel];
        CGRect rect = nameLabel.frame;
        rect.origin.y += rect.size.height + 2;
        rect.size.height = 12.f;
        sname = [[UILabel alloc] initWithFrame:rect];
        [self setDesNameLabelPorperty];
        [self addSubview:sname];
        
    }
    return self;
}
- (void)setNameLabelPorperty
{
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = [UIFont systemFontOfSize:12.f];
    CGFloat color = 133.f/255.f;
    self.nameLabel.textColor = [UIColor colorWithRed:color green:color blue:color alpha:1.f];
}
- (void)setDesNameLabelPorperty
{
    self.sname.backgroundColor = [UIColor clearColor];
    self.sname.font = [UIFont systemFontOfSize:11.f];
    self.sname.textColor = [UIColor grayColor];
}

- (void)refreshUserInfoWithDic:(NSDictionary *)dic
{
    [portraitImageView.imageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"user_icon"]] placeholderImage:[UIImage imageNamed:@"nicheng.png"]];
    sname.text  = [NSString stringWithFormat:@"@%@",[dic objectForKey:@"sname"]];
    nameLabel.text = [dic objectForKey:@"user_nick"];
}

@end
