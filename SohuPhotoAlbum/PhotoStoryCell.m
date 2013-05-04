//
//  PhotoStoryCell.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-17.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PhotoStoryCell.h"
#import "UIImageView+WebCache.h"

#define OFFSETX 12
#define OFFSETY 10
#define DESLABELFONT        [UIFont boldSystemFontOfSize:14]
#define DESLABELMAXSIZE     (CGSize){292,1000}
#define DESLABLELINEBREAK   NSLineBreakByWordWrapping

@implementation PhotoStoryCellDataSource
@synthesize photoId,imageUrl,imageDes,commentInfoArray,allCommentCount;
- (CGFloat)cellHeigth
{
    CGFloat heigth = OFFSETY;
    heigth += 300; //图片
    heigth += OFFSETY;
    if (!imageDes ||[imageDes isKindOfClass:[NSNull class]] || [imageDes isEqualToString:@""])
        imageDes = @"用户暂无描述";
    CGSize size = [imageDes sizeWithFont:DESLABELFONT constrainedToSize:DESLABELMAXSIZE lineBreakMode:DESLABLELINEBREAK];
    heigth += OFFSETY + 5;
    heigth += size.height; //des
    heigth += 5.f; // desview->commnetView
    for (int i = 0; i < MIN(3, commentInfoArray.count); i++) {
        CommentViewDataSource * dataSoure = [commentInfoArray objectAtIndex:i];
        heigth += [dataSoure commetViewheigth];
    }
    if (!MIN(3, commentInfoArray.count)){
        heigth += OFFSETY/2.f;
        heigth += 40;
        return heigth;
    }else{
        heigth += 30;
        heigth += 40; //footView
        heigth += OFFSETY - 5.f; //offset
        return heigth;
    }
    return 0.f;
}
@end

@implementation PhotoStoryCell
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _commentArray = [NSMutableArray arrayWithCapacity:0];
        [self initAllSubViews];
    }
    return self;
}
#pragma mark - SetLabel
- (void)setDesLabelPerporty:(UILabel *)label
{
    //设置label属性
    label.numberOfLines = 0;
    label.font = DESLABELFONT;
    label.lineBreakMode = DESLABLELINEBREAK;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1.f];
}
- (void)setCountLabel
{
    _commentCount.numberOfLines = 0;
    _commentCount.font = [UIFont systemFontOfSize:14];
    _commentCount.lineBreakMode = DESLABLELINEBREAK;
    _commentCount.backgroundColor = [UIColor clearColor];
    _commentCount.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1.f];
}
#pragma mark - InitSubViews
- (void)initAllSubViews
{
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    _bgImageView.image = [[UIImage imageNamed:@"photoStoryBg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(100, 160, 100, 160)];
    _photoView = [[UIImageView alloc] initWithFrame:CGRectZero];
    //clip View
    UIView * view = [[UIImageView alloc] initWithFrame:_bgImageView.bounds];
    view.frame = CGRectMake(6, 0, 320 - 12, 20);
    view.layer.cornerRadius = 3.f;
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:_photoView];
    [_bgImageView addSubview:view];
    [self.contentView addSubview:_bgImageView];
    
    _desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self setDesLabelPerporty:_desLabel];
    [self.contentView addSubview:_desLabel];
    for (int i = 0; i < 3; i++) {
        CommentView * view  =[[CommentView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        view.tag = i;
        [view addtarget:self action:@selector(commentViewClick:)];
        [self.contentView addSubview:view];
        [_commentArray addObject:view];
    }
    
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    imageview.backgroundColor = [UIColor clearColor];
    imageview.image = [[UIImage imageNamed:@"commentViewbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 160, 5, 160)];
    _commentCount = [[UILabel alloc] initWithFrame:imageview.bounds];
    [self setCountLabel];
    [imageview addSubview:_commentCount];
    [self.contentView addSubview:imageview];
    
    _footView = [[StoryFootView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    _footView.delegate = self;
    [self.contentView addSubview:_footView];
}

#pragma mark - DataSource
- (void)setDataSource:(PhotoStoryCellDataSource *)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self updaAllSubViewsFrames];
    }
}

- (void)updaAllSubViewsFrames
{
    
    NSString * str = [NSString stringWithFormat:@"%@_c640",[_dataSource imageUrl]];
    [_photoView setImageWithURL:[NSURL URLWithString:str]];
    _photoView.frame = CGRectMake((_photoView.superview.frame.size.width - 320)/2.f, 0, 320, 320);
    
    //_desLabel Size
    _desLabel.text = [_dataSource imageDes];
    CGSize size = [self sizeOfLabel:_desLabel containSize:DESLABELMAXSIZE];
    
    _desLabel.frame = CGRectMake(OFFSETX + 2 , _photoView.bounds.size.height + OFFSETY + 5, size.width, size.height);
    _bgImageView.frame = CGRectMake(0, OFFSETY, _bgImageView.frame.size.width, _photoView.frame.size.height + _desLabel.frame.size.height + 10);
    //commentSize
    for (CommentView * view in _commentArray){
        [view setHidden:YES];
    }
    if (_dataSource.commentInfoArray && _dataSource.commentInfoArray.count) {
        CommentView * view = [_commentArray objectAtIndex:0];
        view.dataScoure = [[_dataSource commentInfoArray] objectAtIndex:0]; //计算view.frame
        view.frame = CGRectMake(view.frame.origin.x, _desLabel.frame.size.height + _desLabel.frame.origin.y + 5, view.frame.size.width, view.frame.size.height);
        [view setHidden:NO];
        [self setFootViewWithView:view];
        if (_dataSource.commentInfoArray.count > 1){
            CommentView * view1 = [_commentArray objectAtIndex:1];
            view1.dataScoure = [[_dataSource commentInfoArray] objectAtIndex:1];
            view1.frame = CGRectMake(view1.frame.origin.x, view.frame.size.height + view.frame.origin.y, view1.frame.size.width, view1.frame.size.height);
            [view1 setHidden:NO];
            [self setFootViewWithView:view1];

            if (_dataSource.commentInfoArray.count > 2){
                CommentView * view2 = [_commentArray objectAtIndex:2];
                view2.dataScoure = [[_dataSource commentInfoArray] objectAtIndex:2];
                view2.frame = CGRectMake(view2.frame.origin.x, view1.frame.size.height + view1.frame.origin.y, view2.frame.size.width, view2.frame.size.height);
                [view2 setHidden:NO];
                [self setFootViewWithView:view2];
            }
        }
    }else{
        _footView.frame = CGRectMake(0, _desLabel.frame.size.height + _desLabel.frame.origin.y+ OFFSETY /2.f ,320, 40);
    }
    _commentCount.text = [NSString stringWithFormat:@"共%d条评论",_dataSource.allCommentCount];
}
- (void)setFootViewWithView:(UIView *)view
{
    _commentCount.superview.frame = CGRectMake(0, view.frame.size.height+view.frame.origin.y, 320, 30);
    _commentCount.frame = CGRectMake(OFFSETY + 5,4, 320, 21);
    _footView.frame = CGRectMake(0, _commentCount.superview.frame.size.height + _commentCount.superview.frame.origin.y,320, 40);
}
- (CGSize)sizeOfLabel:(UILabel *)label containSize:(CGSize)containSize
{
    return [label.text sizeWithFont:label.font constrainedToSize:containSize lineBreakMode:label.lineBreakMode];
}
#pragma mark - FootViewDelegate
- (void)storyFootView:(StoryFootView *)view clickButtonAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(photoStoryCell:footViewClickAtIndex:)])
        [_delegate photoStoryCell:self footViewClickAtIndex:index];
}
#pragma mark - commentClick
- (void)commentViewClick:(UITapGestureRecognizer *)sender
{
    if ([_delegate respondsToSelector:@selector(photoStoryCell:commentClickAtIndex:)])
        [_delegate photoStoryCell:self commentClickAtIndex:[[sender view] tag]];
}

@end
