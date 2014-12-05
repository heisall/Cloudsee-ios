//
//  JVCLogHelper.h
//  CloudSEE_II
//  用于日志写文件函数
//  Created by chenzhenyang on 14-11-19.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int JVCLogHelperLevel;
static NSString const *kAppLogPath           = @"applog.md";
static NSString const *kDeviceManagerLogPath = @"DeviceManagerLog.md";//设备log
static NSString const *kLoginManagerLogPath  = @"LoginManagerLog.md"; //登录的log
static NSString const *kCloudSEELogPath      = @"temperrolog.md";     //登录的log
static NSString const *kCloudSEECatchCrash   = @"CatchCrash.md";      //崩溃的
static NSString const *kYstNumberPath        = @"ystnumber.md";      //缓存的老设备的文件

static NSString const *kYstNumberFlag        = @"|";      //缓存的老设备的文件
@interface JVCLogHelper : NSObject


enum JVCLogHelperLevel {
    
    JVCLogHelperLevelDubug   = 0,
    JVCLogHelperLevelRelease = 1,
};

typedef NS_ENUM(int, LogType)
{
    LogType_OperationPLayLogPath            = 0,  //系统的
    LogType_DeviceManagerLogPath            = 1,  //设备的
    LogType_LoginManagerLogPath             = 2,  //登录的
    LogType_CatchCrash                      = 3,  //异常的
    LogType_ystNumber                       = 4,  //云视通号

};

/**
 *  单例
 *
 *  @return 返回JVCRGBHelper的单例
 */
+ (JVCLogHelper *)shareJVCLogHelper;

/**
 *  打开文件举报并写数据
 *
 *  @param text 内容
 *  @param type 文件类型
 */
-(void)writeDataToFile:(NSString *)text  fileType:(int)type;

/**
 *  关闭文件写入流句柄
 */
-(void)close;

/**
 *  判断缓存的老设备的云视通号是否存在
 *
 *  @param ystNUmber 云视通号
 */
-(BOOL)checkYstNumberIsInYstNumbers:(NSString *)ystNumber;

@end
