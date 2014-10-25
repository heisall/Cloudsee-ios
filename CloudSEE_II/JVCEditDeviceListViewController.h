//
//  JVCEditDeviceListViewController.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-28.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseWithTopToolViewAndDropListViewController.h"
#import "JVCEditDeviceInfoViewController.h"
#import "JVCCloudSEENetworkHelper.h"


@interface JVCEditDeviceListViewController : JVCBaseWithTopToolViewAndDropListViewController<editDeviceInfoDelegate,ystNetWorkHelpDelegate,ystNetWorkHelpRemoteOperationDelegate,ystNetWorkHelpTextDataDelegate>


@end
