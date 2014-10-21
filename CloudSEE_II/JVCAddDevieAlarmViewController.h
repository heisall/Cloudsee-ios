//
//  JVCAddDevieAlarmViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/20/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseGeneralTableViewController.h"

@interface JVCAddDevieAlarmViewController : JVCBaseGeneralTableViewController
{
       NSMutableArray *arrayAlarmList;
}

@property(nonatomic,assign)int localChannelNum;

@property(nonatomic,retain)   NSMutableArray *arrayAlarmList;
@end
