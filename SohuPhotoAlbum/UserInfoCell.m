//
//  UserInfoCell.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-22.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "UserInfoCell.h"
@implementation UserInfoCellDataSource
@synthesize userName,sizeOfAll,sizeOfUsed;
@end

@implementation UserInfoCell
@synthesize dataSource = _dataSource;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:[self getSectionViewWithTitle:@"个人信息"]];
        CGFloat offset = 30;
        UILabel * nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(18, 20 + offset, 80, 20)];
        [self setTitleLabel:nameTitle];
        nameTitle.text = @"当前账号:";
        [self.contentView addSubview:nameTitle];
        
        UILabel * sizeTitle = [[UILabel alloc] initWithFrame:CGRectMake(18, 50 + offset, 80, 20)];
        [self setTitleLabel:sizeTitle];
        sizeTitle.text = @"空间容量:";
        [self.contentView addSubview:sizeTitle];
        
        userAccount = [[UILabel alloc] initWithFrame:CGRectMake(105, 20 + offset, 190, 20)];
        [self setUserNameLabel];
        [self.contentView addSubview:userAccount];
        sizeOfCloundDisk  = [[UILabel alloc] initWithFrame:CGRectMake(105, 50 + offset, 190, 20)];
        [self.contentView addSubview:sizeOfCloundDisk];
        [self setSizeLabel];
        progessView = [[UIProgressView alloc]initWithFrame:CGRectMake(18, 80 + offset, 280, 8)];
        [self setProgeressView];
        [self.contentView addSubview:progessView];
    }
    return self;
}
- (void)setTitleLabel:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:123.f/255 green:123.f/255 blue:123.f/255 alpha:1.f];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = UITextAlignmentLeft;
}
- (void)setUserNameLabel
{
    userAccount.backgroundColor = [UIColor clearColor];
    userAccount.textColor = [UIColor colorWithRed:125.f/255 green:125.f/255 blue:125.f/255 alpha:1.f];
    userAccount.font = [UIFont systemFontOfSize:15];
    userAccount.textAlignment = UITextAlignmentLeft;
}
- (void)setSizeLabel
{
    sizeOfCloundDisk.backgroundColor = [UIColor clearColor];
    sizeOfCloundDisk.textColor = [UIColor colorWithRed:151.f/255 green:151.f/255 blue:151.f/255 alpha:1.f];
    sizeOfCloundDisk.font = [UIFont systemFontOfSize:15];
    sizeOfCloundDisk.textAlignment = UITextAlignmentLeft;
}
- (void)setProgeressView
{
    [progessView setTrackImage:[[UIImage imageNamed:@"SizeProgressTrack.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)]];
    [progessView setProgressImage:[[UIImage imageNamed:@"SizeProgress.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)]];
}
- (UIView *)getSectionViewWithTitle:(NSString *)title
{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 320, 25)];
    view.backgroundColor = [UIColor clearColor];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 300, 23)];
    label.textAlignment = UITextAlignmentLeft;
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:126.f/255 green:184.f/255 blue:255.f alpha:1];
    [view addSubview:label];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 23, 320, 2)];
    [imageView setImage:[UIImage imageNamed:@"settingBlueLine.png"]];
    [view addSubview:imageView];
    return view;
}
#pragma mark - updata
- (void)setDataSource:(UserInfoCellDataSource *)dataSource
{
    if (dataSource != _dataSource) {
        _dataSource = dataSource;
        [self updataSubViews];
    }
}
- (void)updataSubViews
{
    userAccount.text  = _dataSource.userName;
    sizeOfCloundDisk.text  = [NSString stringWithFormat:@"已用%.2fG/总容量:%.2fG",_dataSource.sizeOfUsed/(1024.f * 1024 * 1024),_dataSource.sizeOfAll/(1024.f * 1024 * 1024)];
    progessView.progress = _dataSource.sizeOfUsed / _dataSource.sizeOfAll;
//    progessView.progress = 0.5f;
    
}
@end
