//
//  UserInfoCell.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-22.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoCellDataSource : NSObject
@property(strong,nonatomic)NSString * userName;
@property(assign,nonatomic)CGFloat sizeOfAll;
@property(assign,nonatomic)CGFloat sizeOfUsed;
@end

@interface UserInfoCell : UITableViewCell
{
    UILabel * userAccount;
    UILabel * sizeOfCloundDisk;
    UIProgressView * progessView;
    UserInfoCellDataSource * _dataSource;
}
@property(strong,nonatomic)UserInfoCellDataSource * dataSource;
@end
