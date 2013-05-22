//
//  ImageViewAdaper.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-16.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "ImageViewAdaper.h"

@implementation NSMutableArray (AddWithType_and_Random)

- (void)addRect:(CGRect)rect
{
    [self addObject:[NSValue valueWithCGRect:rect]];
}
@end

//边线为5, 中间线为3


static CGFloat strategy1(NSMutableArray *frames)
{
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetY, KWallWidth - 2 * KWallOffsetX, 200)];
    
    return 200 + KWallOffsetY ;
}

static CGFloat strategy2(NSMutableArray * frames)
{
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetY, 208, 208)];
    
    [frames addRect:CGRectMake(KWallOffsetX + 208 + KWallOffSet, KWallOffsetY, KWallWidth - (KWallOffsetX + 208 + KWallOffSet) - KWallOffsetX, 208)];
        
    return 208 + KWallOffsetY;
}

static CGFloat strategy3(NSMutableArray *frames)
{
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetY, 208, 208)];
    
    CGFloat heigth =  (208 - KWallOffSet)/2.f;
    
    [frames addRect:CGRectMake(208 + KWallOffsetX + KWallOffSet, KWallOffsetY,
                                KWallWidth - (208 + KWallOffsetX + KWallOffSet) - KWallOffsetX, heigth)];
    
    [frames addRect:CGRectMake(208 + KWallOffsetX + KWallOffSet, KWallOffsetY + heigth + KWallOffSet,
                               KWallWidth - (208 + KWallOffsetX + KWallOffSet) - KWallOffsetX, heigth)];
    
    return KWallOffsetY + 208;
}

static CGFloat strategy4(NSMutableArray *frames)
{
    
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetY, 208, 208)];
    
    [frames addRect:CGRectMake(KWallOffsetX + 208 + KWallOffSet, KWallOffsetY, KWallWidth - (KWallOffsetX + 208 + KWallOffSet) - KWallOffsetX, 208)];
    
    CGFloat originalY =  KWallOffsetY + 208 + KWallOffSet;
    CGFloat heigth  = KWallWidth - (KWallOffsetX + 208 + KWallOffSet) - KWallOffsetX;
    
    [frames addRect:CGRectMake(KWallOffsetX,originalY,
                                208, heigth)];
    
    [frames addRect:CGRectMake(KWallOffsetX + 208 + KWallOffSet, originalY , heigth, heigth)];
    
    return KWallOffsetY + 208 + KWallOffSet + heigth;
}

static CGFloat strategy5(NSMutableArray *frames)
{
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetY, 208, 208)];
    
    [frames addRect:CGRectMake(KWallOffsetX + 208 + KWallOffSet, KWallOffsetY, KWallWidth - (KWallOffsetX + 208 + KWallOffSet) - KWallOffsetX, 208)];

    
    CGFloat originalY = 208 + KWallOffsetY + KWallOffSet;
    CGFloat heigth = KWallWidth - (KWallOffsetX + 208 + KWallOffSet) - KWallOffsetX;
    CGFloat wight = 0.f;
    CGFloat wight_fix = 0.f;
    if ((208 - KWallOffSet) % 2) {
        wight_fix = 1.f;
        wight = (208 - KWallOffSet - wight_fix)/2.f;
    }else{
        wight = (208 - KWallOffSet)/2.f;
    }

    [frames addRect:CGRectMake(KWallOffsetX, originalY, wight, heigth)];
    
    [frames addRect:CGRectMake(KWallOffsetX + wight + KWallOffSet, originalY, wight_fix + wight, heigth)];
    
    
    [frames addRect:CGRectMake(KWallOffsetX + 208 + KWallOffSet, originalY, heigth, heigth)];

    return  KWallOffsetY + 208 + KWallOffSet + heigth;
}

static CGFloat strategy6(NSMutableArray *frames)
{
    
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetY, 208, 208)];
    
    CGFloat heigth =  (208 - KWallOffSet)/2.f;
    [frames addRect:CGRectMake(208 + KWallOffsetX + KWallOffSet, KWallOffsetY,
                               KWallWidth - (208 + KWallOffsetX + KWallOffSet) - KWallOffsetX, heigth)];
    
    [frames addRect:CGRectMake(208 + KWallOffsetX + KWallOffSet, KWallOffsetY + heigth + KWallOffSet,
                               KWallWidth - (208 + KWallOffsetX + KWallOffSet) - KWallOffsetX, heigth)];
    
    
    CGFloat originalY = 208 + KWallOffsetY + KWallOffSet;
    heigth = KWallWidth - (KWallOffsetX + 208 + KWallOffSet) - KWallOffsetX;
    CGFloat wight = 0.f;
    CGFloat wight_fix = 0.f;
    if ((208 - KWallOffSet) % 2) {
        wight_fix = 1.f;
        wight = (208 - KWallOffSet - wight_fix)/2.f;
    }else{
        wight = (208 - KWallOffSet)/2.f;
    }
    
    [frames addRect:CGRectMake(KWallOffsetX, originalY, wight, heigth)];
    
    [frames addRect:CGRectMake(KWallOffsetX + wight + KWallOffSet, originalY, wight + wight_fix, heigth)];
    
    [frames addRect:CGRectMake(KWallOffsetX + 208 + KWallOffSet, originalY, heigth, heigth)];
    
    return KWallOffsetY + 208 + KWallOffSet + heigth;
    
}

typedef CGFloat (* strageyPoint)(NSMutableArray *);
static strageyPoint stategye(uint strategynum)
{
    switch (strategynum) {
        case 1:
            return strategy1;
            break;
        case 2:
            return strategy2;
            break;
        case 3:
            return strategy3;
            break;
        case 4:
            return strategy4;
            break;
        case 5:
            return strategy5;
            break;
        case 6:
            return strategy6;
            break;
        default:
            break;
    }
    return NULL;
}

@implementation ImageViewAdaper
+ (CGFloat)setFramesinToArray:(NSMutableArray *)framesArray byImageCount:(NSInteger)number
{
    strageyPoint point = stategye(number);
    return point(framesArray);
}
@end
