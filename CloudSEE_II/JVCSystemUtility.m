//
//  JVCSystemUtility.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCSystemUtility.h"
#import "JVCDeviceMacro.h"
#import "JVCPredicateHelper.h"
#import <netdb.h>
#import <sys/socket.h>
#import <arpa/inet.h>

@implementation JVCSystemUtility

static NSString const  *kSSIDWithKeyValue          = @"SSID"; //获取当前手机连接无线网络的SSID
static NSString const  *kHomeIPCSSIDWithIndexKey   = @"IPC-"; //家用IPC热点的前缀
static const int        kHomeIPCSSIDWithMinLength  = 6;       //家用IPC热点的最小长度
static NSString const  *APPLANGUAGE = @"zh-Hans";//简体中文的标志

static JVCSystemUtility *shareInstance = nil;


+ (JVCSystemUtility *)shareSystemUtilityInstance
{
    @synchronized(self)
    {
        if (shareInstance == nil) {
            
            shareInstance = [[self alloc] init];
        }
        return shareInstance;
    }
    return shareInstance;
}


+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareInstance == nil) {
            
            shareInstance = [super allocWithZone: zone];
            
            return shareInstance;
        }
    }
    return nil;
}




/**
 *  判断文件是否存在
 *
 *  @param checkFilePath 检查的文件名称
 *
 *  @return 存在返回TRUE
 */
-(BOOL)checkLocalFileExist:(NSString *)checkFilePath{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    return  [fileManager fileExistsAtPath:checkFilePath];
}

/**
 *  获取应用的app的Documents目录
 *
 *  @return 应用的app的Documents目录
 */
- (NSString *)getAppDocumentsPath
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [pathArray objectAtIndex:0];
}

/**
 *  获取应用的app的Caches目录
 *
 *  @return 应用的app的Caches目录
 */
- (NSString *)getAppCachesPath
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [pathArray objectAtIndex:0];
}

/**
 *  获取app的Temp路径
 *
 *  @return app的temp路径
 */
- (NSString *)getAppTempPath
{
    return NSTemporaryDirectory();
}

/**
 *  创建appDocuments下面的目录
 *
 *  @param fileName 文件名称
 *
 *  @return 创建好的应用目录
 */
- (NSString *)getAppDocumentsPathWithName:(NSString *)fileName
{
    NSString *DocumentsPath = [self getAppDocumentsPath];
    
    return [DocumentsPath stringByAppendingPathComponent:fileName];
}

/**
 *  判断字典是不是为空
 *
 *  @param infoId 字典类型的数据
 *
 *  @return yes:空  no：非空
 */
- (BOOL)judgeDictionIsNil:(NSDictionary *)infoId
{
    if (infoId != nil) {
        return NO;
    }
    return YES ;
}

/**
 *  判断收到的字典是否合法，只有再rt字段等于0的时候才是合法
 *
 *  @param dicInfo 传入的字典字段
 *
 *  @return yes：合法  no：不合法
 */
- (BOOL)JudgeGetDictionIsLegal:(NSDictionary *)dicInfo
{
    if (DEVICESERVICERESPONSE_SUCCESS ==  [[dicInfo objectForKey:DEVICE_JSON_RT] intValue]) {
        
        return YES;
    }
    return NO;
}

/**
 *  判断系统的语言
 *
 *  @return yes  中文  no英文
 */
- (BOOL)judgeAPPSystemLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    
    NSString *currentLanguage = [languages objectAtIndex:0];

    if([currentLanguage isEqualToString:(NSString *)APPLANGUAGE])
    {
        return YES;
    }
    return NO;
}

/**
 *  初始化返回按钮
 *
 *  @param event  按下的事件
 *  @param sender 发送对象
 *
 *  @return 返回UIBarButtonItem
 */
- (UIBarButtonItem *)navicationBarWithTouchEvent:(SEL)event  Target:(id)sender
{
    NSString *path= nil;
    
    path = [[NSBundle mainBundle] pathForResource:@"nav_back" ofType:@"png"];
    
    if (path == nil) {
        
        path = [[NSBundle mainBundle] pathForResource:@"nav_back@2x" ofType:@"png"];

    }
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:sender action:event forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    [image release];
    
    return [barButtonItem autorelease];
    
}

/**
 *  随机返回图片路径（基于时间截）
 *
 *  @return 路径
 */
- (NSString *)getRandomPicLocalPath
{
    NSString *appCachePaht = [self getAppDocumentsPath];
    
    NSTimeInterval timerInterval = [[NSDate date] timeIntervalSince1970];
    
    NSString *picString = [NSString stringWithFormat:@"%lf.jpg",timerInterval];
    
    NSString * path=[appCachePaht stringByAppendingPathComponent:picString];
    
    return path;
}

/**
 *  随机返回图片路径（基于时间截）
 *
 *  @return 路径
 */
- (NSString *)getRandomVideoLocalPath
{
    NSString *appCachePaht = [self getAppDocumentsPath];
    
    NSTimeInterval timerInterval = [[NSDate date] timeIntervalSince1970];
    
    NSString *picString = [NSString stringWithFormat:@"%lf.mp4",timerInterval];
    
     NSString * path=[appCachePaht stringByAppendingPathComponent:picString];
    
    return path;
}

/**
 *  根据事件截，获取当前时间
 *
 *  @param timerCurrentInt 时间截
 *
 *  @return 时间
 */
- (NSString *)getCurrentTimerFrom:(int)timerCurrentInt
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timerCurrentInt];    
    NSString *dateString = [formatter stringFromDate:confromTimesp];
    [formatter release];

    return dateString;
}



/**
 *  根据域名获取ip
 *
 *  @param theHost 域名
 *
 *  @return 得到的ip
 */
-(NSString *)getIPAddressForHostString:(NSString *) theHost
{
    char **pptr;
    struct hostent *hptr;
    char str[32];
    
    if(inet_addr([theHost UTF8String]) == 0)
        return theHost;
    
    if ((hptr = gethostbyname([theHost UTF8String])) == NULL)
    {
        return @""; /* 如果调用gethostbyname发生错误，返回1 */
    }
    
    
    NSString *addressString;
    /* 根据地址类型，将地址打出来 */
    switch(hptr->h_addrtype)
    {
        case AF_INET:
            
        case AF_INET6:
            
            pptr=hptr->h_addr_list;
            addressString = [NSString stringWithCString:inet_ntop(hptr->h_addrtype, *pptr, str, sizeof(str)) encoding:NSUTF8StringEncoding];
            DDLogVerbose(@"address = %@",addressString);
            /* 将刚才得到的所有地址都打出来。其中调用了inet_ntop()函数 */
            //         for(;*pptr!=NULL;pptr++)
            //             printf(" address:%s\n", inet_ntop(hptr->h_addrtype, *pptr, str, sizeof(str)));
            break;
        default:
            printf("unknown address type\n");
            break;
    }
    return addressString;
}

/**
 *  获取ip或域名的ip值
 *
 *  @param stringLocal 域名或ip
 *
 *  @return ip地址
 */
- (NSString *)getIpOrNetHostString:(NSString *)stringLocal
{
    NSString *strIp = nil;
    
    if (![[JVCPredicateHelper shareInstance] isIP:stringLocal]) {//域名
        
        strIp = [self getIPAddressForHostString:stringLocal];
    }else{
        
        strIp = stringLocal;
        
    }
    
    return strIp;
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

/**
 *  获取当前的云视通号
 *
 *  @return 云视通号
 */
- (NSString *)getCurrentDeviceYStNUm
{
    if ([self currentPhoneConnectWithWifiSSIDIsHomeIPC]) {
        
        NSString *ssidString = [self currentPhoneConnectWithWifiSSID];
        
        if (ssidString.length>kHomeIPCSSIDWithMinLength) {
            
            NSString *headStr = [ssidString substringFromIndex:kHomeIPCSSIDWithMinLength];
            
            return headStr;
        }
    }
    return nil;
}

/**
 *  打开itunes 评论功能
 */
- (void) openItunsCommet
{
    NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",kAPPIDNUM];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];

}

@end
