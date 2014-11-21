//
//  JVCDataBaseHelper.m
//  CloudSEE_II
//  操作数据库帮助类
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDataBaseHelper.h"
#import "FMDatabase.h"
#import "CommonFunc.h"
#import "JVCUserInfoModel.h"
#import "JVCSystemUtility.h"
#import "JVCSystemConfigMacro.h"
/**
 *  账号信息
 */
//static  NSString const* USERINFO_NAME       =  @"user" ;//用户名
//
//static  NSString const* USERINFO_PW         =  @"password";//密码
//
//static  NSString const* USERINFO_TIMER      =   @"timer";//最后一次登录时间


@interface JVCDataBaseHelper ()
{
    FMDatabase *userInfoSqlite;

}

@end
@implementation JVCDataBaseHelper

static JVCDataBaseHelper *shareDataBaseHelper = nil;

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCDataBaseHelper *)shareDataBaseHelper
{
    @synchronized(self)
    {
        if (shareDataBaseHelper == nil) {
            
            shareDataBaseHelper = [[self alloc] init];
            
            [shareDataBaseHelper  createUserInfoTable];
            
            [shareDataBaseHelper createLoginUserInfoTable];

        }
        
        return shareDataBaseHelper;
    }
    
    return shareDataBaseHelper;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareDataBaseHelper == nil) {
            
            shareDataBaseHelper = [super allocWithZone:zone];
            
            return shareDataBaseHelper;
        }
    }
    
    return nil;
}



/**
 *  设置常量为用户名密码
 *
 *  @param userName 用户名
 *  @param passWord 密码
 */
- (void)setConstantUserInfoWithUserName:(NSString *)userName passWord:(NSString *)passWord
{
    kkUserName =  userName.lowercaseString;
    kkPassword =  passWord.lowercaseString;
    
}


/**
 *  获取当前的时间截
 */
- (NSTimeInterval)getCurrenttime
{
    NSDate *tCurrentTimer = [NSDate date];
    return [tCurrentTimer timeIntervalSince1970];
}


/**
 *  创建用户表格
 */
- (void)createUserInfoTable
{
    //读取目录，如果目录下面没有这个数据库，创建，如果有什么也不处理
    NSString *sqlName = (NSString *)FMDB_USERINF;
    
    NSString *path = [[JVCSystemUtility shareSystemUtilityInstance] getAppDocumentsPathWithName:sqlName];
    
    
    //判断有没有这个数据库
    if (![[NSFileManager defaultManager]fileExistsAtPath:path]) {//没有这个数据库
        
        userInfoSqlite = [FMDatabase databaseWithPath:path];
        
        [userInfoSqlite retain];
        
        if ([userInfoSqlite open]) {//打开数据库
            
            NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS USERINFOTABLE(ID INTEGER PRIMARY KEY,USERNAME TEXT, PASSWORD TEXT,LOGINTIMER DOUBLE,AUTOLOGINSTATE BOOL)"];
            
            BOOL result = [userInfoSqlite executeUpdate:sqlCreateTable];
            
            if (!result) {
                
                NSLog(@"error 创建数据库错误");
                
            }else
            {
                NSLog(@"success 创建数据库成功");
            }
        }
        
        [userInfoSqlite close];
        
    }else{
        
        userInfoSqlite = [FMDatabase databaseWithPath:path];
        
        [userInfoSqlite retain];
        
    }
    
}


/**
 *  登录成功后，将用户名，密码存到数据库中，首先看看数据库中有这条数据吗，有更新，没有直接写入
 *
 *  @param userName 用户名
 *  @param passWord 秘密
 */
- (void)writeUserInfoToDataBaseWithUserName:(NSString *)userName  passWord:(NSString *)passWord
{
    
    if ([userInfoSqlite open]) {
        
        NSString *sqlSerach = [NSString stringWithFormat:@"SELECT COUNT(*) AS 'TOTALCOUNT' FROM  USERINFOTABLE WHERE USERNAME = '%@' COLLATE NOCASE",userName];//,userName];
        
        FMResultSet *resultSet  = [userInfoSqlite executeQuery:sqlSerach];
        
            while ([resultSet next]) {
                
                NSUInteger totalNum = [resultSet intForColumn:@"TOTALCOUNT"];
                
                DDLogInfo(@"查询数据库结果,数据库中共有==%d",totalNum);
                
                if (totalNum == 0) {//数据库没有，直接插入
                    
                    [self insertUserInfoWithUserName:userName passWord:passWord];
                    
                    
                }else{//数据库中有，直接更新时间，以及密码
                    
                    [self updateUserPasswordInfoWithUserName:userName modifyPassWord:passWord];
                    
                    [self updateUserLoginTimeInfoWithUserName:userName];
                    
                }
            }
        
        [userInfoSqlite close];
    }

}

/**
 *  登录成功后，将用户名，密码存到数据库中，首先看看数据库中有这条数据吗，有更新，没有直接写入
 *
 *  @param userName 用户名
 *  @param passWord 秘密
 */
- (void)writeOldUserInfoToDataBaseWithUserName:(NSString *)userName  passWord:(NSString *)passWord  loginTimer:(int)loginTimer
{
    
    if ([userInfoSqlite open]) {
        
        NSString *sqlSerach = [NSString stringWithFormat:@"SELECT COUNT(*) AS 'TOTALCOUNT' FROM  USERINFOTABLE WHERE USERNAME = '%@'",userName];//,userName];
        
        FMResultSet *resultSet  = [userInfoSqlite executeQuery:sqlSerach];
        
        while ([resultSet next]) {
            
            NSUInteger totalNum = [resultSet intForColumn:@"TOTALCOUNT"];
            
            DDLogInfo(@"查询数据库结果,数据库中共有==%d",totalNum);
            
            if (totalNum == 0) {//数据库没有，直接插入
                
                [self insertUserInfoWithUserName:userName passWord:passWord loginTimer:loginTimer];
                
            }
        }
        
        [userInfoSqlite close];
    }
    
}


/**
 *  往表格中插入数据
 *
 *  @param userName 用户名
 *  @param passWord 密码
 */
- (void)insertUserInfoWithUserName:(NSString *)userName  passWord:(NSString *)passWord
{
    if ([userInfoSqlite open]) {
        //转化
        passWord = [CommonFunc  base64StringFromText:passWord];
        
        NSString *sqlInser = [NSString stringWithFormat:@"INSERT INTO USERINFOTABLE(USERNAME,PASSWORD,LOGINTIMER,AUTOLOGINSTATE)VALUES('%@','%@','%f','%d')",userName,passWord,[self getCurrenttime],kLoginStateON];
        
        BOOL result  = [userInfoSqlite executeUpdate:sqlInser];
        if (!result) {
            
            NSLog(@"%s_插入数据错误",__FUNCTION__);
        }else{
            NSLog(@"%s_插入数据成功",__FUNCTION__);
            
        }
        
        [userInfoSqlite close];
    }
}

/**
 *  往表格中插入数据
 *
 *  @param userName 用户名
 *  @param passWord 密码
 */
- (void)insertUserInfoWithUserName:(NSString *)userName  passWord:(NSString *)passWord  loginTimer:(int)timer
{
    if ([userInfoSqlite open]) {
        //转化
        passWord = [CommonFunc  base64StringFromText:passWord];
        
        NSString *sqlInser = [NSString stringWithFormat:@"INSERT INTO USERINFOTABLE(USERNAME,PASSWORD,LOGINTIMER,AUTOLOGINSTATE)VALUES('%@','%@','%f','%d')",userName,passWord,(CGFloat)timer,kLoginStateON];
        
        BOOL result  = [userInfoSqlite executeUpdate:sqlInser];
        if (!result) {
            
            NSLog(@"%s_插入数据错误",__FUNCTION__);
        }else{
            NSLog(@"%s_插入数据成功",__FUNCTION__);
            
        }
        
        [userInfoSqlite close];
    }
}

/**
 *  根据用户名修改用户密码
 *
 *  @param userName 用户名
 *  @param passWord 密码
 */
- (void)updateUserPasswordInfoWithUserName:(NSString *)userName  modifyPassWord:(NSString *)passWord
{
    if ([userInfoSqlite open]) {
        
        passWord = [CommonFunc  base64StringFromText:passWord];
        
        NSString *sqlInser = [NSString stringWithFormat:@"UPDATE  USERINFOTABLE SET PASSWORD='%@',AUTOLOGINSTATE='%d' WHERE USERNAME = '%@'",passWord,kLoginStateON,userName];
        
        BOOL result  = [userInfoSqlite executeUpdate:sqlInser];
        if (!result) {
            
            NSLog(@"%s_跟新数据错误",__FUNCTION__);
        }else{
            NSLog(@"%s_更新数据成功",__FUNCTION__);
            
        }
        
        [userInfoSqlite close];
    }
    
}

/**
 *  根据用户名修改登录时间
 *
 *  @param userName 登录时间
 */
- (void)updateUserLoginTimeInfoWithUserName:(NSString *)userName
{
    if ([userInfoSqlite open]) {
        
        NSString *sqlInser = [NSString stringWithFormat:@"UPDATE  USERINFOTABLE SET LOGINTIMER='%f' WHERE USERNAME = '%@'",[self getCurrenttime],userName];
        
        BOOL result  = [userInfoSqlite executeUpdate:sqlInser];
        
        if (!result) {
            
            NSLog(@"%s_更新数据错误",__FUNCTION__);
            
        }else{
            
            NSLog(@"%s_更新数据成功",__FUNCTION__);
            
        }
        
        [userInfoSqlite close];
    }
    
}

/**
 *  根据用户名修改自动登录状态
 *
 *  @param userName 用户名
 *  @param autoLoginState  登录状态
 */
- (void)updateUserAutoLoginStateWithUserName:(NSString *)userName   loginState:(BOOL )autoLoginState
{
    if ([userInfoSqlite open]) {
        
        NSString *sqlInser = [NSString stringWithFormat:@"UPDATE  USERINFOTABLE SET AUTOLOGINSTATE='%d' WHERE USERNAME = '%@' COLLATE NOCASE",autoLoginState,userName];
        
        BOOL result  = [userInfoSqlite executeUpdate:sqlInser];
        
        if (!result) {
            
            NSLog(@"%s_更新数据错误",__FUNCTION__);
            
        }else{
            
            NSLog(@"%s_更新数据成功",__FUNCTION__);
            
        }
        
        [userInfoSqlite close];
    }
    
}

/**
 *  根据用户名删除账号信息
 *
 *  @param userName 用户名
 */
- (void)deleteUserInfoWithUserName:(NSString *)userName
{
    if ([userInfoSqlite open]) {
        
        NSString *sqlInser = [NSString stringWithFormat:@"DELETE  FROM  USERINFOTABLE  WHERE USERNAME = '%@'",userName];
        
        BOOL result  = [userInfoSqlite executeUpdate:sqlInser];
        
        if (!result) {
            
            NSLog(@"%s_删除数据错误",__FUNCTION__);
            
        }else{
            
            NSLog(@"%s_删除数据成功",__FUNCTION__);
            
        }
        
        [userInfoSqlite close];
    }
    
}

/**
 *  获取所有数据库中用户的数据
 *
 *  @return 用户数组
 */
- (NSMutableArray *)getAllUsers
{
    NSMutableArray *userArray = [[[NSMutableArray alloc] init] autorelease];
    
    
    if ([userInfoSqlite open]) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM USERINFOTABLE ORDER BY LOGINTIMER DESC"];
        
        FMResultSet *rsSet = [userInfoSqlite executeQuery:sqlStr];
        
        while ([rsSet next]) {
            
//            int idNum = [rsSet intForColumn:@"ID"];
            
            NSString *strUserName = [rsSet stringForColumn:@"USERNAME"];
            
            NSString *strPassWord = [rsSet stringForColumn:@"PASSWORD"];
            strPassWord = [CommonFunc textFromBase64String:strPassWord];
            
            double strLogintimer = [rsSet doubleForColumn:@"LOGINTIMER"];
            
            BOOL autoLoginState =  [rsSet boolForColumn:@"AUTOLOGINSTATE"];
            
            JVCUserInfoModel *userModel = [[JVCUserInfoModel alloc] init];
            userModel.userName = strUserName;
            userModel.passWord = strPassWord;
            userModel.loginTimer = strLogintimer;
            userModel.bAutoLoginState = autoLoginState;
            
            [userArray addObject:userModel];
            
            
            [userModel release];
        }
    }
    return userArray;
}


#pragma mark 登录判断账号
/**
 *  创建用户表格
 */
- (void)createLoginUserInfoTable
{
    
    //读取目录，如果目录下面没有这个数据库，创建，如果有什么也不处理
    NSString *sqlName = (NSString *)FMDB_USERINF;
    
    NSString *path = [[JVCSystemUtility shareSystemUtilityInstance] getAppDocumentsPathWithName:sqlName];

    
    userInfoSqlite = [FMDatabase databaseWithPath:path];
    
    [userInfoSqlite retain];
    
    if ([userInfoSqlite open]) {//打开数据库
        
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS JUDGEUSERINFOTABLE(ID INTEGER PRIMARY KEY,USERNAME TEXT)"];
        
        BOOL result = [userInfoSqlite executeUpdate:sqlCreateTable];
        
        if (!result) {
            
            NSLog(@"error 创建数据库错误");
            
        }else
        {
            NSLog(@"success 创建数据库成功");
        }
    }
    
    [userInfoSqlite close];


}
/**
 *  登录成功后，将判断的用户名放到本地数据库中，只有新账号
 *
 *  @param userName 用户名
 *  @param passWord 秘密
 */
- (void)writeJudgeUserInfoToDataBase:(NSString *)userName
{
    
    if ([userInfoSqlite open]) {
        
        NSString *sqlSerach = [NSString stringWithFormat:@"SELECT COUNT(*) AS 'TOTALCOUNT' FROM  JUDGEUSERINFOTABLE WHERE USERNAME = '%@' COLLATE NOCASE",userName];//,userName];
        
        FMResultSet *resultSet  = [userInfoSqlite executeQuery:sqlSerach];
        
        while ([resultSet next]) {
            
            NSUInteger totalNum = [resultSet intForColumn:@"TOTALCOUNT"];
            
            DDLogInfo(@"查询数据库结果,数据库中共有==%d",totalNum);
            
            if (totalNum == 0) {//数据库没有，直接插入
                
                [self insertJudgeUserInfoWithUserName:userName ];
                
            }
        
        [userInfoSqlite close];
        }
    }
}

/**
 *  判断账号是否判断过
 *
 *  @param userName 用户名
 *
 *  @return yes 判断过 no没有
 */
- (BOOL)getUserJudgeState:(NSString *)userName
{
    BOOL state = NO;
    
    if ([userInfoSqlite open]) {
        
        NSString *sqlSerach = [NSString stringWithFormat:@"SELECT COUNT(*) AS 'TOTALCOUNT' FROM  JUDGEUSERINFOTABLE WHERE USERNAME = '%@' COLLATE NOCASE",userName];//,userName];
        
        FMResultSet *resultSet  = [userInfoSqlite executeQuery:sqlSerach];
        
        while ([resultSet next]) {
            
            NSUInteger totalNum = [resultSet intForColumn:@"TOTALCOUNT"];
            
            DDLogInfo(@"查询数据库结果,数据库中共有==%d",totalNum);
            
            if (totalNum == 0) {//数据库没有，直接插入
                
                state = NO;
                
            }else{
                state = YES;
            }
            
            [userInfoSqlite close];
        }
    }
    return state;
}

/**
 *  更新判断用户名数据
 *
 *  @param userName 用户名
 *  @param passWord 密码
 */
- (void)insertJudgeUserInfoWithUserName:(NSString *)userName
{
    if ([userInfoSqlite open]) {
        //转化
        
        NSString *sqlInser = [NSString stringWithFormat:@"INSERT INTO JUDGEUSERINFOTABLE(USERNAME)VALUES('%@')",userName];
        
        BOOL result  = [userInfoSqlite executeUpdate:sqlInser];
        if (!result) {
            
            NSLog(@"%s_插入数据错误",__FUNCTION__);
        }else{
            NSLog(@"%s_插入数据成功",__FUNCTION__);
            
        }
        
        [userInfoSqlite close];
    }
}



/**
 *  登录的账号个数
 *
 *  @return 账号个数
 */
- (int)usersHasLoginCount
{
    NSArray *arrayCount =[self getAllUsers];
    
    return arrayCount.count;
}
- (void)dealloc
{
    [userInfoSqlite release];
    
    [super dealloc];
}
@end
