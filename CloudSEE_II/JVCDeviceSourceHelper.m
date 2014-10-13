//
//  JVCDeviceSourceHelper.m
//  CloudSEE_II
//  设备集合管理的助手类 用于增删改、排序等操作
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDeviceSourceHelper.h"
#import "JVCHandleDeviceMaths.h"
#import "JVCDeviceMacro.h"
#import "JVCLocalDeviceDateBaseHelp.h"

static const int MAX_DEVICE_NUM = 100;//账号下面最大的值

@interface JVCDeviceSourceHelper ()
{
    NSMutableArray *deviceArray;////存放设备数组
}

@end

@implementation JVCDeviceSourceHelper

static JVCDeviceSourceHelper *shareDeviceSourceHelper = nil;

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCDeviceSourceHelper *)shareDeviceSourceHelper
{
    @synchronized(self)
    {
        if (shareDeviceSourceHelper == nil) {
            
            shareDeviceSourceHelper = [[self alloc] init];
            
            [shareDeviceSourceHelper initDeviceSourceArray];
        }
        
        return shareDeviceSourceHelper;
    }
    
    return shareDeviceSourceHelper;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareDeviceSourceHelper == nil) {
            
            shareDeviceSourceHelper = [super allocWithZone:zone];
            
            return shareDeviceSourceHelper;
        }
    }
    
    return nil;
}

/**
 *  初始化数组
 */
- (void)initDeviceSourceArray
{
    deviceArray = [[NSMutableArray alloc] init];
    
}

/**
 *  获取设备列表
 *
 *  @return 设备列表
 */
- (NSMutableArray *)deviceListArray
{
    return deviceArray;
}

/**
 *  返回所有的云视通号集合
 *
 *  @return 云视通号集合
 */
-(NSMutableArray *)ystNumbersWithDevceList{

    NSMutableArray *ystNumberArray = [NSMutableArray arrayWithCapacity:10]; //autoRelease类型的，系统释放
    
    for (int i = 0; i < deviceArray.count; i++) {
        
        JVCDeviceModel *deviceModel = (JVCDeviceModel *)[deviceArray objectAtIndex:i];
        
        [ystNumberArray addObject:deviceModel.yunShiTongNum];
    }

    return ystNumberArray;
}

/**
 *  清楚设备列表的所有数据
 */
- (void)removeAllDeviceObject
{
    [deviceArray removeAllObjects];
}

/**
 *  往数据列表中插入数据
 */
- (void)addDeviceObjectFromArray:(NSArray *)array
{
    [array retain];
    
    [deviceArray addObjectsFromArray:array];
    
    [array release];
}

/**
 *  把从服务器收到的数据转化成model
 *
 *  @param tdicDevice 服务器收到的数据
 */
- (void)addServerDateToDeviceList:(NSDictionary *)tdicDevice
{

    [self removeAllDeviceObject];

    NSArray *array = [tdicDevice objectForKey:DEVICE_JSON_DLIST];
    
    for (int i=0; i<array.count; i++) {
        
        NSDictionary *_dicInfo = [array objectAtIndex:i];
        
        JVCDeviceModel *_model = [[JVCDeviceModel alloc] initWithDictionary:_dicInfo];
        
        [deviceArray addObject:_model];
        
        [_model release];
    }

}

/**
 *  根据云视通号查看云视通号在设备中是否存在
 *
 *  @param YSTNum      云视通号
 *  @param deviceArray 传进来的用户的数组
 *
 *  @return ADDDEVICE_HAS_EXIST:存在  ADDDEVICE_NOT_EXIST:不存在  ADDDEVICE_MAX_MUX:超过最大值
 */
- (int)addDevicePredicateHaveYSTNUM:(NSString *)YSTNum
{
    
    if (deviceArray.count>MAX_DEVICE_NUM) {
        
        return ADDDEVICE_MAX_MUX;
        
    }
    
    for (int i=0; i<deviceArray.count; i++) {
        
        JVCDeviceModel *tSouceModel = [deviceArray objectAtIndex:i];
        
        if([tSouceModel.yunShiTongNum.uppercaseString isEqualToString:YSTNum.uppercaseString])
        {
            return ADDDEVICE_HAS_EXIST;
        }
    }
    
    
    return ADDDEVICE_NOT_EXIST;
    
}

#pragma mark  添加设备后，把获取到得数据（字典类型）转化为model类型
/**
 *  添加设备后，把获取到得数据（字典类型）转化为model类型
 *
 *  @param deviceInfoDic 设备的类型
 *
 *  @param YSTNum 云视通号
 *
 *  @return 转化完成后的model类型
 */
- (JVCDeviceModel *)convertDeviceDictionToModelAndInsertDeviceList:(NSDictionary *)deviceInfoDic withYSTNUM:(NSString *)YSTNum
{
    JVCDeviceModel *_model = [[JVCDeviceModel alloc] initWithADDDeviceDictionary:deviceInfoDic YSTNUM:YSTNum];
    
    [deviceArray insertObject:_model atIndex:0];
    
    return _model;
}

/**
 *  根据设备model删除设备
 *
 *  @param model 设备model
*/
- (void)deleteDevieWithModel:(JVCDeviceModel *)model
{
    [deviceArray removeObject:model];
}
/**
 *  根据设备model删除设备
 *
 *  @param model 设备model
 */
- (void)deleteDevieWithYstNum:(NSString *)ystNum
{
    for (int i=0; i<deviceArray.count; i++) {
        
        JVCDeviceModel *tSouceModel = [deviceArray objectAtIndex:i];
        
        if([tSouceModel.yunShiTongNum.uppercaseString isEqualToString:ystNum.uppercaseString])
        {
            [deviceArray removeObject:tSouceModel];
            break;
        }
    }
}

/**
 *  根据云通号获取sourceModel
 *
 *  @param ystNumber 云通号
 *
 *  @return 云通号的sourceModel
 */
-(JVCDeviceModel *)getDeviceModelByYstNumber:(NSString *)ystNumber
{
    
    for (int i=0; i<deviceArray.count; i++) {
        
        JVCDeviceModel *deviceModel= [deviceArray objectAtIndex:i];
        
        if ([[deviceModel.yunShiTongNum uppercaseString] isEqualToString:[ystNumber uppercaseString]]) {
            
            
            return deviceModel;
            
        }
    }
    
    return nil;
}

/**
 *  还原设备的在线信息，把所有的在线信息置为离线
 */
-(void)restoreDeviceListOnlineStatusInfo{
    
    for (int i=0; i<deviceArray.count; i++) {
        
        JVCDeviceModel *model= (JVCDeviceModel *)[deviceArray objectAtIndex:i];
        
        if (!model.isCustomLinkModel) {
            
            model.linkType =CONNECTTYPE_YST;
            model.ip       = @"";
            model.port     = @"";
        }
    }
}

/**
 *  将广播获取到的设备更新到通道集合中
 *
 *  @param updateLanModelList 广播获取到的设备集合
 */
-(void)updateLanModelToChannelListData:(NSArray *)updateLanModelList{
    
    [updateLanModelList retain];
    
    for (int i=0; i<updateLanModelList.count; i++) {
        
        JVCDeviceModel *deviceModel=(JVCDeviceModel *)[updateLanModelList objectAtIndex:i];
        
        DDLogVerbose(@"%s=%@_wifiState=%d,IP=%@,port=%@",__FUNCTION__,deviceModel.yunShiTongNum,deviceModel.hasWifi,deviceModel.ip,deviceModel.port);
        
        for (JVCDeviceModel *model in deviceArray) {
            
            if ([model.yunShiTongNum.uppercaseString isEqualToString:deviceModel.yunShiTongNum.uppercaseString]) {
                
                if (!model.isCustomLinkModel) {
                    
                    model.ip=deviceModel.ip;
                    model.port=deviceModel.port;
                    model.linkType=deviceModel.linkType;
                }
            }
        }
    }
    
    [updateLanModelList release];
}


#pragma mark ---  本地缓存处理模块

/**
 *  把sourceModel转换成CacheModel集合
 *
 *  @param deviceMArray sourceModel数组
 *
 *  @return CacheModel集合
 */
-(NSMutableArray *)deviceModelListConvertLocalCacheModel{
    
    
    NSMutableArray *cacheDeviceListData=[NSMutableArray arrayWithCapacity:10];
    
    
    for (JVCDeviceModel *model in deviceArray) {
        
        JVCLocalCacheModel *cacheModel = [[JVCLocalCacheModel alloc] init];
        
        cacheModel.strYstNumber        = model.yunShiTongNum;
        cacheModel.strUserName         = model.userName;
        cacheModel.strPassWord         = model.passWord;
        
        [cacheDeviceListData addObject:cacheModel];
        [cacheModel release];
    }
    
    return cacheDeviceListData;
}

/**
 *  根据云视通号获取缓存的实体Model
 *
 *  @param ystNumber 设备的云视通号
 *
 *  @return 缓存的实体Model
 */
-(JVCLocalCacheModel *)deviceModelWithYstNumberConvertLocalCacheModel:(NSString *)ystNumber {
    
    
    JVCLocalCacheModel *cacheModel = [[[JVCLocalCacheModel alloc] init] autorelease];
    
    for (JVCDeviceModel *model in deviceArray) {
        
        if ([model.yunShiTongNum isEqualToString:ystNumber]) {
            
            cacheModel.strYstNumber        = model.yunShiTongNum;
            cacheModel.strUserName         = model.userName;
            cacheModel.strPassWord         = model.passWord;
        }
    }
    
    return cacheModel;
}

/**
 *  获取本地数据库中设备列表
 */
- (void)getLocalDeviceList
{
   NSArray *arrayLocalDevice = [[JVCLocalDeviceDateBaseHelp shareDataBaseHelper] getAllLocalDeviceList];
    [deviceArray removeAllObjects];
    [deviceArray addObjectsFromArray:arrayLocalDevice];
}

@end
