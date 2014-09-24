//
//  JVCAccountPredicateMaths.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAccountPredicateMaths.h"

@implementation JVCAccountPredicateMaths

static JVCAccountPredicateMaths *shareAccountPredicateMaths = nil;

/**
 *  单例
 *
 *  @return 返回单例对象
 */
+ (JVCAccountPredicateMaths *)shareAccontPredicateMaths
{
    @synchronized(self)
    {
        if (shareAccountPredicateMaths == nil) {
            
            shareAccountPredicateMaths = [[self alloc] init];
            
            return shareAccountPredicateMaths;
        }
        
        return shareAccountPredicateMaths;
    }
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareAccountPredicateMaths == nil) {
            
            shareAccountPredicateMaths = [super allocWithZone:zone];
            
            return shareAccountPredicateMaths;
        }
        
        return nil;
    }
}
@end
