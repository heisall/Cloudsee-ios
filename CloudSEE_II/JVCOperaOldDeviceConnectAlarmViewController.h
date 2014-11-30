//
//  JVCOperaOldDeviceConnectAlarmViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseGeneralTableViewController.h"
#import "JVCDeviceModel.h"
@interface JVCOperaOldDeviceConnectAlarmViewController : JVCBaseGeneralTableViewController
{
    JVCDeviceModel *deviceModel;
}
@property(nonatomic,retain) JVCDeviceModel *deviceModel;
@end
