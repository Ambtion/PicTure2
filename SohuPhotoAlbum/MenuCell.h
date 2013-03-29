//
//  MenuCell.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-28.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell
{
    UIImageView * _myHigtView;
}
@property(nonatomic,retain)UIImageView * leftImage;
@property(nonatomic,retain)UILabel * labelText;

@end
