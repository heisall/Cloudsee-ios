//
//  JVCLocalDeviceDateBaseHelp.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

enum{

    TYPE_Add_Device_IP_NO   = 0,//不是ip添加
    TYPE_Add_Device_IP_YES  = 1,//是ip添加

};

NS_ENUM(int, OldDeviceType)
{
    OldDeviceType_Device    = 0,//设备
    OldDeviceType_Channel   = 1,//通道

};
@interface JVCLocalDeviceDateBaseHelp : NSObject

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCLocalDeviceDateBaseHelp *)shareDataBaseHelper;

/**
 *  把数据插入到本地
 */
-(BOOL)addLocalDeviceToDataBase:(NSString *)ystNUm  deviceName:(NSString *)name  passWord:(NSString *)passWord;

/**
 *  把ip数据插入到本地
 */
-(BOOL)addLocalIPDeviceToDataBase:(NSString *)ip  port:(NSString *)port  deviceName:(NSString *)name  passWord:(NSString *)passWord;
/**
 *  删除设备
 */
-(BOOL)deleteLocalDeviceFromDataBase:(NSString *)ystNUm;

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
                          ip:(NSString *)ip;

/**
 *  获取所有的本地设备列表
 *
 *  @return 设备列表数组
 */
- (NSMutableArray *)getAllLocalDeviceList;

/**
 *  修改昵称、用户名、密码
 */
-(BOOL)updateLocalDeviceNickName :(NSString *)ystNUm
                         NickName:(NSString *)nickName
                       deviceName:(NSString *)deviceName
                         passWord:(NSString *)passWord
                iscustomLinkModel:(BOOL)linkModel;

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
                                     ip:(NSString *)ip;

/**
 *  判断云视通号在不在数据中
 *
 *  @param ystNum 云视通号
 *
 *  @return yes 在    no：不在
 */
- (BOOL)judgeYstNumInDateBase:(NSString *)ystNum;

/**
 *  获取所有的本地设备列表
 *
 *  @return 设备列表数组
 */
- (NSMutableArray *)getOldAllLocalDeviceList;

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
-(BOOL)convertOldDeviceToDataBase:(NSString *)ystNUm  deviceName:(NSString *)name  passWord:(NSString *)passWord  nickName:(NSString *)nickName;

/**
 *  把老的数据库转化为新的数据库
 */
- (void)converOldDeviceListInDateFame;

@end
