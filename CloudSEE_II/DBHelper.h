//
//  DBHelper.h
//  CarSteward
//
//  Created by Domino on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "JVCOldSouchModel.h"


@interface DBHelper : NSObject {
	sqlite3 *dataBase;
}

@property sqlite3 *dataBase;
-(BOOL)OpenDataBase;
-(BOOL)closeDataBase;
- (void)createTablewindowsNum;
- (void)createAddSourceTable;
//- (void)createSourceListGroup;
//-(BOOL)insertGroupnameToDataBase:(NSString*)groupName;
//-(NSArray*)querySourceListGroupNameList;
-(BOOL)insertWindowsNumToDataBase:(int)windowsNums;
-(BOOL)updateWindowsNumToDataBase:(NSString*)sql;
-(NSArray*)querySourceListData:(int)groupID;
-(NSArray*)querySourceList;
- (BOOL) insertSourceData:(JVCOldSouchModel*)newSourceModel;
- (BOOL) updateData:(NSString *)updateSqlStr;
-(BOOL)getNumbers:(NSString *)sql;
- (NSMutableArray *) insertSourceArrayData:(JVCOldSouchModel*)tnode;

#pragma mark CC用户的数据库管理方法
- (void)createCCUserInfoTable;
- (BOOL) insertCCUserInfo:(NSArray*)userInfo;
-(NSArray*)queryCCUserInfoList;

- (void)createCaptureNumsTable;
-(BOOL)insertCaptureNumsToDataBase:(int)captureNums;
-(NSArray*)querySourceListDataByESC:(int)groupID;

/**
 *  获取设备的Id
 */
- (int)getDeviceIDWithYStNum:(NSString *)ystNum;

@end
