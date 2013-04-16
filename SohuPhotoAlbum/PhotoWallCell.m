//
//  PhotoWallBaseCell.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PhotoWallCell.h"

#define DESLABELFONT [UIFont systemFontOfSize:20]
#define DESLABELMAXSIZE (CGSize){310,500}
#define DESLABLELINEBREAK NSLineBreakByWordWrapping

#define FOOTVIEWHEIGTH 40

#define OFFSETY 5.F

//static CGFloat imageHeigth = 0.f;
@implementation CellFootView
@synthesize shareTimeLabel,likeCountbutton,talkCountbutton;
@synthesize talkContLabel,likeCountLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat heigth  = frame.size.height;
        self.shareTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 140, heigth)];
        [self setLabelPerporty:shareTimeLabel];
        [self addSubview:self.shareTimeLabel];
        
        self.talkCountbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        talkCountbutton.frame = CGRectMake(shareTimeLabel.frame.size.width, 0, 40, heigth);
        [self addSubview:talkCountbutton];
        self.talkContLabel = [[UILabel alloc]initWithFrame:CGRectMake(talkCountbutton.frame.size.width + talkCountbutton.frame.origin.x, 0, 50, heigth)];
        [self setLabelPerporty:talkContLabel];
        [self addSubview:talkContLabel];
        
        self.likeCountbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        likeCountbutton.frame = CGRectMake(talkContLabel.frame.origin.x + talkContLabel.frame.size.width, 0, 40, heigth);
        [self addSubview:self.likeCountbutton];
        self.likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(likeCountbutton.frame.size.width + likeCountbutton.frame.origin.x,0, 50, heigth)];
        [self setLabelPerporty:likeCountLabel];
        [self addSubview:likeCountLabel];

    }
    return self;
}
- (void)setLabelPerporty:(UILabel *)label
{
    
}
@end

@implementation PhotoWallCellDataSource
@synthesize imageWallInfo,wallDescription,shareTime,talkCount,likeCount;
- (CGFloat)getCellHeigth
{
    if (imageWallInfo.count) {
        CGFloat heigth = [ImageViewAdaper setFramesinToArray:nil byImageCount:MIN([imageWallInfo count] , 6)];
        heigth +=OFFSETY; //图片描述
        CGSize size = [wallDescription sizeWithFont:DESLABELFONT constrainedToSize:DESLABELMAXSIZE lineBreakMode:DESLABLELINEBREAK];
        //offset 缺省为0;
        heigth += size.height; //desLabel
        heigth +=OFFSETY; //描述footView
        heigth += FOOTVIEWHEIGTH;
        heigth +=OFFSETY; //下边界
        return heigth;
    }
    return 0.f;
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
        _framesArray = [NSMutableArray arrayWithCapacity:0];
        _imageViewArray = [NSMutableArray arrayWithCapacity:0];
        [self setFramesWithIndentify:reuseIdentifiernum];
        _wallDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self setDesLabelPerporty];
        _footView = [[CellFootView alloc] initWithFrame:CGRectMake(0, _wallDesLabel.frame.size.height + _wallDesLabel.frame.origin.y, 320, 40)];
        [_footView.talkCountbutton addTarget:self action:@selector(talkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footView.likeCountbutton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_wallDesLabel];
        [self.contentView addSubview:_footView];
    }
    return self;
}

- (void)setDesLabelPerporty
{
    _wallDesLabel.font = DESLABELFONT;
    _wallDesLabel.lineBreakMode = DESLABLELINEBREAK;
    _wallDesLabel.numberOfLines = 0.f;
}
- (void)setFramesWithIndentify:(NSInteger)identifyNum
{
    [_imageViewArray removeAllObjects];
    heigth = [ImageViewAdaper setFramesinToArray:_framesArray byImageCount:identifyNum];
    for (NSValue * value in _framesArray) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:[value CGRectValue]];
        [_imageViewArray addObject:imageView];
        [self.contentView addSubview:imageView];
    }
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
        imageView.image = [UIImage imageNamed:[[_dataSource imageWallInfo] objectAtIndex:i]];
    }
    
    _wallDesLabel.text = _dataSource.wallDescription;
    CGSize size = [_dataSource.wallDescription sizeWithFont:DESLABELFONT constrainedToSize:DESLABELMAXSIZE lineBreakMode:DESLABLELINEBREAK];
    _wallDesLabel.frame = CGRectMake(5, heigth + OFFSETY, size.width, size.height);
    
    _footView.frame = CGRectMake(0, _wallDesLabel.frame.size.height + _wallDesLabel.frame.origin.y + OFFSETY, 320, 40);
    _footView.shareTimeLabel.text = [_dataSource shareTime];
    _footView.talkContLabel.text = [NSString stringWithFormat:@"%d",_dataSource.talkCount];
    _footView.likeCountLabel.text = [NSString stringWithFormat:@"%d",_dataSource.likeCount];
}
#pragma mark ActionFunction
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
@end
