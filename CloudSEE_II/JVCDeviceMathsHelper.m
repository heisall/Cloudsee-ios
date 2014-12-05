//
//  JVCDeviceMathsHelper.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/20/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDeviceMathsHelper.h"
#import "JVCDeviceHelper.h"
#import "JVCDeviceModel.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCLANScanWithSetHelpYSTNOHelper.h"
#import "JVCCloudSEENetworkHelper.h"
#import "JVCChannelScourseHelper.h"
#import "JVCPredicateHelper.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCResultTipsHelper.h"
#import "JVCLocalDeviceDateBaseHelp.h"
#import "JVCConfigModel.h"
#import "JVCDeviceMacro.h"
#import "JVCLogHelper.h"
@interface JVCDeviceMathsHelper ()
{
    NSString *deviceYStNum;
    
    NSString *deviceUserName;
    
    NSString *devicePassWord;
    
    int channelCount ;
}

@end
@implementation JVCDeviceMathsHelper
@synthesize deviceDelegate;
@synthesize deviceUpdate;
@synthesize bUpdateOnLineState;

static JVCDeviceMathsHelper  *shareDeviceMathsHelper = nil;
static const int     KADDDEVICE_RESULT_SUCCESS      = 0;   //成功
static const int    kAddDeviceWithWlanTimeOut       = 5;   //添加设备从服务器获取通道数的超时时间
static const int     KDEFAULTAPCHANNELCOUNT         = 1;   //莫仍的通道数

/**
 *  单例
 *
 *  @return 对象
 */
+(JVCDeviceMathsHelper *)shareJVCUrlRequestHelper
{
    @synchronized(self)
    {
        if (shareDeviceMathsHelper == nil) {
            
            shareDeviceMathsHelper = [[self alloc] init];
            
            shareDeviceMathsHelper.bUpdateOnLineState = NO;
            
            
        }
        
        return shareDeviceMathsHelper;
    }
    
    return shareDeviceMathsHelper;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareDeviceMathsHelper == nil) {
            
            shareDeviceMathsHelper = [super allocWithZone:zone];
            
            return shareDeviceMathsHelper;
        }
    }
    
    return nil;
}

#pragma mark 添加本地设备
/**
 *  添加
 *
 *  @param ystNum   云视通
 *  @param userName 用户名
 *  @param passWord 密码
 */
- (void)addDeviceToLocalAccount
{
    /**
     *  添加设备
     */
    [[JVCLocalDeviceDateBaseHelp shareDataBaseHelper] addLocalDeviceToDataBase:deviceYStNum deviceName:deviceUserName passWord:devicePassWord];
    //设备添加到设备数组中
    [[JVCDeviceSourceHelper shareDeviceSourceHelper] addLocalDeviceInfo:deviceYStNum
                                                         deviceUserName:deviceUserName
                                                         devicePassWord:devicePassWord];
    //添加通道
    [[JVCChannelScourseHelper shareChannelScourseHelper] addLocalChannelsWithDeviceModel:deviceYStNum channelNums:channelCount];
    
    
    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"JVCDeviceMathsHelper_addDevice_success")];

    [self releaseString];
    
    [self handerAddDeviceSuccess];
}

#pragma mark 添加设备方法
/**
 *  添加
 *
 *  @param ystNum   云视通
 *  @param userName 用户名
 *  @param passWord 密码
 */
- (void)addDeviceWithYstNum:(NSString *)ystNum
                   userName:(NSString *)userName
                   passWord:(NSString *)passWord
               ChannelCount:(int)count
{
    deviceYStNum    = [ystNum retain];
    deviceUserName  = [userName retain];
    devicePassWord  = [passWord retain];
    channelCount = count;
    
    int result = [[JVCPredicateHelper shareInstance]addDevicePredicateYSTNUM:ystNum andUserName:userName andPassWord:passWord];
    
    if (KADDDEVICE_RESULT_SUCCESS == result) {
        
        
        //判断是否超过最大值以及数据表中是否有这个设备
        int result = [[JVCDeviceSourceHelper shareDeviceSourceHelper] addDevicePredicateHaveYSTNUM:ystNum];
        
        if (ADDDEVICE_HAS_EXIST == result) {//存在
            
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"JVCDeviceMathsHelper_addDevice_HasExist")];
            
        }else if(ADDDEVICE_MAX_MUX == result)//超过最大值
        {
            
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"addDevice_Max_num")];
            
        }else{//开始添加
            
            if ([JVCConfigModel shareInstance ]._bISLocalLoginIn == TYPELOGINTYPE_ACCOUNT) {
                
                [self  addDeviceToAccount];//账号添加
                
            }else{//本地添加
                
                [self  addDeviceToLocalAccount];

            }
        }
        
    }else{
        
        [[JVCResultTipsHelper shareResultTipsHelper]showAddDevicePredicateAlert:result];
    }
}

- (void)addDeviceToAccount
{
    
    [[JVCAlertHelper shareAlertHelper]alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        id resultDic =[[JVCDeviceHelper sharedDeviceLibrary] newInterfaceAddDeviceWithUserName:deviceUserName passWord:devicePassWord ystNum:deviceYStNum.uppercaseString channelCount:channelCount];//addDeviceToAccount:textFieldYST.text.uppercaseString userName:textFieldUserName.text password:textFieldPassWord.text];
        
        DDLogVerbose(@"%s===%@",__FUNCTION__,resultDic);
        
        [[JVCLogHelper shareJVCLogHelper] writeDataToFile:[NSString stringWithFormat:@"=%s==user=%@  save device =%@=\n",__FUNCTION__,kkUserName,deviceYStNum]fileType:LogType_DeviceManagerLogPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
            
            NSDictionary *dicDevie = (NSDictionary *)resultDic;
            
            if ([[JVCSystemUtility shareSystemUtilityInstance] JudgeGetDictionIsLegal:resultDic]) {
                
                NSDictionary *deviceInfo = [dicDevie objectForKey:DEVICE_JSON_DINFO];
                
                NSArray *channelList = [dicDevie objectForKey:DEVICE_CHANNEL_JSON_LIST];
                
                [[JVCDeviceSourceHelper shareDeviceSourceHelper] newInterFaceAddDevice:deviceInfo ystNum:deviceYStNum];
                [[JVCChannelScourseHelper shareChannelScourseHelper] newInterFaceAddChannelWithChannelArray:channelList deviceYstNumber:deviceYStNum];
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"adddevice_net_success")];
                
                [self handerAddDeviceSuccess];
                
            }else{
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_addDevice_add_error")];
                
            }
        });
    });
}

- (void)dealloc
{
    
    [deviceYStNum    release];
    [deviceUserName  release];
    [devicePassWord  release];
    
    [super dealloc];
}

- (void)releaseString
{
    [deviceYStNum    release];
    [deviceUserName  release];
    [devicePassWord  release];
}

/**
 *  相应添加时间成功
 */
- (void)handerAddDeviceSuccess
{
    if (deviceDelegate !=nil && [deviceDelegate respondsToSelector:@selector(addDeviceSuccess)]) {
        
        [deviceDelegate addDeviceSuccess];
    }
}

/**
 *  刷新设备状态
 */
- ( void)updateAccountDeviceListInfo
{
    id deviceRemoteInfoID=[[JVCDeviceHelper sharedDeviceLibrary] refreshAccountNameByDeviceList];
    
    
    if (deviceRemoteInfoID!=nil||[deviceRemoteInfoID isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *remoteDict=(NSDictionary *)deviceRemoteInfoID;
        

        [self remoteDeviceListDataToModel:remoteDict];
        
    }
    
    if (deviceUpdate !=nil && [deviceUpdate respondsToSelector:@selector(updateDeviceInfoMathSuccess)])  {
        
        [deviceUpdate updateDeviceInfoMathSuccess];
    }
}

- (void)remoteDeviceListDataToModel:(NSDictionary*)deviceListDataMDic
{
    id devicesData=[deviceListDataMDic objectForKey:DEVICE_JSON_DLIST];
    
    if ([devicesData isKindOfClass:[NSArray class]]) {
        
        NSArray *deviceListDataArray=(NSArray*)devicesData;
        
        for (int i=0; i<deviceListDataArray.count; i++) {
            
            NSDictionary  *remoteInfoDict=(NSDictionary*)[deviceListDataArray objectAtIndex:i];
            
            NSArray *updateArray = [[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceListArray];
            
            for (int k=0; k<updateArray.count; k++) {
                
                JVCDeviceModel *model=(JVCDeviceModel*)[updateArray objectAtIndex:k];
                
                if ([[model.yunShiTongNum uppercaseString] isEqualToString:[[remoteInfoDict objectForKey:DEVICE_JSON_DGUID] uppercaseString]]) {
                    if (!bUpdateOnLineState) {
                        
                        model.onLineState        = [[remoteInfoDict objectForKey:DEVICE_JSON_ONLINESTATE] intValue];

                    }
                    model.isDeviceType       = [[remoteInfoDict objectForKey:DEVICE_JSON_TYPE] intValue] == kJVCDeviceModelDeviceType_HomeIPC ? YES : NO ;
                    
                    if (model.isDeviceType) {
                        
                        model.isDeviceSwitchAlarm =[[remoteInfoDict objectForKey:DEVICE_JSON_ALARMSWITCH] boolValue];
                    }
                    model.bDeviceServiceOnlineState =[[remoteInfoDict objectForKey:DEVICE_DEVICE_ServiceState] intValue];

                    model.hasWifi = [[remoteInfoDict objectForKey:DEVICE_JSON_WIFI] intValue];
                    continue;
                    
                }
            }
        }
    }
    
}


@end
