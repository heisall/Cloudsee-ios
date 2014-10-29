//
//  JVCLocalDeviceDateBaseHelp.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCLocalDeviceDateBaseHelp.h"
#import "JVCSystemConfigMacro.h"
#import "FMDatabase.h"
#import "JVCDeviceModel.h"
#import "CommonFunc.h"
#import "JVCDeviceHelper.h"
#import "JVCChannelModel.h"
#import "JVCLocalChannelDateBaseHelp.h"
#import "DBHelper.h"
#import "JVCOldSouchModel.h"

@interface JVCLocalDeviceDateBaseHelp ()
{
    FMDatabase *localDeviceSqlite;
    
}
@end
@implementation JVCLocalDeviceDateBaseHelp
static const NSString *sqlString = @"yunshitong.sql";//老的数据库名称
static JVCLocalDeviceDateBaseHelp *shareLocalDeviceDataBaseHelper = nil;

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCLocalDeviceDateBaseHelp *)shareDataBaseHelper
{
    @synchronized(self)
    {
        if (shareLocalDeviceDataBaseHelper == nil) {
            
            shareLocalDeviceDataBaseHelper = [[self alloc] init];
            
            [shareLocalDeviceDataBaseHelper  createLocalDeviceTable];
            
        }
        
        return shareLocalDeviceDataBaseHelper;
    }
    
    return shareLocalDeviceDataBaseHelper;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareLocalDeviceDataBaseHelper == nil) {
            
            shareLocalDeviceDataBaseHelper = [super allocWithZone:zone];
            
            return shareLocalDeviceDataBaseHelper;
        }
    }
    
    return nil;
}


/**
 *  创建用户表格
 */
- (void)createLocalDeviceTable
{
    //读取目录，如果目录下面没有这个数据库，创建，如果有什么也不处理
    NSString *sqlName = (NSString *)FMDB_USERINF;
    
    NSString *path = [[JVCSystemUtility shareSystemUtilityInstance] getAppDocumentsPathWithName:sqlName];
    
    localDeviceSqlite = [FMDatabase databaseWithPath:path];
    
    [localDeviceSqlite retain];
    
    if ([localDeviceSqlite open]) {//打开数据库
        
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS DEVICEINFOTABLE(ID INTEGER PRIMARY KEY,DEVICEYSTNUM TEXT,USERNAME TEXT, PASSWORD TEXT,LINKTYPE INT,IP TEXT,PORT TEXT,NICKNAME TEXT,ISCUSTOMLINKMODEL BOOL,ISIPADD BOOL)"];
        
        BOOL result = [localDeviceSqlite executeUpdate:sqlCreateTable];
        
        if (!result) {
            
            NSLog(@"error 创建数据库错误");
            
        }else
        {
            NSLog(@"success 创建数据库成功");
        }
    }
    
    [localDeviceSqlite close];
    
    
    
}

/**
 *  把数据插入到本地
 */
-(BOOL)addLocalDeviceToDataBase:(NSString *)ystNUm  deviceName:(NSString *)name  passWord:(NSString *)passWord
{
    
    if ([localDeviceSqlite open]) {
        //转化
        
        DDLogVerbose(@"ystNUm=%@====name=%@===passWord=%@",ystNUm,name,passWord);
        passWord = [CommonFunc  base64StringFromText:passWord];
        
        NSString *sqlInser = [NSString stringWithFormat:@"INSERT INTO DEVICEINFOTABLE(DEVICEYSTNUM,USERNAME,PASSWORD,LINKTYPE,IP,PORT,NICKNAME,ISCUSTOMLINKMODEL)VALUES('%@','%@','%@','%d','%@','%@','%@','%d')",ystNUm,name,passWord,0,@"",@"",ystNUm,0];
        
        BOOL result  = [localDeviceSqlite executeUpdate:sqlInser];
        if (!result) {
            
            NSLog(@"%s_插入数据错误",__FUNCTION__);
            return NO;
        }else{
            NSLog(@"%s_插入数据成功",__FUNCTION__);
            return YES;
            
        }
        [localDeviceSqlite close];
    }
    return NO;
}

/**
 *  把老数据导入成为新数据
 *
 *  @param ystNUm   云视通号
 *  @param name     用户名
 *  @param passWord 密码
 *  @param nickName 昵称
 *
 *  @return 是否成功 yes 成功  no 失败
 */
-(BOOL)convertOldDeviceToDataBase:(NSString *)ystNUm  deviceName:(NSString *)name  passWord:(NSString *)passWord  nickName:(NSString *)nickName
{
    
    if ([localDeviceSqlite open]) {
        //转化
        
        DDLogVerbose(@"ystNUm=%@====name=%@===passWord=%@",ystNUm,name,passWord);
        passWord = [CommonFunc  base64StringFromText:passWord];
        
        NSString *sqlInser = [NSString stringWithFormat:@"INSERT INTO DEVICEINFOTABLE(DEVICEYSTNUM,USERNAME,PASSWORD,LINKTYPE,IP,PORT,NICKNAME,ISCUSTOMLINKMODEL)VALUES('%@','%@','%@','%d','%@','%@','%@','%d')",ystNUm,name,passWord,0,@"",@"",nickName,0];
        
        BOOL result  = [localDeviceSqlite executeUpdate:sqlInser];
        if (!result) {
            
            NSLog(@"%s_插入数据错误",__FUNCTION__);
            return NO;
        }else{
            NSLog(@"%s_插入数据成功",__FUNCTION__);
            return YES;
            
        }
        [localDeviceSqlite close];
    }
    return NO;
}


/**
 *  把ip数据插入到本地
 */
-(BOOL)addLocalIPDeviceToDataBase:(NSString *)ip  port:(NSString *)port  deviceName:(NSString *)name  passWord:(NSString *)passWord
{
    
    if ([localDeviceSqlite open]) {
        //转化
        passWord = [CommonFunc  base64StringFromText:passWord];
        
        NSString *sqlInser = [NSString stringWithFormat:@"INSERT INTO DEVICEINFOTABLE(USERNAME,PASSWORD,LINKTYPE,IP,PORT,NICKNAME,ISCUSTOMLINKMODEL,DEVICEYSTNUM,ISIPADD)VALUES('%@','%@','%d','%@','%@','%@','%d','%@','%d')",name,passWord,1,ip,port,ip,1,ip,TYPE_Add_Device_IP_YES];
        
        BOOL result  = [localDeviceSqlite executeUpdate:sqlInser];
        if (!result) {
            
            NSLog(@"%s_插入数据错误",__FUNCTION__);
            return NO;
        }else{
            NSLog(@"%s_插入数据成功",__FUNCTION__);
            return YES;
            
        }
        [localDeviceSqlite close];
    }
    return NO;
}


/**
 *  删除设备
 */
-(BOOL)deleteLocalDeviceFromDataBase:(NSString *)ystNUm
{
    
    if ([localDeviceSqlite open]) {
        
        NSString *sqlInser = [NSString stringWithFormat:@"DELETE  FROM  DEVICEINFOTABLE  WHERE DEVICEYSTNUM = '%@'",ystNUm];
        
        BOOL result  = [localDeviceSqlite executeUpdate:sqlInser];
        
        if (!result) {
            
            NSLog(@"%s_删除数据错误",__FUNCTION__);
            return NO;
            
        }else{
            
            NSLog(@"%s_删除数据成功",__FUNCTION__);
            return YES;
            
        }
        [localDeviceSqlite close];
    }
    return NO;
}

/**
 *  修改设备
 */
-(BOOL)updateLocalDeviceInfo:(NSString *)ystNUm
                    NickName:(NSString *)nickName
                  deviceName:(NSString *)deviceName
                    passWord:(NSString *)passWord
                    linkType:(int )linkType
           iscustomLinkModel:(BOOL)linkModel
                        port:(NSString*)port
                          ip:(NSString *)ip

{
    
    if ([localDeviceSqlite open]) {
        
        passWord = [CommonFunc  base64StringFromText:passWord];
        
        NSString *sqlInser = [NSString stringWithFormat:@"UPDATE  DEVICEINFOTABLE SET USERNAME = '%@',PASSWORD ='%@',LINKTYPE ='%d',IP='%@',PORT='%@',NICKNAME='%@',ISCUSTOMLINKMODEL='%d' WHERE DEVICEYSTNUM = '%@'",deviceName,passWord,linkType,ip,port,nickName,linkModel,ystNUm];
        
        BOOL result  = [localDeviceSqlite executeUpdate:sqlInser];
        if (!result) {
            
            NSLog(@"%s_跟新数据错误",__FUNCTION__);
            return NO;
        }else{
            NSLog(@"%s_更新数据成功",__FUNCTION__);
            return YES;
            
        }
        [localDeviceSqlite close];
    }
    return NO;

}

/**
 *  修改昵称、用户名、密码
 */
-(BOOL)updateLocalDeviceNickName :(NSString *)ystNUm
                    NickName:(NSString *)nickName
                  deviceName:(NSString *)deviceName
                    passWord:(NSString *)passWord
           iscustomLinkModel:(BOOL)linkModel

{
    
    if ([localDeviceSqlite open]) {
        
        passWord = [CommonFunc  base64StringFromText:passWord];
        
        NSString *sqlInser = [NSString stringWithFormat:@"UPDATE  DEVICEINFOTABLE SET USERNAME = '%@',PASSWORD ='%@',NICKNAME='%@',ISCUSTOMLINKMODEL='%d' WHERE DEVICEYSTNUM = '%@'",deviceName,passWord,nickName,linkModel,ystNUm];
        
        BOOL result  = [localDeviceSqlite executeUpdate:sqlInser];
        if (!result) {
            
            NSLog(@"%s_跟新数据错误",__FUNCTION__);
            return NO;
        }else{
            NSLog(@"%s_更新数据成功",__FUNCTION__);
            return YES;
            
        }
        [localDeviceSqlite close];
    }
    return NO;
    
}

/**
 *  修改设备ip 端口号 用户名 密码
 *
 *  @param ystNUm                云视通号
 *  @param deviceName            用户名
 *  @param passWord              密码
 *  @param linkModel             是否被用户修改
 *  @param port                  端口号
 *  @ip                          ip
*  @return 是否正确
 */
-(BOOL)updateLocalDeviceLickInfoWithYst:(NSString *)ystNUm
                             deviceName:(NSString *)deviceName
                               passWord:(NSString *)passWord
                      iscustomLinkModel:(BOOL)linkModel
                                   port:(NSString*)port
                                     ip:(NSString *)ip
{

    if ([localDeviceSqlite open]) {
        
        passWord = [CommonFunc  base64StringFromText:passWord];
        
        NSString *sqlInser = [NSString stringWithFormat:@"UPDATE  DEVICEINFOTABLE SET USERNAME = '%@',PASSWORD ='%@',IP='%@',PORT='%@',ISCUSTOMLINKMODEL='%d' WHERE DEVICEYSTNUM = '%@'",deviceName,passWord,ip,port,linkModel,ystNUm];
        
        BOOL result  = [localDeviceSqlite executeUpdate:sqlInser];
        if (!result) {
            
            NSLog(@"%s_跟新数据错误",__FUNCTION__);
            return NO;
        }else{
            NSLog(@"%s_更新数据成功",__FUNCTION__);
            return YES;
            
        }
        [localDeviceSqlite close];
    }
    return NO;

}

/**
 *  获取所有的本地设备列表
 *
 *  @return 设备列表数组
 */
- (NSMutableArray *)getAllLocalDeviceList
{
    NSMutableArray *userArray = [[[NSMutableArray alloc] init] autorelease];
    
    if ([localDeviceSqlite open]) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM DEVICEINFOTABLE "];
        
        FMResultSet *rsSet = [localDeviceSqlite executeQuery:sqlStr];
        
        while ([rsSet next]) {
            
            NSString *strDeviceYST= [rsSet stringForColumn:@"DEVICEYSTNUM"];
            NSString *strUserName = [rsSet stringForColumn:@"USERNAME"];
            NSString *strPassWord = [rsSet stringForColumn:@"PASSWORD"];
            strPassWord = [CommonFunc textFromBase64String:strPassWord];
            DDLogVerbose(@"ystNUm=%@====name=%@===passWord=%@",strDeviceYST,strUserName,strPassWord);
            int iLintType = [rsSet intForColumn:@"LINKTYPE"];
            NSString *strIP = [rsSet stringForColumn:@"IP"];
            NSString *strPort = [rsSet stringForColumn:@"PORT"];
            NSString *strNickName = [rsSet stringForColumn:@"NICKNAME"];
            BOOL bISCUSTOMLINKMODEL=  [rsSet boolForColumn:@"ISCUSTOMLINKMODEL"];
            BOOL bIpAddState=  [rsSet boolForColumn:@"ISIPADD"];

            
            JVCDeviceModel *deviceModel = [[JVCDeviceModel alloc]initDeviceWithYstNum:strDeviceYST
                                                                             nickName:strNickName
                                                                       deviceUserName:strUserName
                                                                       devicePassWord:strPassWord
                                                                             deviceIP:strIP
                                                                           devicePort:strPort
                                                                    deviceOnlineState:1
                                                                       deviceLinkType:iLintType
                                                                        deviceHasWifi:1
                                                             devicebICustomLinckModel:bISCUSTOMLINKMODEL
                                                                           ipAddState:bIpAddState];
            [userArray addObject:deviceModel];
            
            [deviceModel release];
        }
        [localDeviceSqlite close];

    }
    return userArray;
}

/**
 *  判断云视通号在不在数据中
 *
 *  @param ystNum 云视通号
 *
 *  @return yes 在    no：不在
 */
- (BOOL)judgeYstNumInDateBase:(NSString *)ystNum
{
    if ([localDeviceSqlite open]) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM DEVICEINFOTABLE WHERE DEVICEYSTNUM='%@'",ystNum];
        
        FMResultSet *rsSet = [localDeviceSqlite executeQuery:sqlStr];
        
        while ([rsSet next]) {
            
            return YES;
        }
        [localDeviceSqlite close];
        
    }
    
    return NO;

}

#pragma mark ===============================
/**
 *  获取所有的本地设备列表
 *
 *  @return 设备列表数组
 */
- (NSMutableArray *)getOldAllLocalDeviceList
{
    
    NSString *path = [[JVCSystemUtility shareSystemUtilityInstance] getAppDocumentsPathWithName:(NSString *)sqlString];
    
     FMDatabase *localOldDeviceSqlite = [FMDatabase databaseWithPath:path];

    NSMutableArray *userArray = [[[NSMutableArray alloc] init] autorelease];
    
    if ([localOldDeviceSqlite open]) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM addSource "];
        
        FMResultSet *rsSet = [localDeviceSqlite executeQuery:sqlStr];
        
        while ([rsSet next]) {
            
            NSString *strDeviceYST= [rsSet stringForColumn:@"yunshitongNum"];
            NSString *strUserName = [rsSet stringForColumn:@"userName"];
            NSString *strPassWord = [rsSet stringForColumn:@"password"];
            int iLintType = [rsSet intForColumn:@"linkType"];
            NSString *strIP = [rsSet stringForColumn:@"ip"];
            NSString *strPort = [rsSet stringForColumn:@"port"];
            NSString *strNickName = [rsSet stringForColumn:@"channelName"];
            NSString *strChannelNum = [rsSet stringForColumn:@"channelNumber"];
            int deviceType =  [rsSet intForColumn:@"windowindex"];
            BOOL bISCUSTOMLINKMODEL=  [rsSet boolForColumn:@"windowindex"];
            BOOL bIpAddState=  [rsSet boolForColumn:@"ISIPADD"];
            
            if (deviceType == OldDeviceType_Device) {
                
                JVCDeviceModel *deviceModel = [[JVCDeviceModel alloc]initDeviceWithYstNum:strDeviceYST
                                                                                 nickName:strNickName
                                                                           deviceUserName:strUserName
                                                                           devicePassWord:strPassWord
                                                                                 deviceIP:strIP
                                                                               devicePort:strPort
                                                                        deviceOnlineState:1
                                                                           deviceLinkType:iLintType
                                                                            deviceHasWifi:1
                                                                 devicebICustomLinckModel:bISCUSTOMLINKMODEL
                                                                               ipAddState:bIpAddState];
                [userArray addObject:deviceModel];
                
                [deviceModel release];

            }else{
            
                JVCChannelModel *channelMode = [[JVCChannelModel alloc] initChannelWithystNum:strDeviceYST nickName:strNickName channelNum:strChannelNum.intValue ];
                
                [userArray addObject:channelMode];
                
                [channelMode release];
            }
            
      
        }
        [localDeviceSqlite close];
        
    }
    return userArray;
}

/**
 * 把老数据转化为新数据存到数据库中
 */
- (void)converOldDeviceListInDateFame
{
    
    DBHelper *helpDate = [[DBHelper alloc]init];
    NSArray *array = [helpDate querySourceListData:0];
    
    for (JVCOldSouchModel *model in array) {
        
        if (model.windowIndex == OldDeviceType_Device) {
            
            JVCDeviceModel *deviceModel = [[JVCDeviceModel alloc]initDeviceWithYstNum:model.yunShiTongNum
                                                                             nickName:model.channelName
                                                                       deviceUserName:model.userName
                                                                       devicePassWord:model.password
                                                                             deviceIP:@""
                                                                           devicePort:@""
                                                                    deviceOnlineState:1
                                                                       deviceLinkType:0
                                                                        deviceHasWifi:1
                                                             devicebICustomLinckModel:0
                                                                           ipAddState:0];

            
            [self convertOldDeviceToDataBase:deviceModel.yunShiTongNum deviceName:deviceModel.userName passWord:deviceModel.passWord nickName:deviceModel.nickName];
            
            [deviceModel release];

        }else{
            
            JVCChannelModel *channelMode = [[JVCChannelModel alloc] initChannelWithystNum:model.yunShiTongNum nickName:model.channelName channelNum:model.channelNumber.intValue ];

            [[JVCLocalChannelDateBaseHelp shareDataBaseHelper] addLocalChannelToDataBase:channelMode.strDeviceYstNumber nickName:channelMode.strNickName ChannelSortNum:channelMode.nChannelValue];

        }
    }
    
    [helpDate release];
    
    [self deleteOldLocalDateBase];
}

/**
 *  删除数据库
 *
 *  @return yes成功  no 失败
 */
- (BOOL )deleteOldLocalDateBase
{
    BOOL success;
    NSError *error;
    NSString *path = [[JVCSystemUtility shareSystemUtilityInstance] getAppDocumentsPathWithName:(NSString *)sqlString];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    FMDatabase *localOldDeviceSqlite = [FMDatabase databaseWithPath:path];

    // delete the old db.
    if ([fileManager fileExistsAtPath:path])
    {
        [localOldDeviceSqlite close];
        success = [fileManager removeItemAtPath:path error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to delete old database file with message '%@'.", [error localizedDescription]);
            
            return NO;
        }
    }
    
    return YES;
}


@end
