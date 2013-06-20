//
//  LocalPhotoesController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAlbumCell.h"
#import "LocalBaseController.h"
#import "CQSegmentControl.h"

@interface LocalAlbumsController : LocalBaseController<UITableViewDelegate,UITableViewDataSource,PhotoAlbumCellDelegate>
{
    CQSegmentControl  * segControll;
    BOOL _isReading; //for app bacome background
    BOOL needReadonce;
}
@end
