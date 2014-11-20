//
//  JVCTencentHelp.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/12/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int  JVCTencentLeveal ;//腾讯云统计的leveal

enum JVCTencentLeveal {
    
    JVCTencentTypeClose = 0,    //默认关闭
    JVCTencentTypeOpen  = 1,    //打开
};

@interface JVCTencentHelp : NSObject

/**
 *  单例
 *
 *  @return 对象
 */
+(JVCTencentHelp *)shareTencentHelp;

/**
 *  初始腾讯sdk
 */
- (void)initTencentSDK;
/**
 *  点击事件的次数统计
 *
 *  @param tencentKey 腾讯key值
 */
- (void)tencenttrackCustomKeyValueEvent:(NSString *)tencentKey;

/**
 *  跟踪事件开始
 *
 *  @param tencentKey 腾讯key值
 */
- (void)tencenttrackCustomKeyValueEventBegin:(NSString *)tencentKey;

/**
 *  跟踪事件结束
 *
 *  @param tencentKey 腾讯key值
 */
- (void)tencenttrackCustomKeyValueEventEnd:(NSString *)tencentKey;

/**
 *  跟踪活动页面按钮事件
 *
 *  @param tencentKey         腾讯key值
 *  @param activityViewString 活动页面
 */
- (void)tencenttrackCustomKeyValueEvent:(NSString *)tencentKey
                          activityClass:(NSString *)activityViewString;

@end
