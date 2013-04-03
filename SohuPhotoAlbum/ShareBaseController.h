//
//  ShareBaseController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-1.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CusTomerBarController.h"


#define kSinaTag    1000
#define kRenrenTag  1001
#define kWeixinTag 1002
#define kQQTag      1003

@interface AccountButton : UIButton

@property(nonatomic,retain)UILabel * labelText;
@end
@interface ShareBaseController : CusTomerBarController

@property(nonatomic,retain)AccountButton * sinaAcountBtn;
@property(nonatomic,retain)AccountButton * renrenAcountBtn;
@property(nonatomic,retain)AccountButton * weixinAcountBtn;
@property(nonatomic,retain)AccountButton * qqAcountBtn;
@property(nonatomic,retain)ALAsset * uploadAsset;

- (id)initWithUpLoadAsset:(ALAsset *)aseet;
@end
