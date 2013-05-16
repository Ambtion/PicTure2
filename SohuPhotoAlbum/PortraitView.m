//
//  PortraitView.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-18.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "PortraitView.h"

@implementation PortraitView
@synthesize imageView;
- (void)dealloc
{
    [self.imageView removeObserver:self forKeyPath:@"image"];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        self.backgroundColor = [UIColor clearColor];
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIView * lineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 1, self.bounds.size.width, 1.f)];
        lineView.backgroundColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:.2f];
        [self addSubview:imageView];
        [self addSubview:lineView];
        [imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew  context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.imageView.image) return;
    CGSize size = [self getRectofProtrait:self.imageView.image];
    self.imageView.frame = CGRectMake(0, 0, size.width, size.height);
    self.imageView.center = CGPointMake(self.frame.size.width /2.f, self.frame.size.height /2.f);
}
- (CGSize)getRectofProtrait:(UIImage *)image
{
    CGFloat width = self.frame.size.width;
    CGSize size = image.size;
    CGFloat scale = 1.f;
    if (size.width < width || size.height < width) {
        scale  = MAX(width / size.width, width / size.height);
        size.width *= scale;
        size.height *= scale;
    }else{
        scale = MIN(size.width / width, size.height / width);
        size.width /= scale;
        size.height /= scale;
    }
    return size;
}
@end
