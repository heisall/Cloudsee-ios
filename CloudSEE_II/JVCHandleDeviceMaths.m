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


/**
 *  把设备列表中得设备字段转化为model字段，存放到数组中，返回
 *
 *  @param deviceDic 设备列表的返回值
 *
 *  @return 包含所有设备的model的数组
 */
- (NSMutableArray *)convertDeviceListDictionToModelArray:(NSDictionary *)deviceDic
{
    [deviceDic retain];
    
    NSArray *array = [deviceDic objectForKey:DEVICE_JSON_DLIST];
    
    NSMutableArray *_arrayModel = [[NSMutableArray alloc] init];
    
    for (int i=0; i<array.count; i++) {
        
        NSDictionary *_dicInfo = [array objectAtIndex:i];
        
        JVCDeviceModel *_model = [[JVCDeviceModel alloc] init];
        _model.userName = [_dicInfo objectForKey:DEVICE_JSON_DVUSERNAME];
        _model.passWord = [_dicInfo objectForKey:DEVICE_JSON_DVPASSWORD];
        _model.yunShiTongNum = [_dicInfo objectForKey:DEVICE_JSON_DGUID];
        _model.hasWifi = [[_dicInfo objectForKey:DEVICE_JSON_WIFI] intValue];
        
        DDLogInfo(@"%s-----content=%@---wifiFlag==%d", __FUNCTION__,_dicInfo,[[_dicInfo objectForKey:DEVICE_JSON_WIFI] intValue]);
        _model.nickName = [_dicInfo objectForKey:DEVICE_JSON_NICKNAME];
        _model.linkType = [[_dicInfo objectForKey:DEVICE_JSON_LINKTYPE] intValue];
        
        if (_model.linkType==CONNECTTYPE_IP) {
            
           // _model.editByUser=YES;
        }
        _model.ip = [_dicInfo objectForKey:DEVICE_JSON_IP];
        _model.port = [NSString stringWithFormat:@"%@",[_dicInfo objectForKey:DEVICE_JSON_PORT]];
        
        _model.onLineState=[[_dicInfo objectForKey:DEVICE_ONLINE_STATUS] intValue];
        
        [_arrayModel addObject:_model];
        
        [_model release];
    }
    [deviceDic release];
    return [_arrayModel autorelease];
}


@end
