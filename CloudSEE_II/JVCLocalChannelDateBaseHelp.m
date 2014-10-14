//
//  JVCLocalChannelDateBaseHelp.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCLocalChannelDateBaseHelp.h"


#import "JVCSystemConfigMacro.h"
#import "FMDatabase.h"
#import "JVCChannelModel.h"

@interface JVCLocalChannelDateBaseHelp ()
{
    FMDatabase *localChannelSqlite;
    
}
@end
@implementation JVCLocalChannelDateBaseHelp

static JVCLocalChannelDateBaseHelp *shareLocalChannelDataBaseHelper = nil;

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCLocalChannelDateBaseHelp *)shareDataBaseHelper
{
    @synchronized(self)
    {
        if (shareLocalChannelDataBaseHelper == nil) {
            
            shareLocalChannelDataBaseHelper = [[self alloc] init];
            
            [shareLocalChannelDataBaseHelper  createLocalChannelTable];
            
        }
        
        return shareLocalChannelDataBaseHelper;
    }
    
    return shareLocalChannelDataBaseHelper;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareLocalChannelDataBaseHelper == nil) {
            
            shareLocalChannelDataBaseHelper = [super allocWithZone:zone];
            
            return shareLocalChannelDataBaseHelper;
        }
    }
    
    return nil;
}


/**
 *  创建用户表格
 */
- (void)createLocalChannelTable
{
    //读取目录，如果目录下面没有这个数据库，创建，如果有什么也不处理
    NSString *sqlName = (NSString *)FMDB_USERINF;
    
    NSString *path = [[JVCSystemUtility shareSystemUtilityInstance] getAppDocumentsPathWithName:sqlName];
    
    localChannelSqlite = [FMDatabase databaseWithPath:path];
    
    [localChannelSqlite retain];
    
    if ([localChannelSqlite open]) {//打开数据库
        
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CHANNELINFOTABLE(ID INTEGER PRIMARY KEY,DEVICEYSTNUM TEXT,NICKNAME TEXT,CHANNELNUM INT)"];
        
        BOOL result = [localChannelSqlite executeUpdate:sqlCreateTable];
        
        if (!result) {
            
            NSLog(@"error 创建数据库错误");
            
        }else
        {
            NSLog(@"success 创建数据库成功");
        }
    }
    
    [localChannelSqlite close];
    
}

/**
 *  把数据插入到本地
 */
-(BOOL)addLocalChannelToDataBase:(NSString *)ystNUm  nickName:(NSString *)name  ChannelSortNum:(int)channelNum
{
    
    if ([localChannelSqlite open]) {
        //转化
        
        NSString *sqlInser = [NSString stringWithFormat:@"INSERT INTO CHANNELINFOTABLE(DEVICEYSTNUM,NICKNAME,CHANNELNUM)VALUES('%@','%@','%d')",ystNUm,name,channelNum];
        
        BOOL result  = [localChannelSqlite executeUpdate:sqlInser];
        if (!result) {
            
            NSLog(@"%s_插入数据错误",__FUNCTION__);
            return NO;
        }else{
            NSLog(@"%s_插入数据成功",__FUNCTION__);
            return YES;
            
        }
        [localChannelSqlite close];
    }
    return NO;
}

/**
 *  删除通道
 */
-(BOOL)deleteLocalChannelFromDataBase:(NSString *)ystNUm
{
    
    if ([localChannelSqlite open]) {
        
        NSString *sqlInser = [NSString stringWithFormat:@"DELETE  FROM  CHANNELINFOTABLE  WHERE DEVICEYSTNUM = '%@'",ystNUm];
        
        BOOL result  = [localChannelSqlite executeUpdate:sqlInser];
        
        if (!result) {
            
            NSLog(@"%s_删除数据错误",__FUNCTION__);
            return YES;
            
        }else{
            
            NSLog(@"%s_删除数据成功",__FUNCTION__);
            return NO;
            
        }
        [localChannelSqlite close];
    }
    return NO;
}

/**
 *  更新通道
 */
-(BOOL)updateLocalChannelInfo:(NSString *)ystNUm
                    NickName:(NSString *)nickName


{
    
    if ([localChannelSqlite open]) {
        
        
        NSString *sqlInser = [NSString stringWithFormat:@"UPDATE  CHANNELINFOTABLE SET NICKNAME='%@' WHERE DEVICEYSTNUM = '%@'",nickName,ystNUm];
        
        BOOL result  = [localChannelSqlite executeUpdate:sqlInser];
        if (!result) {
            
            NSLog(@"%s_跟新数据错误",__FUNCTION__);
            return NO;
        }else{
            NSLog(@"%s_更新数据成功",__FUNCTION__);
            return YES;
            
        }
        [localChannelSqlite close];
    }
    return NO;
    
}

/**
 *  获取所有的本地通道列表
 *
 *  @return 设备列表数组
 */
- (NSMutableArray *)getAllChannnelList
{
    NSMutableArray *channelArray = [[[NSMutableArray alloc] init] autorelease];
    
    if ([localChannelSqlite open]) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM CHANNELINFOTABLE"];
        
        FMResultSet *rsSet = [localChannelSqlite executeQuery:sqlStr];
        
        while ([rsSet next]) {
            
            NSString *strDeviceYST= [rsSet stringForColumn:@"DEVICEYSTNUM"];
            int iChananelNum = [rsSet intForColumn:@"CHANNELNUM"];
            NSString *strNickName = [rsSet stringForColumn:@"NICKNAME"];
            
            JVCChannelModel *channeModel = [[JVCChannelModel alloc] initChannelWithystNum:strDeviceYST nickName:strNickName channelNum:iChananelNum];
            
            [channelArray addObject:channeModel];
            
            [channeModel release];
        }
        [localChannelSqlite close];
    }
    return channelArray;
}

/**
 *  获取单个通道的列表
 *
 *  @return 设备列表数组
 */
- (NSMutableArray *)getSingleChannnelListWithYstNum:(NSString *)ystNum
{
    NSMutableArray *channelArray = [[[NSMutableArray alloc] init] autorelease];
    
    if ([localChannelSqlite open]) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM CHANNELINFOTABLE WHERE DEVICEYSTNUM = '%@'",ystNum];
        
        FMResultSet *rsSet = [localChannelSqlite executeQuery:sqlStr];
        
        while ([rsSet next]) {
            
            NSString *strDeviceYST= [rsSet stringForColumn:@"DEVICEYSTNUM"];
            int iChananelNum = [rsSet intForColumn:@"CHANNELNUM"];
            NSString *strNickName = [rsSet stringForColumn:@"NICKNAME"];
            
            JVCChannelModel *channeModel = [[JVCChannelModel alloc] initChannelWithystNum:strDeviceYST nickName:strNickName channelNum:iChananelNum];
            
            [channelArray addObject:channeModel];
            
            [channeModel release];
        }
        [localChannelSqlite close];
    }
    return channelArray;
}


@end
