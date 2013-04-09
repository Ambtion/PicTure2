//
//  PhotoAlbumCell.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PhotoAlbumCell.h"

#define CELLHEIGTH 160

#define LEFTFRAME  CGRectMake(21, 0, 128, 128)
#define RIGHTFRAME CGRectMake(170, 0, 128, 128)


@implementation PhotoAlbumCellDataSource
@synthesize leftGroup,rightGroup;
- (void)dealloc
{
    self.leftGroup = nil;
    self.rightGroup = nil;
    [super dealloc];
}
- (CGFloat)cellHight
{
    return CELLHEIGTH;
}
@end
@implementation PhotoAlbumCell

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

- (void)dealloc
{
    self.dataSource = nil;
    [_leftImage release];
    [_leftLabel release];
    [_leftCount release];
    [_rightImgae release];
    [_rigthLabel release];
    [_rightCount release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView * imageView1 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alume-pic.png"]] autorelease];
        imageView1.frame = LEFTFRAME;
        [imageView1 setUserInteractionEnabled:YES];
        _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, imageView1.frame.size.width - 24, imageView1.frame.size.height - 24)];
        [imageView1 addSubview:_leftImage];
        [self.contentView addSubview:imageView1];
        _leftCount = [[CountLabel alloc] initWithFrame:CGRectZero];
        [self setCountLabelProperty:_leftCount];
        [imageView1 addSubview:_leftCount];
        
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGusture:)];
        gesture.numberOfTapsRequired = 1;
        [_leftImage addGestureRecognizer:gesture];
        [_leftImage setUserInteractionEnabled:YES];
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView1.frame.origin.x,
                                                               imageView1.frame.size.height + imageView1.frame.origin.y,
                                                               imageView1.frame.size.width, 20)];
        [self setNameLabelProperty:_leftLabel];
        [self.contentView addSubview:_leftLabel];
        
        UIImageView * imageView2 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alume-pic.png"]] autorelease];
        imageView2.frame = RIGHTFRAME;
        [imageView2 setUserInteractionEnabled:YES];
        _rightImgae = [[UIImageView alloc] initWithFrame:_leftImage.frame];
        [imageView2 addSubview:_rightImgae];
        [self.contentView addSubview:imageView2];
        _rightCount = [[CountLabel alloc] initWithFrame:CGRectZero];
        [self setCountLabelProperty:_rightCount];
        [imageView2 addSubview:_rightCount];
        
        UITapGestureRecognizer * gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGusture:)];
        gesture2.numberOfTapsRequired = 1;
        [_rightImgae addGestureRecognizer:gesture2];
        [_rightImgae setUserInteractionEnabled:YES];
        _rigthLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView2.frame.origin.x,
                                                                imageView2.frame.size.height + imageView2.frame.origin.y,
                                                                imageView2.frame.size.width, 20)];
        [self setNameLabelProperty:_rigthLabel];
        [self.contentView addSubview:_rigthLabel];
    }
    return self;
}
- (void)setNameLabelProperty:(UILabel *)label
{
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16.f];
    label.textColor = [UIColor colorWithRed:128.f/255 green:128.f/255 blue:128.f/255 alpha:1.f];
}
- (void)setCountLabelProperty:(CountLabel *)label
{
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
}
- (void)setDataSource:(PhotoAlbumCellDataSource *)dataSource
{
    if (_dataSource != dataSource) {
        [_dataSource release];
        _dataSource = [dataSource retain];
        [self updataViews];
    }
}
- (void)updataViews
{
    [_leftImage setImage:[UIImage imageWithCGImage:[self.dataSource.leftGroup posterImage]]];
    [_leftLabel setText:[NSString stringWithFormat:@"%@",[self.dataSource.leftGroup valueForProperty:ALAssetsGroupPropertyName]]];
    [self setCoutLabelFrame:_leftCount WithNumber:[[self.dataSource leftGroup] numberOfAssets]];
    
    if (self.dataSource.rightGroup) {
        [_rightImgae.superview setHidden:NO];
        [(ALAssetsGroup *)self.dataSource.rightGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
        [_rightImgae setImage:[UIImage imageWithCGImage:[self.dataSource.rightGroup posterImage]]];
        [_rigthLabel setText:[NSString stringWithFormat:@"%@",[self.dataSource.rightGroup valueForProperty:ALAssetsGroupPropertyName]]];
        [self setCoutLabelFrame:_rightCount WithNumber:[[self.dataSource rightGroup] numberOfAssets]];
    }else{
        [_rightImgae.superview setHidden:YES];
    }
}
- (void)setCoutLabelFrame:(CountLabel *)label WithNumber:(NSInteger)num
{
    [label setText:[NSString stringWithFormat:@" %d ", num]];
    [label sizeToFit];
    label.frame = CGRectMake(label.superview.frame.size.width - label.frame.size.width - 18,
                             label.superview.frame.size.height - label.frame.size.height - 15,
                             label.frame.size.width > 22 ? label.frame.size.width : 22 , 22);

}

- (void)handleGusture:(UITapGestureRecognizer *)gesture
{
    id view = [gesture view];
    ALAssetsGroup * group = nil;
    if ([view isEqual:_leftImage]) {
        group = _dataSource.leftGroup;
    }else{
        group = _dataSource.rightGroup;
    }
    if ([_delegate respondsToSelector:@selector(photoAlbumCell:clickCoverGroup:)])
        [_delegate photoAlbumCell:self clickCoverGroup:group];
}
////customise delete button
//- (void)willTransitionToState:(UITableViewCellStateMask)state
//{
//    [super willTransitionToState:state];
//    if ((state & UITableViewCellStateShowingEditControlMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
//        for (UIView *subview in self.subviews) {
//            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
//                UIImageView *deleteBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 33)];
//                [[subview.subviews objectAtIndex:0] addSubview:deleteBtn];
//                [deleteBtn release];
//            }
//        }
//    }
//}
@end
