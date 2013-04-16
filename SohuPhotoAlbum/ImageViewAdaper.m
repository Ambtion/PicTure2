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
    [frames addRect:CGRectMake(5, 0, 310, 200)];
    
    return 200;
}

static CGFloat strategy2(NSMutableArray * frames)
{
    [frames addRect:CGRectMake(5, 0, 200, 200)];
    
    [frames addRect:CGRectMake(210, 0, 105, 200)];
        
    return 200;
}

static CGFloat strategy3(NSMutableArray *frames)
{
    [frames addRect:CGRectMake(5, 0, 200, 205)];
    
    [frames addRect:CGRectMake(215, 0, 100, 100)];
    
    [frames addRect:CGRectMake(215, 105, 100, 100)];
    
    return 205;
}

static CGFloat strategy4(NSMutableArray *frames)
{
    [frames addRect:CGRectMake(5, 0, 200, 200)];
    
    [frames addRect:CGRectMake(210, 0, 105, 200)];
    
    [frames addRect:CGRectMake(5, 210, 200, 100)];
    
    [frames addRect:CGRectMake(210, 210, 100, 100)];
    
    return 310;
}

static CGFloat strategy5(NSMutableArray *frames)
{
    [frames addRect:CGRectMake(5, 0, 200, 200)];
    
    [frames addRect:CGRectMake(210, 0, 105, 200)];
    
    [frames addRect:CGRectMake(5, 210, 100, 100)];
    
    [frames addRect:CGRectMake(110, 210, 100, 100)];
    
    [frames addRect:CGRectMake(215, 210, 100, 100)];
    
    return 310;
}

static CGFloat strategy6(NSMutableArray *frames)
{
    [frames addRect:CGRectMake(5, 0, 200, 200)];
    
    [frames addRect:CGRectMake(210, 0, 105, 100)];
    
    [frames addRect:CGRectMake(210, 105, 105, 100)];
    
    [frames addRect:CGRectMake(5, 210, 100, 100)];
    
    [frames addRect:CGRectMake(110, 210, 100, 100)];
    
    [frames addRect:CGRectMake(215, 210, 100, 100)];;
    
    return 310;
    
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
