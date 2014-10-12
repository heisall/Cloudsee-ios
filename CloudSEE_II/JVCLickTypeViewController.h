//
//  JVCLickTypeViewController.h
//  CloudSEE_II
//  
//  Created by Yanghu on 10/10/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseSliderViewController.h"
#import "JVCLabelFieldSView.h"

@class JVCDeviceModel;
@interface JVCLickTypeViewController : JVCBaseSliderViewController<UITextFieldDelegate,JVCLabelFieldSViewDelegate>
{
    JVCDeviceModel *deviceModel;
}
@property(nonatomic,retain)JVCDeviceModel *deviceModel;
@end
