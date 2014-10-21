//
//  JVCDeviceMathsHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/20/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JVCDeviceMathDelegate <NSObject>

/**
 *  添加云视通成功的时候
 */
- (void)addDeviceSuccess;

/**
 *  删除云视通成功的时候
 */
- (void)deleteDeviceSuccess;

@end

@interface JVCDeviceMathsHelper : NSObject
{
    id<JVCDeviceMathDelegate> deviceDelegate;
}
@property(nonatomic,assign) id<JVCDeviceMathDelegate> deviceDelegate;

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCDeviceMathsHelper *)shareJVCUrlRequestHelper;

#pragma mark 添加设备方法
/**
 *  添加
 *
 *  @param ystNum   云视通
 *  @param userName 用户名
 *  @param passWord 密码
 */
- (void)addDeviceWithYstNum:(NSString *)ystNum
                   userName:(NSString *)userName
                   passWord:(NSString *)passWord;
@end
