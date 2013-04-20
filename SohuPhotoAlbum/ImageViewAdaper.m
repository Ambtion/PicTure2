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

static CGFloat strategy1(NSMutableArray *frames)
{
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetX, KWallWidth - KWallOffsetX, 200)];
    
    return 208;
}

static CGFloat strategy2(NSMutableArray * frames)
{
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetX, 200, 200)];
    
    [frames addRect:CGRectMake(210, KWallOffsetX, KWallWidth - 210, 200)];
        
    return 208;
}

static CGFloat strategy3(NSMutableArray *frames)
{
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetX, 202, 202)];
    
    [frames addRect:CGRectMake(212, KWallOffsetX, 100, 100)];
    
    [frames addRect:CGRectMake(212, 110, 100, 100)];
    
    return 210;
}

static CGFloat strategy4(NSMutableArray *frames)
{
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetX, 202, 202)];
    
    [frames addRect:CGRectMake(212, KWallOffsetX, 100, 202)];
    
    [frames addRect:CGRectMake(KWallOffsetX, 212, 202, 100)];
    
    [frames addRect:CGRectMake(212, 212, 100, 100)];
    
    return 312;
}

static CGFloat strategy5(NSMutableArray *frames)
{
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetX, 202, 202)];
    
    [frames addRect:CGRectMake(212, KWallOffsetX, 100, 202)];
    
    [frames addRect:CGRectMake(KWallOffsetX, 212, 100, 100)];
    
    [frames addRect:CGRectMake(110, 212, 100, 100)];
    
    [frames addRect:CGRectMake(212, 212, 100, 100)];;

    
    return 312;
}

static CGFloat strategy6(NSMutableArray *frames)
{
    [frames addRect:CGRectMake(KWallOffsetX, KWallOffsetX, 202, 202)];
    
    [frames addRect:CGRectMake(212, 8, 100, 100)];
    
    [frames addRect:CGRectMake(212, 110, 100, 100)];
    
    [frames addRect:CGRectMake(KWallOffsetX, 212, 100, 100)];
    
    [frames addRect:CGRectMake(110, 212, 100, 100)];
    
    [frames addRect:CGRectMake(212, 212, 100, 100)];;
    
    return 312;
    
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
