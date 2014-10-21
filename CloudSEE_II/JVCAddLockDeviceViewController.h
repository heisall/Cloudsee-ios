//
//  JVCAddLockDeviceViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"
#import "JVCCloudSEENetworkHelper.h"

@protocol JVCAddlockDeviceDelegate <NSObject>

/**
 *  绑定设备成功的回调
 *
 *  @param tdic 设备的字典
 */
- (void)AddLockDeviceSuccessCallBack:(NSDictionary *)tdic;

@end

@interface JVCAddLockDeviceViewController : JVCBaseWithGeneralViewController<ystNetWorkHelpRemoteOperationDelegate,ystNetWorkHelpTextDataDelegate>
{
    id<JVCAddlockDeviceDelegate>addLockDeviceDelegate;
}
@property(nonatomic,assign)id<JVCAddlockDeviceDelegate>addLockDeviceDelegate;

@end
