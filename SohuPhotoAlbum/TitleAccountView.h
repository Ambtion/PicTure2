//
//  TitileAccountView.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitView.h"

@interface TitleAccountView : UIImageView

@property(strong, nonatomic)NSString * userId;
@property(strong, nonatomic)PortraitView * portraitImageView;
@property(strong, nonatomic)UILabel * sname;
@property(strong, nonatomic)UILabel * nameLabel;
- (void)refreshUserInfo;
@end
