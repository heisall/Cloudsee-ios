//
//  JVCDeviceListViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/10/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseGeneralTableViewController.h"
#import "JVCAddDeviceViewController.h"
#import "JVCQRCoderViewController.h"
#import "JVCAddDevicePopView.h"

typedef enum {
    
    AddDevicePopType_NormalAddDevice    = 0,//正常添加
    AddDevicePopType_QRAddDevice        = 1,//扫一扫
    AddDevicePopType_WlanAddDevice      = 2,//无线添加
    AddDevicePopType_ScanADDDevice      = 3,//扫描添加
    AddDevicePopType_VloceAddDevice     = 4,//声波添加
    
}AddDevicePopType;

@interface JVCDeviceListViewController : JVCBaseGeneralTableViewController<addDeviceDelegate,CustomViewControllerDelegate,AddDevicePopViewDelegate>

#pragma mark 获取设备
- (void)getDeviceList;

@end
