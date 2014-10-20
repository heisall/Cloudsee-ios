//
//  JVCAlarmHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/16/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCAlarmHelper : NSObject

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCAlarmHelper *)shareAlarmHelper;

/**
 *  获取报警历史
 *
 *  @param index 起始位置  index 开始位置 结束位置：index+JK_ALARM_LISTCOUNT（4）
 */
- (NSMutableArray  *)getHistoryAlarm:(int)index;

/**
 *  删除报警信息
 *
 *  @param deviceGuid 报警的32位唯一标识
 *
 *  @return yes 成功  no 失败
 */
- (BOOL)deleteAlarmHistoryWithGuid:(NSString *)deviceGuid;
@end
