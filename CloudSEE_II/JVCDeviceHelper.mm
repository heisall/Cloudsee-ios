//
//  JVCDeviceHelper.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDeviceHelper.h"
#import "JSONKit.h"
#import "JVCDeviceMacro.h"
#import "JVCAccountInterface.h"
#import "JVCAlarmMacro.h"
#import "JVCDeviceMacro.h"

@implementation JVCDeviceHelper

static JVCDeviceHelper *shareDevicelibrary=nil;

char outTextBuffer[1280*720*3];

#define CONVERTCHARTOSTRING(A) [NSString stringWithFormat:@"%s",A]


/**
 *  获取设备服务类库对象（注需要帐号初始化SDK，帐号登陆
 之后相应的方法才能生效，
 否则提供的对应方法无法使用）
 *
 *  @return 设备服务类库对象
 */
+(JVCDeviceHelper *)sharedDeviceLibrary{
    
    @synchronized(self){
        
        
        if (shareDevicelibrary==nil) {
            
            shareDevicelibrary=[[self alloc] init];
            
            return shareDevicelibrary;
        }
    }
    
    return shareDevicelibrary;
    
}

/**
 *  模式重写对象创建方法
 *
 *  @param zone 任何默认对内存的操作都是在Zone上进行的，确保只能创建一次
 *
 *  @return 单利对象
 */
+(id)allocWithZone:(struct _NSZone *)zone{
    
    @synchronized(self){
        
        if (shareDevicelibrary==nil) {
            
            shareDevicelibrary=[super allocWithZone:zone];
            
            return shareDevicelibrary;
        }
    }
    
    return nil;
}

/**
 *	通用接口的设备请求（短连接）
 *
 *	@param	accountName 短连接的
 *
 *	@return	JSON格式的设备列表
 */
-(id)getResponseByRequestBusinessServer:(NSString *)requstJosnStr{
    
    memset(outTextBuffer, 0, sizeof(outTextBuffer));
    
    int resultValue=GetResponseByRequestDeviceShortConnectionServer_C((const char *)[requstJosnStr UTF8String],outTextBuffer);
    
    if (resultValue!=DEVICESERVICERESPONSE_SUCCESS){
        
        return nil;
    }
    
    if (strlen(outTextBuffer)<=0) {
        
        return nil;
    }
    
    NSData *responseData=[NSData dataWithBytes:outTextBuffer length:strlen(outTextBuffer)];
    
    DDLogVerbose(@"__%s=================%@=======",__FUNCTION__,[responseData objectFromJSONData]);
    return [responseData objectFromJSONData];
    
}

/**
 *	通用接口的设备请求（短连接）
 *
 *	@param	accountName 短连接的
 *
 *	@return	JSON格式的设备列表
 */
-(id)getResponseLongByRequestBusinessServer:(NSString *)requstJosnStr{
    
    memset(outTextBuffer, 0, sizeof(outTextBuffer));
    
    int resultValue=GetResponseByRequestDevicePersistConnectionServer_C((const char *)[requstJosnStr UTF8String],outTextBuffer);
    
    
    if (resultValue!=DEVICESERVICERESPONSE_SUCCESS){
        
        return nil;
    }
    
    if (strlen(outTextBuffer)<=0) {
        
        return nil;
    }
    
    NSData *responseData=[NSData dataWithBytes:outTextBuffer length:strlen(outTextBuffer)];
    
    return [responseData objectFromJSONData];
    
}

#pragma mark---------------------------
#pragma mark 与设备服务交互的业务接口
#pragma mark---------------------------

/**
 *	获取帐号下面的设备列表
 *
 *	@return	JSON格式的设备列表 注:返回为Nil 时，为请求超时
 */
-(NSDictionary *)getAccountByDeviceList{
    
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:GET_USER_DEVICES] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID=[self getResponseByRequestBusinessServer:parseStr];
    
    if(resultID==nil||![resultID isKindOfClass:[NSDictionary class]]){
        
        return nil;
        
    }
    
    NSDictionary *resultInfoDic=(NSDictionary *)resultID;
    
    return resultInfoDic;
    
}

/**
 *	获取帐号下面的设备的详细信息
 *
 *  @param  deviceGuidStr 云视通号
 *
 *	@return	JSON 按云视通一条设备详细信息 注:返回为Nil 时，为请求超时
 */
-(NSDictionary *)getDeviceInfoByDeviceGuid:(NSString *)deviceGuidStr{
    
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:GET_USER_DEVICE_INFO] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID=[self getResponseByRequestBusinessServer:parseStr];
    
    if(resultID==nil||![resultID isKindOfClass:[NSDictionary class]]){
        
        return nil;
    }
    
    NSDictionary *resultInfoDic=(NSDictionary *)resultID;
    
    return resultInfoDic;
    
}

/**
 *	修改设备的连接模式
 *
 *	@param	deviceGuidStr	云通号
 *	@param	linkType	连接模式（0-云通连接 1:IP连接）
 *	@param	userName	用户名
 *	@param	password	密码
 *	@param	ip	        连接的IP（linkType==1生效）
 *	@param	port	    连接的密码（linkType==1生效）
 *
 *	@return	{"mt":2014,"rt":0,"mid":1} rt为0时 操作成功，否则失败 (－5 请求超时)
 */
-(int)modifyDeviceLinkModel:(NSString *)deviceGuidStr linkType:(int)linkType userName:(NSString *)userName password:(NSString *)password ip:(NSString *)ip port:(NSString *)port{
    
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:MODIFY_DEVICE_INFO_VIDEO_LINK] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    [requestInfoMDict setValue:userName forKey:CONVERTCHARTOSTRING(JK_DEVICE_VIDEO_USERNAME)];
    [requestInfoMDict setValue:password forKey:CONVERTCHARTOSTRING(JK_DEVICE_VIDEO_PASSWORD)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:linkType] forKey:CONVERTCHARTOSTRING(JK_VIDEO_LINK_TYPE)];
    [requestInfoMDict setValue:ip forKey:CONVERTCHARTOSTRING(JK_DEVICE_VIDEO_IP)];
    [requestInfoMDict setValue:port forKey:CONVERTCHARTOSTRING(JK_DEVICE_VIDEO_PORT)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID=[self getResponseByRequestBusinessServer:parseStr];
    
    
    if(resultID==nil||![resultID isKindOfClass:[NSDictionary class]]){
        
        return DEVICESERVICERESPONSE_REQ_TIMEOUT;
        
    }
    
    NSDictionary *resultInfoDic=(NSDictionary *)resultID;
    
    int resultIntValue=[[resultInfoDic objectForKey:CONVERTCHARTOSTRING(JK_RESULT)] intValue];
    
    return resultIntValue;
    
}


/**
 *	修改本地连接信息
 *
 *	@param	deviceGuidStr  云通号
 *	@param	userName	   本地连接的用户名
 *	@param	password	   本地连接的密码
 *	@param	nikeName	   设备的昵称
 *
 *	@return	0标示成功 否则为错误代码
 */
-(int)modifyDeviceConnectInfo:(NSString *)deviceGuidStr userName:(NSString *)userName password:(NSString *)password nickName:(NSString *)nikeName{
    
    //   int resultID= [self controlDeviceOperationSwitchButton:deviceGuidStr operationType:DEVICE_Name switchState:0 updateText:nikeName];
    //
    //    if (resultID==DEVICESERVICERESPONSE_SUCCESS) {
    
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:MODIFY_DEVICE_INFO] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    [requestInfoMDict setValue:userName forKey:CONVERTCHARTOSTRING(JK_DEVICE_VIDEO_USERNAME)];
    [requestInfoMDict setValue:password forKey:CONVERTCHARTOSTRING(JK_DEVICE_VIDEO_PASSWORD)];
    [requestInfoMDict setValue:nikeName forKey:CONVERTCHARTOSTRING(JK_DEVICE_NAME)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID= [self getResponseByRequestBusinessServer:parseStr];
    
    if(resultID==nil||![resultID isKindOfClass:[NSDictionary class]]){
        
        return DEVICESERVICERESPONSE_REQ_TIMEOUT;
    }
    
    NSDictionary *resultDict=(NSDictionary *)resultID;
    
    return [[resultDict objectForKey:CONVERTCHARTOSTRING(JK_RESULT)] intValue];
    
    //    }
    //
    //    return resultID;
}


/**
 *	添加设备的方法
 *
 *	@param	deviceGuidStr	云通号
 *	@param	userName	    用户名
 *	@param	password	    密码
 *
 *	@return	{"mt":2016,"rt":0,"mid":1} rt为0时 操作成功，否则错误代码
 */
-(int)addDeviceToAccount:(NSString *)deviceGuidStr userName:(NSString *)userName password:(NSString *)password {
    
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    
    [requestInfoMDict setValue:[NSNumber numberWithInt:USER_BIND_DEVICE] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    
    [requestInfoMDict setValue:userName forKey:CONVERTCHARTOSTRING(JK_DEVICE_VIDEO_USERNAME)];
    [requestInfoMDict setValue:password forKey:CONVERTCHARTOSTRING(JK_DEVICE_VIDEO_PASSWORD)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID=[self getResponseByRequestBusinessServer:parseStr];
    
    if (resultID==nil||![resultID isKindOfClass:[NSDictionary class]]) {
        
        return DEVICESERVICERESPONSE_REQ_TIMEOUT;
    }
    
    NSDictionary *resultMDic=(NSDictionary *)resultID;
    
    int resultValue=[[resultMDic objectForKey:CONVERTCHARTOSTRING(JK_RESULT)] intValue];
    
    if (resultValue==DEVICESERVICERESPONSE_SUCCESS) {
        
        if ([[resultMDic objectForKey:CONVERTCHARTOSTRING(JK_DEVICE_RESET_FLAG)] intValue]==DEVICESERVICERESPONSE_RESETFLAG) {
            
            return DEVICESERVICERESPONSE_RESETFLAG;
        }
    }
    
    return resultValue;
}


/**
 *	删除帐号下面设备
 *
 *	@param	accountName	    删除设备所属的帐号
 *	@param	deviceGuidStr	云通号
 *
 *	@return	{"mt":2018,"rt":0,"mid":1} rt为0时 操作成功，否则失败,看错误码
 */
-(int)deleteDeviceInAccount:(NSString *)deviceGuidStr {
    
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:USER_REMOVE_BIND_DEVICE] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID= [self getResponseByRequestBusinessServer:parseStr];
    
    if(resultID==nil||![resultID isKindOfClass:[NSDictionary class]]){
        
        return DEVICESERVICERESPONSE_REQ_TIMEOUT;
    }
    
    NSDictionary *resultDict=(NSDictionary *)resultID;
    
    return [[resultDict objectForKey:CONVERTCHARTOSTRING(JK_RESULT)] intValue];
    
}


/**
 *	获取设备的温湿度（前多少个，默认前24个）
 *
 *	@param	deviceGuidStr	云通号
 *
 *	@return	json数据 Nil 请求超时
 */
-(NSDictionary *)getTHListDataByYSTNumber:(NSString *)deviceGuidStr {
    
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt: GET_DEVICE_HUMITURE_STAT] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt: 24] forKey:CONVERTCHARTOSTRING(JK_DEVICE_HUMITURE_NUM)];
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID=[self getResponseByRequestBusinessServer:parseStr];
    
    if(resultID==nil||![resultID isKindOfClass:[NSDictionary class]]){
        
        return nil;
    }
    
    NSDictionary *resultInfoDic=(NSDictionary *)resultID;
    
    return resultInfoDic;
}


/**
 *	刷新帐号下设备信息的状态
 *
 *	@return	json数据 Nil 请求超时
 */
-(NSDictionary *)refreshAccountNameByDeviceList{
    
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt: GET_USER_DEVICES_STATUS_INFO] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    [requestInfoMDict release];
    
    id resultID=[self getResponseByRequestBusinessServer:parseStr];
    
    if(resultID==nil||![resultID isKindOfClass:[NSDictionary class]]){
        
        return nil;
    }
    
    NSDictionary *resultInfoDic=(NSDictionary *)resultID;
    
    return resultInfoDic;
}

/**
 *	获取评分、排名、同比增长数
 *
 *	@param	deviceGuidStr	云通号
 *
 *	@return	json数据 Nil 请求超时
 */
-(NSDictionary *)getTHListMoreInfoByYSTNumber:(NSString *)deviceGuidStr{
    
    
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    
    [requestInfoMDict setValue:[NSNumber numberWithInt:GET_DEVICE_HUMITURE_SCORE] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID=[self getResponseByRequestBusinessServer:parseStr];
    
    if(resultID==nil||![resultID isKindOfClass:[NSDictionary class]]){
        
        return nil;
    }
    
    NSDictionary *resultInfoDic=(NSDictionary *)resultID;
    
    return resultInfoDic;
    
}


/**
 *	刷新设备当前的温湿度数值
 *
 *	@param	accountName	    当前帐号
 *	@param	deviceGuidStr	云视通号
 *
 *	@return	json数据 Nil 请求超时
 */
-(NSDictionary *)refreshDeviceTHValueByYSTNumber:(NSString *)deviceGuidStr{
    
    
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    
    [requestInfoMDict setValue:[NSNumber numberWithInt:GET_DEVICE_HUMITURE_ONTIME] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID=[self getResponseByRequestBusinessServer:parseStr];
    
    if(resultID==nil||![resultID isKindOfClass:[NSDictionary class]]){
        
        return nil;
    }
    
    NSDictionary *resultInfoDic=(NSDictionary *)resultID;
    
    return resultInfoDic;
    
}


/**
 *	控制设备的功能按钮（安全防护、时段、Baby模式）
 *
 *	@param	deviceGuidStr	    设备的云通号
 *	@param	operationInfoDict	控制的开关
 *  @param  switchState         开关的状态
 *  @param  updateText          更新的内容
 *
 *	@return	0：成功 否则看失败代码
 */
-(int)controlDeviceOperationSwitchButton:(NSString *)deviceGuidStr operationType:(int)operationType  switchState:(int)switchState updateText:(NSString *)updateText {
    
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:IM_SERVER_RELAY] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    [requestInfoMDict setValue:[self fillMdicByOperationType:operationType switchState:switchState updateText:updateText] forKey:CONVERTCHARTOSTRING(JK_DEVICE_INFO)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:PUSH_DEVICE_MODIFY_INFO] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID= [self getResponseLongByRequestBusinessServer:parseStr];
    
    if (resultID==nil||![resultID isKindOfClass:[NSDictionary class]]) {
        
        return DEVICESERVICERESPONSE_REQ_TIMEOUT;
    }
    
    NSDictionary *resultDict=(NSDictionary *)resultID;
    
    if ([[resultDict objectForKey:CONVERTCHARTOSTRING(JK_RESULT)] intValue]==DEVICESERVICERESPONSE_SUCCESS) {
        
        if (!updateText||DEVICE_ALARTM_TIME_SWITCH) {
            
            [self saveControlDeviceOperationSwitchButtonToDataBase:deviceGuidStr operationType:operationType switchState:switchState updateText:updateText];
        }
        
        return DEVICESERVICERESPONSE_SUCCESS;
    }
    
    return  [[resultDict objectForKey:CONVERTCHARTOSTRING(JK_RESULT)] intValue];
    
}

/**
 *	将控制按钮的修改信息保存倒数据库
 *
 *	@param	jsonStr	控制按钮的修改信息
 */
-(void)saveControlDeviceOperationSwitchButtonToDataBase:(NSString *)deviceGuidStr operationType:(int)operationType  switchState:(int)switchState updateText:(NSString *)updateText{
    
    
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    
    NSMutableDictionary *operaInfoDict=[self fillMdicByOperationType:operationType switchState:switchState updateText:updateText];
    
    NSArray *keys=[operaInfoDict allKeys];
    
    for (NSString *strKey in keys) {
        
        [requestInfoMDict setValue: [operaInfoDict objectForKey:strKey] forKey:strKey];
    }
    
    [requestInfoMDict setValue:[NSNumber numberWithInt:MODIFY_DEVICE_INFO_ADVANCED] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [self getResponseByRequestBusinessServer:parseStr];
    
    
    [requestInfoMDict release];
}



/**
 *	根据选择的业务逻辑标示填充处理的字典集合
 *
 *	@param	operationType  业务逻辑标志
 *	@param	switchState	   按钮的状态
 *	@param	updateText	   如果不是按钮，更新的内容
 *
 *	@return	子的字典
 */
-(NSMutableDictionary *)fillMdicByOperationType:(int)operationType switchState:(int)switchState updateText:(NSString *)updateText{
    
    NSMutableDictionary *fillMidc=[[[NSMutableDictionary alloc] initWithCapacity:10] autorelease];
    
    if (!updateText) {
        
        switch (operationType) {
                
            case DEVICE_ALARTM_SWITCH:
                
                [fillMidc setValue:[NSNumber numberWithInt:switchState] forKey:CONVERTCHARTOSTRING(JK_ALARM_SWITCH)];
                break;
            case DEVICE_ALARTM_ANYTIME_SWITCH:
                
                [fillMidc setValue:[NSNumber numberWithInt:switchState] forKey:CONVERTCHARTOSTRING(JK_DEVICE_FULL_ALARM_MODE)];
                break;
            case DEVICE_ALARTM_BABY_SWITCH:
                
                [fillMidc setValue:[NSNumber numberWithInt:switchState] forKey:CONVERTCHARTOSTRING(JK_DEVICE_BABY_MODE)];
                break;
            case DEVICE_TF_SWITCH:
                
                [fillMidc setValue:[NSNumber numberWithInt:switchState] forKey:CONVERTCHARTOSTRING(JK_TF_STORAGE_SWITCH)];
                break;
                
            default:
                break;
        }
        
    }else{
        
        switch (operationType) {
                
            case DEVICE_Name:
                [fillMidc setValue:updateText forKey:CONVERTCHARTOSTRING(JK_DEVICE_NAME)];
                break;
            case DEVICE_ALARTM_TIME_SWITCH:
                
                [fillMidc setValue:updateText forKey:CONVERTCHARTOSTRING(JK_ALARM_TIME)];
                break;
                
            default:
                break;
        }
    }
    
    return fillMidc;
}


#pragma mark IPC远程升级接口


/**
 *  检查IPC是否有新版本
 *
 *  @param deviceType    设备类型
 *  @param deviceModel   设备型号
 *  @param deviceVersion 设备的版本
 *
 *  @return json格式 为空请求超时
 */
-(NSDictionary *)checkDeviceUpdateState:(int)deviceType deviceModel:(int)deviceModel deviceVersion:(NSString *)deviceVersion{
    
    
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:GET_DEVICE_UPDATE_INFO] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:deviceType] forKey:CONVERTCHARTOSTRING(JK_DEVICE_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:deviceModel] forKey:CONVERTCHARTOSTRING(JK_DEVICE_SUB_TYPE)];
    [requestInfoMDict setValue:deviceVersion forKey:CONVERTCHARTOSTRING(JK_DEVICE_SOFT_VERSION)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID= [self getResponseByRequestBusinessServer:parseStr];
    
    if (resultID==nil||![resultID isKindOfClass:[NSDictionary class]]) {
        
        return nil;
    }
    
    NSMutableDictionary *resultMDic=(NSMutableDictionary *)resultID;
    
    
    return resultMDic;
}

/**
 *	IPC远程升级的流程函数
 *
 *	@param	accountName	            更新IPC的帐号
 
 UPDATEDEVICEMATH_CMD_UPDATE=0,     //IPC升级命令
 UPDATEDEVICEMATH_CMD_EXIT=1,       //IPC升级退出
 UPDATEDEVICEMATH_DOWNLOAD_VALUE,   //IPC下载升级文件的进度
 UPDATEDEVICEMATH_WRITE_VALUE,      //IPC烧写文件的进度
 UPDATEDEVICEMATH_CMD_REBOOT        //IPC烧写完重启
 
 *	@param	deviceUpdateMathType	更新的业务编号
 *	@param	deviceGuidStr	        更新的IPC的云通号
 *	@param	updateText	            更新的文本（更新的URL）
 *
 *	@return	>=0成功 否则处理错误码
 */
-(int)deviceUpdateMath:(int)deviceUpdateMathType deviceGuidStr:(NSString *)deviceGuidStr updateText:(NSString *)updateText downloadSize:(int)downloadSize updateVer:(NSString *)updateVer{
    
    
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:IM_SERVER_RELAY] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    
    [self fillUpdateDeviceMdicByMathType:deviceUpdateMathType updateText:updateText fillInfoMDic:requestInfoMDict downloadSize:downloadSize updateVer:updateVer];
    
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID= [self getResponseLongByRequestBusinessServer:parseStr];
    
    if (resultID==nil||![resultID isKindOfClass:[NSDictionary class]]) {
        
        return nil;
    }
    
    NSMutableDictionary *resultMDic=(NSMutableDictionary *)resultID;
    
    int resultValue=-1;
    
    if ([[resultMDic objectForKey:CONVERTCHARTOSTRING(JK_RESULT)] intValue]==DEVICESERVICERESPONSE_SUCCESS) {
        
        switch (deviceUpdateMathType) {
                
            case UPDATEDEVICEMATH_CMD_UPDATE:{
                
                resultValue=DEVICESERVICERESPONSE_SUCCESS;
                break;
            }
            case UPDATEDEVICEMATH_CMD_EXIT:{
                
                resultValue=DEVICESERVICERESPONSE_SUCCESS;
                break;
            }
            case UPDATEDEVICEMATH_DOWNLOAD_VALUE:{
                
                resultValue=[[resultMDic objectForKey:CONVERTCHARTOSTRING(JK_UPGRADE_DOWNLOAD_STEP)] intValue];
                break;
            }
            case UPDATEDEVICEMATH_WRITE_VALUE:{
                
                resultValue=[[resultMDic objectForKey:CONVERTCHARTOSTRING(JK_UPGRADE_WRITE_STEP)] intValue];
                break;
            }
            case UPDATEDEVICEMATH_CMD_REBOOT:{
                
                resultValue=DEVICESERVICERESPONSE_SUCCESS;
                break;
            }
                
            default:
                resultValue=DEVICESERVICERESPONSE_SUCCESS;
                break;
        }
        
    }
    
    return resultValue;
}


/**
 *	根据IPC升级的流程填充相应的字典类
 *
 *	@param	mathType	烧写的业务编号
 *	@param	updateText	烧写的文本标示：（目前只有烧写的URL）
 *	@param	fillMdic	填充的字典
 */
-(NSMutableDictionary *)fillUpdateDeviceMdicByMathType:(int)mathType  updateText:(NSString *)updateText fillInfoMDic:(NSMutableDictionary *)fillInfoMDic downloadSize:(int)downloadSize updateVer:(NSString *)updateVer{
    
    switch (mathType) {
            
        case UPDATEDEVICEMATH_CMD_UPDATE:{
            
            [fillInfoMDic setValue:[NSNumber numberWithInt:PUSH_DEVICE_UPDATE_CMD] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
            [fillInfoMDic setValue:updateText forKey:CONVERTCHARTOSTRING(JK_UPGRADE_FILE_URL)];
            [fillInfoMDic setValue:updateVer forKey:CONVERTCHARTOSTRING(JK_UPGRADE_FILE_VERSION)];
            [fillInfoMDic setValue:[NSNumber numberWithInt:downloadSize] forKey:CONVERTCHARTOSTRING(JK_UPGRADE_FILE_SIZE)];
            break;
        }
        case UPDATEDEVICEMATH_CMD_EXIT:{
            
            [fillInfoMDic setValue:[NSNumber numberWithInt:PUSH_DEVICE_CANCEL_CMD] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
            break;
        }
        case UPDATEDEVICEMATH_DOWNLOAD_VALUE:{
            
            [fillInfoMDic setValue:[NSNumber numberWithInt:GET_UPDATE_DOWNLOAD_STEP] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
            break;
        }
        case UPDATEDEVICEMATH_WRITE_VALUE:{
            
            [fillInfoMDic setValue:[NSNumber numberWithInt:GET_UPDATE_WRITE_STEP] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
            break;
        }
        case UPDATEDEVICEMATH_CMD_REBOOT:{
            
            [fillInfoMDic setValue:[NSNumber numberWithInt:PUSH_DEVICE_REBOOT_CMD] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
            break;
        }
            
        default:
            break;
    }
    
    return fillInfoMDic;
}


#pragma mark 修改设备用户名和密码
/**
 *	修改设备的运视通连接的用户名和密码到设备服务器
 *
 *	@param	deviceGuidStr	运通号
 *	@param	userName	    用户名
 *	@param	password	    密码
 *
 *	@return	0 成功 否则
 */
-(int)modifyDevicePassWord:(NSString *)deviceGuidStr userName:(NSString *)userName password:(NSString *)password{
    
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:IM_SERVER_RELAY] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    [requestInfoMDict setValue:userName forKey:CONVERTCHARTOSTRING(JK_DEVICE_USERNAME)];
    [requestInfoMDict setValue:password forKey:CONVERTCHARTOSTRING(JK_DEVICE_PASSWORD)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:PUSH_DEVICE_MODIFY_PASSWORD] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    id resultID= [self getResponseLongByRequestBusinessServer:parseStr];
    
    if (resultID==nil||![resultID isKindOfClass:[NSDictionary class]]) {
        
        [requestInfoMDict release];
        
        return DEVICESERVICERESPONSE_REQ_TIMEOUT;
    }
    
    NSMutableDictionary *resultMDic=(NSMutableDictionary *)resultID;
    
    int resultValue=[[resultMDic objectForKey:CONVERTCHARTOSTRING(JK_RESULT)] intValue];
    
    if (resultValue==DEVICESERVICERESPONSE_SUCCESS) {
        
        
        [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
        
        [requestInfoMDict setValue:[NSNumber numberWithInt:MODIFY_DEVICE_PASSWORD] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
        
        NSString *saveParseStr=[requestInfoMDict JSONString];
        
        //修改设备用户名和秘密成功后，保存到数据库
        [self getResponseByRequestBusinessServer:saveParseStr];
    }
    
    [requestInfoMDict release];
    
    return resultValue;
}

#pragma mark 设备通道功能模块

/**
 *  添加设备的通道接口 注：通道最多添加64个
 
 *   调试实例:
 
 {"pv":"1.0","dguid":"A230164761","dcs":4,"lpt":1,"mt":2039,"mid":81}
 
 {"mt":2040,"rt":0,"mid":81}
 
 *  @param deviceGuidStr     设备的云通号
 *  @param addChannelCount   添加的通道个数
 *
 *  @return 0 添加成功 （添加成功之后需要获取设备的通道信息，来获取新增的通道）
 */
-(int)addChannelToDevice:(NSString *)deviceGuidStr addChannelCount:(int)addChannelCount{
    
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:ADD_DEVICE_CHANNEL] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:addChannelCount] forKey:CONVERTCHARTOSTRING(JK_DEVICE_CHANNEL_SUM)];
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID= [self getResponseByRequestBusinessServer:parseStr];
    
    if(resultID==nil||![resultID isKindOfClass:[NSDictionary class]]){
        
        return DEVICESERVICERESPONSE_REQ_TIMEOUT;
    }
    
    NSDictionary *resultDict=(NSDictionary *)resultID;
    
    return [[resultDict objectForKey:CONVERTCHARTOSTRING(JK_RESULT)] intValue];
    
}

/**
 *  删除设备的指定通道
 *
 调试实例:
 
 {"pv":"1.0","dguid":"A230164761","dcn":2,"lpt":1,"mt":2041,"mid":82}
 
 {"mt":2042,"rt":0,"mid":81}
 
 *  @param deviceGuidStr 设备的运视通号
 *  @param channelValue  要删除的通道
 *
 *  @return 0 删除成功
 */
-(int)deleteChannelbyChannelValue:(NSString *)deviceGuidStr channelValue:(int)channelValue{
    
    
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DELETE_DEVICE_CHANNEL] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:channelValue] forKey:CONVERTCHARTOSTRING(JK_DEVICE_CHANNEL_NO)];
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID= [self getResponseByRequestBusinessServer:parseStr];
    
    if(resultID==nil||![resultID isKindOfClass:[NSDictionary class]]){
        
        return DEVICESERVICERESPONSE_REQ_TIMEOUT;
    }
    
    NSDictionary *resultDict=(NSDictionary *)resultID;
    
    return [[resultDict objectForKey:CONVERTCHARTOSTRING(JK_RESULT)] intValue];
    
}

/**
 *  修改设备的通道名称
 *
 调试实例：
 
 {"pv":"1.0","dguid":"A230164761","dcn":2,"dcname":"woca","lpt":1,"mt":2045,"mid":88}
 
 {"mt":2046,"rt":0,"mid":88}
 
 *  @param deviceGuidStr     设备的运视通号
 *  @param channelNickName   通道的昵称
 *  @param channelValue      修改的通道号
 *
 *  @return 0 修改成功
 */
-(int)modifyDeviceChannelNickName:(NSString *)deviceGuidStr channelNickName:(NSString *)channelNickName channelValue:(int)channelValue{
    
    
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:MODIFY_DEVICE_CHANNEL_NAME] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    [requestInfoMDict setValue:channelNickName forKey:CONVERTCHARTOSTRING(JK_DEVICE_CHANNEL_NAME)];
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:channelValue] forKey:CONVERTCHARTOSTRING(JK_DEVICE_CHANNEL_NO)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID= [self getResponseByRequestBusinessServer:parseStr];
    
    if(resultID==nil||![resultID isKindOfClass:[NSDictionary class]]){
        
        return DEVICESERVICERESPONSE_REQ_TIMEOUT;
    }
    
    NSDictionary *resultDict=(NSDictionary *)resultID;
    
    return [[resultDict objectForKey:CONVERTCHARTOSTRING(JK_RESULT)] intValue];
}

/**
 *  获取指定设备的通道信息
 *
 *  @param deviceGuidStr 设备的运视通号
 *
 *  @return {"mt":2044,"rt":0,"mid":83,
 "clist":
 [
 {"dcn":1,"dcname":"A230164761_1"},
 {"dcn":2,"dcname":"woca"},
 {"dcn":3,"dcname":"A230164761_3"},
 {"dcn":4,"dcname":"A230164761_4"},
 {"dcn":5,"dcname":"A230164761_5"},
 {"dcn":6,"dcname":"A230164761_6"}
 ]}
 mt：0 获取成功,解析 clist为通道信息集合,否则按错误代码处理
 */
-(NSDictionary *)getDeviceChannelListData:(NSString *)deviceGuidStr{
    
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:GET_DEVICE_CHANNEL] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID=[self getResponseByRequestBusinessServer:parseStr];
    
    if(resultID==nil||![resultID isKindOfClass:[NSDictionary class]]){
        
        return nil;
    }
    
    NSDictionary *resultInfoDic=(NSDictionary *)resultID;
    
    return resultInfoDic;
}

#pragma mark 添加设备属性

/**
 *  绑定设备的Wi-Fi信息
 *
 *  @param deviceGuidStr 云视通号
 *  @param wifiFlag      1:有Wi-Fi 0:不支持
 *
 *  @return 成功返回 0
 */
-(int)bindWifiInfoToDevice:(NSString *)deviceGuidStr WifiFlag:(int)wifiFlag{
    
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:MODIFY_DEVICE_WIFI_FLAG] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:wifiFlag] forKey:CONVERTCHARTOSTRING(JK_DEVICE_WIFI_FLAG)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID= [self getResponseByRequestBusinessServer:parseStr];
    
    if(resultID==nil||![resultID isKindOfClass:[NSDictionary class]]){
        
        return DEVICESERVICERESPONSE_REQ_TIMEOUT;
    }
    
    NSDictionary *resultDict=(NSDictionary *)resultID;
    
    return [[resultDict objectForKey:CONVERTCHARTOSTRING(JK_RESULT)] intValue];
    
}

/**
 *  判断设备是否在线
 *
 *  @param strGUID 云视通号
 *
 *  @return
 */
-(int)predicateDeviceOnlineStateWithYST:(NSString *)deviceGuidStr
{
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:GET_DEVICE_ONLINE_STATE] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEVICE_ONLINE_MID] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_ID)];
    
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    id resultID= [self getResponseByRequestBusinessServer:parseStr];
    
    if(resultID==nil||![resultID isKindOfClass:[NSDictionary class]]){//错误
        
        return DEVICEONLINESTATE_ERROR;
    }
    
    NSDictionary *resultDict=(NSDictionary *)resultID;
    
    NSLog(@"收到的=%@",resultDict);
    
    //    DEVICEONLINESTATE_ONLINE        = 0,          //设备在线
    //    DEVICEONLINESTATE_OFFLINE       = 1,          //设备离线
    //    DEVICEONLINESTATE_UNKONWN       = 2,          //设备不确定
    //    DEVICEONLINESTATE_TIMEROUT      = 3,          //设备请求超时
    //    DEVICEONLINESTATE_ERROR         = 4,          //设备请求错误
    
    int result = [[resultDict objectForKey:CONVERTCHARTOSTRING(JK_RESULT)] intValue];
    
    if (result == DEVICESERVICERESPONSE_SUCCESS) {//成功
        
        int iOnlineState = [[resultDict objectForKey:CONVERTCHARTOSTRING(JK_DEVICES_ONLINE_STATUS)] intValue];
        
        if (iOnlineState == 1) {//在线
            
            return DEVICEONLINESTATE_ONLINE;
            
        }else{//离线
            
            return DEVICEONLINESTATE_OFFLINE;
            
        }
        
    }else{
        
        return DEVICEONLINESTATE_OFFLINE;
        
    }
}

/**
 *  获取添加设备的信息
 *
 *  @param deviceGuidStr 传入的云视通号
 *
 *  @return 收到的字典   dsls 设备在线状态， 1为在线  drn 设备的绑定状态  0 没有绑定  其他值有绑定
 */
- (NSDictionary *)getDeviceOnlineAndBindingStateInfoWithGuid:(NSString *)deviceGuidStr
{
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    //    [requestInfoMDict setValue:CONVERTCHARTOSTRING(JK_SESSION_TEXT) forKey:CONVERTCHARTOSTRING(JK_SESSION_ID)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:GET_DEVICE_Info_stateAndBing] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:DEV_INFO_PRO] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    
    
    [requestInfoMDict setValue:[NSNumber numberWithInt:IM_DEV_RESETSTATE] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_ID)];
    [requestInfoMDict setValue:deviceGuidStr forKey:CONVERTCHARTOSTRING(JK_DEVICE_GUID)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    
    [requestInfoMDict release];
    
    id resultID= [self getResponseByRequestBusinessServer:parseStr];
    
    DDLogInfo(@"resultID=%@",resultID);
    
    if (resultID==nil||![resultID isKindOfClass:[NSDictionary class]]) {
        
        return nil;//非重置设备
    }
    
    NSDictionary *resultMDic=(NSDictionary *)resultID;
    
    return resultMDic;
    
}

/**
 *	获取报警信息的列表
 *
 *	@param	startIndexValue	从哪一条开始
 *
 *	@return	返回JK_ALARM_LISTCOUNT个
 */
-(id)getAccountByDeviceAlarmList:(int)startIndexValue{
    
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];

    [requestInfoMDict setValue:[NSNumber numberWithInt:JK_ALARM_MESSAGE_TYPE_Get] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];


    [requestInfoMDict setValue:[NSNumber numberWithInt:ALARM_INFO_PROCESS] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    
    [requestInfoMDict setValue:[NSNumber numberWithInt:startIndexValue] forKey:CONVERTCHARTOSTRING(JK_ALARM_INDEX_START)];
    [requestInfoMDict setValue:[NSNumber numberWithInt:startIndexValue+JK_ALARM_LISTCOUNT] forKey:CONVERTCHARTOSTRING(JK_ALARM_INDEX_STOP)];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    NSLog(@"parseStr=%@",parseStr);
    
    [requestInfoMDict release];
    
    id resultID=[self getResponseByRequestBusinessServer:parseStr];
    NSLog(@"resultID=%@",resultID);
    return resultID;
   // return [self ConvertAlarmlistToModelListData:resultID];
}


/**
 *	删除报警信息的列表
 *
 *	@param	deleteIndexValue 删除
 *
 *	@return	返回JK_ALARM_LISTCOUNT个
 */
-(id)deleteAlarmHorisyWithIndex:(NSString *)deleteDeviceGuid{
    
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:CONVERTCHARTOSTRING(PROTO_VERSION) forKey:CONVERTCHARTOSTRING(JK_PROTO_VERSION)];
    
    [requestInfoMDict setValue:[NSNumber numberWithInt:ALARM_INFO_PROCESS] forKey:CONVERTCHARTOSTRING(JK_LOGIC_PROCESS_TYPE)];
    
    [requestInfoMDict setValue:[NSNumber numberWithInt:JK_ALARM_MESSAGE_TYPE_Delete] forKey:CONVERTCHARTOSTRING(JK_MESSAGE_TYPE)];
    
    [requestInfoMDict setValue:deleteDeviceGuid forKey:JK_ALARM_GUID];
    
    NSString *parseStr=[requestInfoMDict JSONString];
    
    NSLog(@"parseStr=%@",parseStr);
    
    [requestInfoMDict release];
    
    id resultID=[self getResponseByRequestBusinessServer:parseStr];
    NSLog(@"resultID=%@",resultID);
    return resultID;
    // return [self ConvertAlarmlistToModelListData:resultID];
}



/**
 *	获取一条报警视频信息的视频
 *
 *	@param	alarmGuid	报警信息的GUID
 *
 *	@return	一条报警信息的视频信息
 */
-(id)getSingleAlarmVideoInfo:(NSString *)alarmGuid{
    
    //请求的参数集合
    NSMutableDictionary *requestInfoMDict=[[NSMutableDictionary alloc] init];
    
    [requestInfoMDict setValue:[NSNumber numberWithInt:MID_REQUEST_ALARMVIDEOURL] forKey:JK_ALARM_MID];
    [requestInfoMDict setValue:alarmGuid forKey:JK_ALARM_GUID];
    NSString *parseStr=[requestInfoMDict JSONString];
    
    [requestInfoMDict release];
    
    return [self getResponseByRequestBusinessServer:parseStr];
}



@end
