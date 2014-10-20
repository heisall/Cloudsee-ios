//
//  JVCAppHelper.m
//  CloudSEE_II
//  应用程序公共方法
//  Created by chenzhenyang on 14-9-24.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCAppHelper.h"
#import "JVCAccountHelper.h"
#import "JVCSystemUtility.h"
#import <SystemConfiguration/CaptiveNetwork.h>


@implementation JVCAppHelper

static JVCAppHelper *jvcAppHelper = nil;

static NSString const  *kSSIDWithKeyValue          = @"SSID"; //获取当前手机连接无线网络的SSID
static NSString const  *kHomeIPCSSIDWithIndexKey   = @"IPC-"; //家用IPC热点的前缀
static const int        kHomeIPCSSIDWithMinLength  = 6;       //家用IPC热点的最小长度

/**
 *  单例
 *
 *  @return 返回JVCAppHelper的单例
 */
+ (JVCAppHelper *)shareJVCAppHelper
{
    @synchronized(self)
    {
        if (jvcAppHelper == nil) {
            
            jvcAppHelper = [[self alloc] init];
            
        }
        return jvcAppHelper;
    }
    return jvcAppHelper;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (jvcAppHelper == nil) {
            
            jvcAppHelper = [super allocWithZone:zone];
            
            return jvcAppHelper;
        }
    }
    return nil;
}

/**
 *  获取指定索引View在矩阵视图中的位置
 *
 *  @param SuperViewWidth 父视图的宽
 *  @param viewCGRect     子视图的坐标
 *  @param nColumnCount   一列几个元素
 *  @param viewIndex      矩阵中的索引 （从1开始）
 */
-(void)viewInThePositionOfTheSuperView:(CGFloat)SuperViewWidth viewCGRect:(CGRect &)viewCGRect  nColumnCount:(int)nColumnCount viewIndex:(int)viewIndex{
	
    CGFloat viewWidth  = viewCGRect.size.width;
    CGFloat viewHeight = viewCGRect.size.height;
    
    float spacing = (SuperViewWidth - viewWidth*nColumnCount ) / (nColumnCount + 1);
    
    int column    =  viewIndex % nColumnCount; // 1
    int row       =  viewIndex / nColumnCount; // 0
    
    if (column != 0 ) {
        
        row = row + 1;
        
    }else {
        
        column = nColumnCount;
    }
    
    viewCGRect.origin.x = spacing * column + viewWidth  * (column -1);
    viewCGRect.origin.y = spacing * row    + viewHeight * (row -1);
}

/**
 *  复制View的函数
 *
 *  @param templateView 模板View
 *
 *  @return 复制出的View
 */
-(UIView *)duplicate:(UIView *)templateView{

    NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:templateView];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

/**
 *  获取当前Wifi的SSid （需要引入#import <SystemConfiguration/CaptiveNetwork.h>）
 *
 *  @return 当前手机连接的热点
 */
-(NSString *)currentPhoneConnectWithWifiSSID {
    
    NSString *ssid = nil;
    
    NSArray *ifs = (id)CNCopySupportedInterfaces();
    
    for (NSString *ifnam in ifs) {
        
        NSDictionary *info = (id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
        
        if (info[kSSIDWithKeyValue]) {
            
            ssid = info[kSSIDWithKeyValue];
        }
    }
    
    return ssid;
}

/**
 *  判断当前连接的设备的无线网络是否是家用设备的无线热点
 *
 *  @return YES：是 NO:否
 */
-(BOOL)currentPhoneConnectWithWifiSSIDIsHomeIPC {
    
    
    NSString *ssid = [self currentPhoneConnectWithWifiSSID];
    
    [ssid retain];
    
    if (ssid.length < kHomeIPCSSIDWithMinLength) {
        
        [ssid release];
        return FALSE;
    }
    
    NSString *headStr = [ssid substringToIndex:kHomeIPCSSIDWithIndexKey.length];
    
    NSArray *arrayContran = [NSArray arrayWithObjects:(NSString *)kHomeIPCSSIDWithIndexKey,nil];
    
    if ([arrayContran containsObject:headStr]) {
        
        [ssid release];
        return TRUE;
    }
    
    [ssid release];
    
    return FALSE;
}

@end
