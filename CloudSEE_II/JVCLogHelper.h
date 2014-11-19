//
//  JVCLogHelper.h
//  CloudSEE_II
//  用于日志写文件函数
//  Created by chenzhenyang on 14-11-19.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int JVCLogHelperLevel;
static NSString const *kAppLogPath = @"applog.md";

@interface JVCLogHelper : NSObject


enum JVCLogHelperLevel {
    
    JVCLogHelperLevelDubug   = 0,
    JVCLogHelperLevelRelease = 1,
};

/**
 *  单例
 *
 *  @return 返回JVCRGBHelper的单例
 */
+ (JVCLogHelper *)shareJVCLogHelper;

/**
 *  打开文件写入流句柄并写入数据
 *
 *  @param buffer 写入的数据
 *  @param nSize  写入数据的大小
 */
-(void)writeDataToFile:(NSString *)text;

/**
 *  关闭文件写入流句柄
 */
-(void)close;

@end
