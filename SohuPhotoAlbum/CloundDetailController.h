//
//  CloundDetailController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoDetailBaseController.h"

@interface CloundDetailController : PhotoDetailBaseController
{
    BOOL _isLoading;
}
- (id)initWithAssetsArray:(NSArray *)array andCurAsset:(NSDictionary *)asset;
@end
