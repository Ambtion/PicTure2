//
//  PhotoAlbumCell.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PhotoAlbumCell.h"
#import "UIImageView+WebCache.h"

#define CELLHEIGTH 160

#define LEFTFRAME  CGRectMake(21, 0, 128, 128)
#define RIGHTFRAME CGRectMake(170, 0, 128, 128)


@implementation PhotoAlbumCellDataSource
@synthesize leftGroup,rightGroup;
+ (CGFloat)cellHight
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
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _leftImage = [[FolderImageView alloc] initWithFrame:LEFTFRAME];
        _leftCount = [[CountLabel alloc] initWithFrame:CGRectZero];
        [self setCountLabelProperty:_leftCount];
        [_leftImage addSubview:_leftCount];
        [self.contentView addSubview:_leftImage];

        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGusture:)];
        gesture.numberOfTapsRequired = 1;
        [_leftImage addGestureRecognizer:gesture];
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftImage.frame.origin.x,
                                                               _leftImage.frame.size.height + _leftImage.frame.origin.y,
                                                               _leftImage.frame.size.width, 20)];
        [self setNameLabelProperty:_leftLabel];
        [self.contentView addSubview:_leftLabel];
        
        _rightImage = [[FolderImageView alloc] initWithFrame:RIGHTFRAME];
        [self.contentView addSubview:_rightImage];
        _rightCount = [[CountLabel alloc] initWithFrame:CGRectZero];
        [self setCountLabelProperty:_rightCount];
        [_rightImage addSubview:_rightCount];
        
        UITapGestureRecognizer * gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGusture:)];
        gesture2.numberOfTapsRequired = 1;
        [_rightImage addGestureRecognizer:gesture2];
        _rigthLabel = [[UILabel alloc] initWithFrame:CGRectMake(_rightImage.frame.origin.x,
                                                                _rightImage.frame.size.height + _rightImage.frame.origin.y,
                                                                _rightImage.frame.size.width, 20)];
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
        _dataSource = dataSource;
        [self updataViews];
    }
}
- (void)updataViews
{
    if ([_dataSource.leftGroup isKindOfClass:[ALAssetsGroup class]]) {
        //本地
        [_leftImage.actualView setImage:[UIImage imageWithCGImage:[self.dataSource.leftGroup posterImage]]];
        [_leftLabel setText:[NSString stringWithFormat:@"%@",[self.dataSource.leftGroup valueForProperty:ALAssetsGroupPropertyName]]];
        [self setCoutLabelFrame:_leftCount WithNumber:[[self.dataSource leftGroup] numberOfAssets]];
        if (self.dataSource.rightGroup) {
            [_rightImage setHidden:NO];
            [_rigthLabel setHidden:NO];

            [(ALAssetsGroup *)self.dataSource.rightGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
            [_rightImage.actualView setImage:[UIImage imageWithCGImage:[self.dataSource.rightGroup posterImage]]];
            [_rigthLabel setText:[NSString stringWithFormat:@"%@",[self.dataSource.rightGroup valueForProperty:ALAssetsGroupPropertyName]]];
            [self setCoutLabelFrame:_rightCount WithNumber:[[self.dataSource rightGroup] numberOfAssets]];
        }else{
            [_rightImage setHidden:YES];
            [_rigthLabel setHidden:YES];
        }
    }else{
        //网络
        NSString * str = [NSString stringWithFormat:@"%@_c205",[[_dataSource leftGroup] objectForKey:@"cover_url"]];
        [_leftImage.actualView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"moren.png"]];
        [_leftLabel setText:[NSString stringWithFormat:@"%@",[self.dataSource.leftGroup objectForKey:@"folder_name"]]];
        [self setCoutLabelFrame:_leftCount WithNumber:[[self.dataSource.leftGroup objectForKey:@"photo_num"] integerValue]];
        if (self.dataSource.rightGroup) {
            [_rightImage setHidden:NO];
            [_rigthLabel setHidden:NO];

            NSString * str = [NSString stringWithFormat:@"%@_c205",[[_dataSource rightGroup] objectForKey:@"cover_url"]];
            [_rightImage.actualView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"moren.png"]];
            [_rigthLabel setText:[NSString stringWithFormat:@"%@",[self.dataSource.rightGroup objectForKey:@"folder_name"]]];
            [self setCoutLabelFrame:_rightCount WithNumber:[[self.dataSource.rightGroup objectForKey:@"photo_num"] integerValue]];
        }else{
            [_rightImage setHidden:YES];
            [_rigthLabel setHidden:YES];
        }
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
    FolderImageView *  view = (FolderImageView *)[gesture view];
    id group = nil;
    if ([view isEqual:_leftImage]) {
        group = _dataSource.leftGroup;
    }else{
        group = _dataSource.rightGroup;
    }
    if (!view.isNomalState) {
        view.isSelected = !view.isSelected;
    }
    if ([_delegate respondsToSelector:@selector(photoAlbumCell:clickCoverGroup:)])
        [_delegate photoAlbumCell:self clickCoverGroup:group];
}
- (void)showNomalState:(BOOL)isShow
{
    _leftImage.isNomalState = isShow;
    _rightImage.isNomalState = isShow;
}
- (void)isSelectedinSeletedArray:(NSArray *)array
{
    _leftImage.isSelected = [array containsObject:_dataSource.leftGroup];
    _rightImage.isSelected = [array containsObject:_dataSource.rightGroup];
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
