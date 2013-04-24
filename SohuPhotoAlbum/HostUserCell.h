//
//  HostUserCell.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-23.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitView.h"


@interface HostUserCellDataSource : NSObject
@property(strong,nonatomic)NSString * portrait;
@property(strong,nonatomic)NSString * userName;
@property(strong,nonatomic)NSString * accountName;
@end
@interface HostUserCell : UITableViewCell
{
    PortraitView * _portraitView;
    UILabel * _userName;
    UILabel * _accounName;
    HostUserCellDataSource * _dataSource;
}
@property(strong,nonatomic)HostUserCellDataSource * dataSource;
@end
