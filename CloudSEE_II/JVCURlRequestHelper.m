//
//  JVCURlRequestHelper.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/19/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCURlRequestHelper.h"
#import "JSONKit.h"
#import "JVCConfigModel.h"

@interface JVCURlRequestHelper ()
{
    NSMutableData *receivedata;
}

@end

@implementation JVCURlRequestHelper
@synthesize delegateUrl;
@synthesize bShowNetWorkError;
static  const   NSString *KMODELTYPEGETUPDATEINFO  =  @"1006";//版本号
static  const   NSString  *KVersion =  @"Version";
static  const   NSString  *KRequestType =  @"RequestType";
static  const   NSString  *KRequestTypeValue =  @"3";

static  const   NSString  *KLanguage =  @"Language";
static  const   NSString  *KMobileType=  @"MobileType";
static  const   NSString  *KMobileTypeValue=  @"2";
static const    int        KAnimationTimer  = 5;//超时时间
static const    NSString   *KNUm                       = @"Num";//检测更新的返回值
static const    NSString   *KContentK                  = @"Content";//检测更新的返回值
static const    NSString   *KCFBundleVersion           = @"CFBundleVersion";//版本号
static const    int        kAlertNEWVersionTag         = 3000;   //新版本的tag

static const  NSString * KSErVER_URl_VERSION_HEADER  = @"http://wmap.yoosee.cc/MobileWeb.aspx";//请求版本更新的

- (void)initReceiveDate
{
    receivedata = [[NSMutableData alloc] init];
}

/**
 *  请求appVersion
 */
- (void)requeAppVersion
{
    [self initReceiveDate];
    
    if (!self.bShowNetWorkError) {
        [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];

    }
    
    NSMutableDictionary *paramer = [[NSMutableDictionary alloc] init];
    [paramer setObject:KRequestTypeValue forKey:KRequestType];
    if ([[JVCSystemUtility shareSystemUtilityInstance]judgeAPPSystemLanguage]) {
        [paramer setObject:@"1" forKey:KLanguage];
    }else{
        [paramer setObject:@"2" forKey:KLanguage];
    }
    [paramer setObject:KMODELTYPEGETUPDATEINFO forKey:KVersion];
    [paramer setObject:KMobileTypeValue forKey:KMobileType];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",KSErVER_URl_VERSION_HEADER,[self getRequestKeyString: paramer]]]];
    [request setTimeoutInterval:KAnimationTimer];
    
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self] ;
    
   
    [request release];
    
    if (connect) {
        
        [receivedata resetBytesInRange:NSMakeRange(0, [receivedata length])];
        [receivedata setLength:0];
      
    }else{
        
        if (!self.bShowNetWorkError) {
            
            [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:LOCALANGER(@"networkError")];

        }
    }
    [paramer release];

}

- (NSString *)getRequestKeyString:(NSDictionary *)tDic
{
    NSArray *keyArray =[tDic allKeys];
    
    NSMutableString *singString = [[NSMutableString alloc] init];
    
    for (int i=0;i<keyArray.count;i++) {
        NSString *keyString = [keyArray objectAtIndex:i];
        if (singString.length == 0) {
            [singString appendFormat:@"%@=%@",keyString,[tDic objectForKey:keyString]];
        }else{
            [singString appendFormat:@"&%@=%@",keyString,[tDic objectForKey:keyString]];
        }
    }
    
    return singString;
}

#pragma mark 异步请求数据的delegate方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedata appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

    if (!self.bShowNetWorkError) {

        [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:LOCALANGER(@"networkError")];
    }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

    if (receivedata.length<=0) {
        return;
    }
    NSArray *tReceiveArray = [receivedata objectFromJSONData];
    NSString *getVersionInteger =nil;
    
    //判断当前版本与获取到得版本得信息
    
    NSDictionary *versionDic=nil;
    for (int i=0; i<tReceiveArray.count; i++) {
        NSDictionary *tempDic = [tReceiveArray objectAtIndex:i];
        NSInteger  tStringVersionInt = [[tempDic objectForKey:KNUm] integerValue];
        if (tStringVersionInt == 1) {//内容
            versionDic = tempDic;
            continue;
        }else if(tStringVersionInt == 0)//版本号
        {
            getVersionInteger= [tempDic objectForKey:KContentK];
            
        }
    }
    
    NSArray *arrayRemote = [getVersionInteger componentsSeparatedByString:@"."];
    
    NSString *versionCurrent = [[[NSBundle mainBundle] infoDictionary] objectForKey:KCFBundleVersion];
    NSArray *arrayVersionCurrent = [versionCurrent componentsSeparatedByString:@"."];
    
    [JVCConfigModel shareInstance]._bNewVersion = NO;
    
    if (arrayRemote.count<3) {//有错
        
        [self alertVithVersionUpdate];
        
        return;
        
    }
    /**
     *  远端数据
     */
    NSString *remoteItem1 = [arrayRemote objectAtIndex:0];
    NSString *remoteItem2 = [arrayRemote objectAtIndex:1];
    NSString *remoteItem3 = [arrayRemote objectAtIndex:2];
    
    /**
     *  本地保存数据
     */
    NSString *VersionCurrentItem1 = [arrayVersionCurrent objectAtIndex:0];
    NSString *VersionCurrentItem2 = [arrayVersionCurrent objectAtIndex:1];
    NSString *VersionCurrentItem3 = [arrayVersionCurrent objectAtIndex:2];
    
    /**
     *  跟新消息
     */
    NSString *versionString = [versionDic objectForKey:KContentK];
    
    if (remoteItem1.intValue>VersionCurrentItem1.intValue) {
        
        [JVCConfigModel shareInstance]._bNewVersion = YES;
    }else{
        
        if (remoteItem2.intValue>VersionCurrentItem2.intValue) {
            
            [JVCConfigModel shareInstance]._bNewVersion = YES;
            
        }else{
            
            if (remoteItem3.intValue>VersionCurrentItem3.intValue) {
                
                [JVCConfigModel shareInstance]._bNewVersion = YES;
                
            }
        }
    }
    
    if ([JVCConfigModel shareInstance]._bNewVersion) {
        
        [JVCConfigModel shareInstance]._bNewVersion = YES;
        [self showUpdateVeiwAlert:versionString];
    
    }else{
        
        [self alertVithVersionUpdate];
    }

    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // NSLog(@"receive");
}

- (void)showUpdateVeiwAlert:(NSString *)versionString
{
    dispatch_async(dispatch_get_main_queue(), ^{
    
        NSString *alertString = [versionString stringByReplacingOccurrencesOfString:@"&" withString:@"\n"];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertString message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"UpdateBtn",nil ) otherButtonTitles:NSLocalizedString(@"local_location", nil), nil];
//        alertView.tag = kAlertNEWVersionTag;
//        [alertView show];
//        [alertView release];
        
        [[JVCAlertHelper shareAlertHelper] alertControllerWithTitle:alertString delegate:self selectAction:@selector(openItunes) cancelAction:nil selectTitle:NSLocalizedString(@"UpdateBtn",nil ) cancelTitle:NSLocalizedString(@"local_location", nil)alertTage:0];
    
    });
}

/**
 *  没有版本升级时的提示
 */
- (void)alertVithVersionUpdate
{
    if (!self.bShowNetWorkError) {

        [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:NSLocalizedString(@"home_version_last_count3", nil) ];
    }
}

- (void)openItunes
{
    [[JVCSystemUtility shareSystemUtilityInstance] openItunsCommet];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self openItunes];
    }
}

- (void)dealloc
{
    [receivedata release];
    
    [super dealloc];
}

@end
