//
//  JVCAddDeviceViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseSliderViewController.h"
enum DEVICE_INFO {
    
    DEVICE_E      = -1,
    DEVICE_R      = 0,
    DEVICE_RESET  = 1,
};


enum BINDING
{
    DEVICE_BINGING_NO  = 0,//没有绑定
};

enum DEVICEBIND
{
    DEVICEBIND_SUCCESS = 0,//成功
    
};

@protocol addDeviceDelegate <NSObject>

/**
 *  添加设备的回调
 */
- (void)addDeviceSuccessCallBack;

@end

@interface JVCAddDeviceViewController : JVCBaseSliderViewController<UITextFieldDelegate>
{
    id<addDeviceDelegate>addDeviceDelegate;
}
@property(nonatomic,assign)id<addDeviceDelegate>addDeviceDelegate;
@end
