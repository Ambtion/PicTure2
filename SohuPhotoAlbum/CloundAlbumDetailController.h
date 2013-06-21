//
//  CloudAlbumDetailController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-6-19.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloundDetailController.h"

/*这个继承手机备份最终页,重载去掉加载更多的逻辑*/
@interface CloundAlbumDetailController : CloundDetailController
{
    NSString * _folderId;
}
- (id)initWithAssetsArray:(NSArray *)array andCurAsset:(NSDictionary *)asset folderId:(NSString *)folderID;
@end
