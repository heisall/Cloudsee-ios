//
//  AppDelegate.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-22.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "JVCLoginViewController.h"
#import "JVCSystemUtility.h"
#import "JVCRGBHelper.h"
#import "AHReach.h"
#import "JVCConfigModel.h"
//#import "JVCAppHelper.h"

#import "JVCEditDeviceListViewController.h"
#import "JVCDeviceListViewController.h"
#import "JVCAlarmMessageViewController.h"
#import "JVCMoreViewController.h"
#import "GlView.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCChannelScourseHelper.h"
#import "JVCLANScanWithSetHelpYSTNOHelper.h"
#import "JVCDefaultViewController.h"
#import "JVCKeepOnlineHelp.h"
#import "UINavigationBar+JVCCustomNavBar.h"

#import "JVCAPConfigViewController.h"
#import "JVCApConfigPlayVideoViewController.h"
#import "JVCApConfigDeviceViewController.h"
#import "JVCAlertHelper.h"
#import "JVCSystemUtility.h"
#import "JVCAlarmModel.h"
#import "JVCOperationController.h"
#import "JVCOperationControllerIphone5.h"
#import "JVCAlarmCurrentView.h"
#import "JVCOperationController.h"
#import "JVCLocalDeviceDateBaseHelp.h"
#import "JVCSignleAlarmDisplayView.h"
#import "JVCURlRequestHelper.h"
#import "MTA.h"
#import "MTAConfig.h"
#import "JVCConstansALAssetsMathHelper.h"
#import "JVCMediaMacro.h"
#import "JVCLogHelper.h"

#import "JVCTencentHelp.h"
#import "JVCDeviceMacro.h"

@interface AppDelegate ()
{
    JVCDeviceListViewController     *deviceListController; //设备管理界面
    NSMutableString                 *selectedSSID;
    JVCAlarmMessageViewController   *alarmMessageViewController;
    JVCEditDeviceListViewController *editDeviceViewController;
}

@end

static const int  kTableBarDefaultSelectIndex = 0;//tabbar默认选择
static const NSTimeInterval  KAfterDelayTimer = 3;//3秒延时

int JVCLogHelperLevel                         = JVCLogHelperLevelRelease;  //输出热i
int JVCTencentLeveal                          = JVCTencentTypeClose;      //广告位的
int AdverTypeLocation                         = AdverTypeLocation_iPhone; //广告位的


int AdverType                                 = AdverType_Cloud;
@implementation AppDelegate
@synthesize _amOpenGLViewListData;
@synthesize QRViewController;
@synthesize localtionString;

static NSString const *kAPPLocalCaheKey          = @"localDeviceListData";
static  const   int    KSetHelpMaxCount          = 5;
static  const   int    KCheckLocationRequestTime = 5;
static NSString const *KCheckLocationFlag        = @"中国";
static NSString const *KCheckLocationURL         = @"http://int.dpool.sina.com.cn/iplookup/iplookup.php";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /**
     *  设置ddlog
     */
    [self DDLogSettings];
    //初始化位置字符串
    self.localtionString = @"";
    
    [self convertOldUserInfoToDatebase];
    
    [[JVCLocalDeviceDateBaseHelp shareDataBaseHelper] converOldDeviceListInDateFame];
    
    selectedSSID = [[NSMutableString alloc] init];
    
    //云视通
    [self initYSTSDK];
    
    //腾讯云统计
    [self initTencentSdk];
    
    //openglView
    [self initOpenGlView];
    
    //初始化二维码模块
    [self initQRViewController];
    
    //设置设备浏览模式
    [self setDeviceBrowseModel];
    
    //初始化相册
    [self initPhotoAlbum];
    
    //获取报警开关，本地不起作用
    [self getUserAlarmState];
    
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

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    UIColor *viewDefaultColor = [rgbHelper rgbColorForKey:kJVCRGBColorMacroWhite];
    
    if (viewDefaultColor) {
        
         self.window.backgroundColor = viewDefaultColor;
    }
    
    
    JVCDefaultViewController *defaultVC = [[JVCDefaultViewController alloc] init];
    self.window.rootViewController =  defaultVC;
    [defaultVC release];
    
    [self  performSelector:@selector(changeDefaultController) withObject:nil afterDelay:KAfterDelayTimer];

    [self.window makeKeyAndVisible];
    
    //设置默认情况为初始化sdk失败，初始化成功之后，置换成成功
    [JVCConfigModel shareInstance]._bInitAccountSDKSuccess = TYPEINITSDK_DEFAULT;
    
    //初始化sdk
    [self initAHReachSetting];
    
    return YES;
}

- (void)changeDefaultController
{
    //设置导航
    JVCLoginViewController *loginVC = [[JVCLoginViewController alloc] init];
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = rootNav;
    [loginVC release];
    [rootNav release];
    
    [self checkNewVersion];
}

/**
 *  初始化TabarViewControllers
 */
-(void)initWithTabarViewControllers{
    
    if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_ACCOUNT) {//本地登录
        
        [self startUserKeepOnline];
        
    }
    /**
     *	我的设备模块
     */
    deviceListController                              = [[JVCDeviceListViewController alloc] init];
    deviceListController.hidesBottomBarWhenPushed     = FALSE;
    UINavigationController      *deviceNav            = [[UINavigationController alloc] initWithRootViewController:deviceListController];
    [deviceListController release];
    
    /**
     *	报警消息模块
     */
    alarmMessageViewController                                = [[JVCAlarmMessageViewController alloc] init];
    alarmMessageViewController.hidesBottomBarWhenPushed       = FALSE;
    UINavigationController        *alarmMessageViewNav        =[[UINavigationController alloc] initWithRootViewController:alarmMessageViewController];
    [alarmMessageViewController release];
    
    /**
     *	设备管理模块
     */
    editDeviceViewController                                  = [[JVCEditDeviceListViewController alloc] init];
    editDeviceViewController.hidesBottomBarWhenPushed         = FALSE;
    UINavigationController          *editDeviceNav            = [[UINavigationController alloc] initWithRootViewController:editDeviceViewController];
    
    [editDeviceViewController release];
    
    /**
     *	更多模块
     */
    JVCMoreViewController  *moreViewController  = [[JVCMoreViewController alloc] init];
    moreViewController.hidesBottomBarWhenPushed = FALSE;
    UINavigationController *moreNav             = [[UINavigationController alloc] initWithRootViewController:moreViewController];
    [moreViewController release];
    
    
    UITabBarController *rootViewController  = [[UITabBarController alloc] init];
    rootViewController.viewControllers      =  [NSArray arrayWithObjects:deviceNav,alarmMessageViewNav,editDeviceNav,moreNav, nil] ;
    rootViewController.delegate             = self;
    
    if (IOS_VERSION<IOS7) {
        
        NSString *tabbarString = [UIImage imageBundlePath:@"tabbar_bg.png"];
        UIImage *tabbarBgIamge = [[UIImage alloc] initWithContentsOfFile:tabbarString];
        rootViewController.tabBar.backgroundImage = tabbarBgIamge;
        
        NSString *tabbarStringSec = [UIImage imageBundlePath:@"tabSec.png"];
        UIImage *tabbarBgIamgeSec = [[UIImage alloc] initWithContentsOfFile:tabbarStringSec];
        rootViewController.tabBar.selectionIndicatorImage = tabbarBgIamgeSec;
        
        [tabbarBgIamge release];
        [tabbarBgIamgeSec release];
        
        
    }else{
        
        JVCRGBHelper *rgbHelper = [JVCRGBHelper shareJVCRGBHelper];
        UIColor *tabBarBackgroundColor = [rgbHelper rgbColorForKey:kJVCRGBColorMacroTabarTitleFontColor];
        if (tabBarBackgroundColor) {
    
            rootViewController.tabBar.backgroundColor = tabBarBackgroundColor;
        }
        
    }
    self.window.rootViewController = rootViewController ;
    
    [deviceNav release];
    [alarmMessageViewNav release];
    [editDeviceNav release];
    [moreNav release];
    [rootViewController release];
    
}

/**
 *  UITabar的选中委托事件
 *
 *  @param tabBarController 当前的tabBar控制器
 *  @param viewController   当前选择的视图
 */
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *) viewController {
    
    
    if (tabBarController.selectedIndex !=  tabarViewItem_editDevice) {
        
        editDeviceViewController.nIndex = 0;
        
    }
}

/**
 *  重新登录后，初始化TabarViewControllers
 */
-(void)UpdateTabarViewControllers{
    
    //清除弹出来的view
    [alarmMessageViewController removeJVHAlarmShowView];
    
    //关闭报警的
    JVCAlarmCurrentView *viewCurrent = [JVCAlarmCurrentView shareCurrentAlarmInstance];
    [viewCurrent CloseCurrentView];
    
    UITabBarController *tabbar =(UITabBarController *)self.window.rootViewController;
    
    [tabbar setSelectedIndex:kTableBarDefaultSelectIndex];
    
    //清理数据
    [[JVCDeviceSourceHelper shareDeviceSourceHelper] removeAllDeviceObject];
    [[JVCChannelScourseHelper shareChannelScourseHelper]removeAllchannelsObject];
    
    //清理报警信息
    [alarmMessageViewController.arrayAlarmList removeAllObjects];
    
    if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_ACCOUNT) {//非本地登录
        
        [self startUserKeepOnline];
        
        [alarmMessageViewController  headerRereshingDataAlarmDate];
        
    }
    
    for (id idControler in tabbar.viewControllers) {
        
        if ([idControler isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController *navController = (UINavigationController *)idControler;
            [navController popToRootViewControllerAnimated:NO];
        }
    }
    
    [deviceListController getDeviceList];
    
    
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
    
    if ([[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceListArray].count > 0 ) {
        
        [self saveCacheDevicesData];
    }
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
    [fileLogger release];
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
    
    JVCConfigModel *configObj = [JVCConfigModel shareInstance];
    
    int netLinkType = NETLINTYEPE_NONET;
    

    if([reach isReachableViaWWAN]){
        
        netLinkType = NETLINTYEPE_3G;
    }
	if([reach isReachableViaWiFi]){

		netLinkType = NETLINTYEPE_WIFI;
    }
    
    configObj._netLinkType = netLinkType;
    
    if (selectedSSID.length <= 0) {
        
        NSString *current = [[JVCSystemUtility shareSystemUtilityInstance] currentPhoneConnectWithWifiSSID];
        
        if (current.length > 0) {
            
            [selectedSSID appendString:[[JVCSystemUtility shareSystemUtilityInstance] currentPhoneConnectWithWifiSSID]];
        }
        
    }else {
        
        if (![selectedSSID isEqualToString:[[JVCSystemUtility shareSystemUtilityInstance] currentPhoneConnectWithWifiSSID]]) {
            
            [self ssidChangeWithStopApConfigDevce];
        }
    }
    
    if (configObj._netLinkType != NETLINTYEPE_NONET && configObj._bInitAccountSDKSuccess != 0) {
        

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            BOOL isLocation = [self checkLocalLocation];
            
            int result  =   [[JVCAccountHelper sharedJVCAccountHelper] intiAccountSDKWithIsLocalCheck:NO withIslocation:isLocation];
            
            configObj._bInitAccountSDKSuccess = result;
            
            if ( result == 0) {
                
                configObj._bInitAccountSDKSuccess = 0;
            }

        });
    }
}

/**
 *  判断当前手机所在的位置(中国YES:否则是国外)
 *
 */
-(BOOL)checkLocalLocation{
    
    BOOL findStatus = FALSE;
    
    NSURL *url = [NSURL URLWithString:(NSString *)KCheckLocationURL];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KCheckLocationRequestTime];
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    [request release];
    
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString *requsetString = [[NSString alloc]initWithData:received encoding:gbkEncoding];
    
    self.localtionString = requsetString;

    if([requsetString rangeOfString:(NSString *)KCheckLocationFlag].location != NSNotFound)//_roaldSearchText
    {
        findStatus = TRUE;
    }

    [requsetString release];
    
    return findStatus;
}

/**
 *  往报警列表界面中插入一条数据
 *
 *  @param alarmModel alarm数据
 */
- (void)addCurrentAlarmInalarmMessageViewController:(JVCAlarmModel*)alarmModel
{
    [alarmMessageViewController.arrayAlarmList insertObject:alarmModel atIndex:0];
    [alarmMessageViewController removeNoAlarmView];
    [alarmMessageViewController.tableView reloadData];
}

/**
 *  如果在AP配置过程中手机无线网络发生变化，回到根视图重新配置
 */
-(void)ssidChangeWithStopApConfigDevce {
    
    UINavigationController *rootNav = (UINavigationController *)self.window.rootViewController;
    
    if ([rootNav isKindOfClass:[UINavigationController class]]) {
        
        BOOL isCheckAPConfig = FALSE;
        
        for (UIViewController *con in rootNav.viewControllers) {
            
             if ([con isKindOfClass:[JVCApConfigDeviceViewController class]]){
            
                JVCApConfigDeviceViewController  *apConfigDeviceObj = (JVCApConfigDeviceViewController *)con;
                [apConfigDeviceObj stopGetWifiListTimer];
                 
                 isCheckAPConfig = TRUE;
                 
             }else if  ([con isKindOfClass:[JVCApConfigPlayVideoViewController class]]){
                 
                 JVCApConfigPlayVideoViewController  *apConfigPlayVideoObj = (JVCApConfigPlayVideoViewController *)con;
                 
                 isCheckAPConfig = TRUE;
                 
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                     
                     [apConfigPlayVideoObj apConfigDisconnect];
                     
                 });
             }else if  ([con isKindOfClass:[JVCAPConfigViewController class]]){
                 
                 isCheckAPConfig = TRUE;
                 
             }
            
        }
        if (isCheckAPConfig) {
            
            [rootNav popToRootViewControllerAnimated:NO];
            
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"ap_change_net_work", nil)];

        }
        
    }
}

/**
 *  初始化云视通sdk
 */
- (void)initYSTSDK
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    
    JVC_InitSDK(9200, (char *)[path UTF8String]);
    JVD04_InitSDK();
    JVD05_InitSDK();
    InitDecode(); //板卡语音解码
    InitEncode(); //板卡语音编解]
    JVC_EnableHelp(TRUE,3);  //手机端是3
}

/**
 *  初始化opengl的view
 */
- (void)initOpenGlView
{
    NSMutableArray *amOpenGLViewListData=[[NSMutableArray alloc] initWithCapacity:10];
    self._amOpenGLViewListData  =amOpenGLViewListData;
    [amOpenGLViewListData release];
    
    
    for (int i=0; i<OPENGLMAXCOUNT; i++) {
        
        GlView *glView = [[GlView alloc] init];
        [glView initWithDecoderWidth:320.0 decoderHeight:240.0 frameSizeWidth:320.0 frameSizeHeight:240.0];
        [self._amOpenGLViewListData addObject:glView];
        [glView release];
    }

}

/**
 *  注册推送协议
 */
- (void)resignNotificationTypes
{
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *tokenStr = [[[NSString stringWithFormat:@"%@", deviceToken]
                      stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                     stringByReplacingOccurrencesOfString:@" " withString:@""];
    DDLogVerbose(@"tokenStr==%@",tokenStr);
    kkToken = tokenStr;
}
/**
 *  启心跳
 */
-(void)startUserKeepOnline
{
    [[JVCKeepOnlineHelp shareKeepOnline] startKeepOnline];
    
}

/**
 *  获取用户的报警信息字段，与服务器统一
 */
- (void)getUserAlarmState
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kAPPWELCOMEAlarmState];
        [JVCConfigModel shareInstance].bSwitchSafe = NO;
        if (str.length==0) {
            [JVCConfigModel shareInstance].bSwitchSafe = YES;
        }
    });
   
}
/**
 *  presentLoginViewController
 */
- (void)presentLoginViewController
{
    /**
     *  如果显示等待框，直接让其消失
     */
    [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

    UITabBarController *controller = (UITabBarController *)self.window.rootViewController;
    
    for (UIViewController *con in controller.viewControllers) {
        
        if ([con isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController *navCon=(UINavigationController*)con;
            
            for (UIViewController *chView in navCon.viewControllers) {
                
                if ([chView isKindOfClass:[JVCOperationController class]]) {//断开视频连接
                    
                    JVCOperationController *opView = (JVCOperationController *)chView;
                
                    [opView  BackClick];
                 }
            }
        }
    }
    
    JVCLoginViewController *loginVC = [[JVCLoginViewController alloc] init];
    UINavigationController *navLoginVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.window.rootViewController presentModalViewController:navLoginVC animated:YES];
    [loginVC release];
    [navLoginVC release];
    
}

/**
 *  关闭设备列表界面的timer
 */
- (void)stopDeviceListTimer
{
    [deviceListController stopTimer];
}

/**
 *  初始化二维码模块
 */
- (void)initQRViewController
{
    JVCQRCoderViewController *_temp = [[JVCQRCoderViewController alloc] init];
    self.QRViewController = _temp;
    [_temp release];
    
}

/**
 *	缓存前一次登录帐号的历史数据
 */
-(void)saveCacheDevicesData{
    
    NSMutableArray *cacheModelList = [[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceModelListConvertLocalCacheModel];
    
    [cacheModelList retain];
    
    NSMutableArray *saveCacheDeviceListData=[[NSMutableArray alloc] initWithCapacity:10];
    
    for (int i=0; i<cacheModelList.count; i++) {
        
        if (i < KSetHelpMaxCount) {
            
            [saveCacheDeviceListData addObject:[cacheModelList objectAtIndex:i]];
            
        }else{
            
            break;
        }
    }
    
    [cacheModelList release];
    
    NSData *cacheDeviceData=[NSKeyedArchiver archivedDataWithRootObject:saveCacheDeviceListData];
    
    [saveCacheDeviceListData release];
    
    [[NSUserDefaults standardUserDefaults] setObject:cacheDeviceData forKey:(NSString *)kAPPLocalCaheKey];
}

#pragma mark 绑定小助手功能

/**
 *	获取前一次登录帐号的历史数据并开始小助手连接
 */
-(void)startCacheDevicesHelp{
    
    NSData *cacheDatas=[[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kAPPLocalCaheKey];
    
    NSArray *devicesListData=[NSKeyedUnarchiver unarchiveObjectWithData:cacheDatas];
    
    [[JVCLANScanWithSetHelpYSTNOHelper sharedJVCLANScanWithSetHelpYSTNOHelper] setDevicesHelper:devicesListData];
}

/**
 *  返回用户的选择
 *
 *  @param result 用户选择
 */
- (void)JVCAlarmAlarmCallBack:(JVCAlarmModel *)alarmModelSelect
{
    JVCOperationController *tOPVC;
    
    if (![[JVCDeviceSourceHelper shareDeviceSourceHelper] judgeDeviceHasExist:alarmModelSelect.strYstNumber]) {
        
        return;
    }
    
    if (iphone5) {
        
        tOPVC = [[JVCOperationControllerIphone5 alloc] init];
        
    }else
    {
        tOPVC = [[JVCOperationController alloc] init];
        
    }
    
    tOPVC.strSelectedDeviceYstNumber = alarmModelSelect.strYstNumber;
    tOPVC._iSelectedChannelIndex     = 0;
    
    UITabBarController *tabbarController = (UITabBarController *)self.window.rootViewController;
    if (tabbarController) {
        
        UINavigationController *navSelect = [tabbarController.viewControllers objectAtIndex:tabbarController.selectedIndex];
        
        if (navSelect) {
            
            [navSelect pushViewController:tOPVC animated:YES];

        }
    }
    
    [tOPVC release];
}

- (void)dealloc
{
    [QRViewController release];
    QRViewController = nil;
    
    [_amOpenGLViewListData release];
    _amOpenGLViewListData=nil;
    
    [selectedSSID release];
    
    [super dealloc];
}

/**
 *  添加设备广播
 */
- (void)startDeviceLANSerchAllDevice
{
    [deviceListController StartLANSerchAllDevice];
}

- (void)convertOldUserInfoToDatebase
{
    [[JVCUserInfoManager shareUserInfoManager]convertOldUserInfoToDateBase ];
    
}

- (void)checkNewVersion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCURlRequestHelper *jvcRequest = [[[JVCURlRequestHelper alloc] init] autorelease];
        jvcRequest.bShowNetWorkError = YES;
        [jvcRequest requeAppVersion];
    
    });
   
}

/**
 *  注册腾讯云统计
 */
- (void)initTencentSdk
{
  
    [[JVCTencentHelp shareTencentHelp] initTencentSDK];
    
}

/**
 *  初始化相册
 */
- (void)initPhotoAlbum
{
    [JVCConstansALAssetsMathHelper checkAlbumNameIsExist:(NSString *)kKYCustomPhotoAlbumName];
    [JVCConstansALAssetsMathHelper checkAlbumNameIsExist:(NSString *)kKYCustomVideoAlbumName];
//    [JVCConstansALAssetsMathHelper checkAlbumNameIsExist:(NSString *)kKShare_Photo];
}

/**
 *  设置设备浏览模式
 */
- (void)setDeviceBrowseModel
{
   NSString *keyValue =  [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)deviceBrowseModelType];
    
    if (keyValue.length>0) {
        
        [JVCConfigModel shareInstance].iDeviceBrowseModel = YES;
    }

}
@end
