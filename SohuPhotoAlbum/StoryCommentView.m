//
//  CommentView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-17.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "StoryCommentView.h"
#import "UIImageView+WebCache.h"

#define MAXSIZE CGSizeMake(230, 10000)
#define OFFSETX 18
#define OFFSETY 10
#define CommentLABELFONT        [UIFont boldSystemFontOfSize:11]
#define CommentLABELMAXSIZE     (CGSize){300,1000}
#define CommentLABLELINEBREAK   NSLineBreakByWordWrapping


@implementation StoryCommentViewDataSource
@synthesize userId,potraitImage,userName,shareTime,comment;
- (CGFloat)commetViewheigth
{
    CGFloat heigth = OFFSETY;
    heigth += 21; //userNameheigth
    heigth += OFFSETY;
    heigth += [comment sizeWithFont:CommentLABELFONT constrainedToSize:CommentLABELMAXSIZE lineBreakMode:CommentLABLELINEBREAK].height;
    return MAX(70, heigth + 10);
}
@end

@implementation StoryCommentView

@synthesize portraitView,userName,shareTime,commentLabel;
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
        self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(OFFSETX, OFFSETY, 50, 50)];
        [self addSubview:portraitView];
        [self.portraitView setUserInteractionEnabled:YES];
        self.userName = [[UILabel alloc] initWithFrame:CGRectZero];
        [self setUserNameLabel];
        [self addSubview:self.userName];
        self.shareTime = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:self.shareTime];
        [self setLabelproperty:self.shareTime];
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self setLabelproperty:self.commentLabel];
        [self addSubview:commentLabel];
    }
    return self;
}
- (void)setUserNameLabel
{
    userName.backgroundColor = [UIColor clearColor];
    userName.font = [UIFont boldSystemFontOfSize:12.f];
    userName.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1.f];
}
- (void)setLabelproperty:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = CommentLABELFONT;
    label.lineBreakMode = CommentLABLELINEBREAK;
    label.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1.f];
}
- (void)updateLabel
{
   //布局规则
    [portraitView setImageWithURL:[NSURL URLWithString:_dataScoure.potraitImage] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    userName.text = [_dataScoure userName];
    shareTime.text  = [_dataScoure shareTime];
    commentLabel.text  = [_dataScoure comment];
    CGSize size = [self sizeOfLabel:userName containSize:CGSizeMake(200, 21)];
    userName.frame = CGRectMake(portraitView.frame.size.width + portraitView.frame.origin.x + 10 , OFFSETY, size.width, size.height);
    
    size = [self sizeOfLabel:shareTime containSize:CGSizeMake(200, 21)];
    shareTime.frame = CGRectMake(userName.frame.size.width + userName.frame.origin.x + 10, OFFSETY, size.width, size.height);

    //commentView
    size = [self sizeOfLabel:commentLabel containSize:MAXSIZE];
    
    commentLabel.frame = CGRectMake(userName.frame.origin.x, userName.frame.size.height + userName.frame.origin.y + OFFSETY, size.width, size.height);
    self.frame = CGRectMake(0, 0, 320, MAX(70, commentLabel.frame.size.height + commentLabel.frame.origin.y + 10));
}
- (CGSize)sizeOfLabel:(UILabel *)label containSize:(CGSize)containSize
{
    return [label.text sizeWithFont:label.font constrainedToSize:containSize lineBreakMode:label.lineBreakMode];
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
