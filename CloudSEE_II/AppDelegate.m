//
//  AppDelegate.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-22.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "JVCLoginViewController.h"
#import "JVCAccountHelper.h"
#import "JVCSystemUtility.h"



static  NSString *const ACCOUNTSERVICELOG     =   @"accountServiceLog.md";


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /**
     *  设置ddlog
     */
    [self DDLogSettings];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //设置导航
    JVCLoginViewController *loginVC = [[JVCLoginViewController alloc] init];
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = rootNav;
    [loginVC release];
    [rootNav release];
    
    /**
     *  初始化账号SDK
     */
    [self intiAccountSDKWithIsLocalCheck];
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


/**
 *  初始化账号服务器域名
 *
 *  @param state TRUE  :忽略本地缓存解析IP,为TRUE的时候不会在调用初始化SDK和设置超时的函数
 */
- (int)intiAccountSDKWithIsLocalCheck {
    
    NSArray *pathsAccount=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *pathAccountHome=[pathsAccount objectAtIndex:0];
    
    NSString * pathAccount=[pathAccountHome stringByAppendingPathComponent:ACCOUNTSERVICELOG];
    
//    NSString *APPCHANNELSERVICEADDRESSPATHPATH =[pathAccountHome stringByAppendingPathComponent:LOCALANGER(@"APPCHANNELSERVICEADDRESS")];
//    
//    NSString *AccountAPPONLINESERVICEADDRESSPATH =[pathAccountHome stringByAppendingPathComponent:LOCALANGER(@"APPONLINESERVICEADDRESS")];
    
    NSString *APPCHANNELSERVICEADDRESSPATHPATH =[pathAccountHome stringByAppendingPathComponent:@"appchannelen.afdvr.com"];
    
    NSString *AccountAPPONLINESERVICEADDRESSPATH =[pathAccountHome stringByAppendingPathComponent:@"apponlineen.afdvr.com"];

    int result = [self InitSdk:pathAccount
                       channelServerAddressStr:@"appchannelen.afdvr.com"
                       channelServerAddressStrLocalPath:APPCHANNELSERVICEADDRESSPATHPATH
                       onlineServerAddressStr:@"apponlineen.afdvr.com"
                       onlineServerAddressStrLocalPath:AccountAPPONLINESERVICEADDRESSPATH
                       islocalCheck:NO
                       isLogAppend:YES];
    
    DDLogInfo(@"=%s=注册账号收到的返回值=%d==%@",__FUNCTION__,result,NSLocalizedString(@"APPCHANNELSERVICEADDRESS", nil));
    
    return result;
}


-(int)InitSdk:(NSString *)sdkLogPath  channelServerAddressStr:(NSString *)channelServerAddressStr channelServerAddressStrLocalPath:(NSString *) channelServerAddressStrLocalPath onlineServerAddressStr:(NSString *)onlineServerAddressStr onlineServerAddressStrLocalPath:(NSString *)onlineServerAddressStrLocalPath islocalCheck:(BOOL)islocalCheck isLogAppend:(BOOL)isLogAppend{
    
    NSMutableString *mstrChannelServerPath=nil;
    
    NSMutableString *mstronlineServerPath=nil;
    
    [mstrChannelServerPath deleteCharactersInRange:NSMakeRange(0, [mstrChannelServerPath length])];
    
    [mstronlineServerPath deleteCharactersInRange:NSMakeRange(0, [mstronlineServerPath length])];
    
    [mstrChannelServerPath appendString:channelServerAddressStrLocalPath];
    [mstronlineServerPath appendString:onlineServerAddressStrLocalPath];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if (!isLogAppend) {
        
        [fileManager removeItemAtPath:sdkLogPath error:nil];
    }
    
    if (!islocalCheck) {
        
        NSMutableString *mstrChannelServer = [NSMutableString stringWithCapacity:10];
        
        NSMutableString *mstronlineServer = [NSMutableString stringWithCapacity:10];
        
        if ([[JVCSystemUtility shareSystemUtilityInstance] checkLocalFileExist:channelServerAddressStrLocalPath]) {
            
            NSData *channelServerAddressData=[NSData dataWithContentsOfFile:channelServerAddressStrLocalPath];
            
            
            NSString *strChannelServer=[[NSString alloc] initWithData:channelServerAddressData encoding:NSUTF8StringEncoding];
            
            [mstrChannelServer appendString:strChannelServer];
            
            
            [strChannelServer release];
            
            if ([[JVCSystemUtility shareSystemUtilityInstance] checkLocalFileExist:onlineServerAddressStrLocalPath]) {
                
                NSData *onlineServerAddressData=[NSData dataWithContentsOfFile:onlineServerAddressStrLocalPath];
                
                NSString *stronlineServerAddress=[[NSString alloc] initWithData:onlineServerAddressData encoding:NSUTF8StringEncoding];
                
                
                [mstronlineServer appendString:stronlineServerAddress];
                
                [stronlineServerAddress release];
                
                
                return [[JVCAccountHelper sharedJVCAccountHelper] InitSdk:sdkLogPath channelServerAddressStr:mstrChannelServer onlineServerAddressStr:mstronlineServer islocalCheck:islocalCheck isSetAddress:TRUE];
                
            }
            
        }
        
    }
    
    return [[JVCAccountHelper sharedJVCAccountHelper] InitSdk:sdkLogPath channelServerAddressStr:channelServerAddressStr onlineServerAddressStr:onlineServerAddressStr islocalCheck:islocalCheck isSetAddress:FALSE];
    
}

- (void)DDLogSettings
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];// 启用颜色区分
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.maximumFileSize = 1024 * 512;    // 512 KB
    fileLogger.rollingFrequency = 60*60*24;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];

}


@end
