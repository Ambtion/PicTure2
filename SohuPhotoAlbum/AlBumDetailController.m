//
//  AlBumDetailController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "AlBumDetailController.h"
#import "RequestManager.h"

//#import <objc/runtime.h>
//
//void MethodSwizzle(Class c,SEL origSEL,SEL overrideSEL)
//{
//    DLog(@"");
//    Method origMethod = class_getInstanceMethod(c, origSEL);
//    Method overrideMethod= class_getInstanceMethod(c, overrideSEL);
//
//    if(class_addMethod(c, origSEL, method_getImplementation(overrideMethod),method_getTypeEncoding(overrideMethod)))
//    {
//        class_replaceMethod(c,overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
//    }else{
//        method_exchangeImplementations(origMethod,overrideMethod);
//    }
//}
//@implementation CloundDetailController(Private)
//- (void)getNullLess
//{
//    DLog(@"lllll");
//}
//- (void)getNullMore
//{
//    DLog(@"lllll");
//}
//@end

@implementation AlBumDetailController
@synthesize ownerId,storyID;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //fix tabBar
    [self.tabBar.deleteButton setHidden:YES];
}

- (void)getMoreAssetsAfterCurNum
{
    if (self.assetsArray.count % 20 || self.isLoading)  return;
    self.isLoading = YES;
    [RequestManager getAllPhototInStoryWithOwnerId:self.ownerId stroyId:self.storyID start:[self.assetsArray count] count:20 success:^(NSString *response) {
//        DLog(@"%d ::%@",[[self assetsArray] count],[response JSONValue]);
        [self.assetsArray addObjectsFromArray:[[response JSONValue] objectForKey:@"photos"]];
        self.isLoading = NO;
    } failure:^(NSString *error) {
        self.isLoading = NO;
    }];
}
- (void)getMoreAssetsBeforeCurNum
{
    return;
}
@end
