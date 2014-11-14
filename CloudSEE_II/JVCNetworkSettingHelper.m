//
//  JVCNetworkSettingHelper.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-12.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCNetworkSettingHelper.h"

@implementation JVCNetworkSettingHelper

@synthesize networkSettingErrorBlock;
@synthesize networkSettingGetNetworkInfoBlock;
@synthesize networkSettingConnectResultBlock;
@synthesize networkSettingHelperDeleagte;
@synthesize networkSettingResultSSIDListBlock;

-(void)ConnectMessageCallBackMath:(NSString *)connectCallBackInfo nLocalChannel:(int)nlocalChannel connectResultType:(int)connectResultType{

    if (CONNECTRESULTTYPE_Succeed != connectResultType) {
        
        if (self.networkSettingHelperDeleagte != nil && [self.networkSettingHelperDeleagte respondsToSelector:@selector(JVCNetworkSettingConnectResult:)]) {
            
            [self.networkSettingHelperDeleagte JVCNetworkSettingConnectResult:connectResultType];
        }
    }
}

-(void)dealloc{
    
    JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    ystNetWorkHelperObj.ystNWTDDelegate                      = nil;

    [networkSettingErrorBlock release];
    [networkSettingGetNetworkInfoBlock release];
    [networkSettingConnectResultBlock release];
    [networkSettingResultSSIDListBlock release];
    
    DDLogVerbose(@"%s------------^^^^^^^^^^^",__FUNCTION__);
    
    [super dealloc];
}

-(void)error:(int)type{
    
    if (self.networkSettingErrorBlock) {
        
        self.networkSettingErrorBlock(type);
    }
}

-(void)RequestTextChatCallback:(int)nLocalChannel withDeviceType:(int)nDeviceType {

    if (nDeviceType != DEVICEMODEL_IPC) {
        
        DDLogVerbose(@"不是IPC,不支持此操作！");
        [self error:ErrorTypeNotSupport];
        
        [self disconnect];
        
    }else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            JVCCloudSEENetworkHelper *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
            
            [ystNetWorkHelperObj RemoteOperationSendDataToDevice:nLocalChannel remoteOperationCommand:JVN_REQ_TEXT];
            
        });
    }
}

-(void)RequestTextChatStatusCallBack:(int)nLocalChannel withStatus:(int)nStatus{

    switch (nStatus) {
            
        case JVN_RSP_TEXTACCEPT:{
        
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
                ystNetWorkHelperObj.ystNWTDDelegate                      = self;
                
                [ystNetWorkHelperObj RemoteOperationSendDataToDevice:nConnectLocalChannel remoteOperationType:TextChatType_NetWorkInfo remoteOperationCommand:-1];
            });
        
        }
            break;
        default:{
        
            DDLogVerbose(@"%s---------------------  主控忙碌",__FUNCTION__);
            [self error:ErrorTypeReject];
            [self disconnect];
        
        }
            break;
    }
}

#pragma mark -------------- ystNetWorkHelpTextDataDelegate (文本聊天的回调)

/**
 *  文本聊天返回的回调
 *
 *  @param nYstNetWorkHelpTextDataType 文本聊天的状态类型
 *  @param objYstNetWorkHelpSendData   文本聊天返回的内容
 */
-(void)ystNetWorkHelpTextChatCallBack:(int)nYstNetWorkHelpTextDataType objYstNetWorkHelpSendData:(id)objYstNetWorkHelpSendData{

    switch (nYstNetWorkHelpTextDataType) {
            
        case TextChatType_NetWorkInfo:{
        
            if (self.networkSettingGetNetworkInfoBlock) {
                
                NSMutableDictionary *networkInfo = (NSMutableDictionary *)objYstNetWorkHelpSendData;
                self.networkSettingGetNetworkInfoBlock(networkInfo);
            }
        }
            break;
        case TextChatType_ApList:{
            
            NSMutableArray *networkInfo = (NSMutableArray *)objYstNetWorkHelpSendData;
        
            if (self.networkSettingResultSSIDListBlock) {
                
                self.networkSettingResultSSIDListBlock(networkInfo);
            }
        }
            
        default:
            break;
    }
}

/**
 *  设置有线连接（自动和手动切换）
 *
 *  @param nDHCP             是否自动获取
 *  @param strIp             ip地址
 *  @param strSubnetMask     子网掩码
 *  @param strDefaultGateway 默认网关
 *  @param strDns            域名
 */
-(void)setWiredConnectType:(int)nDHCP withIpAddress:(NSString *)strIp withSubnetMask:(NSString *)strSubnetMask withDefaultGateway:(NSString *)strDefaultGateway withDns:(NSString *)strDns {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        DDLogVerbose(@"%s----------------ip=%@",__FUNCTION__,strIp);
        [ystNetWorkHelperObj RemoteSetWiredNetwork:nConnectLocalChannel nIsEnableDHCP:nDHCP strIpAddress:strIp strSubnetMask:strSubnetMask strDefaultGateway:strDefaultGateway strDns:strDns];
        
        [self disconnect];
    });
  
}

/**
 *  配置设备的无线网络(老的配置方式)
 *
 *  @param strSSIDName     配置的热点名称
 *  @param strSSIDPassWord 配置的热点密码
 *  @param strWifiAuth     热点的认证方式
 *  @param strWifiEncryp   热点的加密方式
 */
-(void)setWifiConnectType:(NSString *)strSSIDName withSSIDPassWord:(NSString *)strSSIDPassWord withWifiAuth:(NSString *)strWifiAuth withWifiEncrypt:(NSString *)strWifiEncryp{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        [ystNetWorkHelperObj RemoteOldSetWiFINetwork:nConnectLocalChannel strSSIDName:strSSIDName strSSIDPassWord:strSSIDPassWord strWifiAuth:strWifiAuth strWifiEncrypt:strWifiEncryp];
        
        [self disconnect];
    });



}


/**
 *  获取设备的WIFI信息
 */
-(void)refreshWifiListInfo {
    
    JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    ystNetWorkHelperObj.ystNWTDDelegate                      = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [ystNetWorkHelperObj RemoteOperationSendDataToDevice:nConnectLocalChannel remoteOperationType:TextChatType_ApList remoteOperationCommand:-1];
        
    });
}

@end
