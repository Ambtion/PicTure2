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
#import "UMAppKey.h"

@implementation AppDelegate
@synthesize window = _window;
@synthesize assetsLibrary;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //主视图
    LocalALLPhotoesController * lp = [[LocalALLPhotoesController alloc] init];
    //左菜单
    LeftMenuController *leftVC = [[LeftMenuController alloc] init];
    leftVC.localAllController = lp;
    
    IIViewDeckController * deckViewController = [[IIViewDeckController alloc] initWithCenterViewController:leftVC.localAllController leftViewController:leftVC];
    
    deckViewController.navigationControllerBehavior = IIViewDeckNavigationControllerIntegrated;
    deckViewController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    
    UINavigationController * nav =[[UINavigationController alloc] initWithRootViewController:deckViewController];
    //    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbarnoline.png"] forBarMetrics:UIBarMetricsDefault];
    nav.delegate = self;
    self.window.rootViewController = nav;
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    [self.window makeKeyAndVisible];
    //INIT DATABASE
    [DataBaseManager defaultDataBaseManager];
    //umeng
    [MobClick startWithAppkey:UM_APP_KEY];
    //    [[UIApplication sharedApplication]  registerForRemoteNotificationTypes:
    //     (UIRemoteNotificationTypeAlert |
    //      UIRemoteNotificationTypeBadge |
    //      UIRemoteNotificationTypeSound)];
//    NSDictionary * dic = [[NSBundle mainBundle] infoDictionary];
//    NSString *bundleId = [dic  objectForKey: @"CFBundleIdentifier"];
//    NSUserDefaults *appUserDefaults = [[NSUserDefaults alloc] init];
//    NSDictionary * cacheDic = [appUserDefaults persistentDomainForName: bundleId];
//    DLog(@"cacheDic::%@",cacheDic);
    return YES;
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController.navigationItem setHidesBackButton:YES];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController.navigationItem setHidesBackButton:YES];
}

#pragma mark notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
    //                                                    message:notification.alertBody
    //                                                   delegate:nil
    //                                          cancelButtonTitle:@"确定"
    //                                          otherButtonTitles:nil];
    //    [alert show];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:-1];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * token = [NSString stringWithFormat:@"%@",deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    DLog(@"token:%@",token);
    [LoginStateManager storeDeviceToken:token];
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *str = [NSString stringWithFormat: @"Error: %@", error];
    DLog(@"%@",str);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary  *)userInfo {
    
    //    NSLog(@"%@",[userInfo allKeys]);
    //    NSLog(@"%@",userInfo);
    //    UIAlertView * alterview = [[UIAlertView alloc] initWithTitle:@"通知" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"详细", nil];
    //    [alterview show];
    //    application.applicationIconBadgeNumber -= 1;
}

@end
