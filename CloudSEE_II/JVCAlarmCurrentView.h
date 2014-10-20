//
//  JVCAlarmCurrentView.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/18/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

enum  {

    AlarmType_Close = 0,//关闭
    AlarmType_Watch = 1,//查看
};

@class JVCAlarmModel;

@protocol JVCAlarmAlarmDelegate <NSObject>

/**
 *  返回用户的选择
 *
 *  @param result 用户选择
 */
- (void)JVCAlarmAlarmCallBack:(int)result;

@end

@interface JVCAlarmCurrentView : UIView
{
    id<JVCAlarmAlarmDelegate>AlarmDelegate;
}
@property(nonatomic,assign)id<JVCAlarmAlarmDelegate>AlarmDelegate;

- (void)initCurrentAlarmView:(JVCAlarmModel *)alarmModel;
@end
