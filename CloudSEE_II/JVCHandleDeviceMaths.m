//
//  JVCHandleDeviceMaths.m
//  CloudSEE_II
//  设备列表数据处理类，把服务器获取的数据处理
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCHandleDeviceMaths.h"
#import "JVCDeviceMacro.h"
#import "JVCDeviceModel.h"

@implementation JVCHandleDeviceMaths

static JVCHandleDeviceMaths *shareHandleDeviceMaths = nil;

/**
 *  单例
 *
 *  @return 返回单例对象
 */
+ (JVCHandleDeviceMaths *)shareHandleDeviceMaths
{
    @synchronized(self)
    {
        if (shareHandleDeviceMaths == nil) {
            
            shareHandleDeviceMaths = [[self alloc] init];
            
            return shareHandleDeviceMaths;
        }
        
        return shareHandleDeviceMaths;
    }
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareHandleDeviceMaths == nil) {
            
            shareHandleDeviceMaths = [super allocWithZone:zone];
            
            return shareHandleDeviceMaths;
        }
        
        return nil;
    }
}



@end
