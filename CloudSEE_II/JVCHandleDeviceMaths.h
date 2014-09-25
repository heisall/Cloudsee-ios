//
//  JVCHandleDeviceMaths.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCHandleDeviceMaths : NSObject

/**
 *  单例
 *
 *  @return 返回单例对象
 */
+ (JVCHandleDeviceMaths *)shareHandleDeviceMaths;

/**
 *  把设备列表中得设备字段转化为model字段，存放到数组中，返回
 *
 *  @param deviceDic 设备列表的返回值
 *
 *  @return 包含所有设备的model的数组
 */
- (NSMutableArray *)convertDeviceListDictionToModelArray:(NSDictionary *)deviceDic;
@end
