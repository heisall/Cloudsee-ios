//
//  JVCChannelScourseHelper.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCChannelScourseHelper.h"
#import "JVCSystemUtility.h"
#import "JVCDeviceModel.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCDeviceMacro.h"
#import "JVCChannelModel.h"

@interface JVCChannelScourseHelper ()
{
    NSMutableArray *channelArray;
}
@end
@implementation JVCChannelScourseHelper

static JVCChannelScourseHelper *shareChannelScourseHelper = nil;

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCChannelScourseHelper *)shareChannelScourseHelper
{
    @synchronized(self)
    {
        if (shareChannelScourseHelper == nil) {
            
            shareChannelScourseHelper = [[self alloc] init];
            
            [shareChannelScourseHelper initChannelSourceArray];
        }
        
        return shareChannelScourseHelper;
    }
    
    return shareChannelScourseHelper;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareChannelScourseHelper == nil) {
            
            shareChannelScourseHelper = [super allocWithZone:zone];
            
            return shareChannelScourseHelper;
        }
    }
    
    return nil;
}

- (void)dealloc
{
    [channelArray release];
    channelArray = nil;
    
    [super dealloc];
}

/**
 *  初始化数组
 */
- (void)initChannelSourceArray
{
    channelArray = [[NSMutableArray alloc] init];
    
}

/**
 *  获取通道数组
 */
- (NSMutableArray *)ChannelListArray
{
    return channelArray;
}

/**
 *  清楚通道列表的所有数据
 */
- (void)removeAllchannelsObject
{
    [channelArray removeAllObjects];
}


/**
 *  根据云视通号返回一个设备的所有通道号集合
 *
 *  @return 一个设备的所有通道号集合
 */
-(NSMutableArray *)channelValuesWithDeviceYstNumber:(NSString *)ystNumber{
    
    NSMutableArray *channnleValues = [NSMutableArray arrayWithCapacity:10];
    
     DDLogVerbose(@"%s---deviceYst=%@,channelCount=%d",__FUNCTION__,ystNumber,channelArray.count);
    
    for (int i = 0; i < channelArray.count; i++) {

        JVCDeviceModel *channelModel = (JVCDeviceModel *)[channelArray objectAtIndex:i];
        
        DDLogVerbose(@"%s---channelYst=%@",__FUNCTION__,channelModel.yunShiTongNum);
        
        if ([channelModel.yunShiTongNum isEqualToString:ystNumber]) {
            
            [channnleValues addObject:[NSNumber numberWithInt:channelModel.channelValue]];
        }
    }

    return channnleValues;
}

/**
 *  把获取的单个设备的通道信息转换成model的数组并添加到arrayPoint集合里面
 *
 *  @param channelMdicInfo 设备通道信息的JSON数据
 */
-(void)channelInfoMDicConvertChannelModelToMArrayPoint:(NSDictionary *)channelMdicInfo deviceYstNumber:(NSString *)deviceYstNumber
{
    /**
     *  判断返回字典的rt字段是否为0
     */
    if ( [[JVCSystemUtility shareSystemUtilityInstance] JudgeGetDictionIsLegal:channelMdicInfo]) {
        
        //根据云通号获取相应的设备Model类
        JVCDeviceModel *deviceModel=[[JVCDeviceSourceHelper shareDeviceSourceHelper] getDeviceModelByYstNumber:deviceYstNumber];
        
        [deviceModel retain];
        
        DDLogVerbose(@"deviceModel=%@",deviceModel.yunShiTongNum);
        
        if (deviceModel!=nil) {
            
          [self convertChannelDictionToModelList:channelMdicInfo deviceModel:deviceModel];
        }
        
        [deviceModel release];
    }
}

/**
 *  将获取的通道信息转换成通道数组
 *
 *  @param channelInfoMDic 获取的通道信息数据
 *  @param deviceModel     设备的MODEl类
 *
 */
-( void)convertChannelDictionToModelList:(NSDictionary *)channelInfoMDic deviceModel:(JVCDeviceModel *)deviceModel
{
    id channelInfoId=[channelInfoMDic objectForKey:DEVICE_CHANNEL_JSON_LIST];
    
    if ([channelInfoId isKindOfClass:[NSArray class]]) {
        
        NSArray *channelInfoArray=(NSArray *)channelInfoId;
        
        for (int i=0; i<channelInfoArray.count; i++) {
            
            NSDictionary *channelMdic=(NSDictionary *)[channelInfoArray objectAtIndex:i];
            
            JVCDeviceModel *channelModel=[[JVCDeviceModel alloc] initWithChannelDic:channelMdic devieModel:deviceModel];
            
            [channelArray addObject:channelModel];
            
            [channelModel release];
        }
    }
}

/**
 *  根据云视通号返回一个设备的所有通道集合
 *
 *  @return 一个设备的所有通道集合
 */
-(NSMutableArray *)channelModelWithDeviceYstNumber:(NSString *)ystNumber{
    
    NSMutableArray *channnleValues = [NSMutableArray arrayWithCapacity:10];
    
    DDLogVerbose(@"%s---deviceYst=%@,channelCount=%d",__FUNCTION__,ystNumber,channelArray.count);
    
    for (int i = 0; i < channelArray.count; i++) {
        
        JVCDeviceModel *channelModel = (JVCDeviceModel *)[channelArray objectAtIndex:i];
        
        DDLogVerbose(@"%s---channelYst=%@",__FUNCTION__,channelModel.yunShiTongNum);
        
        if ([channelModel.yunShiTongNum isEqualToString:ystNumber]) {
            
            [channnleValues addObject:channelModel];
        }
    }
    
    return channnleValues;
}


@end
