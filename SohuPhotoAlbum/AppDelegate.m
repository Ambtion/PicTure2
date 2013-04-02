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
//    [application setStatusBarHidden:YES];
    LocalALLPhotoesController * lp = [[[LocalALLPhotoesController alloc] init] autorelease];
    UINavigationController *navApiVC = [[[UINavigationController alloc] initWithRootViewController:lp] autorelease];
    [navApiVC.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBarBG.png"] forBarMetrics:UIBarMetricsDefault];
    //左菜单
    LeftMenuController *leftVC = [[[LeftMenuController alloc] init] autorelease];
    IIViewDeckController *vc = [[[IIViewDeckController alloc] initWithCenterViewController:navApiVC leftViewController:leftVC] autorelease];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    //INIT DATABASE
    [DataBaseManager defaultDataBaseManager];
//    [application setStatusBarHidden:NO];
    return YES;
}






@end
