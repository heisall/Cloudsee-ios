//
//  JVCLocalChannelDateBaseHelp.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCLocalChannelDateBaseHelp : NSObject


/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCLocalChannelDateBaseHelp *)shareDataBaseHelper;

/**
 *  把数据插入到本地
 */
-(BOOL)addLocalChannelToDataBase:(NSString *)ystNUm  nickName:(NSString *)name  ChannelSortNum:(int)channelNum;

/**
 *  删除通道
 */
-(BOOL)deleteLocalChannelFromDataBase:(NSString *)ystNUm;

/**
 *  更新通道
 */
-(BOOL)updateLocalChannelInfoWithId:(int)idNum
                           NickName:(NSString *)nickName;


/**
 *  获取所有的本地通道列表
 *
 *  @return 设备列表数组
 */
- (NSMutableArray *)getAllChannnelList;

/**
 *  获取单个通道的列表
 *
 *  @return 设备列表数组
 */
- (NSMutableArray *)getSingleChannnelListWithYstNum:(NSString *)ystNum;

/**
 *  删除通道
 */
-(BOOL)deleteLocalChannelWithIdNUm:(int)idNUm;


@end
