//
//  JVCChannelModel.m
//  CloudSEE_II
//  通道对象的Model,主要用来获取设备的通道相关信息
//  Created by chenzhenyang on 14-10-8.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCChannelModel.h"

@implementation JVCChannelModel

@synthesize strDeviceYstNumber,strNickName,nChannelValue;


static NSString const *kDeviceChannelName   = @"dcname"; //通道名称
static NSString const *kDeviceChannelNumber = @"dcn";    //通道名称


-(void)dealloc{

    [strNickName release];
    [strDeviceYstNumber release];
    [super dealloc];
}

/**
 *  根据网络通道信息的字典转换成通道Model
 *
 *  @param channelDic   通道信息的字典
 *  @param ystNumber    云视通号
 *
 *  @return 通道实体
 */
-(id)initWithChannelDic:(NSDictionary *)channelDic  ystNumber:(NSString *)ystNumber {
    
    if (self = [super init]) {
        
        self.strNickName           = [channelDic objectForKey:kDeviceChannelName];
        
        if ([channelDic objectForKey:kDeviceChannelNumber]) {
            
             self.nChannelValue    = [[channelDic objectForKey:kDeviceChannelNumber] intValue];
        }
        
        self.strDeviceYstNumber    = ystNumber;
    }
    
    return self;
}

/**
 *  初始化通道实体
 *
 *  @param ystNum     云视通
 *  @param nickName   昵称
 *  @param channelNum 通道号
 *
 *  @return 通道实体
 */
-(id)initChannelWithystNum:(NSString *)ystNum nickName:(NSString *)nickName  channelNum:(int )channelNum {
    
    if (self = [super init]) {
        
        self.strNickName           = nickName;
        
        self.strDeviceYstNumber   = ystNum;
        
        self.nChannelValue    = channelNum;
    }
    
    return self;
}

@end
