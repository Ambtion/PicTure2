//
//  CommentView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-17.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "StoryCommentView.h"
#import "UIImageView+WebCache.h"

#define OFFSETX 13
#define OFFSETY 10
#define CommentLABELFONT        [UIFont systemFontOfSize:14]
#define CommentLABELMAXSIZE     (CGSize){245,1000}
#define CommentLABLELINEBREAK   NSLineBreakByWordWrapping
#define CommentColor [UIColor colorWithRed:153.f/255 green:153.f/255 blue:153.f/255 alpha:1.f]

#define UserColor [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1.f]

// 默认高度58

@implementation StoryCommentViewDataSource
@synthesize userId,potraitImage,userName,shareTime,comment;
- (CGFloat)commetViewheigth
{
    CGFloat heigth = OFFSETY - 2;
    NSString * str = [NSString stringWithFormat:@"%@:  %@",[self userName],[self comment]];
    CGSize size = [str sizeWithFont:CommentLABELFONT constrainedToSize:CommentLABELMAXSIZE lineBreakMode:CommentLABLELINEBREAK];
    heigth += size.height;
    heigth += 15; //shareTime
    return MAX(58, heigth + 10);
}

@end

@implementation StoryCommentView

@synthesize portraitView,userName,shareTime;
@synthesize dataScoure = _dataScoure;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        bgImageView.image = [[UIImage imageNamed:@"commentViewbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 160, 10, 160)];
        [self addSubview:bgImageView];
        self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(OFFSETX, OFFSETY, 38, 38)];
        portraitView.layer.cornerRadius = 5.f;
        portraitView.layer.borderWidth = 1.f;
        portraitView.layer.borderColor = [[UIColor colorWithRed:210/255.f green:210/255.f blue:210/255.f alpha:1.f] CGColor];
        portraitView.backgroundColor = [UIColor clearColor];

        [self addSubview:portraitView];
        [self.portraitView setUserInteractionEnabled:YES];
        self.userName = [[DetailTextView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.userName];
        self.shareTime = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:self.shareTime];
        [self setLabelproperty:self.shareTime];
    }
    return self;
}
- (void)setLabelproperty:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:10.f];
    label.lineBreakMode = CommentLABLELINEBREAK;
    CGFloat color = 180.f/255.f;
    label.textColor = [UIColor colorWithRed:color green:color blue:color alpha:1.f];
}

- (void)updateLabel
{
   //布局规则
    [portraitView setImageWithURL:[NSURL URLWithString:_dataScoure.potraitImage] placeholderImage:[UIImage imageNamed:@"nicheng.png"]];
    NSString * str = [NSString stringWithFormat:@"%@:  %@",[_dataScoure userName],[_dataScoure comment]];
    [userName setText:str WithFont:CommentLABELFONT AndColor:CommentColor];
    CGSize aSize = [str sizeWithFont:CommentLABELFONT constrainedToSize:CommentLABELMAXSIZE lineBreakMode:CommentLABLELINEBREAK];
    aSize.width = MAX(aSize.width, 245);
    aSize.height = MAX(aSize.height, 25);
    userName.frame = CGRectMake(portraitView.frame.size.width + portraitView.frame.origin.x + 11 , OFFSETY - 2, aSize.width, aSize.height);
    userName.backgroundColor = [UIColor clearColor];
    [userName setKeyWordTextArray:[NSArray arrayWithObjects:[_dataScoure userName],@":",nil] WithFont:[UIFont boldSystemFontOfSize:14] AndColor:UserColor];
    
    shareTime.frame = CGRectMake(userName.frame.origin.x, userName.frame.origin.y + userName.frame.size.height, 200, 15);
    shareTime.text = [_dataScoure shareTime];
    self.frame = CGRectMake(0, 0, 320, MAX(58, shareTime.frame.size.height + shareTime.frame.origin.y + 10));
}

- (void)setDataScoure:(StoryCommentViewDataSource *)dataScoure
{
    if (_dataScoure != dataScoure) {
        _dataScoure = dataScoure;
        [self updateLabel];
    }
}
- (void)addtarget:(id)target action:(SEL)action
{
    if (self.gestureRecognizers) return;
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:gesture];
}
@end
