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
//- (void) dumpCookies:(NSString *)msgOrNil
//{
//    NSMutableString *cookieDescs    = [[NSMutableString alloc] init];
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [cookieJar cookies]) {
//        [cookieDescs appendString:[self cookieDescription:cookie]];
//    }
//    NSLog(@"------ [Cookie Dump: %@] ---------\n%@", msgOrNil, cookieDescs);
//    NSLog(@"----------------------------------");
//}
//
//- (NSString *) cookieDescription:(NSHTTPCookie *)cookie {
//    
//    NSMutableString *cDesc      = [[NSMutableString alloc] init];
//    [cDesc appendString:@"[NSHTTPCookie]\n"];
//    [cDesc appendFormat:@"  name            = %@\n",            [[cookie name] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    [cDesc appendFormat:@"  value           = %@\n",            [[cookie value] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    [cDesc appendFormat:@"  domain          = %@\n",            [cookie domain]];
//    [cDesc appendFormat:@"  path            = %@\n",            [cookie path]];
//    [cDesc appendFormat:@"  expiresDate     = %@\n",            [cookie expiresDate]];
//    [cDesc appendFormat:@"  sessionOnly     = %d\n",            [cookie isSessionOnly]];
//    [cDesc appendFormat:@"  secure          = %d\n",            [cookie isSecure]];
//    [cDesc appendFormat:@"  comment         = %@\n",            [cookie comment]];
//    [cDesc appendFormat:@"  commentURL      = %@\n",            [cookie commentURL]];
//    [cDesc appendFormat:@"  version         = %d\n",            [cookie version]];
//    
//    //  [cDesc appendFormat:@"  portList        = %@\n",            [cookie portList]];
//    //  [cDesc appendFormat:@"  properties      = %@\n",            [cookie properties]];
//    
//    return cDesc;
//}
@end
