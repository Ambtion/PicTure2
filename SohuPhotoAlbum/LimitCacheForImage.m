//
//  LimitCacheForImage.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-7.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "LimitCacheForImage.h"
#import <mach/mach.h>
#import <mach/mach_host.h>

static natural_t minFreeMemLeft = 1024 * 1024 * 12; // reserve 12MB RAM

static natural_t get_free_memory(void)
{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
    {
        DLog(@"Failed to fetch vm statistics");
        return 0;
    }
    
    /* Stats in bytes */
    natural_t mem_free = vm_stat.free_count * pagesize;
    return mem_free;
}
@interface LimitCacheForImage()
@property(nonatomic,retain)NSMutableDictionary * cacheContainer;
@end

@implementation LimitCacheForImage
@synthesize cacheContainer;
- (void)dealloc
{
    [cacheContainer release];
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self) {
        cacheContainer = [[NSMutableDictionary dictionaryWithCapacity:0] retain];
    }
    return self;
}
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (get_free_memory() < minFreeMemLeft)
    {
        [cacheContainer removeAllObjects];
    }
    [cacheContainer setObject:anObject forKey:aKey];
}
- (id)objectForKey:(id)aKey
{
    return [cacheContainer objectForKey:aKey];
}
- (void)clear
{
    if ([cacheContainer allKeys].count)
        [cacheContainer removeAllObjects];
}
@end
