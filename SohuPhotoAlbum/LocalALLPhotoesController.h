//
//  LocalPhotoseController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoesCell.h"
#import "LocalBaseController.h"

@interface LocalALLPhotoesController : LocalBaseController<UITableViewDataSource,UITableViewDelegate,PhotoesCellDelegate,CusNavigationBarDelegate>
{
    ALAssetsLibrary *_library;
    BOOL _isReading; //for app bacome background
}
@end
