//
//  JVCAppParameterModel.m
//  CloudSEE_II
//
//  Created by David on 14/12/15.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "JVCAppParameterModel.h"

static JVCAppParameterModel *shareAppParameter = nil;

@implementation JVCAppParameterModel
@synthesize nHasRegister,nUpdateIdentification,nCaptureMode;
@synthesize bHasDemoPoint,bHasFeedback,bHasVoiceDevice,bHasGuidHelp,bHasAdvertising,isEnableAPModel;
@synthesize appleID,userName,passWord,appDisplayName,appUmKey;

static const NSString *kCloudSee                = @"CloudSEE";  //Cloudsee
static const NSString *kNVSIP                   = @"NVSIP";     //NVSIP
static const NSString *kEhome                   = @"Ehome";     //Ehome
static const NSString *kHITVIS                  = @"HITVIS";    //HITVIS
static const NSString *kELEC                    = @"ELEC";    //elec
static const NSString *kATVCloud                = @"ATVCloud";    //elec

static const NSString *kAppBundleName           = @"CFBundleDisplayName";    //
static const NSString       *KCloseGuid        =@"fistOpen";//第一次打开

static const NSString *kAppDefaultUserName      = @"abc";
static const NSString *kAppDefaultPassWord      = @"123";
static const NSString *kAppDefaultOEMUserName   = @"admin";
static const NSString *kAppDefaultOEmPassWord   = @"";
+(JVCAppParameterModel *)shareJVCAPPParameter
{
    @synchronized(self)
    {
        if (shareAppParameter == nil) {
            shareAppParameter = [[self alloc] init];
            [shareAppParameter initAppParamer];
        }
        return shareAppParameter;
    }
    return shareAppParameter;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareAppParameter == nil) {
            
            shareAppParameter = [super allocWithZone:zone];
            
            return shareAppParameter;
        }
    }
    return nil;
}

/**
 *  初始化app
 *
 *  @param appName 应用的名称
 */
- (void)initAppParamer
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    DDLogVerbose(@"%s====%@",__FUNCTION__,infoDictionary);
    NSString *appName = [infoDictionary objectForKey:kAppBundleName];
    
    JVCAppParameterModel *appModel = [JVCAppParameterModel shareJVCAPPParameter];
    appModel.nHasRegister           = JVCRegisterType_Default;
    appModel.appDisplayName          = appName;
    appModel.appUmKey                = @"";
    if ([appName isEqualToString:(NSString *)kCloudSee]) {
        //上传账号用户名：wyj@jovetech.com 密码：Jovetech86996685
        appModel.nCaptureMode           = JVCConfigModelCaptureModeTypeDecoder;
        appModel.nHasRegister           =JVCRegisterType_ALL;
        appModel.isEnableAPModel        = NO;
        appModel.bHasAdvertising        = YES;
        appModel.bHasGuidHelp           = YES;
        appModel.bHasDemoPoint          = YES;
        appModel.bHasFeedback           = YES;
        appModel.bHasVoiceDevice        = YES;
        appModel.nUpdateIdentification  =  2001;
        appModel.appUmKey               =  @"5491029afd98c5b85e001351";
        appModel.appleID                = @"583826804";//cloudsee的appID
        appModel.userName               = (NSString *)kAppDefaultUserName;
        appModel.passWord               = (NSString *)kAppDefaultPassWord;
        
    }else if([appName isEqualToString:(NSString *)kNVSIP])
    {   //上传账号用户名：jindan.mail@gmail.com 密码：Jovison2015
        appModel.nCaptureMode           = JVCConfigModelCaptureModeTypeDecoder;
        appModel.bHasAdvertising        = NO;
        appModel.isEnableAPModel        = NO;
        appModel.bHasGuidHelp           = NO;
        appModel.bHasDemoPoint          = YES;
        appModel.bHasFeedback           = YES;
        appModel.bHasVoiceDevice        = YES;
        appModel.bHasFeedback           = YES;
        appModel.nUpdateIdentification  =  1007;
        appModel.nHasRegister           = JVCRegisterType_Default;
        appModel.appleID                = @"673070046";//nvsip的appleid
        appModel.userName               = (NSString *)kAppDefaultOEMUserName;
        appModel.passWord               = (NSString *)kAppDefaultOEmPassWord;
    }else if([appName isEqualToString:(NSString *)kEhome])
    {//上传账号用户名：apple@tongfangcloud.com 密码：Tongfang2013
        appModel.nCaptureMode           = JVCConfigModelCaptureModeTypeDecoder;
        appModel.bHasAdvertising        = NO;
        appModel.isEnableAPModel        = NO;
        appModel.bHasGuidHelp           = YES;
        appModel.bHasDemoPoint          = YES;
        appModel.bHasFeedback           = YES;
        appModel.bHasVoiceDevice        = YES;
        appModel.nHasRegister           =JVCRegisterType_China;
        appModel.bHasFeedback           = YES;
        appModel.nUpdateIdentification  =  1002;
        appModel.appleID                = @"583826804";//nvsip的appleid
        appModel.userName               = (NSString *)kAppDefaultOEMUserName;
        appModel.passWord               = (NSString *)kAppDefaultOEmPassWord;
    }else if([appName isEqualToString:(NSString *)kHITVIS])
    {//上传账号用户名：hitvis@hitvis.com 密码：Jnme810729
        appModel.nCaptureMode           = JVCConfigModelCaptureModeTypeDevice;
        appModel.bHasAdvertising        = NO;
        appModel.isEnableAPModel        = YES;
        appModel.bHasGuidHelp           = YES;
        appModel.bHasDemoPoint          = YES;
        appModel.bHasFeedback           = YES;
        appModel.bHasVoiceDevice        = YES;
        appModel.bHasFeedback           = YES;
        appModel.nHasRegister           = JVCRegisterType_Default;
        appModel.nUpdateIdentification  =  1005;
        appModel.appleID                = @"583826804";//nvsip的appleid
        appModel.userName               = (NSString *)kAppDefaultOEMUserName;
        appModel.passWord               = (NSString *)kAppDefaultOEmPassWord;
    }else if([appName isEqualToString:(NSString *)kELEC])
    {//上传账号用户名：elecapk@gmail.com  密码：Elec2014apple
        appModel.bHasDemoPoint          = NO;
        appModel.nHasRegister           = JVCRegisterType_Default;
        appModel.bHasGuidHelp           = NO;
        appModel.bHasFeedback           = YES;
        appModel.bHasAdvertising        = NO;
        appModel.bHasVoiceDevice        = YES;
        appModel.nCaptureMode           = JVCConfigModelCaptureModeTypeDecoder;
        appModel.isEnableAPModel        = NO;
        appModel.bHasFeedback           = YES;
        appModel.nUpdateIdentification  =  1010;
        appModel.appleID                = @"";//nvsip的appleid
        appModel.userName               = (NSString *)kAppDefaultOEMUserName;
        appModel.passWord               = (NSString *)kAppDefaultOEmPassWord;
    }else if([appName isEqualToString:(NSString *)kATVCloud]){
        //
        appModel.bHasDemoPoint          = NO;
        appModel.nHasRegister           = JVCRegisterType_Default;
        appModel.bHasGuidHelp           = NO;
        appModel.bHasFeedback           = NO;
        appModel.bHasAdvertising        = NO;
        appModel.bHasVoiceDevice        = YES;
        appModel.nCaptureMode           = JVCConfigModelCaptureModeTypeDecoder;
        appModel.isEnableAPModel        = NO;
        appModel.bHasFeedback           = YES;
        appModel.nUpdateIdentification  =  1011;
        appModel.appleID                = @"";//nvsip的appleid
        appModel.userName               = (NSString *)kAppDefaultOEMUserName;
        appModel.passWord               = (NSString *)kAppDefaultOEmPassWord;
    }
    
    if (!appModel.bHasGuidHelp) {
        
        [[NSUserDefaults standardUserDefaults] setObject:(NSString *)KCloseGuid forKey:(NSString *)kAPPWELCOME];

    }
    
}


- (void)dealloc
{
    [appUmKey release];
    [appDisplayName release];
    [appleID release];
    [userName release];
    [passWord release];
    
    [super dealloc];
}

@end
