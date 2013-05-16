//
//  Projectconfig.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-11.
//  Copyright (c) 2013年 Qu. All rights reserved.
//


//#define DEBUG 1

#ifndef PROJECTCONFIG
#define PROJECTCONFIG

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

//#define CLog(fmt,...) NSLog((fmt),##__VA_ARGS__)
#endif

#define LOCALBACKGORUNDCOLOR [UIColor colorWithRed:255.f/255 green:255.f/255 blue:255.f/255 alpha:1.f]
#define BASEWALLCOLOR [UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1.f]

#import "IIViewDeckController.h"
//alert
#import "NSObject+extension.h"

#import<AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+Read.h"

// account
#import "LoginStateManager.h"
#import "LoginViewController.h"
#import "UploadTaskManager.h"

//share
typedef enum __shareModel {
    SinaWeiboShare,
    RenrenShare,
    WeixinShare,
    QQShare,
    NoShare
}shareModel;
