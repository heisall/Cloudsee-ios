//
//  JVCOperationHelpView.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/4/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JVCOperationHelpType) {
    JVCOperationHelpType_Add                     = 0,//添加按钮的帮助的
    JVCOperationHelpType_DeviceManager           = 1,//设备管理界面的帮助
    
};

@interface JVCOperationHelpView : UIView<UIScrollViewDelegate>


- (void)AddDeviceHelpView;

- (void)operationEditDeviceHelpView;
@end
