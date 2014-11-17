//
//  JVCHomeIPCUpdate.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-17.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCHomeIPCUpdate.h"
#import "JVCDeviceHelper.h"
#import "JVCSystemUtility.h"

@interface JVCHomeIPCUpdate () {

    NSMutableDictionary *mdUpdateInfo;
    NSMutableString     *strVersion;
    int                  nDeviceType;
    int                  nDeviceModelInt;
    NSMutableString     *strYstNumber;
    NSMutableString     *strLoginUserName;
    __block int          nDownloadSize;
    __block int          nWriteSize;
    __block BOOL         isCancelDownload;
}

@end

@implementation JVCHomeIPCUpdate
@synthesize homeIPCUpdateCheckVersionStatusBlock;
@synthesize homeIPCDownloadUpdateProgressBlock;
@synthesize homeIPCErrorBlock;
@synthesize homeIPCFinshedBlock;
@synthesize homeIPCWriteProgressBlock;
@synthesize homeIPCResetBlock;

static const int  kKeepDownloadErrorCount = 6;   //持续下载出错的次数
static const int  kDownloadMaxSize        = 100; //下载最大的值
static const int  kDownloadMinSize        = 0;   //下载最小的值
static const int  kWriteMaxSize           = 100; //烧写最大的值
static const int  kWriteMinSize           = 0;   //烧写最小的值
static const int  kCancelDownloadTime     = 40;   //退出下载线程的时间间隔（毫秒级）

/**
 *  初始化连接回调的助手类
 *
 *  @return 连接回调的助手类
 */
-(id)init:(int)deviceType withDeviceModelInt:(int)deviceModelInt withDeviceVersion:(NSString *)strDeviceVersion withYstNumber:(NSString *)ystNumber withLoginUserName:(NSString *)userName{
    
    if (self = [super init]) {
        
        mdUpdateInfo      = [[NSMutableDictionary alloc] initWithCapacity:10];
        strVersion        = [[NSMutableString alloc]     initWithCapacity:10];
        strYstNumber      = [[NSMutableString alloc]     initWithCapacity:10];
        strLoginUserName  = [[NSMutableString alloc]     initWithCapacity:10];
        nDeviceType       = deviceType;
        nDeviceModelInt   = deviceModelInt;
        [strVersion appendString:strDeviceVersion];
        [strYstNumber appendString:ystNumber];
        [strLoginUserName appendString:userName];
        
        isCancelDownload  = FALSE;
        [self checkIpcIsNewVersion];
    }
    
    return self;
}

/**
 *  检查当前的IPC版本是否有更新
 */
-(void)checkIpcIsNewVersion{
    
    [mdUpdateInfo removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        JVCDeviceHelper *deviceHelperObj = [JVCDeviceHelper sharedDeviceLibrary];
        
        [mdUpdateInfo setValuesForKeysWithDictionary:[deviceHelperObj checkDeviceUpdateState:nDeviceType deviceModel:nDeviceModelInt deviceVersion:strVersion]];
        
        if (self.homeIPCUpdateCheckVersionStatusBlock) {
            
            self.homeIPCUpdateCheckVersionStatusBlock([[JVCSystemUtility shareSystemUtilityInstance] JudgeGetDictionIsLegal:mdUpdateInfo] == YES ? JVCHomeIPCUpdateCheckoutNewVersionNew : JVCHomeIPCUpdateCheckoutNewVersionHighVersion);
        }
    
    });
}

/**
 *  取消下载更新
 */
-(void)CancelDownloadUpdate {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        JVCDeviceHelper *deviceHelperObj = [JVCDeviceHelper sharedDeviceLibrary];

        [deviceHelperObj deviceUpdateMath:strLoginUserName  deviceUpdateMathType:UPDATEDEVICEMATH_CMD_EXIT deviceGuidStr:strYstNumber updateText:nil downloadSize:0 updateVer:nil];
        
        while (TRUE) {
            
            if (isCancelDownload) {
                
                usleep(kCancelDownloadTime);
                
            }else{
                
                break;
            }
        }
    });
}

/**
 *  下载更新
 */
-(void)DownloadUpdatePacket {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        JVCSystemUtility *systemUtility  = [JVCSystemUtility shareSystemUtilityInstance];
        NSDictionary     *updateInfoMDic = (NSDictionary *)[mdUpdateInfo objectForKey:CONVERTCHARTOSTRING(JK_UPDATE_FILE_INFO)];
        
        if (![systemUtility judgeDictionIsNil:updateInfoMDic]) {
            
            JVCDeviceHelper *deviceHelperObj = [JVCDeviceHelper sharedDeviceLibrary];
            //开始更新
            int resultValue = [deviceHelperObj deviceUpdateMath:strLoginUserName deviceUpdateMathType:UPDATEDEVICEMATH_CMD_UPDATE deviceGuidStr:strYstNumber updateText:[updateInfoMDic objectForKey:CONVERTCHARTOSTRING(JK_UPGRADE_FILE_URL)] downloadSize:[[updateInfoMDic objectForKey:CONVERTCHARTOSTRING(JK_UPGRADE_FILE_SIZE)] intValue] updateVer:[updateInfoMDic objectForKey:CONVERTCHARTOSTRING(JK_UPGRADE_FILE_VERSION)]];
            
            if (resultValue == DEVICESERVICERESPONSE_SUCCESS) {
                
                isCancelDownload = TRUE;
                [self DownloadProgress];
                
            }
        }
    });
}

/**
 *  下载进度
 */
-(void)DownloadProgress {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        JVCDeviceHelper *deviceHelperObj = [JVCDeviceHelper sharedDeviceLibrary];

        int nDownloadErrorCount = 0;
        int dowloadTempValue    = 0;
        
        while (true) {
            
            if (!isCancelDownload) {
                
                break;
            }
            
            nDownloadSize  =  [deviceHelperObj deviceUpdateMath:strLoginUserName deviceUpdateMathType:UPDATEDEVICEMATH_DOWNLOAD_VALUE deviceGuidStr:strYstNumber updateText:nil downloadSize:0 updateVer:nil];;
            
            if (nDownloadSize >= kDownloadMinSize && nDownloadSize <= kDownloadMaxSize) {
                
                if (nDownloadSize != dowloadTempValue) {
                    
                    dowloadTempValue    = nDownloadSize;
                    nDownloadErrorCount = 0;
                    
                    
                }else{
                    
                    nDownloadErrorCount ++;
                    
                    if (nDownloadErrorCount > kKeepDownloadErrorCount) {
                        
                        break;
                    }
                }
                
                //返回到UI层的下载进度
                if (self.homeIPCDownloadUpdateProgressBlock) {
                    
                    self.homeIPCDownloadUpdateProgressBlock(nDownloadSize);
                }
            }
            
            if (nDownloadSize == kDownloadMaxSize) {
                
                break;
                
            }else{
            
                if (nDownloadSize < kDownloadMinSize) {
                    
                    break;
                }
            }
        }
        
        DDLogVerbose(@"%s-----------------009",__FUNCTION__);
        if (isCancelDownload) {
            
            isCancelDownload = FALSE;
            
            if (nDownloadSize == kDownloadMaxSize) {
                
                [self finshedType:JVCHomeIPCFinshedDownload];
                [self updateDevice];
                
            }else {
                
                [self errorType:JVCHomeIPCErrorUpdateError];
            }
            
        }else{
            
            [self finshedType:JVCHomeIPCFinshedCancelDownload];
        
        }
       
    });
}

/**
 *  更新设备
 */
-(void)updateDevice{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        JVCDeviceHelper *deviceHelperObj = [JVCDeviceHelper sharedDeviceLibrary];
        
        int nWriteErrorCount = 0;
        int writeTempValue   = -2;
        
        while (true) {
            
            nWriteSize = [deviceHelperObj deviceUpdateMath:strLoginUserName  deviceUpdateMathType:UPDATEDEVICEMATH_WRITE_VALUE deviceGuidStr:strYstNumber updateText:nil downloadSize:0 updateVer:nil];
            
            
            if (nWriteSize >= kWriteMinSize && nWriteSize <= kWriteMaxSize) {
                
                if (nWriteSize != writeTempValue) {
                    
                    writeTempValue    = nWriteSize;
                    nWriteErrorCount  = 0;
                    
                    
                }else{
                    
                    nWriteErrorCount ++;
                    
                    if (nWriteErrorCount > kKeepDownloadErrorCount) {
                        
                        break;
                    }
                }
                
                //返回到UI层的下载进度
                if (self.homeIPCWriteProgressBlock) {
                    
                    self.homeIPCWriteProgressBlock(nWriteSize);
                }
            }
            
            if (nWriteSize == kWriteMaxSize) {
                
                break;
                
            }else{
                
                if (nWriteSize < kWriteMinSize) {
                    
                    break;
                }
            }
        }
        
        if (nWriteSize == kWriteMaxSize) {
            
            [self finshedType:JVCHomeIPCFinshedWrite];
            
        }else {
            
            [self errorType:JVCHomeIPCErrorWriteError];
        }
        
    });
}

/**
 *  重启设备
 */
-(void)resetDevice {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
        JVCDeviceHelper *deviceHelperObj = [JVCDeviceHelper sharedDeviceLibrary];
        
        int result  = [deviceHelperObj deviceUpdateMath:strLoginUserName  deviceUpdateMathType:UPDATEDEVICEMATH_CMD_REBOOT deviceGuidStr:strYstNumber updateText:nil downloadSize:0 updateVer:nil];
        
        if (self.homeIPCResetBlock) {
            
            self.homeIPCResetBlock(result == DEVICESERVICERESPONSE_SUCCESS ? JVCHomeIPCResetSuccess : JVCHomeIPCResetError);
        }
    
    });

}

/**
 *  更新出错的回调block
 *
 *  @param errorType 出错的类型
 */
-(void)errorType:(int)errorType {

    if (self.homeIPCErrorBlock) {
        
        self.homeIPCErrorBlock(errorType);
    }
}

/**
 *  操作结束的回调block
 *
 *  @param type
 */
-(void)finshedType:(int)type {

    if (self.homeIPCFinshedBlock) {
        
        self.homeIPCFinshedBlock(type);
    }

}

-(void)dealloc {

    [homeIPCDownloadUpdateProgressBlock release];
    [homeIPCUpdateCheckVersionStatusBlock release];
    [homeIPCErrorBlock release];
    [homeIPCFinshedBlock release];
    [homeIPCWriteProgressBlock  release];
    [homeIPCResetBlock release];
    [mdUpdateInfo release];
    [strLoginUserName release];
    [strYstNumber release];
    [strVersion release];
    [super dealloc];
}

@end
