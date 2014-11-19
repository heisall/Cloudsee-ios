//
//  JVCLANScanWithSetHelpYSTNOHelper.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-10-13.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCLANScanWithSetHelpYSTNOHelper.h"
#import "JVCCloudSEENetworkInterface.h"

@interface JVCLANScanWithSetHelpYSTNOHelper ()

#define MAX_PATH_01 256
/*分控回调函数*/
typedef struct
{
    char chGroup[4];
    int  nYSTNO;
    int  nCardType;
    int  nChannelCount;
    char chClientIP[16];
    int  nClientPort;
    int  nVariety;
    char chDeviceName[100];
    BOOL bTimoOut;
    
    int  nNetMod;//例如 是否具有Wifi功能：nNetMod&NET_MOD_WIFI
    int  nCurMod;//例如 当前使用的（WIFI或有线）
    
}STLANSRESULT_01;

typedef struct STBASEYSTNO
{
    char chGroup[4];
    int  nYSTNO;
    int  nChannel;
    char chPName[MAX_PATH_01];
    char chPWord[MAX_PATH_01];
    int  nConnectStatus;
    
}STBASEYSTNO; //云视通号码基本信息，用于初始化小助手的虚连接

@end
@implementation JVCLANScanWithSetHelpYSTNOHelper
@synthesize delegate;

static JVCLANScanWithSetHelpYSTNOHelper *jvcLANScanWithSetHelpYSTNOHelper = nil;
static const int kScanLocalServerPort      = 9400; //默认9400
static const int kScanDeviceServerPort     = 6666;
static const int kScanDeviceKeepTimeSecond = 1;

NSMutableArray *CacheMArrayDeviceList;

-(void)dealloc {

    [CacheMArrayDeviceList release];
    [super dealloc];
}

/**
 *  获取云视通网络库广播和设置设备小助手的助手类
 *
 *  @return 云视通网络库逻辑类
 */
+(JVCLANScanWithSetHelpYSTNOHelper *)sharedJVCLANScanWithSetHelpYSTNOHelper;
{
    
    @synchronized(self){
        
        if (jvcLANScanWithSetHelpYSTNOHelper == nil) {
            
            jvcLANScanWithSetHelpYSTNOHelper = [[self alloc] init];
            
            CacheMArrayDeviceList=[[NSMutableArray alloc] initWithCapacity:10];
            
            JVC_StartLANSerchServer(kScanLocalServerPort, kScanDeviceServerPort,SerachLANAllDeviceInfo);
            
            return jvcLANScanWithSetHelpYSTNOHelper;
        }
    }
    
    return jvcLANScanWithSetHelpYSTNOHelper;
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
        
        if (jvcLANScanWithSetHelpYSTNOHelper == nil) {
            
            jvcLANScanWithSetHelpYSTNOHelper = [super allocWithZone:zone];
            
            return jvcLANScanWithSetHelpYSTNOHelper;
        }
    }
    
    return nil;
}

#pragma mark --------------------------------------局域网广播搜索设备方法

void SerachLANAllDeviceInfo(STLANSRESULT_01 stlanResultData) {
    
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    
    if (stlanResultData.nYSTNO>0) {
        
        NSMutableString *strYstNumber=[[NSMutableString alloc] initWithCapacity:10];
        
        [strYstNumber appendFormat:@"%s",stlanResultData.chGroup];
        
        if ([strYstNumber isEqualToString:@""]|| [strYstNumber isEqualToString:nil]) {
            
            [strYstNumber appendFormat:@"A%d",stlanResultData.nYSTNO];
            
        }else{
            
            [strYstNumber appendFormat:@"%d",stlanResultData.nYSTNO];
            
        }
        
        for (JVCLanScanDeviceModel *LanModel in CacheMArrayDeviceList) {
            
            if ([[LanModel.strYstNumber uppercaseString] isEqualToString:strYstNumber]) {
                
                [strYstNumber release];
                [pool release];
                return;
            }
        }
        
        int _isNetWork=(stlanResultData.nNetMod & 0x01);
        int _isUserWIfi=stlanResultData.nCurMod ;
        
        JVCLanScanDeviceModel *lanModel=[[JVCLanScanDeviceModel alloc] init];
        
        lanModel.strYstNumber=strYstNumber;
        lanModel.strDeviceIP=[NSString stringWithFormat:@"%s",stlanResultData.chClientIP];
        lanModel.strDevicePort=[NSString stringWithFormat:@"%d",stlanResultData.nClientPort];
        lanModel.strDeviceName=[NSString stringWithFormat:@"%s",stlanResultData.chDeviceName];
        lanModel.iDeviceVariety=stlanResultData.nVariety;
        lanModel.iDeviceChannelCount=stlanResultData.nChannelCount;
        
        if (_isUserWIfi==1) {
            
            lanModel.iCurMod=YES;
        }
        
        if (_isNetWork) {
            
            lanModel.iNetMod=YES;
        }
        
        [CacheMArrayDeviceList addObject:lanModel];
        
        [strYstNumber release];
        [lanModel release];
        
    }
    
    if (stlanResultData.bTimoOut) {
        
        DDLogCVerbose(@"%s--------endLanserach--------",__FUNCTION__);
        [jvcLANScanWithSetHelpYSTNOHelper performSelectorOnMainThread:@selector(sendCallBack) withObject:nil waitUntilDone:NO];
        
    }
    [pool release];
    
}

/**
 *  返回广播获取的设备集合
 */
-(void)sendCallBack{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(SerachLANAllDevicesAsynchronousRequestWithDeviceListDataCallBack:)]) {
        
        [self.delegate SerachLANAllDevicesAsynchronousRequestWithDeviceListDataCallBack:CacheMArrayDeviceList];
    }
}

/**
 *  搜索局域网设备的函数
 */
-(void)SerachLANAllDevicesAsynchronousRequestWithDeviceListData{
    
    [CacheMArrayDeviceList removeAllObjects];
    
    JVC_MOLANSerchDevice([@"" UTF8String], 0, 0, 0,[@"" UTF8String], kScanDeviceKeepTimeSecond*1000);
}

/**
 *  设置小助手
 *
 *  @param devicesMArray devicesMArray
 */
-(void)setDevicesHelper:(NSArray *)devicesMArray{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [devicesMArray retain];
        
        unsigned char bBuffer[([devicesMArray count])*sizeof(STBASEYSTNO)];
        
        for (int i=0; i<devicesMArray.count; i++) {
            
            JVCLocalCacheModel *model=[devicesMArray objectAtIndex:i];
            
            int kk;
            
            for (kk=0; kk<model.strYstNumber.length; kk++) {
                
                unsigned char c=[model.strYstNumber characterAtIndex:kk];
                
                if (c<='9' && c>='0') {
                    
                    break;
                }
            }
            
            NSString *sGroup=[model.strYstNumber substringToIndex:kk];
            NSString *iYstNum=[model.strYstNumber substringFromIndex:kk];
            STBASEYSTNO stinfo;
            
            if ([sGroup isEqualToString:NULL]||[sGroup isEqualToString:nil]||[iYstNum intValue]<=0) {
                
                return;
            }
            
            memset(stinfo.chGroup, 0, 4);
            memcpy(stinfo.chGroup, [sGroup UTF8String], strlen([sGroup UTF8String]));
            
            stinfo.nYSTNO = [iYstNum intValue];
            stinfo.nChannel =1 ;
            stinfo.nConnectStatus=0;
            memset(stinfo.chPName, 0, MAX_PATH_01);
            memcpy(stinfo.chPName, [model.strUserName UTF8String], strlen([model.strUserName UTF8String]));
            
            memset(stinfo.chPWord, 0, MAX_PATH_01);
            
            memcpy(stinfo.chPWord, [model.strPassWord UTF8String], strlen([model.strPassWord UTF8String]));
            
            if (i==0) {
                
                memcpy(bBuffer, &stinfo, sizeof(STBASEYSTNO));
                
            }else{
                
                memcpy(&bBuffer[i*sizeof(STBASEYSTNO)], &stinfo, sizeof(STBASEYSTNO));
            }
        }
        
        JVC_SetHelpYSTNO((unsigned char *)bBuffer,devicesMArray.count*sizeof(STBASEYSTNO));
        
        [devicesMArray release];
        
    });
}

@end
