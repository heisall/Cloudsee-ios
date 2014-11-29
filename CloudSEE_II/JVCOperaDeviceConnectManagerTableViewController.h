//
//  JVCOperaDeviceConnectManagerTableViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/28/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseGeneralTableViewController.h"
@class JVCDeviceModel;
@interface JVCOperaDeviceConnectManagerTableViewController : JVCBaseGeneralTableViewController
{
    JVCDeviceModel *deviceModel;
}
@property(nonatomic,retain) JVCDeviceModel *deviceModel;
@end
