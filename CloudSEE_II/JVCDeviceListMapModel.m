//
//  JVCDeviceListMapModel.m
//  CloudSEE_II
//
//  Created by David on 14/12/16.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "JVCDeviceListMapModel.h"
#import "JVCDeviceMapModel.h"
#import "JVCDeviceMacro.h"

@implementation JVCDeviceListMapModel

@synthesize dlist;

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class
 */
- (NSDictionary *)modelClassNameInArray{

    return @{(NSString *)DEVICE_JSON_DLIST:[JVCDeviceMapModel class]};
}


-(void)dealloc{

    [dlist release];
    [super dealloc];

}

@end
