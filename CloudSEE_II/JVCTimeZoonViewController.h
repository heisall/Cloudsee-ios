//
//  JVCTimeZoonViewController.h
//  CloudSEE_II
//
//  Created by David on 14/12/11.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"

static const NSString *KTIMEZOME    =  @"timezone";
static const NSString *KTIMEINFO    =  @"TIMEINFO";

@protocol TimeZoneDelegate <NSObject>

- (void)setDeviceTimerZoneWithIndex:(int)index;

@end

@interface JVCTimeZoonViewController : JVCBaseWithGeneralViewController<UITableViewDelegate,UITableViewDataSource>
{
    id<TimeZoneDelegate>TimeZoneDelegate;
}

@property (nonatomic,retain) NSString *strCurrentTimer;
@property(nonatomic,assign)id<TimeZoneDelegate>TimeZoneDelegate;
@property(nonatomic,assign)BOOL bSelectState;//标识设备是否有timezome字段,也就是设备是否支持切换时区


/**
 *  根据时区跟新消息
 *
 *  @param timeIndex 时区
 */
- (void)updateLabelWithTimeZoon:(int)timeIndex;
@end
