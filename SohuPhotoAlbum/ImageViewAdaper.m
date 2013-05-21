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
    
    [frames addRect:CGRectMake(KWallOffsetX + 208 + 3, KWallOffsetY, KWallWidth - (KWallOffsetX + 208 + 3) - KWallOffsetX, 208)];
        
    return 208 + KWallOffsetY;
}

static CGFloat strategy3(NSMutableArray *frames)
{
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetY, 208, 208)];
    
    [frames addRect:CGRectMake(208 + KWallOffsetX + 3, KWallOffsetY, 99, 103)];
    
    [frames addRect:CGRectMake(208 + KWallOffsetX + 3, KWallOffsetY + 103 + 2, 99, 103)];
    
    return KWallOffsetY + 200 + 2;
}

static CGFloat strategy4(NSMutableArray *frames)
{
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetY, 208, 208)];
    
    [frames addRect:CGRectMake(KWallOffsetX + 208 + 3, KWallOffsetY, KWallWidth - (KWallOffsetX + 208 + 3) - KWallOffsetX, 208)];
    
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetY + 208 + 3, 208, 100)];
    
    [frames addRect:CGRectMake(KWallOffsetX + 208 + 3, KWallOffsetY + 208 + 3, KWallWidth - (KWallOffsetX + 208 + 3) - KWallOffsetX, 100)];
    
    return KWallOffsetY + 208 + 3 + 100;
}

static CGFloat strategy5(NSMutableArray *frames)
{
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetY, 208, 208)];
    
    [frames addRect:CGRectMake(KWallOffsetX + 208 + 3, KWallOffsetY, KWallWidth - (KWallOffsetX + 208 + 3) - KWallOffsetX, 208)];

    
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetY + 208 + 3, 102, 100)];
    
    [frames addRect:CGRectMake(KWallOffsetX + 105, KWallOffsetY + 208 + 3, 103, 100)];
    
    [frames addRect:CGRectMake(KWallOffsetX + 208 + 3, KWallOffsetY + 208 + 3, KWallWidth - (KWallOffsetX + 208 + 3) - KWallOffsetX, 100)];

    return  KWallOffsetY + 208 + 3 + 100;
}

static CGFloat strategy6(NSMutableArray *frames)
{
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetY, 208, 208)];
    
    [frames addRect:CGRectMake(208 + KWallOffsetX + 3, KWallOffsetY, 99, 103)];
    
    [frames addRect:CGRectMake(208 + KWallOffsetX + 3, KWallOffsetY + 103 + 2, 99, 103)];
    
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetY + 208 + 3, 102, 100)];
    
    [frames addRect:CGRectMake(KWallOffsetX + 105, KWallOffsetY + 208 + 3, 103, 100)];
    
    [frames addRect:CGRectMake(KWallOffsetX + 208 + 3, KWallOffsetY + 208 + 3, KWallWidth - (KWallOffsetX + 208 + 3) - KWallOffsetX, 100)];
    
    return KWallOffsetY + 208 + 3 + 100;
    
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
