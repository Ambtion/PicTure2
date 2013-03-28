//
//  AccountCell.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-28.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCell : UITableViewCell
{
    UIImageView * _bgView;
    UILabel * _labelText;
}
@property(nonatomic,retain)UILabel * labelText;
@end
