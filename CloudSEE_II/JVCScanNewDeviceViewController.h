//
//  JVCScanNewDeviceViewController.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-10-13.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"
#import "JVCLANScanWithSetHelpYSTNOHelper.h"
#import"JVCDeviceMathsHelper.h"
#import "JVCSystemSoundHelper.h"


@interface JVCScanNewDeviceViewController : JVCBaseWithGeneralViewController <JVCLANScanWithSetHelpYSTNOHelperDelegate,JVCDeviceMathDelegate,UIAlertViewDelegate,JVCSystemSoundHelperDelegate>

@end
