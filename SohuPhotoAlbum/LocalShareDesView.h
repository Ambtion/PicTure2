//
//  ShareDescriptionView.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-15.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitView.h"

typedef enum _DesshareModel{
    QQModel,
    RenrenModel,
    SinaModel
}DesViewShareModel;
@class LocalShareDesView;
@protocol LocalShareDesViewDelegate <NSObject>
- (void)localShareDesView:(LocalShareDesView *)view shareTo:(DesViewShareModel)model withDes:(NSString *)text;
@end
@interface LocalShareDesView : UIImageView<UITextViewDelegate>
{
    UIImageView * _thumbNailView;
    DesViewShareModel  _model;
    UIButton * _shareButton;
    UIImageView * _contentView;
    UITextView * _contentTextView;
    UILabel * _textcount;
    PortraitView * _porTraitView;
}
@property(weak,nonatomic) id<LocalShareDesViewDelegate> delegate;
- (id)initWithModel:(DesViewShareModel )model thumbnail:(UIImage *)thumbnail andDelegate:(id<LocalShareDesViewDelegate>)Adelegete;
@end
