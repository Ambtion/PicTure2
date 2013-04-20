//
//  CommentView.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-17.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CommentViewDataSource : NSObject
@property(strong,nonatomic)NSString * potraitImage;
@property(strong,nonatomic)NSString * userName;
@property(strong,nonatomic)NSString * shareTime;
@property(strong,nonatomic)NSString * comment;
- (CGFloat)commetViewheigth;
@end
@interface CommentView : UIView
{
    CommentViewDataSource * _dataScoure;
}
@property(strong,nonatomic)UIImageView * portraitView;
@property(strong,nonatomic)UILabel * userName;
@property(strong,nonatomic)UILabel * shareTime;
@property(strong,nonatomic)UILabel * commentLabel;
@property(strong,nonatomic)CommentViewDataSource * dataScoure;
- (void)addtarget:(id)target action:(SEL)action;

@end
