//
//  HostUserCell.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-23.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "HostUserCell.h"

@implementation HostUserCellDataSource
@synthesize portrait,userName,accountName;
@end

@implementation HostUserCell
@synthesize dataSource = _dataSource;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        _portraitView = [[PortraitView alloc] initWithFrame:CGRectMake(10, 5, 42, 42)];
        _portraitView.layer.cornerRadius = 21.f;
//        _portraitView.layer.borderColor = [[UIColor colorWithRed:217.f/255 green:217.f/255 blue:217.f/255 alpha:1.f] CGColor];
//        _portraitView.layer.borderWidth = 1.f;
        [self.contentView addSubview:_portraitView];
        _userName = [[UILabel alloc] initWithFrame:CGRectMake(63, 10, 200, 18)];
        [self  setUserNameLabel];
        [self.contentView addSubview:_userName];
        _accounName = [[UILabel alloc] initWithFrame:CGRectMake(63, 30, 200, 16)];
        [self  setAcountNameLabel];
        [self.contentView addSubview:_accounName];
    }
    return self;
}

- (void)setUserNameLabel
{
    _userName.backgroundColor = [UIColor clearColor];
    _userName.textColor = [UIColor colorWithRed:125.f/255 green:125.f/255 blue:125.f/255 alpha:1.f];
    _userName.font = [UIFont boldSystemFontOfSize:15];
    _userName.textAlignment = UITextAlignmentLeft;
}
- (void)setAcountNameLabel
{
    _accounName.backgroundColor = [UIColor clearColor];
    _accounName.textColor = [UIColor colorWithRed:151.f/255 green:151.f/255 blue:151.f/255 alpha:1.f];
    _accounName.font = [UIFont systemFontOfSize:14];
    _accounName.textAlignment = UITextAlignmentLeft;
}

#pragma mark dataSource
- (void)setDataSource:(HostUserCellDataSource *)dataSource
{
    if (dataSource != _dataSource) {
        _dataSource = dataSource;
        [self updataViews];
    }
}
- (void)updataViews
{
    _portraitView.imageView.image = [UIImage imageNamed:_dataSource.portrait];
    _userName.text  = _dataSource.userName;
    _accounName.text = _dataSource.accountName;
}
@end
