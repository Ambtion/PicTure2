//
//  LocalPhotoesController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoAlbumCell.h"

@interface LocalAlbumsController : UIViewController<UITableViewDelegate,UITableViewDataSource,PhotoAlbumCellDelegate>
{
    ALAssetsLibrary *_library;
    UITableView * _myTableView;
    BOOL _isReading; //for app bacome background
}
@end
