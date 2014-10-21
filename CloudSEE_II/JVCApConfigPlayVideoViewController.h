//
//  JVCApConfigPlayVideoViewController.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-10-20.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"
#import "JVCCloudSEENetworkHelper.h"
#import "JVCMonitorConnectionSingleImageView.h"
#import "JVCAPConfingMiddleIphone5.h"
#import "JVCApConfigDeviceViewController.h"

@interface JVCApConfigPlayVideoViewController : JVCBaseWithGeneralViewController <ystNetWorkHelpDelegate,JVCMonitorConnectionSingleImageViewDelegate,JVCAPConfingMiddleIphone5Delegate,ystNetWorkHelpRemoteOperationDelegate,ystNetWorkHelpTextDataDelegate,JVCApConfigDeviceViewControllerDelegate> {

    NSString *strYstNumber;
}

@property (nonatomic,retain) NSString *strYstNumber;

@end
