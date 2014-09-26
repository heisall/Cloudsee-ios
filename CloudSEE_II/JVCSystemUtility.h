//
//  JVCSystemUtility.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCSystemUtility : NSObject

+ (JVCSystemUtility *)shareSystemUtilityInstance;

/**
 *  根据设备类型，自动获取iphone5图片的类型，如果是iphone5的情况下，返回图片1_iphone5.png 如果不是iphone5返回原来的图片
 *
 *  @param imageStr 图片的名称
 *
 *  @return 如果是iphone5 在图片的后面追加_iphone5.png 如果不是返回图片的原来的名称
 */
-(NSString *)getImageByImageName:(NSString *)imageStr;


/**
 *  判断文件是否存在
 *
 *  @param checkFilePath 检查的文件名称
 *
 *  @return 存在返回TRUE
 */
-(BOOL)checkLocalFileExist:(NSString *)checkFilePath;

/**
 *  创建appDocuments下面的目录
 *
 *  @param fileName 文件名称
 *
 *  @return 创建好的应用目录
 */
- (NSString *)getAppDocumentsPathWithName:(NSString *)fileName;

/**
 *  获取应用的app的Documents目录
 *
 *  @return 应用的app的Documents目录
 */
- (NSString *)getAppDocumentsPath;

/**
 *  获取应用的app的Caches目录
 *
 *  @return 应用的app的Caches目录
 */
- (NSString *)getAppCachesPath;

/**
 *  获取app的Temp路径
 *
 *  @return app的temp路径
 */
- (NSString *)getAppTempPath;


@end
