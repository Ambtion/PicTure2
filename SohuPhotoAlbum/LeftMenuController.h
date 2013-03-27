//
//  LeftMenuController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
}
@end
