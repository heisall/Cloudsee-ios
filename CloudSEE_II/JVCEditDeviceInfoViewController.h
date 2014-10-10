//
//  JVCEditDeviceInfoViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/9/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseSliderViewController.h"

@protocol editDeviceInfoDelegate <NSObject>

/**
 *  删除设备的回调
 */
- (void)deleteDeviceInfoCallBack;

@end
@class JVCDeviceModel;
@interface JVCEditDeviceInfoViewController : JVCBaseSliderViewController<UITextFieldDelegate>
{
    JVCDeviceModel *deviceModel;
    
    id<editDeviceInfoDelegate>deleteDelegate;
}
@property(nonatomic,retain)JVCDeviceModel *deviceModel;
@property(nonatomic,assign) id<editDeviceInfoDelegate>deleteDelegate;
@end
