//
//  PhotoWallBaseCell.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PhotoWallCell.h"
#import "UIImageView+WebCache.h"


#define FOOTVIEWHEIGTH 40
#define OFFSETY 5.F
#define DESLABELFONT        [UIFont systemFontOfSize:14]
#define DESLABELMAXSIZE     (CGSize){298,1000}
#define DESLABLELINEBREAK   NSLineBreakByWordWrapping


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
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat heigth  = frame.size.height;
        UIImageView * imagView = [[UIImageView alloc] initWithFrame:self.bounds];
        imagView.image = [UIImage imageNamed:@"wallFoot_bg.png"];
        
        [self addSubview:imagView];
        imagView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.shareTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 125, heigth)];
        [self setLabelPerporty:shareTimeLabel];
        [self setShareTimeLabelPerporty];
        [self addSubview:shareTimeLabel];
        
        self.talkCountbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        talkCountbutton.frame = CGRectMake(150, -1, 44, 44);
        [talkCountbutton setImage:[UIImage imageNamed:@"talkCountIcon.png"] forState:UIControlStateNormal];
        self.talkContLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 0, 40, heigth)];
        [self setLabelPerporty:talkContLabel];
        [self addSubview:talkContLabel];
        [self addSubview:talkCountbutton];
        
        self.likeCountbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        likeCountbutton.frame = CGRectMake(talkContLabel.frame.origin.x + talkContLabel.frame.size.width - 4, -1, 44, 44);
        [likeCountbutton setImage:[UIImage imageNamed:@"likeCountIcon.png"] forState:UIControlStateNormal];
        
        self.likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(likeCountbutton.frame.size.width + likeCountbutton.frame.origin.x,0, 50, heigth)];
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
@synthesize wallId,imageWallInfo,wallDescription,shareTime,talkCount,likeCount,photoCount,OwnerISMe,isLiking;
- (CGFloat)getCellHeigth
{
    if (imageWallInfo.count) {
        CGFloat heigth = [ImageViewAdaper setFramesinToArray:nil byImageCount:MIN([imageWallInfo count] , 6)];
        heigth +=OFFSETY; //图片描述
        self.wallDescription = [NSObject isString:self.wallDescription];
        CGSize size = [wallDescription sizeWithFont:DESLABELFONT constrainedToSize:DESLABELMAXSIZE lineBreakMode:DESLABLELINEBREAK];
        //offset 缺省为0;
        heigth += size.height; //desLabel
        heigth +=OFFSETY; //描述footView
        heigth += FOOTVIEWHEIGTH;
//        heigth +=OFFSETY; //下边界
        return heigth;
    }
    return 0.f;
}
- (CGFloat)getLastCellHeigth
{
    if (imageWallInfo.count) {
        CGFloat heigth = [ImageViewAdaper setFramesinToArray:nil byImageCount:MIN([imageWallInfo count] , 6)];
        heigth +=OFFSETY; //图片描述
        self.wallDescription = [NSObject isString:self.wallDescription];
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

#define Width
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifierNum:(NSInteger)reuseIdentifiernum
{
    if (reuseIdentifiernum > 6 || reuseIdentifiernum < 1) return nil;
    self = [super initWithStyle:style reuseIdentifier:identify[reuseIdentifiernum]];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backImageView.image = [[UIImage imageNamed:@"new_paper_wall.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 160, 50, 50)];
        
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
        [self.contentView addSubview:_footView];
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
    heigth = [ImageViewAdaper setFramesinToArray:_framesArray byImageCount:identifyNum];
    for (NSValue * value in _framesArray) {
        UIView * view = [[UIView alloc] initWithFrame:[value CGRectValue]];
        view.backgroundColor = [UIColor clearColor];
        view.clipsToBounds = YES;
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 304, 304)];
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
        _countLabel = [[CountLabel alloc] initIconLabeWithFrame:CGRectMake(view.frame.size.width - 30, view.frame.size.height - 30, 22, 22)];
        [self setCountLabelProperty:_countLabel];
        [view addSubview:_countLabel];
        CGRect rect = [self.contentView convertRect:_countLabel.frame fromView:view];
        rect.origin.x = 20.f;
        rect.size.width = 32.f;
        rect.size.height = 22.f;
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"stroyDeleteButton.png"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.frame = rect;
        [self.contentView addSubview:_deleteButton];
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
    CGSize size = [_dataSource.wallDescription sizeWithFont:DESLABELFONT constrainedToSize:DESLABELMAXSIZE lineBreakMode:DESLABLELINEBREAK];
    _wallDesLabel.frame = CGRectMake(KWallOffsetX + 2, heigth + OFFSETY, size.width, size.height);
    
    _footView.frame = CGRectMake(0, _wallDesLabel.frame.size.height + _wallDesLabel.frame.origin.y + OFFSETY, 320, 42);
    _footView.shareTimeLabel.text = [NSString stringWithFormat:@"分享于%@",[[[_dataSource shareTime] componentsSeparatedByString:@"-"] lastObject]];
    _footView.talkContLabel.text = [NSString stringWithFormat:@"%d",_dataSource.talkCount];
    _footView.likeCountLabel.text = [NSString stringWithFormat:@"%d",_dataSource.likeCount];
    _countLabel.text = [NSString stringWithFormat:@"%d",_dataSource.photoCount];
    [_deleteButton setHidden:![_dataSource OwnerISMe]];
    _backImageView.frame = CGRectMake(0, 0, self.bounds.size.width, _wallDesLabel.frame.size.height + _wallDesLabel.frame.origin.y + OFFSETY);
    if (_dataSource.isLiking) {
        [_footView.likeCountbutton setImage:[UIImage imageNamed:@"likeCountIcon1.png"] forState:UIControlStateNormal];

    }else{
        [_footView.likeCountbutton setImage:[UIImage imageNamed:@"likeCountIcon.png"] forState:UIControlStateNormal];
    }
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
