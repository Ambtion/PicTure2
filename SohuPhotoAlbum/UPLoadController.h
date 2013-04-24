//
//  UPLoadViewController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-12.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UPLoadController;
@protocol UPLoadControllerDelegate <NSObject>
- (void)upLoadController:(UPLoadController *)upload didclickContinue:(id)sender;
@end
@interface UPLoadController : UIViewController
{
    UILabel * _waitNum;
    UILabel * _uploadNum;
    UIProgressView * _progressView;
}
@property(weak,nonatomic)id<UPLoadControllerDelegate> delegate;
@end
