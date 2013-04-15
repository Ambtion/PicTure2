//
//  ShareBaseController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-1.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalBaseController.h"


#define kSinaTag    1000
#define kRenrenTag  1001
#define kWeixinTag 1002
#define kQQTag      1003

@interface AccountButton : UIButton

@property(nonatomic,strong)UILabel * labelText;
@end
@interface ShareBaseController : LocalBaseController

@property(nonatomic,strong)AccountButton * sinaAcountBtn;
@property(nonatomic,strong)AccountButton * renrenAcountBtn;
@property(nonatomic,strong)AccountButton * weixinAcountBtn;
@property(nonatomic,strong)AccountButton * qqAcountBtn;
@property(nonatomic,strong)ALAsset * uploadAsset;

- (id)initWithUpLoadAsset:(ALAsset *)aseet;
@end
