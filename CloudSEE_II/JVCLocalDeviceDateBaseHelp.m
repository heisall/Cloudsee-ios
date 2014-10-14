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

@interface JVCLocalDeviceDateBaseHelp ()
{
    FMDatabase *localDeviceSqlite;
    
}
@end
@implementation JVCLocalDeviceDateBaseHelp

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
        
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS DEVICEINFOTABLE(ID INTEGER PRIMARY KEY,DEVICEYSTNUM TEXT,USERNAME TEXT, PASSWORD TEXT,LINKTYPE INT,IP TEXT,PORT TEXT,NICKNAME TEXT,ISCUSTOMLINKMODEL BOOL)"];
        
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
 *  删除设备
 */
-(BOOL)deleteLocalDeviceFromDataBase:(NSString *)ystNUm
{
    
    if ([localDeviceSqlite open]) {
        
        NSString *sqlInser = [NSString stringWithFormat:@"DELETE  FROM  DEVICEINFOTABLE  WHERE USERNAME = '%@'",ystNUm];
        
        BOOL result  = [localDeviceSqlite executeUpdate:sqlInser];
        
        if (!result) {
            
            NSLog(@"%s_删除数据错误",__FUNCTION__);
            return YES;
            
        }else{
            
            NSLog(@"%s_删除数据成功",__FUNCTION__);
            return NO;
            
        }
        [localDeviceSqlite close];
    }
    return NO;
}

/**
 *  删除设备
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
            
            int iLintType = [rsSet intForColumn:@"LINKTYPE"];
            NSString *strIP = [rsSet stringForColumn:@"IP"];
            NSString *strPort = [rsSet stringForColumn:@"PORT"];
            NSString *strNickName = [rsSet stringForColumn:@"NICKNAME"];
            BOOL bISCUSTOMLINKMODEL=  [rsSet boolForColumn:@"ISCUSTOMLINKMODEL"];
            
            JVCDeviceModel *deviceModel = [[JVCDeviceModel alloc]initDeviceWithYstNum:strDeviceYST
                                                                             nickName:strNickName
                                                                       deviceUserName:strUserName
                                                                       devicePassWord:strPassWord
                                                                             deviceIP:strIP
                                                                           devicePort:strPort
                                                                    deviceOnlineState:1
                                                                       deviceLinkType:iLintType
                                                                        deviceHasWifi:1
                                                             devicebICustomLinckModel:bISCUSTOMLINKMODEL];
            [userArray addObject:deviceModel];
            
            [deviceModel release];
        }
        [localDeviceSqlite close];

    }
    return userArray;
}


@end
