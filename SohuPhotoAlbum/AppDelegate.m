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
//#import "BaseNaviController.h"
#import "Projectconfig.h"

@implementation AppDelegate
@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    //主视图
    LocalALLPhotoesController * lp = [[[LocalALLPhotoesController alloc] init] autorelease];

    //左菜单
    LeftMenuController *leftVC = [[[LeftMenuController alloc] init] autorelease];
    
    IIViewDeckController *deckViewController = [[[IIViewDeckController alloc] initWithCenterViewController:lp leftViewController:leftVC] autorelease];
    deckViewController.navigationControllerBehavior = IIViewDeckNavigationControllerIntegrated;
    deckViewController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    
    UINavigationController * nav =[[[UINavigationController alloc] initWithRootViewController:deckViewController] autorelease];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    //INIT DATABASE
    [DataBaseManager defaultDataBaseManager];
//    [application setStatusBarHidden:NO];
    return YES;
}

@end
