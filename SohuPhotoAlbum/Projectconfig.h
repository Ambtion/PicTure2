//
//  Projectconfig.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-11.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

//share
typedef enum __shareModel {
    SinaWeiboShare,
    RenrenShare,
    WeixinShare,
    QQShare,
    SohuShare,
    NoShare,
}KShareModel;

//本地/云端 . 图片 视图状态
typedef enum ViewState {
    NomalState  ,
    UPloadState ,
    ShareState,
    DeleteState
}viewState;

#import "IIViewDeckController.h"
//alert
#import "NSObject+extension.h"

#import<AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+Read.h"

// account
#import "LoginStateManager.h"
#import "LoginViewController.h"
#import "UploadTaskManager.h"

#define ___DEBUG 1

#ifndef PROJECTCONFIG
#define PROJECTCONFIG

#ifdef ___DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

#define LOCALBACKGORUNDCOLOR [UIColor colorWithRed:255.f/255 green:255.f/255 blue:255.f/255 alpha:1.f]
#define BASEWALLCOLOR [UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1.f]

#endif




