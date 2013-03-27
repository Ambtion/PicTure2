//
//  LocalPhotoseController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegate.h"
#import "PhotoesCell.h"

@interface LocalPhotoesController : UIViewController<UITableViewDataSource,UITableViewDelegate,PhotoesCellDelegate>
{
    ALAssetsLibrary *_library;
    UITableView * _myTableView;
    BOOL _isReading; //for app bacome background
}
@end
