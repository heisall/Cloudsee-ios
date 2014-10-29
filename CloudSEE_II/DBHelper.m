//
//  DBHelper.m
//  CarSteward
//
//  Created by Domino on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DBHelper.h"
#import "JVCOldSouchModel.h"

@implementation DBHelper

@synthesize dataBase;

-(BOOL)OpenDataBase{
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *path=[documentsDirectory stringByAppendingPathComponent:@"yunshitong.sql"];
	NSFileManager *filemanager=[NSFileManager defaultManager];
	BOOL find=[filemanager fileExistsAtPath:path];  //判断数据库是否存在
	if (find) {
		if (sqlite3_open([path UTF8String], &dataBase)!=SQLITE_OK) {
				sqlite3_close(dataBase);
				return NO;
		}
		return YES;
	}
	if(sqlite3_open([path UTF8String], &dataBase) == SQLITE_OK) {
//		[self createTablewindowsNum];
//		[self createAddSourceTable];
//		//[self createSourceListGroup];
//		[self createCCUserInfoTable];
//		[self createCaptureNumsTable];
             return YES;
    }
	else {
		sqlite3_close(dataBase);
		return NO;
	}

}

/**
 类型：自定义方法
 功能：关闭数据库
 **/
-(BOOL)closeDataBase{
	if(sqlite3_close(dataBase)==SQLITE_OK){
		return YES;
	}
	return NO;

}

/**
 类型：自定义方法
 功能：保留监控窗体当前的布局显示（4 四窗体显示，10001：单窗体一号窗体显示）
 **/
- (void)createTablewindowsNum{
	char *sql = "CREATE TABLE IF NOT EXISTS windowsNums (nums integer);";
	if (sqlite3_exec(dataBase, sql, NULL, NULL, nil)!=SQLITE_OK) {
	}
}

/**
 类型：自定义方法
 功能：保留连拍的次数
 **/
- (void)createCaptureNumsTable{
	char *sql = "CREATE TABLE IF NOT EXISTS CaptureNums (nums integer);";
	if (sqlite3_exec(dataBase, sql, NULL, NULL, nil)!=SQLITE_OK) {
	}
}

/**
 类型：自定义方法
 功能：创建源表
 **/
- (void)createAddSourceTable{
	char *sql = "CREATE TABLE IF NOT EXISTS addSource(id integer primary key AUTOINCREMENT,channelName text,channelNumber text,userName text,password text,savePasswordState int,linkType int,yunshitongNum text,ip text,port text,windowindex int,groupID integer,byTCP integer,localTry integer,deleteChannelNums text)";
	if (sqlite3_exec(dataBase, sql, NULL, NULL, nil)!=SQLITE_OK) {
	}
}

/**
 类型：自定义方法
 功能:  创建分组信息
 *
- (void)createSourceListGroup{
	char *sql = "CREATE TABLE IF NOT EXISTS sourceGroup(id integer primary key AUTOINCREMENT,groupName text)";
	if (sqlite3_exec(dataBase, sql, NULL, NULL, nil)!=SQLITE_OK) {
	}
}
*/
/**
 类型：自定义方法
 功能:  创建CC用户信息表
 savePasswordState: 0不保存 1保存
 state: 0:不是最后一次使用 1是 最后一次使用
 **/
- (void)createCCUserInfoTable{
	char *sql = "CREATE TABLE IF NOT EXISTS CCUserInfo(id integer primary key AUTOINCREMENT,userName text,passWord text,savePasswordState int,state int)";
	if (sqlite3_exec(dataBase, sql, NULL, NULL, nil)!=SQLITE_OK) {
	}
}

/**
 类型：自定义方法
 功能：创建源分组
 *
-(BOOL)insertGroupnameToDataBase:(NSString*)groupName{
	if ([self OpenDataBase]) {
		sqlite3_stmt *statement;
		NSString *insertSqlStr = [NSString stringWithFormat:@"insert into sourceGroup(groupName) values(?)"];
		const char *insertSql = [insertSqlStr UTF8String];
		int insertSqlOK = sqlite3_prepare_v2(dataBase, insertSql, -1, &statement, nil);
		if (insertSqlOK != SQLITE_OK) {
			sqlite3_close(dataBase);
			return NO;
		}
		sqlite3_bind_text(statement, 1, [groupName UTF8String], -1, nil);
		int execInsertSqlOK = sqlite3_step(statement);
		sqlite3_finalize(statement);
		if (execInsertSqlOK ==SQLITE_ERROR) {
			sqlite3_close(dataBase);
			return  NO;
		}
	}
	sqlite3_close(dataBase);
	return YES;
}*/

/**
 类型：自定义方法
 功能：查询数据库源分组名
 *
-(NSArray*)querySourceListGroupNameList{
	
	NSMutableArray  *sourceListGroupNameList=[NSMutableArray arrayWithCapacity:10];
	if (![self OpenDataBase]) {
		return sourceListGroupNameList;
	}
	sqlite3_stmt*stmt;
	const char *sql="SELECT id ,groupName FROM sourceGroup";
	if(sqlite3_prepare_v2(dataBase, sql , -1, &stmt, nil)==SQLITE_OK){
		while (sqlite3_step(stmt)==SQLITE_ROW) {
			
			groupModel *model=[[groupModel alloc] init];
			model.groupID= sqlite3_column_int(stmt, 0);
			
			char *groupName=(char*)sqlite3_column_text(stmt,1);
			model.groupName =[NSString stringWithUTF8String:groupName];
			[sourceListGroupNameList addObject:model];
			[model release];
		}
		sqlite3_finalize(stmt);
		sqlite3_close(dataBase);
		
	}else {
		sqlite3_finalize(stmt);
		sqlite3_close(dataBase);
	}
	return sourceListGroupNameList;
}
*/

-(BOOL)insertWindowsNumToDataBase:(int)windowsNums{
	if ([self OpenDataBase]) {
		sqlite3_stmt *statement;
		NSString *insertSqlStr = [NSString stringWithFormat:@"insert into windowsNums(nums) values(?)"];
		const char *insertSql = [insertSqlStr UTF8String];
		int insertSqlOK = sqlite3_prepare_v2(dataBase, insertSql, -1, &statement, nil);
		if (insertSqlOK != SQLITE_OK) {
			sqlite3_close(dataBase);
			return NO;
		}
		sqlite3_bind_int(statement, 1, windowsNums);
		int execInsertSqlOK = sqlite3_step(statement);
		sqlite3_finalize(statement);
		if (execInsertSqlOK ==SQLITE_ERROR) {
			sqlite3_close(dataBase);
			return  NO;
		}
	}
	sqlite3_close(dataBase);
	return YES;
}

-(BOOL)insertCaptureNumsToDataBase:(int)captureNums{
	if ([self OpenDataBase]) {
		sqlite3_stmt *statement;
		NSString *insertSqlStr = [NSString stringWithFormat:@"insert into CaptureNums(nums) values(?)"];
		const char *insertSql = [insertSqlStr UTF8String];
		int insertSqlOK = sqlite3_prepare_v2(dataBase, insertSql, -1, &statement, nil);
		if (insertSqlOK != SQLITE_OK) {
			sqlite3_close(dataBase);
			return NO;
		}
		sqlite3_bind_int(statement, 1, captureNums);
		int execInsertSqlOK = sqlite3_step(statement);
		sqlite3_finalize(statement);
		if (execInsertSqlOK ==SQLITE_ERROR) {
			sqlite3_close(dataBase);
			return  NO;
		}
	}
	sqlite3_close(dataBase);
	return YES;
}

/**
 类型：自定义方法
 功能：保存第一次监控的窗体个数
 **/
-(BOOL)updateWindowsNumToDataBase:(NSString*)sql{
	
	if (![self OpenDataBase]) {
		return NO;
	}
	char *errmsg;
	int insertOK=sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &errmsg);
	
	if (insertOK!=SQLITE_OK) {
		sqlite3_free(errmsg);
		sqlite3_close(dataBase);
		return NO;
	}
	
	sqlite3_free(errmsg);
	sqlite3_close(dataBase);
	return YES;
}

/**
 类型：自定义方法
 功能：查询数据库中源信息
 **/
-(NSArray*)querySourceListData:(int)groupID {
	
	NSMutableArray  *sourceListData=[NSMutableArray arrayWithCapacity:10];
	if (![self OpenDataBase]) {
		return sourceListData;
	}
	sqlite3_stmt*stmt;
    NSString	*strSql;
   	strSql=[NSString stringWithFormat:@"SELECT id ,channelName,channelNumber,userName,password,savePasswordState,linkType,yunshitongNum,ip,port,windowindex,groupID,byTCP,localTry,deleteChannelNums FROM addSource where  groupID=%d order by id desc",groupID];

	const char *sql=[strSql UTF8String];
	if(sqlite3_prepare_v2(dataBase, sql, -1, &stmt, nil)==SQLITE_OK){
		while (sqlite3_step(stmt)==SQLITE_ROW) {
			
			JVCOldSouchModel *model=[[JVCOldSouchModel alloc] init];
			model.idnum= sqlite3_column_int(stmt, 0);
		    
            model.linkType=sqlite3_column_int(stmt, 6);
            
            char *ip=(char*)sqlite3_column_text(stmt, 8);
            NSString *ipString;
            if (ip == NULL) {
                ipString = @"";
            }else{
                ipString =[NSString stringWithUTF8String:ip];
            }
			if (ipString.length>0) {
				char *ip=(char*)sqlite3_column_text(stmt, 8);
				model.ip =[NSString stringWithUTF8String:ip];

				char *port=(char*)sqlite3_column_text(stmt, 9);
				model.port =[NSString stringWithUTF8String:port];
                model.editByUser = YES;
			}else{
                model.ip = @"";
                model.password = @"";
                model.editByUser = NO;
            }
                char *yunShiTongNum=(char*)sqlite3_column_text(stmt, 7);
                if (yunShiTongNum!=nil||yunShiTongNum!=NULL) {
                    model.yunShiTongNum =[NSString stringWithUTF8String:yunShiTongNum];
                    
				
			}
			
            char *channelName=(char*)sqlite3_column_text(stmt,1);
            if (channelName!=NULL||channelName!=nil) {
                
                model.channelName =[NSString stringWithUTF8String:channelName];
             //   NSLog(@"channe=%@",model.channelName);
            }
			
			
			char *channelNumber=(char*)sqlite3_column_text(stmt, 2);
            if (channelNumber!=NULL||channelNumber!=nil) {
                model.channelNumber =[NSString stringWithUTF8String:channelNumber];
            }
			
			
			char *userName=(char*)sqlite3_column_text(stmt, 3);
            if (userName!=NULL||userName!=nil) {
                
                model.userName =[NSString stringWithUTF8String:userName];
            }
			
			char *password=(char*)sqlite3_column_text(stmt, 4);
			
			model.passwordState=sqlite3_column_int(stmt, 5);
			if (model.passwordState==0||model.passwordState==2) {
				if (password==nil||password==NULL) {
                    
				}else{
                        model.password =[NSString stringWithUTF8String:password];
			     }
			}
			
			model.windowIndex=sqlite3_column_int(stmt, 10);
			model.groupID=sqlite3_column_int(stmt, 11);
			model.byTCP=sqlite3_column_int(stmt, 12);
			model.localTry=sqlite3_column_int(stmt, 13);
            model.onLineState=1;
			char *deletedChannelNums=(char*)sqlite3_column_text(stmt, 14);
			if (deletedChannelNums==nil||deletedChannelNums==NULL) {
				model.deleteChannle=@"";
			}else {
				model.deleteChannle=[NSString stringWithUTF8String:deletedChannelNums];
			}

			[sourceListData addObject:model];
			[model release];
		}
		
		sqlite3_finalize(stmt);
		sqlite3_close(dataBase);
		
	}else {
		sqlite3_finalize(stmt);
		sqlite3_close(dataBase);
	}
	return sourceListData;
}

/**
 *  获取设备的Id
 */
- (int)getDeviceIDWithYStNum:(NSString *)ystNum
{
    int num = -1;

    if ([self OpenDataBase]) {

    sqlite3_stmt*stmt;
    NSString *sqlString = [NSString stringWithFormat:@"SELECT id FROM addSource where userName = 'A361' and windowindex = 1"];
        
	const char *sql= [sqlString UTF8String];
        
    
	if(sqlite3_prepare_v2(dataBase, sql, -1, &stmt, nil)==SQLITE_OK){
        
		while (sqlite3_step(stmt)==SQLITE_ROW) {
			
            num = sqlite3_column_int(stmt, 0);
            
            
		}
		sqlite3_finalize(stmt);
		sqlite3_close(dataBase);
		
	}else {
		sqlite3_finalize(stmt);
		sqlite3_close(dataBase);
	}
    }
	return num;
    
}


/**
 类型：自定义方法
 功能：保存当前监控的窗体个数
 **/
- (BOOL) updateData:(NSString *)updateSqlStr {
	
    if ([self OpenDataBase]) {
        sqlite3_stmt *statement = nil;
        const char *updateSql  = [updateSqlStr UTF8String];
        int updateSqlOK = sqlite3_prepare_v2(dataBase, updateSql, -1, &statement, nil);
		
        if (updateSqlOK != SQLITE_OK) {
            sqlite3_close(dataBase);
            return NO;
        }
		
        int execUpdateSqlOk = sqlite3_step(statement);
        sqlite3_finalize(statement);
		
        if (execUpdateSqlOk == SQLITE_ERROR) {
            sqlite3_close(dataBase);
            return NO;
        }       
    }
	printf("----------update data  t_Infor Database is OK!-------------\r\n");
	sqlite3_close(dataBase);
	return YES;
}


/**
 类型：自定义方法
 功能：获取当前查询表中第一行第一列的数据
 **/
-(BOOL)getNumbers:(NSString *)sql{
	
	BOOL maxIndex=NO ;
	if(![self OpenDataBase])
	{
		return maxIndex;
	}
	sqlite3_stmt*stmt;
	if(sqlite3_prepare_v2(dataBase, [sql UTF8String] , -1, &stmt, nil)==SQLITE_OK){
		while (sqlite3_step(stmt)==SQLITE_ROW) {
			maxIndex=sqlite3_column_int(stmt, 0);
		}
		
		sqlite3_finalize(stmt);
		sqlite3_close(dataBase);
		return YES;
		
	}else {
		sqlite3_finalize(stmt);
		sqlite3_close(dataBase);
	}
    return NO ;
}




/**
 添加用户信息到本地数据库
 **/
- (BOOL) insertCCUserInfo:(NSArray*)userInfo {
    if ([self OpenDataBase]) {
		sqlite3_stmt *statement;
		NSString *insertSqlStr = [NSString stringWithFormat:@"INSERT INTO CCUserInfo (userName,passWord,savePasswordState,state) VALUES(?,?,?,1);"];
		const char *insertSql = [insertSqlStr UTF8String];
		int insertSqlOK = sqlite3_prepare_v2(dataBase, insertSql, -1, &statement, nil);
		if (insertSqlOK != SQLITE_OK) {
			sqlite3_close(dataBase);
			return NO;
		}
		sqlite3_bind_text(statement, 1, [[userInfo objectAtIndex:0] UTF8String], -1, nil);
		sqlite3_bind_text(statement, 2, [[userInfo objectAtIndex:1] UTF8String], -1, nil);
		sqlite3_bind_int(statement, 3, [[userInfo objectAtIndex:2] intValue]);
		int execInsertSqlOK = sqlite3_step(statement);
		sqlite3_finalize(statement);
		if (execInsertSqlOK ==SQLITE_ERROR) {
			sqlite3_close(dataBase);
			return  NO;
		}
	}
	sqlite3_close(dataBase);
	return YES;
}

/**
 查询用户的所有信息
 **/
-(NSArray*)queryCCUserInfoList{
	
	NSMutableArray  *userInfoListData=[NSMutableArray arrayWithCapacity:10];
	if (![self OpenDataBase]) {
		return userInfoListData;
	}
	sqlite3_stmt*stmt;
	const char *sql="SELECT userName,passWord,id,savePasswordState,state FROM CCUserInfo order by state desc";
	if(sqlite3_prepare_v2(dataBase, sql, -1, &stmt, nil)==SQLITE_OK){
		while (sqlite3_step(stmt)==SQLITE_ROW) {
			NSMutableArray  *sigUserInfo=[NSMutableArray arrayWithCapacity:10];
			
			char *userName=(char*)sqlite3_column_text(stmt,0);
			[sigUserInfo addObject:[NSString stringWithUTF8String:userName]];
			
			
			char *passWord=(char*)sqlite3_column_text(stmt,1);
			[sigUserInfo addObject:[NSString stringWithUTF8String:passWord]];
			int idNum=sqlite3_column_int(stmt, 2);
			[sigUserInfo addObject:[NSString stringWithFormat:@"%d",idNum]];
			
			int savePasswordState=sqlite3_column_int(stmt, 3);
			[sigUserInfo addObject:[NSString stringWithFormat:@"%d",savePasswordState]];
			
			int state=sqlite3_column_int(stmt, 4);
			[sigUserInfo addObject:[NSString stringWithFormat:@"%d",state]];
			
			[userInfoListData addObject:sigUserInfo];
		
		}
		sqlite3_finalize(stmt);
		sqlite3_close(dataBase);
		
	}else {
		sqlite3_finalize(stmt);
		sqlite3_close(dataBase);
	}
	return userInfoListData;
}



-(void)dealloc{
	[super dealloc];
}

@end
