//
//  LimitCacheForImage.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-7.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LimitCacheForImage : NSObject
- (id)init;
- (id)objectForKey:(id)aKey;
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;
@end
