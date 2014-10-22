//
//  JVCEditLockDeviceNickNameViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"
#import "JVCCloudSEENetworkHelper.h"
#import "JVCLockAlarmModel.h"
@interface JVCEditLockDeviceNickNameViewController : JVCBaseWithGeneralViewController
{
    JVCLockAlarmModel *alertmodel;
}
@property(nonatomic,retain)JVCLockAlarmModel *alertmodel;

@end
