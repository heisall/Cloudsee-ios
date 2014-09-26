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
#import "JVCRootTabarViewControllersHelper.h"
#import "JVCRGBHelper.h"
#import "AHReach.h"
#import "JVCConfigModel.h"
//#import "JVCAppHelper.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /**
     *  设置ddlog
     */
    [self DDLogSettings];
    
    
    JVCRGBHelper *rgbHelper      = [JVCRGBHelper shareJVCRGBHelper];
    
    UIColor *navBackgroundColor  = [rgbHelper rgbColorForKey:kJVCRGBColorMacroNavBackgroundColor];
    
    /**
     *  设置导航条的颜色值
     */
    if (navBackgroundColor) {
        
         [[UINavigationBar appearance] setBarTintColor:navBackgroundColor];
    }
    
    UIColor *navtitleFontColor = [rgbHelper rgbColorForKey:kJVCRGBColorMacroTabarTitleFontColor];
    
    /**
     *  设置全局的导航条字体颜色
     */
    if (navtitleFontColor) {
        
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:navtitleFontColor, UITextAttributeTextColor,navtitleFontColor, UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,[UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,nil]];
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    UIColor *viewDefaultColor = [rgbHelper rgbColorForKey:kJVCRGBColorMacroWhite];
    
    if (viewDefaultColor) {
        
         self.window.backgroundColor = viewDefaultColor;
    }
   
    [self.window makeKeyAndVisible];
    
    //设置导航
    JVCLoginViewController *loginVC = [[JVCLoginViewController alloc] init];
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = rootNav;
    [loginVC release];
    [rootNav release];
    
    //设置默认情况为初始化sdk失败，初始化成功之后，置换成成功
    [JVCConfigModel shareInstance]._bInitAccountSDKSuccess = -1;
    
    //初始化sdk
    [self initAHReachSetting];
    
    return YES;
}

/**
 *  初始化TabarViewControllers
 */
-(void)initWithTabarViewControllers{
    
    JVCRootTabarViewControllersHelper *rootTabarHelper = [[JVCRootTabarViewControllersHelper alloc] init];
    NSArray *viewControllers = [rootTabarHelper initWithTabarViewControllers];
    [viewControllers retain];
    
    UITabBarController *rootViewController=[[UITabBarController alloc] init];
    rootViewController.viewControllers=viewControllers;
    [viewControllers release];
    [rootTabarHelper release];
    
    JVCRGBHelper *rgbHelper = [JVCRGBHelper shareJVCRGBHelper];
    
    UIColor *tabBarBackgroundColor = [rgbHelper rgbColorForKey:kJVCRGBColorMacroTabarTitleFontColor];
    
    if (tabBarBackgroundColor) {
        
        rootViewController.tabBar.backgroundColor = tabBarBackgroundColor;
    }
    
    self.window.rootViewController = rootViewController;
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

#pragma mark 初始化网路检测
- (void)initAHReachSetting
{
    AHReach *hostReach = [AHReach reachForHost:LOCALANGER(@"AHReach_url")];
    
    [hostReach startUpdatingWithBlock:^(AHReach *reach) {
        
        
		[self updateAvailabilityStatus:reach];
	}];
    /**
     *  初始化账号SDK
     */
    [self updateAvailabilityStatus:hostReach];
}
/**
 *  更新设备的网络状态的变化
 *
 *  @param reach 网络参数对象
 */
-(void)updateAvailabilityStatus:(AHReach *)reach {
    
    
    [JVCConfigModel shareInstance]._netLinkType = NETLINTYEPE_NONET;
    
    if([reach isReachableViaWWAN]){
        
        [JVCConfigModel shareInstance]._netLinkType = NETLINTYEPE_3G;
    }
	if([reach isReachableViaWiFi]){
        
		[JVCConfigModel shareInstance]._netLinkType = NETLINTYEPE_WIFI;
    }
    DDLogInfo(@"[JVCConfigModel shareInstance]._netLinkType =%d",[JVCConfigModel shareInstance]._netLinkType );
    
    if ([JVCConfigModel shareInstance]._netLinkType != NETLINTYEPE_NONET && [JVCConfigModel shareInstance]._bInitAccountSDKSuccess !=0) {
        
       int result  =   [[JVCAccountHelper sharedJVCAccountHelper] intiAccountSDKWithIsLocalCheck:NO];
        
        if ( result == 0) {
            
            [JVCConfigModel shareInstance]._bInitAccountSDKSuccess = 0;
        }
        
        DDLogInfo(@"%s---- hahha....==%d",__FUNCTION__,result);

    }
    
}

@end
