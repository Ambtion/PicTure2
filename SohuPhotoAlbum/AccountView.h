//
//  AcountView.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-15.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountView;
@protocol AccountViewDelegate <NSObject>
- (void)accountView:(AccountView *)acountView accessoryClick:(id)sender;
- (void)accountView:(AccountView *)acountView setttingClick:(id)sender;
@end
@interface AccountView : UIImageView<UIGestureRecognizerDelegate>
{
    UIImageView * accessory;
    UIImageView * setting;
}

@property(strong, nonatomic)UIImageView * portraitImageView;
@property(strong, nonatomic)UILabel * desLabel;
@property(strong, nonatomic)UILabel * nameLabel;
@property(weak, nonatomic)id<AccountViewDelegate> delegate;
@end
