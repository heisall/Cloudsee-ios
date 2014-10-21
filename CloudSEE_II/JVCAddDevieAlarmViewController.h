//
//  JVCAddDevieAlarmViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/20/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseGeneralTableViewController.h"

@protocol JVCAddDeviceArmDelegate <NSObject>

- (void)AddDeviceArmCallBack:(NSDictionary *)tdic;

@end

@interface JVCAddDevieAlarmViewController : JVCBaseGeneralTableViewController
{
       NSMutableArray *arrayAlarmList;
    
    id<JVCAddDeviceArmDelegate>delegateAddArm;
}

@property(nonatomic,assign)int localChannelNum;
@property(nonatomic,assign)id<JVCAddDeviceArmDelegate>delegateAddArm;
@property(nonatomic,retain)   NSMutableArray *arrayAlarmList;
@end
