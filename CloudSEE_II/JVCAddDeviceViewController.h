//
//  JVCAddDeviceViewController.h
//  CloudSEE_II
//  云视通添加设备
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseSliderViewController.h"
enum DEVICE_INFO {
    
    DEVICE_E      = -1,
    DEVICE_R      = 0,
    DEVICE_RESET  = 1,
};

static const int     DEFAULTCHANNELCOUNT         = 4;   //莫仍的通道数

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

@interface JVCAddDeviceViewController : JVCBaseSliderViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    id<addDeviceDelegate>addDeviceDelegate;
}
@property(nonatomic,assign)id<addDeviceDelegate>addDeviceDelegate;

/**
 *  设置云视通textfield的文本,二维码扫描的时候用到
 */
- (void)YstTextFieldTextL:(NSString *)yunNum;

/**
 *  添加设备，即先把设备绑定到自己的账号中，然后获取设备的详细信息
 *
 */
- (void)addDeviceToAccount:(NSString *)ystNum  deviceUserName:(NSString *) name  passWord:(NSString *)passWord;
@end
