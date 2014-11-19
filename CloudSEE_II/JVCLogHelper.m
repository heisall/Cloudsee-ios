//
//  JVCLogHelper.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-19.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCLogHelper.h"
#import "JVCSystemUtility.h"

@implementation JVCLogHelper

FILE *appLogHandle    = NULL;
FILE *deviceLogHandle = NULL;
FILE *LoginLogHandle  = NULL;

static JVCLogHelper *jvcLogHelper = nil;

/**
 *  初始化颜色的辅助类
 *
 *  @return 颜色助手类对象
 */
-(id)init {
    
    if (self = [super init]) {
        
        JVCSystemUtility  *systemUtility = [JVCSystemUtility shareSystemUtilityInstance];

        appLogHandle = fopen([[systemUtility getDocumentpathAtFileName:(NSString *)kAppLogPath] UTF8String], "ab+");
        deviceLogHandle = fopen([[systemUtility getDocumentpathAtFileName:(NSString *)kDeviceManagerLogPath] UTF8String], "ab+");
        LoginLogHandle = fopen([[systemUtility getDocumentpathAtFileName:(NSString *)kLoginManagerLogPath] UTF8String], "ab+");
    }
    
    return self;
}

/**
 *  单例
 *
 *  @return 返回JVCRGBHelper的单例
 */
+ (JVCLogHelper *)shareJVCLogHelper
{
    @synchronized(self)
    {
        if (jvcLogHelper == nil) {
            
            jvcLogHelper = [[self alloc] init];
        }
        
        return jvcLogHelper;
    }
    return jvcLogHelper;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (jvcLogHelper == nil) {
            
            jvcLogHelper = [super allocWithZone:zone];
            
            return jvcLogHelper;
        }
    }
    return nil;
}

/**
 *  打开文件写入流句柄并写入数据
 *
 *  @param buffer 写入的数据
 *  @param nSize  写入数据的大小
 */
-(void)writeDataToFile:(NSString *)text  fileType:(int)type{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        switch (type) {
                
            case LogType_OperationPLayLogPath:
                [self writeHandleDataToFile:text handleType:appLogHandle];
                break;
            case LogType_DeviceManagerLogPath:
                [self writeHandleDataToFile:text handleType:deviceLogHandle];
                break;
            case LogType_LoginManagerLogPath:
                [self writeHandleDataToFile:text handleType:LoginLogHandle];
                break;
                
            default:
                break;
        }
        
    });
}

/**
 *  关闭文件写入流句柄
 */
-(void)close{
    
    if (NULL != appLogHandle) {
        
        fclose(appLogHandle);
        
        appLogHandle = NULL;
    }
}

/**
 *  往指定的handle写数据
 *
 *  @param dateString 写入的数据
 *  @param fileHandle file名称
 */
-(void)writeHandleDataToFile:(NSString *)dateString  handleType:(FILE *)fileHandle
{
    if (NULL != fileHandle) {
        
        switch (JVCLogHelperLevel) {
                
            case JVCLogHelperLevelRelease:{
                
                /**
                 *  解决时差相差8个小时的问题
                 */
                NSTimeZone *localZone =[NSTimeZone systemTimeZone];
                NSDate  *timestamp = [NSDate date];
                NSUInteger interval =[localZone secondsFromGMTForDate:timestamp];
                NSDate *date  = [timestamp dateByAddingTimeInterval:interval];
                
                NSString *writeStr= [NSString stringWithFormat:@"%@%@\n",date,dateString];
                
                flockfile(fileHandle);
                fwrite([writeStr UTF8String],1,writeStr.length, fileHandle);
                fflush(fileHandle);
                funlockfile(fileHandle);
                
            }
                break;
                
            default:
                break;
        }
    }
}

@end
