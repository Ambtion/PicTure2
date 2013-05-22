//
//  AppDelegate.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegateOauthor.h"
#import "IIViewDeckController.h"

@class LocalShareController;
@interface AppDelegate : AppDelegateOauthor<UIApplicationDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) ALAssetsLibrary * assetsLibrary;
@property (strong, nonatomic) UIWindow *window;

@end
