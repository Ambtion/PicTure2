//
//  CommentCell.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"

#define TEXTCOLOR   [UIColor colorWithRed:75.f/255 green:75.f/255 blue:75.f/255 alpha:1.f]
#define TEXTFONT    [UIFont systemFontOfSize:14]
#define OFFSETY     10.f
@implementation CommentCellDeteSource
@synthesize userId,portraitUrl,userName,commentStr;

- (CGFloat)cellHeigth
{
    CGSize size = [self.commentStr sizeWithFont:TEXTFONT constrainedToSize:CGSizeMake(220, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + 43 + 10 + OFFSETY;
}

@end
@implementation CommentCell
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor blackColor];
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews
{
    
    porViews = [[PortraitView alloc] initWithFrame:CGRectMake(6, 6 + OFFSETY, 38, 38)];
    porViews.clipsToBounds = YES;
//    porViews.layer.cornerRadius = 5.f;
//    porViews.layer.borderWidth = 1.f;
//    porViews.layer.borderColor = [[UIColor blackColor] CGColor];
//    porViews.backgroundColor = [UIColor clearColor];
    [porViews setUserInteractionEnabled:YES];
    [self.contentView addSubview:porViews];
    UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleUserPortraitTap:) ];
    [porViews addGestureRecognizer:ges];
    
    commentbgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"commentbgView.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 10 + OFFSETY, 45, 25)]];
    [self.contentView addSubview:commentbgView];
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 12 + OFFSETY, 200, 20)];
    [self setusernameLabel];
    [self.contentView addSubview:nameLabel];
    commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self setCommentLabel];
    [self.contentView addSubview:commentLabel];
}
- (void)setusernameLabel
{
    nameLabel.textColor = [UIColor colorWithRed:75.f/255 green:75.f/255 blue:75.f/255 alpha:1.f];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
}
- (void)setCommentLabel
{
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.textColor = TEXTCOLOR;
    commentLabel.font = TEXTFONT;
    commentLabel.numberOfLines = 0;
}
- (CommentCellDeteSource *)dataSource
{
    return _dataSource;
}
- (void)setDataSource:(CommentCellDeteSource *)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self updateViews];
    }
}
- (void)updateViews
{
    [porViews.imageView setImageWithURL:[NSURL URLWithString:_dataSource.portraitUrl]];
    nameLabel.text = [NSString stringWithFormat:@"%@:",_dataSource.userName];
    CGSize size = [_dataSource.commentStr sizeWithFont:TEXTFONT constrainedToSize:CGSizeMake(220, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect rect = CGRectMake(68, 35 + OFFSETY, size.width, size.height);
    commentLabel.frame = rect;
    commentLabel.text = _dataSource.commentStr;
    commentbgView.frame = CGRectMake(50, 6 + OFFSETY, 240, rect.origin.y + rect.size.height);
}
- (void)handleUserPortraitTap:(UIGestureRecognizer *)gesture
{
    if ([_delegate respondsToSelector:@selector(commentCell:clickPortrait:)])
        [_delegate commentCell:self clickPortrait:gesture];
}
@end
