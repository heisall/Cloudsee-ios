//
//  JVCMoreSettingHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCMoreSettingHelper : NSObject

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCMoreSettingHelper *)shareDataBaseHelper;

/**
 *  获取设备列表
 */
- (NSMutableArray *)getMoreSettingList;

/**
 *  获取更多界面用户设置
 */
- (NSMutableArray *)getMoreUserSettingList;

@end
