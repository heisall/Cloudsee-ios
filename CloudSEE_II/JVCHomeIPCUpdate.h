//
//  JVCHomeIPCUpdate.h
//  CloudSEE_II
//  家用IPC升级业务流程 （设备需要支持设备服务）
//  Created by chenzhenyang on 14-11-17.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JVCHomeIPCUpdate;

/**
 *   检查当前的版本是否可以更新
 *
 *  @param nStatus       JVCHomeIPCUpdateCheckNewVersionStatus
 *  @param strNewVersion 最新版本
 */
typedef void (^JVCHomeIPCUpdateCheckVersionStatusBlock)(int nStatus,NSString *strNewVersion);

/**
 *  升级包下载进度回调块
 *
 *  @param nProgressValue 升级进度 （0~~100）
 */
typedef void (^JVCHomeIPCDownloadUpdateProgressBlock)(int nProgressValue);

/**
 *  出错的回调
 *
 *  @param errorType 更新出错的类型
 */
typedef void (^JVCHomeIPCErrorBlock)(int errorType);

/**
 *  操作完成的回调
 *
 *  @param JVCHomeIPCFinshedType
 */
typedef void (^JVCHomeIPCFinshedBlock)(int finshedType);

/**
 *  烧写进度回调块
 *
 *  @param nProgressValue 升级进度 （0~~100）
 */
typedef void (^JVCHomeIPCWriteProgressBlock)(int nProgressValue);


/**
 *  重置结果的回调
 *
 *  @param JVCHomeIPCFinshedType
 */
typedef void (^JVCHomeIPCResetBlock)(int resetStatus,NSString *strNewVersion);


@interface JVCHomeIPCUpdate : NSObject


@property (nonatomic,copy) JVCHomeIPCUpdateCheckVersionStatusBlock   homeIPCUpdateCheckVersionStatusBlock;
@property (nonatomic,copy) JVCHomeIPCDownloadUpdateProgressBlock     homeIPCDownloadUpdateProgressBlock;
@property (nonatomic,copy) JVCHomeIPCErrorBlock                      homeIPCErrorBlock;
@property (nonatomic,copy) JVCHomeIPCFinshedBlock                    homeIPCFinshedBlock;
@property (nonatomic,copy) JVCHomeIPCWriteProgressBlock              homeIPCWriteProgressBlock;
@property (nonatomic,copy) JVCHomeIPCResetBlock                      homeIPCResetBlock;

enum JVCHomeIPCUpdateCheckNewVersionStatus{
    
    JVCHomeIPCUpdateCheckoutNewVersionNew          = 0,  //存在新版本
    JVCHomeIPCUpdateCheckoutNewVersionHighVersion  = 1,  //已经是最新版本
};

enum JVCHomeIPCErrorType {

    JVCHomeIPCErrorUpdateError = 0, //更新出错
    JVCHomeIPCErrorTimeout     = 1, //更新超时
    JVCHomeIPCErrorWriteError  = 2, //烧写出错
};



enum JVCHomeIPCFinshedType{

    JVCHomeIPCFinshedDownload          = 0,  //下载完成
    JVCHomeIPCFinshedWrite             = 1,  //烧写完成
    JVCHomeIPCFinshedCancelDownload    = 2,  //取消下载完成

};

enum JVCHomeIPCResetStatus{
    
    JVCHomeIPCResetSuccess = 0,
    JVCHomeIPCResetError   = 1,
};

/**
 *  初始化连接回调的助手类
 *
 *  @return 连接回调的助手类
 */
-(id)init:(int)deviceType withDeviceModelInt:(int)deviceModelInt withDeviceVersion:(NSString *)strDeviceVersion withYstNumber:(NSString *)ystNumber withLoginUserName:(NSString *)userName;

/**
 *  检查当前的IPC版本是否有更新
 */
-(void)checkIpcIsNewVersion;

/**
 *  下载更新
 */
-(void)DownloadUpdatePacket;

/**
 *  取消下载更新
 */
-(void)CancelDownloadUpdate;

/**
 *  重启设备
 */
-(void)resetDevice;

@end
