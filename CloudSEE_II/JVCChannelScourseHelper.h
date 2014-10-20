//
//  JVCChannelScourseHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVCChannelModel.h"

static const int kJVCChannelScourseHelperAllConnectFlag = 109 ;

@interface JVCChannelScourseHelper : NSObject

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCChannelScourseHelper *)shareChannelScourseHelper;

/**
 *  获取通道数组
 */
- (NSMutableArray *)ChannelListArray;

/**
 *  清楚通道列表的所有数据
 */
- (void)removeAllchannelsObject;

/**
 *  根据云视通号返回一个设备的所有通道号集合
 *
 *  @return 一个设备的所有通道号集合
 */
-(NSMutableArray *)channelValuesWithDeviceYstNumber:(NSString *)ystNumber;

/**
 *  把获取的单个设备的通道信息转换成model的数组并添加到arrayPoint集合里面
 *
 *  @param channelMdicInfo 设备通道信息的JSON数据
 */
-(void)channelInfoMDicConvertChannelModelToMArrayPoint:(NSDictionary *)channelMdicInfo deviceYstNumber:(NSString *)deviceYstNumber;

/**
 *  根据设备的云视通号和单个设备通道数组的索引号返回一个通道实体
 *
 *  @param index     通道索引号
 *  @param ystNumber 云视通号
 *
 *  @return 通道实体
 */
-(JVCChannelModel *)channelModelAtIndex:(int)index withDeviceYstNumber:(NSString *)ystNumber;

/**
 *  根据云视通号返回一个设备的所有通道集合
 *
 *  @return 一个设备的所有通道集合
 */
-(NSMutableArray *)channelModelWithDeviceYstNumber:(NSString *)ystNumber;

/**
 *  删除一个设备下面的所有的通道
 *
 *  @param ystNumber 云视通号
 */
-(void)deleteChannelsWithDeviceYstNumber:(NSString *)ystNumber;

/**
 * 删除设备下面一个的通道
 *
 */
-(void)deleteSingleChannelWithDeviceYstNumber:(JVCChannelModel *)channelModelDelete;

/**
 *  本地添加通道,并且把本地通道放到数组中
 *
 *  @param ystNum 云视通号
 */
- (void)addLocalChannelsWithDeviceModel:(NSString *)ystNum;

/**
 *  获取本地通道所有列表
 */
- (void)getAllLocalChannelsList;

/**
 *  修改通道昵称
 *
 *  @param nickName   通道昵称
 *  @param channelIDNum 通道号
 *
 *  @return 成功失败  yes 成功
 */
- (BOOL)editLocalChannelNickName:(NSString *)nickName  channelIDNum:(int)channelIDNum;
/**
 *  根据id删除设备
 *
 *  @param idNum idnum
 *
 *  @return yes 成功
 */
- (BOOL)deleteLocalChannelWithId:(int)idNum;

/**
 *  根据云视通号，删除通道
 *
 *  @param ystNum 云视通号
 *
 *  @return 成功 yes 不成功 no
 */
- (BOOL)deleteLocalChannelsWithYStNum:(NSString *)ystNum;
@end
