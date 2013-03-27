//
//  PhotoesViewController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoesCell.h"

@interface AlbumPhotoesController : UIViewController<UITableViewDelegate,UITableViewDataSource,PhotoesCellDelegate>
{
    ALAssetsGroup * _assetGroup;
    UITableView * _myTableView;
}
@property(nonatomic,retain)ALAssetsGroup * assetGroup;

- (id)initWithAssetGroup:(ALAssetsGroup *)AnAssetGroup;
@end
