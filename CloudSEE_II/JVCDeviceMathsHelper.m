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
@interface JVCDeviceMathsHelper ()
{
    NSString *deviceYStNum;
    
    NSString *deviceUserName;
    
    NSString *devicePassWord;
}

@end
@implementation JVCDeviceMathsHelper
@synthesize deviceDelegate;

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
    [[JVCChannelScourseHelper shareChannelScourseHelper] addLocalChannelsWithDeviceModel:deviceYStNum];
    
    
    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"添加设备成功")];

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
{
    deviceYStNum    = [ystNum retain];
    deviceUserName  = [userName retain];
    devicePassWord  = [passWord retain];

    
    int result = [[JVCPredicateHelper shareInstance]addDevicePredicateYSTNUM:ystNum andUserName:userName andPassWord:passWord];
    
    if (KADDDEVICE_RESULT_SUCCESS == result) {
        
        
        //判断是否超过最大值以及数据表中是否有这个设备
        int result = [[JVCDeviceSourceHelper shareDeviceSourceHelper] addDevicePredicateHaveYSTNUM:ystNum];
        
        if (ADDDEVICE_HAS_EXIST == result) {//存在
            
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"设备列表中已存在"];
            
        }else if(ADDDEVICE_MAX_MUX == result)//超过最大值
        {
            
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"超过最大值"];
            
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
        
        int resutl =  [[JVCDeviceHelper sharedDeviceLibrary] addDeviceToAccount:deviceYStNum userName:deviceUserName password:devicePassWord];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (KADDDEVICE_RESULT_SUCCESS == resutl) {//成功,获取设备的信息
                
                [self getNewAddDeviceInfo];
                
            }else{//失败
                
                [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"添加失败")];
            }
        });
    });

}

- (void)getNewAddDeviceInfo
{
    [[JVCAlertHelper shareAlertHelper]alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *resutlDic =  [[JVCDeviceHelper sharedDeviceLibrary] getDeviceInfoByDeviceGuid:deviceYStNum ];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /**
             *  判断返回的字典是不是nil
             */
            if (![[JVCSystemUtility shareSystemUtilityInstance] judgeDictionIsNil:resutlDic] ) {
                DDLogInfo(@"===![[JVCSystemUtility shareSystemUtilityInstance] judgeDictionIsNil:resutlDic");
                /**
                 *  判断返回字典的rt字段是否为0
                 */
                if ( [[JVCSystemUtility shareSystemUtilityInstance] JudgeGetDictionIsLegal:resutlDic]) {//成功，把收到的字典转化为model类型
                    
                    /**
                     *  给的返回数据中没有云视通信息，所有要吧云视通号传过去
                     */
                    
                    JVCDeviceModel *tempMode =   [[JVCDeviceSourceHelper shareDeviceSourceHelper] convertDeviceDictionToModelAndInsertDeviceList:resutlDic withYSTNUM:deviceYStNum];
                    
                    [tempMode retain];
                    
                    NSMutableArray *newModelList = [NSMutableArray arrayWithCapacity:10];
                    
                    [newModelList addObject:[[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceModelWithYstNumberConvertLocalCacheModel:tempMode.yunShiTongNum]];
                    
                    [[JVCLANScanWithSetHelpYSTNOHelper sharedJVCLANScanWithSetHelpYSTNOHelper] setDevicesHelper:newModelList];
                    
                    //从云视通服务器获取设备的通道数
                    [self getDeviceChannelNums:deviceYStNum];
                    [tempMode release];
                    
                    
                }else{
                    
                    DDLogInfo(@"==error2=![[AddDeviceLogicMaths shareInstance] judgeDictionIsNil:deviceInfoMdic]");
                    
                    
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"adddevice_error")];
                    
                }
                
            }else{//空
                
                DDLogInfo(@"==error3=![[AddDeviceLogicMaths shareInstance] judgeDictionIsNil:deviceInfoMdic]");
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"adddevice_net_error")];
                
            }
        });
    });
    
}

/**
 *  重云视通获取设备的通道数
 *
 *  @param ystNumber 云视通
 */
- (void)getDeviceChannelNums:(NSString *)ystNumber
{
    
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int channelCount = KDEFAULTAPCHANNELCOUNT;
        DDLogVerbose(@"ystServicDeviceChannel=%d",channelCount);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [self addDeviceChannelToServerWithNum:channelCount];
        });
        
    });
}

/**
 *  往服务器添加设备的通道
 */
- (void)addDeviceChannelToServerWithNum:(int )channelNum
{
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //把通道数添加到服务器
        int reusult =   [[JVCDeviceHelper sharedDeviceLibrary] addChannelToDevice:deviceYStNum addChannelCount:channelNum];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (KADDDEVICE_RESULT_SUCCESS !=reusult) {//失败
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"adddevice_net_error")];
                /**
                 *  删除云视通号
                 */
                [[JVCDeviceSourceHelper shareDeviceSourceHelper] deleteDevieWithYstNum:deviceYStNum];
                
            }else{//成功后，获取设备的所有信息
                
                
                [self getChannelsDetailInfo];
            }
            
        });
        
    });
}

/**
 *  获取设备的通道的详细信息
 */
- (void)getChannelsDetailInfo
{
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *channelAllInfoMdic=[[JVCDeviceHelper sharedDeviceLibrary] getDeviceChannelListData:deviceYStNum];
        DDLogInfo(@"获取设备的所有通道信息=%@",channelAllInfoMdic);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /**
             *  判断返回的字典是不是nil
             */
            if (![[JVCSystemUtility shareSystemUtilityInstance] judgeDictionIsNil:channelAllInfoMdic]  ) {
                
                //把获取的设备通道信息的josn数据转换成model集合
                [[JVCChannelScourseHelper shareChannelScourseHelper] channelInfoMDicConvertChannelModelToMArrayPoint:channelAllInfoMdic deviceYstNumber:deviceYStNum];
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"添加设备成功")];

                [self handerAddDeviceSuccess];
                
            }else{//空
                
                //   [self serachCloseFindDevice];
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"添加设备通道数错误")];
                
                /**
                 *  删除云视通号
                 */
                [[JVCDeviceSourceHelper shareDeviceSourceHelper] deleteDevieWithYstNum:deviceYStNum];
                
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


@end
