//
//  JVCDeviceUpdateViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/17/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseSliderViewController.h"
#import "JVCDeviceModel.h"

@interface JVCDeviceUpdateViewController : JVCBaseSliderViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    JVCDeviceModel *modelDevice;
}
@property(nonatomic,retain)JVCDeviceModel *modelDevice;
@end
