//
//  JVDeviceCAlarmAddTableViewCell.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVCLockAlarmModel.h"

@interface JVDeviceCAlarmAddTableViewCell : UITableViewCell
{
    UISwitch *switchDevcie;
}
@property(nonatomic,retain)UISwitch *switchDevcie;
- (void)initAlarmAddTableViewContentView:(JVCLockAlarmModel *)model;

@end
