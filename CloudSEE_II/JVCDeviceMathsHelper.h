//
//  JVCDeviceMathsHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/20/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JVCUpdateMathDelegate <NSObject>

/**
 *  更新设备信息成功的回调
 */
- (void)updateDeviceInfoMathSuccess;


@end

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
    id<JVCUpdateMathDelegate> deviceUpdate;
    BOOL                      bUpdateOnLineState;  //no 更新  yes 不更新

}
@property(nonatomic,assign) id<JVCDeviceMathDelegate> deviceDelegate;
@property(nonatomic,assign) id<JVCUpdateMathDelegate> deviceUpdate;
@property(nonatomic,assign) BOOL                      bUpdateOnLineState;

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
                   passWord:(NSString *)passWord
               ChannelCount:(int)count;

/**
 *  刷新设备状态
 */
- ( void)updateAccountDeviceListInfo;
@end
