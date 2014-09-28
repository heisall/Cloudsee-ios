//
//  JVCChannelScourseHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCChannelScourseHelper : NSObject
{
    NSMutableArray *channelArray;
}
@property(nonatomic,retain)NSMutableArray *channelArray;

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCChannelScourseHelper *)shareChannelScourseHelper;

/**
 *  把获取的单个设备的通道信息转换成model的数组并添加到arrayPoint集合里面
 *
 *  @param channelMdicInfo 设备通道信息的JSON数据
 */
-(void)channelInfoMDicConvertChannelModelToMArrayPoint:(NSDictionary *)channelMdicInfo deviceYstNumber:(NSString *)deviceYstNumber;

@end
