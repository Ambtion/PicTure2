//
//  ImageViewAdaper.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <Foundation/Foundation.h>
#define     KWallOffsetX    5
#define     KWallOffsetY    5
#define     KWallWidth      320
#define     KWallOffSet     1

@interface ImageViewAdaper : NSObject

+ (CGFloat)setFramesinToArray:(NSMutableArray *)framesArray byImageCount:(NSInteger)number;

@end
