//
//  AppDelegate.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-3-25.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftMenuController.h"
#import "LocalAlbumsController.h"
#import "LocalALLPhotoesController.h"
#import "DataBaseManager.h"
#import "Projectconfig.h"
#import "UploadTaskManager.h"

@implementation AppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //主视图
    LocalALLPhotoesController * lp = [[LocalALLPhotoesController alloc] init];

    //左菜单
    LeftMenuController *leftVC = [[LeftMenuController alloc] init];
    
    IIViewDeckController *deckViewController = [[IIViewDeckController alloc] initWithCenterViewController:lp leftViewController:leftVC];
    deckViewController.navigationControllerBehavior = IIViewDeckNavigationControllerIntegrated;
    deckViewController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    
    UINavigationController * nav =[[UINavigationController alloc] initWithRootViewController:deckViewController];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    //INIT DATABASE
    [DataBaseManager defaultDataBaseManager];
    return YES;
}

@end
