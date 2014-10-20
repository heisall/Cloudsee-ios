//
//  JVCIPAddViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/18/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseSliderViewController.h"
#import "JVCLabelFieldSView.h"
#import "JVCDeviceModel.h"
@interface JVCIPAddViewController : JVCBaseSliderViewController<UITextFieldDelegate,JVCLabelFieldSViewDelegate>
{
    JVCDeviceModel *deviceModel;
}
@property(nonatomic,retain)JVCDeviceModel *deviceModel;
@end
