//
//  PhotoesViewController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoesCell.h"
#import "LocalBaseController.h"

@interface AlbumPhotoesController : LocalBaseController<UITableViewDelegate,UITableViewDataSource,PhotoesCellDelegate>
{
    ALAssetsGroup * _assetGroup;
    UITableView * _myTableView;
    ALAssetsLibrary * _libiary;
    BOOL _isInitUpload;
    BOOL _isReading;
}
@property(nonatomic,retain)ALAssetsGroup * assetGroup;

- (id)initWithAssetGroup:(ALAssetsGroup *)AnAssetGroup andViewState:(viewState)state;
@end
