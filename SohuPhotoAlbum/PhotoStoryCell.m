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
#define DESLABELFONT        [UIFont systemFontOfSize:14]
#define DESLABELMAXSIZE     (CGSize){292,1000}
#define DESLABLELINEBREAK   NSLineBreakByWordWrapping
//bgView has Offset
//图片 1 + hegith const 308 wigth
//des OFFSETY + 5 + hegth 隐藏的话 0
//comment _desLabel.frame.origin.y + 5
//comment 0
//footView 0

@implementation PhotoStoryCellDataSource

@synthesize isLiking,photoId,photoShowID,imageUrl,weigth,higth,imageDes,commentInfoArray,allCommentCount;
- (CGFloat)lastCellHeigth
{
    return [self cellHeigth] + 5;
}
- (CGFloat)cellHeigth
{
    CGFloat heigth =  OFFSETY + 1; //biView Offset;
    
    heigth += 308  * higth / weigth; //等宽缩放
    
    if (!imageDes ||[imageDes isKindOfClass:[NSNull class]] || [imageDes isEqualToString:@""]){
        imageDes = nil;
    }else{
        CGSize size = [imageDes sizeWithFont:DESLABELFONT constrainedToSize:DESLABELMAXSIZE lineBreakMode:DESLABLELINEBREAK];
        heigth +=  5 ; //desOffset
        heigth += size.height; //des
        heigth +=  5; //des下边界
    }
    
    
    if (!MIN(3, commentInfoArray.count)){ //评论内容不存在
        heigth += 40;
    }else{
        //comment
        for (int i = 0; i < MIN(3, commentInfoArray.count); i++) {
            StoryCommentViewDataSource * dataSoure = [commentInfoArray objectAtIndex:i];
            heigth += [dataSoure commetViewheigth];
        }
        heigth += 30; //comment Account
        heigth += 40; //footView
    }
    return heigth; //边界
}

@end

@implementation PhotoStoryCell
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier thenHiddeDeleteButton:(BOOL)isHidden
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _commentArray = [NSMutableArray arrayWithCapacity:0];
        [self initAllSubViewsWithHiddenDeleButton:isHidden];
        [self.contentView setHidden:YES];
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
    _commentCount.backgroundColor = [UIColor clearColor];
    _commentCount.numberOfLines = 0;
    _commentCount.font = [UIFont systemFontOfSize:14.f];
    _commentCount.lineBreakMode = DESLABLELINEBREAK;
    CGFloat color = 180.f/255.f;
    _commentCount.textColor = [UIColor colorWithRed:color green:color blue:color alpha:1.f];
}

#pragma mark - InitSubViews
- (void)initAllSubViewsWithHiddenDeleButton:(BOOL)ishidden
{
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, OFFSETY, 320, 0)];
    [_bgImageView setUserInteractionEnabled:YES];
    _bgImageView.image = [[UIImage imageNamed:@"photoStoryBg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(100, 160, 100, 160)];
    _bgImageView.backgroundColor = [UIColor whiteColor];
    _photoView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_photoView setUserInteractionEnabled:YES];
    _photoView.frame = CGRectMake(6, 0, 320 - 12, 20);
    UITapGestureRecognizer * gesTure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_photoView addGestureRecognizer:gesTure];
    [_bgImageView addSubview:_photoView];
    [self.contentView addSubview:_bgImageView];
    
    _desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self setDesLabelPerporty:_desLabel];
    //    [self.contentView addSubview:_desLabel];
    [_bgImageView addSubview:_desLabel];
    for (int i = 0; i < 3; i++) {
        StoryCommentView * view  =[[StoryCommentView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        view.tag = i;
        [view addtarget:self action:@selector(commentViewClick:)];
        UITapGestureRecognizer * gesTure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentPortraitView:)];
        [view.portraitView addGestureRecognizer:gesTure];
        [_bgImageView addSubview:view];
        [_commentArray addObject:view];
    }
    
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    imageview.backgroundColor = [UIColor clearColor];
    //    imageview.image = [[UIImage imageNamed:@"commentViewbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 160, 10, 160)];
    imageview.image =[UIImage imageNamed:@"accountLabelbg.png"];
    _commentCount = [[UILabel alloc] initWithFrame:imageview.bounds];
    [self setCountLabel];
    [imageview addSubview:_commentCount];
    [_bgImageView  addSubview:imageview];
    
    _footView = [[StoryFootView alloc] initWitFrame:CGRectMake(0, 0, 320, 40) thenHiddenDeleteButton:ishidden];
    _footView.delegate = self;
    [_bgImageView addSubview:_footView];
}
#pragma mark - DataSource
- (void)setDataSource:(PhotoStoryCellDataSource *)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self updateAllSubViewsFrames];
    }
}

- (void)updateAllSubViewsFrames
{    
    NSString * str = [NSString stringWithFormat:@"%@_w640",[_dataSource imageUrl]];
    _photoView.frame = CGRectMake(6, 1, 308, 308 * _dataSource.higth / _dataSource.weigth);
    [_photoView setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
    [self updateAllOhterViewButImageView];
}
- (void)updateAllOhterViewButImageView
{
    [self.contentView setHidden:NO];
    _desLabel.text = [_dataSource imageDes];
    CGSize size = [self sizeOfLabel:_desLabel containSize:DESLABELMAXSIZE];
    CGFloat offsetDes = size.height ? OFFSETY + 5 : 0;
    _desLabel.frame = CGRectMake(OFFSETX + 2 , _photoView.bounds.size.height + _photoView.frame.origin.y + offsetDes , size.width, size.height);
    
    for (StoryCommentView * view in _commentArray)
        [view setHidden:YES];
    
    if (_dataSource.commentInfoArray && _dataSource.commentInfoArray.count) {
        StoryCommentView * view = [_commentArray objectAtIndex:0];
        view.dataScoure = [[_dataSource commentInfoArray] objectAtIndex:0]; //计算view.frame
        view.frame = CGRectMake(view.frame.origin.x, _desLabel.frame.size.height + _desLabel.frame.origin.y + offsetDes, view.frame.size.width, view.frame.size.height);
        [view setHidden:NO];
        [self setFootViewWithView:view];
        if (_dataSource.commentInfoArray.count > 1){
            
            StoryCommentView * view1 = [_commentArray objectAtIndex:1];
            view1.dataScoure = [[_dataSource commentInfoArray] objectAtIndex:1];
            view1.frame = CGRectMake(view1.frame.origin.x, view.frame.size.height + view.frame.origin.y, view1.frame.size.width, view1.frame.size.height);
            [view1 setHidden:NO];
            [self setFootViewWithView:view1];

            if (_dataSource.commentInfoArray.count > 2){
                StoryCommentView * view2 = [_commentArray objectAtIndex:2];
                view2.dataScoure = [[_dataSource commentInfoArray] objectAtIndex:2];
                view2.frame = CGRectMake(view2.frame.origin.x, view1.frame.size.height + view1.frame.origin.y, view2.frame.size.width, view2.frame.size.height);
                [view2 setHidden:NO];
                [self setFootViewWithView:view2];
            }
        }
    }else{
        
        [_commentCount.superview setHidden:YES];
        _footView.frame = CGRectMake(0, _desLabel.frame.size.height + _desLabel.frame.origin.y ,320, _footView.frame.size.height);
    }
    _commentCount.text = [NSString stringWithFormat:@"共%d条评论",_dataSource.allCommentCount];
    [_footView setLikeStateTolike:_dataSource.isLiking];
    _bgImageView.frame = CGRectMake(0, _bgImageView.frame.origin.y, _bgImageView.frame.size.width, _footView.frame.origin.y + _footView.frame.size.height - 10);
}
- (void)setFootViewWithView:(UIView *)view
{
    //commetCount
    [_commentCount.superview setHidden:NO];
    _commentCount.superview.frame = CGRectMake(0, view.frame.size.height + view.frame.origin.y, 320, 30);
    _commentCount.frame = CGRectMake(OFFSETY + 10,4, 280, 21);
    _footView.frame = CGRectMake(0, _commentCount.superview.frame.size.height + _commentCount.superview.frame.origin.y,320, _footView.frame.size.height);
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

#pragma mark - TapGesture
- (void)tapGesture:(UIGestureRecognizer *)gesture
{
    if ([_delegate respondsToSelector:@selector(photoStoryCellImageClick:)])
        [_delegate photoStoryCellImageClick:self];
}
#pragma mark - commentClick
- (void)commentPortraitView:(UITapGestureRecognizer *)sender
{
    NSIndexPath * path = [NSIndexPath indexPathForRow:0 inSection:[[sender view] tag]];
    if ([_delegate respondsToSelector:@selector(photoStoryCell:commentClickAtIndex:)])
        [_delegate photoStoryCell:self commentClickAtIndex:path];
}
- (void)commentViewClick:(UITapGestureRecognizer *)sender
{
    NSIndexPath * path = [NSIndexPath indexPathForRow:1 inSection:[[sender view] tag]];
    if ([_delegate respondsToSelector:@selector(photoStoryCell:commentClickAtIndex:)])
        [_delegate photoStoryCell:self commentClickAtIndex:path];
}

#pragma mark - Animation
- (void)resetImageWithAnimation:(BOOL)animation
{
    
    CABasicAnimation * animationTr = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -1000;
    //this would rotate object on an axis of x = 0, y = 1, z = -0.3f. It is "Z" here which would
    transform = CATransform3DRotate(transform, roundf(45.f), 1, 0,  - 0.2);
    animationTr.fromValue = [NSValue valueWithCATransform3D:transform];
    
    animationTr.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, roundf(0), 0, 0, 0)];
    animationTr.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation * animationRec = [CABasicAnimation animationWithKeyPath:@"position"];
    animationRec.fromValue = [NSValue valueWithCGPoint:CGPointMake(_bgImageView.layer.position.x + 100, _bgImageView.layer.position.y + 200)];
    animationRec.toValue = [NSValue valueWithCGPoint:_bgImageView.layer.position];
    animationRec.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:animationRec,animationTr, nil];
    [_bgImageView.layer addAnimation:group forKey:@""];
    CABasicAnimation * animationBac = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animationBac.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationBac.fromValue = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5];
    animationBac.toValue = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
    [self.contentView.layer addAnimation:animationBac forKey:@""];
}


@end