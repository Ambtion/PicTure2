//
//  FolderImageView.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-6-18.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderImageView : UIView
{
    UIImageView * _bgImageView;
    UIImageView * _statuImage;
    UIImageView * _actualView;
    BOOL    _isNomalState;
}
@property(nonatomic,strong)UIImageView * actualView;
@property(nonatomic,assign)BOOL isNomalState;
@property(nonatomic,assign)BOOL isSelected;
@end

