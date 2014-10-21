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

/**
 *  判断字典是不是为空
 *
 *  @param infoId 字典类型的数据
 *
 *  @return yes:空  no：非空
 */
- (BOOL)judgeDictionIsNil:(NSDictionary *)infoId;

/**
 *  判断收到的字典是否合法，只有再rt字段等于0的时候才是合法
 *
 *  @param dicInfo 传入的字典字段
 *
 *  @return yes：合法  no：不合法
 */
- (BOOL)JudgeGetDictionIsLegal:(NSDictionary *)dicInfo;

/**
 *  判断系统的语言
 *
 *  @return yes  中文  no英文
 */
- (BOOL)judgeAPPSystemLanguage;

/**
 *  初始化返回按钮
 *
 *  @param event  按下的事件
 *  @param sender 发送对象
 *
 *  @return 返回UIBarButtonItem
 */
- (UIBarButtonItem *)navicationBarWithTouchEvent:(SEL)event  Target:(id)sender;

/**
 *  随机返回图片路径（基于时间截）
 *
 *  @return 路径
 */
- (NSString *)getRandomPicLocalPath;

/**
 *  随机返回图片路径（基于时间截）
 *
 *  @return 路径
 */
- (NSString *)getRandomVideoLocalPath;

/**
 *  根据事件截，获取当前时间
 *
 *  @param timerCurrentInt 时间截
 *
 *  @return 时间
 */
- (NSString *)getCurrentTimerFrom:(int)timerCurrentInt;

/**
 *  根据域名获取ip
 *
 *  @param theHost 域名
 *
 *  @return 得到的ip
 */
-(NSString *)getIPAddressForHostString:(NSString *) theHost;

/**
 *  获取ip或域名的ip值
 *
 *  @param stringLocal 域名或ip
 *
 *  @return ip地址
 */
- (NSString *)getIpOrNetHostString:(NSString *)stringLocal;

/**
 *  获取当前Wifi的SSid （需要引入#import <SystemConfiguration/CaptiveNetwork.h>）
 *
 *  @return 当前手机连接的热点
 */
-(NSString *)currentPhoneConnectWithWifiSSID;

/**
 *  判断当前连接的设备的无线网络是否是家用设备的无线热点
 *
 *  @return YES：是 NO:否
 */
-(BOOL)currentPhoneConnectWithWifiSSIDIsHomeIPC;

@end
