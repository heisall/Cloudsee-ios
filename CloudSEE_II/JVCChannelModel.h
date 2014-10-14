//
//  JVCChannelModel.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-10-8.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCChannelModel : NSObject {
    
    NSString  *strDeviceYstNumber;
    NSString  *strNickName;
    int       nChannelValue;
}

@property (nonatomic,retain) NSString  *strDeviceYstNumber;
@property (nonatomic,retain) NSString  *strNickName;
@property (nonatomic,assign) int       nChannelValue;

/**
 *  根据网络通道信息的字典转换成通道Model
 *
 *  @param channelDic   通道信息的字典
 *  @param ystNumber    云视通号
 *
 *  @return 通道实体
 */
-(id)initWithChannelDic:(NSDictionary *)channelDic  ystNumber:(NSString *)ystNumber;

/**
 *  初始化通道实体
 *
 *  @param ystNum     云视通
 *  @param nickName   昵称
 *  @param channelNum 通道号
 *
 *  @return 通道实体
 */
-(id)initChannelWithystNum:(NSString *)ystNum nickName:(NSString *)nickName  channelNum:(int )channelNum;
@end
