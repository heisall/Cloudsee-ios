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

/**
 *  删除事件
 */
- (void)deleteDevice;

/**
 *  正则判断成功后，调用修改方法
 */
- (void)editDeviceInfoPredicateSuccess:(NSString *)nickName  userName:(NSString *)userName  passWord:(NSString *)password;

/**
 *  处理修改设备信息返回值的方法
 *
 *  @param result 返回值
 */
- (void)handelModifyDeviceInfoResult:(int )result;

/**
 *  处理设备删除返回值的方法
 *
 *  @param result 返回值
 */
- (void)handeleDeleteDeviceRusult:(int )result;
@end
