//
//  PhotoWallBaseCell.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PhotoWallCell.h"
#import "UIImageView+WebCache.h"


#define FOOTVIEWHEIGTH 36
#define OFFSETY 10.f
#define DESLABELFONT        [UIFont systemFontOfSize:14]
#define DESLABELMAXSIZE     (CGSize){298,1000}
#define DESLABLELINEBREAK   NSLineBreakByWordWrapping

double radians(float degrees) {
    return ( degrees * 3.14159265 ) / 180.0;
}

@implementation NSObject(string)

+ (NSString *)isString:(id)sender
{
    if (!sender ||[sender isKindOfClass:[NSNull class]] || [sender isEqualToString:@""])
        return nil;
    return sender;
}

@end
@implementation CellFootView
@synthesize shareTimeLabel,likeCountbutton,talkCountbutton;
@synthesize talkContLabel,likeCountLabel;

- (id)initWithFrame:(CGRect)frame
{
    //320 * 36
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat heigth  = frame.size.height;
        UIImageView * imagView = [[UIImageView alloc] initWithFrame:self.bounds];
        imagView.image = [UIImage imageNamed:@"wallFoot_bg.png"];
        imagView.backgroundColor = [UIColor clearColor];
        [self addSubview:imagView];
        imagView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.shareTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * KWallOffsetX, 0, 125, heigth)];
        [self setLabelPerporty:shareTimeLabel];
        [self setShareTimeLabelPerporty];
        [self addSubview:shareTimeLabel];
        
        self.talkCountbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        talkCountbutton.frame = CGRectMake(180, 0, heigth, heigth);
        [talkCountbutton setImage:[UIImage imageNamed:@"talkCountIcon.png"] forState:UIControlStateNormal];
        self.talkContLabel = [[UILabel alloc]initWithFrame:CGRectMake(talkCountbutton.frame.origin.x + talkCountbutton.frame.size.width, 0, 30, heigth)];
        [self setLabelPerporty:talkContLabel];
        [self addSubview:talkContLabel];
        [self addSubview:talkCountbutton];
        
        self.likeCountbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        likeCountbutton.frame = CGRectMake(talkContLabel.frame.origin.x + talkContLabel.frame.size.width , 0, heigth, heigth);
        [likeCountbutton setImage:[UIImage imageNamed:@"likeCountIcon.png"] forState:UIControlStateNormal];
        
        self.likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(likeCountbutton.frame.size.width + likeCountbutton.frame.origin.x,0, 30, heigth)];
        [self setLabelPerporty:likeCountLabel];
        [self addSubview:likeCountLabel];
        [self addSubview:self.likeCountbutton];
        
    }
    return self;
}
- (void)setShareTimeLabelPerporty
{
    shareTimeLabel.backgroundColor = [UIColor clearColor];
    shareTimeLabel.font = [UIFont systemFontOfSize:11.f];
    shareTimeLabel.textColor = [UIColor colorWithRed:121.f/255 green:121.f/255 blue:121.f/255 alpha:1.f];
}
- (void)setLabelPerporty:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:11.f];
}
@end

@implementation PhotoWallCellDataSource
@synthesize stroyName,showId,wallId,imageWallInfo,wallDescription,shareTime,talkCount,likeCount,photoCount,isMine,isLiking;

- (CGFloat)getCellHeigth
{
    if (imageWallInfo.count) {
        CGFloat heigth = OFFSETY; //背景上边界
        heigth += [ImageViewAdaper setFramesinToArray:nil byImageCount:MIN([imageWallInfo count] , 6)];
        self.wallDescription = [NSObject isString:self.wallDescription];
        if (self.wallDescription) {
            heigth +=OFFSETY; //图片描述
            CGSize size = [wallDescription sizeWithFont:DESLABELFONT constrainedToSize:DESLABELMAXSIZE lineBreakMode:DESLABLELINEBREAK];
            //offset 缺省为0;
            heigth += size.height; //desLabel
            heigth += OFFSETY; //描述下边界
        }
        heigth += FOOTVIEWHEIGTH;
        return heigth;
    }
    return 0.f;
}
- (CGFloat)getLastCellHeigth
{
    return [self getCellHeigth] + 10.f;
}
- (NSInteger)numOfCellStragey
{
    if (imageWallInfo) {
        return imageWallInfo.count;
    }
    return 0;
}
@end

@implementation PhotoWallCell
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifierNum:(NSInteger)reuseIdentifiernum
{
    if (reuseIdentifiernum > 6 || reuseIdentifiernum < 1) return nil;
    self = [super initWithStyle:style reuseIdentifier:identify[reuseIdentifiernum]];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backImageView.image = [[UIImage imageNamed:@"new_paper_wall.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 160, 50, 50)];
        _backImageView.backgroundColor = [UIColor clearColor];
        [_backImageView setUserInteractionEnabled:YES];
        [self.contentView addSubview:_backImageView];
        
        _framesArray = [NSMutableArray arrayWithCapacity:0];
        _imageViewArray = [NSMutableArray arrayWithCapacity:0];
        [self setFramesWithIndentify:reuseIdentifiernum];
        
        _wallDesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self setDesLabelPerporty];
        _footView = [[CellFootView alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
        [_footView.talkCountbutton addTarget:self action:@selector(talkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footView.likeCountbutton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backImageView addSubview:_wallDesLabel];
        [_backImageView addSubview:_footView];
    }
    return self;
}

- (void)setDesLabelPerporty
{
    _wallDesLabel.font = DESLABELFONT;
    _wallDesLabel.lineBreakMode = DESLABLELINEBREAK;
    _wallDesLabel.numberOfLines = 0.f;
    _wallDesLabel.textColor = [UIColor colorWithRed:102.f/255.f green:102.f/255.f blue:102.f/255.f alpha:1.f];
    _wallDesLabel.backgroundColor = [UIColor clearColor];
}

- (void)setFramesWithIndentify:(NSInteger)identifyNum
{
    [_imageViewArray removeAllObjects];
    imageViewheigth = [ImageViewAdaper setFramesinToArray:_framesArray byImageCount:identifyNum];
    for (NSValue * value in _framesArray) {
        UIView * view = [[UIView alloc] initWithFrame:[value CGRectValue]];
        view.backgroundColor = [UIColor clearColor];
        view.clipsToBounds = YES;
        CGFloat maxSize = MAX(view.frame.size.width, view.frame.size.height);
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, maxSize, maxSize)];
        imageView.center = CGPointMake(view.frame.size.width /2.f, view.frame.size.height/2.f);
        [imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [imageView addGestureRecognizer:tap];
        [_imageViewArray addObject:imageView];
        [view addSubview:imageView];
        [_backImageView addSubview:view];
    }
    if (_imageViewArray.count) {
        UIView * view = [[_imageViewArray lastObject] superview];
        _countLabel = [[CountLabel alloc] initIconLabeWithFrame:CGRectMake(view.frame.size.width + view.frame.origin.x - 30, view.frame.size.height + view.frame.origin.y - 30, 22, 22)];
        [self setCountLabelProperty:_countLabel];
        [view.superview addSubview:_countLabel];
        CGRect rect = _countLabel.frame;
        rect.origin.x = 20.f;
        rect.size.width = 32.f;
        rect.size.height = 22.f;
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"WallDeleteButton.png"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.frame = rect;
        [view.superview addSubview:_deleteButton];
    }
    
}
- (void)setCountLabelProperty:(CountLabel *)label
{
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
}

- (void)setDataSource:(PhotoWallCellDataSource *)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self updataSubViews];
    }
}

- (void)updataSubViews
{
    for (int i = 0; i < _imageViewArray.count;i++) {
        //设置图片
        UIImageView * imageView = [_imageViewArray objectAtIndex:i];
        NSDictionary * photoInfo = [_dataSource.imageWallInfo objectAtIndex:i];
        NSString * str = [NSString stringWithFormat:@"%@_c410",[photoInfo objectForKey:@"photo_url"]];
        [imageView setImageWithURL:[NSURL URLWithString:str]];
    }
    
    _wallDesLabel.text = _dataSource.wallDescription;
    if (_wallDesLabel.text) {
        CGSize size = [_dataSource.wallDescription sizeWithFont:DESLABELFONT constrainedToSize:DESLABELMAXSIZE lineBreakMode:DESLABLELINEBREAK];
        _wallDesLabel.frame = CGRectMake(KWallOffsetX * 2 , imageViewheigth + OFFSETY, size.width, size.height);
        
        _footView.frame = CGRectMake(0, _wallDesLabel.frame.size.height + _wallDesLabel.frame.origin.y + OFFSETY, 320, FOOTVIEWHEIGTH);
    }else{
        _footView.frame = CGRectMake(0, imageViewheigth, 320, FOOTVIEWHEIGTH);
    }
    
    _footView.shareTimeLabel.text = [NSString stringWithFormat:@"分享于%@",[[[_dataSource shareTime] componentsSeparatedByString:@"-"] lastObject]];
//    _footView.talkContLabel.text = [NSString stringWithFormat:@"%d",_dataSource.talkCount];
//    _footView.likeCountLabel.text = [NSString stringWithFormat:@"%d",_dataSource.likeCount];
    _countLabel.text = [NSString stringWithFormat:@"%d",_dataSource.photoCount];
    [_deleteButton setHidden:![_dataSource isMine]];
    
    [self updataLikeState];
    _backImageView.frame = CGRectMake(0, OFFSETY, 320, _footView.frame.size.height + _footView.frame.origin.y);;
    DLog(@"%f %f",[self.dataSource getCellHeigth], _backImageView.frame.size.height + _backImageView.frame.origin.y);
}
- (void)updataLikeState
{
    if (_dataSource.isLiking) {
        [_footView.likeCountbutton setImage:[UIImage imageNamed:@"likeCountIcon1.png"] forState:UIControlStateNormal];
    }else{
        [_footView.likeCountbutton setImage:[UIImage imageNamed:@"likeCountIcon.png"] forState:UIControlStateNormal];
    }
    _footView.talkContLabel.text = [NSString stringWithFormat:@"%d",_dataSource.talkCount];
    _footView.likeCountLabel.text = [NSString stringWithFormat:@"%d",_dataSource.likeCount];
}
- (void)resetImageWithAnimation:(BOOL)animation
{
    CABasicAnimation * animationTr = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -1000;
    //this would rotate object on an axis of x = 0, y = 1, z = -0.3f. It is "Z" here which would
    transform = CATransform3DRotate(transform, roundf(45.f), 1, 0,  -0.2);
    animationTr.fromValue = [NSValue valueWithCATransform3D:transform];
    
    animationTr.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, roundf(0), 0, 0, 0)];
    animationTr.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    CABasicAnimation * animationRec = [CABasicAnimation animationWithKeyPath:@"position"];
    animationRec.fromValue = [NSValue valueWithCGPoint:CGPointMake(_backImageView.layer.position.x + 50, _backImageView.layer.position.y + 100)];
    animationRec.toValue = [NSValue valueWithCGPoint:_backImageView.layer.position];
    animationRec.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.duration = 0.5;
    [[UIDevice currentDevice] model];
    
    group.animations = [NSArray arrayWithObjects:animationRec,animationTr, nil];
    [_backImageView.layer addAnimation:group forKey:@""];
    
    CABasicAnimation * animationBac = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animationBac.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationBac.fromValue = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5];
    animationBac.toValue = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
    [self.contentView.layer addAnimation:animationBac forKey:@""];
}
#pragma mark ActionFunction
- (void)handleGesture:(id)sender
{
    if ([_delegate respondsToSelector:@selector(photoWallCell:photosClick:)])
        [_delegate photoWallCell:self photosClick:nil];
}
- (void)likeButtonClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(photoWallCell:likeClick:)])
        [_delegate photoWallCell:self likeClick:button];
}
- (void)talkButtonClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(photoWallCell:talkClick:)])
        [_delegate photoWallCell:self talkClick:button];
}
- (void)deleteButtonClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(photoWallCell:deleteClick:)])
        [_delegate photoWallCell:self deleteClick:button];
}
@end
