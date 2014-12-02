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
#import "sys/utsname.h"
@implementation JVCSystemUtility

static NSString const  *kSSIDWithKeyValue          = @"SSID"; //获取当前手机连接无线网络的SSID
static NSString const  *kHomeIPCSSIDWithIndexKey   = @"IPC-"; //家用IPC热点的前缀
static const int        kHomeIPCSSIDWithMinLength  = 6;       //家用IPC热点的最小长度
static NSString const  *APPLANGUAGE                = @"zh-Hans";//简体中文的标志
static NSString const  *KOldUserPlist              = @"userInfo.plist";//简体中文的标志
static NSString const *kDateTimeFormatter          = @"HH:mm";
static const NSString *KDateFormatterReseive       = @"HH:mm:ss";


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
    if ([self judgeDictionIsNil:dicInfo]) {
        return NO;
    }
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
    
    NSDate *configDate = [NSDate dateWithTimeIntervalSince1970:timerCurrentInt];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger intervaldd = [zone secondsFromGMTForDate: configDate];
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *returnTimerString = [formatter stringFromDate:configDate];
    [formatter release];
    return returnTimerString;
}

/**
 *  根据时间，获取当前时间
 *
 *  @param stringTimer 时间截
 *
 *  @return 时间
 */
- (NSString *)getTimerWithTimerString:(NSString *)stringTimer
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    inputFormatter.locale = [NSLocale currentLocale];
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate* inputDate = [inputFormatter dateFromString:stringTimer];
    [inputFormatter release];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [outputFormatter stringFromDate:inputDate];
    [outputFormatter release];
    return str;
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

//返回保存用户名密码的plist路径
- (NSString *)getUserInfoPlistPath
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *tPath = [NSString stringWithFormat:@"%@/%@",docPath,KOldUserPlist];
    return tPath;
}

//返回保存用户名密码的plist路径
- (BOOL )removeOldUserPlist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *pathString = [self getUserInfoPlistPath];
    NSError *error;
    if ([fileManager fileExistsAtPath:pathString]) {
        
        [fileManager removeItemAtPath:pathString error:&error];
        if (error) {
            DDLogVerbose(@"%s==%@",__FUNCTION__,error);
            return NO;
        }
    }
    return YES;
}

/**
 *  根据文件名称 返回在document目录下面的路径
 *
 *  @param fileName 文件名称
 *
 *  @return 路径
 */
-(NSString *)getDocumentpathAtFileName:(NSString *)fileName {

    
    NSArray  *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *path= [paths objectAtIndex:0];
    
   return [path stringByAppendingPathComponent:fileName];
}

/**
 *  获取设备类型
 *
 *  @return 设备类型
 */
- (NSString*)getDeviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

/**
 *  设备类型
 *
 *  @return 设备类型
 */
- (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
   
    if ([platform isEqualToString:@"iPhone5,3"]|| [platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";

     if ([platform isEqualToString:@"iPhone6,2"]|| [platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";

    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 plus";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    
    
    return @"iphone";
    
}

/**
 *  再document目录下面创建文件夹
 *
 *  @param fileName 文件目录
 */
- (NSString *)creatDirectoryAtDocumentPath:(NSString *)fileName
{
    NSString *imageDir = [NSString stringWithFormat:@"%@/%@", [self getAppDocumentsPath], fileName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return imageDir;
}

/**
 *  把小时的字符串转为时间格式
 *
 *  @param strTime 当前的时间
 *
 *  @return 小时日期格式
 */
-(NSDate *)strHoursConvertDateHours:(NSString *)strTime{
    
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:(NSString *)kDateTimeFormatter];

    NSDate *date = [dateFormatter dateFromString:strTime];
    
    [dateFormatter release];
    
    
    return date;
}

/**
 *  把小时的字符串转为时间格式(精确到秒)
 *
 *  @param strTime 当前的时间
 *
 *  @return 小时日期格式
 */
-(NSDate *)strHoursSecondsConvertDateHours:(NSString *)strTime{
    
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:(NSString *)KDateFormatterReseive];
    
    NSDate *date = [dateFormatter dateFromString:strTime];
    
    [dateFormatter release];
    
    
    return date;
}

/**
 *  把小时的时间转为字符串时间格式
 *
 *  @param dateTime 当前选择的时间
 *
 *  @return 小时日期格式
 */
-(NSString *)DateHoursConvertStrHours:(NSDate *)dateTime{
    
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:(NSString *)kDateTimeFormatter];
    
    NSString *strDate = [dateFormatter stringFromDate:dateTime];
    
    [dateFormatter release];
    
    return strDate;
}

@end
