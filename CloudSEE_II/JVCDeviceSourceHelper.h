//
//  JVCDeviceSourceHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVCDeviceModel.h"
#import "JVCLocalCacheModel.h"

@class JVCDeviceModel;

@class JVCDeviceListMapModel;
/**
 *  判断用户名密码和是否超过最大数的枚举
 */
enum ADDDEVICE_TYPE
{
    ADDDEVICE_HAS_EXIST=0,//存在
    ADDDEVICE_NOT_EXIST,//不存在
    ADDDEVICE_MAX_MUX,//超过最大值
    
};

@interface JVCDeviceSourceHelper : NSObject


/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCDeviceSourceHelper *)shareDeviceSourceHelper;

/**
 *  获取设备列表
 *
 *  @return 设备列表
 */
- (NSMutableArray *)deviceListArray;

/**
 *  返回所有的云视通号集合
 *
 *  @return 云视通号集合
 */
-(NSMutableArray *)ystNumbersWithDevceList;

/**
 *  返回所有的设备昵称集合
 *
 *  @return 云视通号集合
 */
-(NSMutableArray *)deviceNicknameWithDevceList;

/**
 *  清楚设备列表的所有数据
 */
- (void)removeAllDeviceObject;

/**
 *  往数据列表中插入数据
 */
- (void)addDeviceObjectFromArray:(NSArray *)array;

/**
 *  把从服务器收到的数据放到设备数组中
 *
 *  @param tdicDevice 服务器收到的数据
 */
- (void)addServerDateToDeviceList:(NSDictionary *)tdicDevice;


/**
 *  根据云视通号查看云视通号在设备中是否存在
 *
 *  @param YSTNum      云视通号
 *  @param deviceArray 传进来的用户的数组
 *
 *  @return ADDDEVICE_HAS_EXIST:存在  ADDDEVICE_NOT_EXIST:不存在  ADDDEVICE_MAX_MUX:超过最大值
 */
- (int)addDevicePredicateHaveYSTNUM:(NSString *)YSTNum;

#pragma mark  添加设备后，把获取到得数据（字典类型）转化为model类型
/**
 *  添加设备后，把获取到得数据（字典类型）转化为model类型
 *
 *  @param deviceInfoDic 设备的类型
 *
 *  @param YSTNum 云视通号
 *
 *  @return 转化完成后的model类型
 */
- (JVCDeviceModel *)convertDeviceDictionToModelAndInsertDeviceList:(NSDictionary *)deviceInfoDic withYSTNUM:(NSString *)YSTNum;

/**
 *  根据云通号获取sourceModel
 *
 *  @param ystNumber 云通号
 *
 *  @return 云通号的sourceModel
 */
-(JVCDeviceModel *)getDeviceModelByYstNumber:(NSString *)ystNumber;


/**
 *  根据设备model删除设备
 *
 *  @param model 设备model
 */
- (void)deleteDevieWithModel:(JVCDeviceModel *)model;

/**
 *  根据设备model删除设备
 *
 *  @param model 设备model
 */
- (void)deleteDevieWithYstNum:(NSString *)ystNum;

/**
 *  还原设备的在线信息，把所有的在线信息置为离线
 */
-(void)restoreDeviceListOnlineStatusInfo;

/**
 *  将广播获取到的设备更新到通道集合中
 *
 *  @param updateLanModelList 广播获取到的设备集合
 */
-(void)updateLanModelToChannelListData:(NSArray *)updateLanModelList;

/**
 *  把sourceModel转换成CacheModel集合
 *
 *  @param deviceMArray sourceModel数组
 *
 *  @return CacheModel集合
 */
-(NSMutableArray *)deviceModelListConvertLocalCacheModel;

/**
 *  根据云视通号获取缓存的实体Model
 *
 *  @param ystNumber 设备的云视通号
 *
 *  @return 缓存的实体Model
 */
-(JVCLocalCacheModel *)deviceModelWithYstNumberConvertLocalCacheModel:(NSString *)ystNumber;

#pragma mark 本地
/**
 *  获取本地数据库中设备列表
 */
- (void)getLocalDeviceList;

/**
 *  根据用户名密码云视通号添加设备
 *
 *  @param ystNum   云视通号
 *  @param userName 用户名
 *  @param passWord 密码
 */
- (void)addLocalDeviceInfo:(NSString *)ystNum  deviceUserName:(NSString *)userName  devicePassWord:(NSString *)passWord;

/**
 *  删除本地设备
 *
 *  @param ystNum 云视通号
 */
- (BOOL)deleteLocalDeviceInfo:(NSString *)ystNum;



/**
 *  修改本地设备昵称用户名密码
 */
-(BOOL)updateLocalDeviceNickNameWithYst:(NSString *)ystNUm
                               NickName:(NSString *)nickName
                             deviceName:(NSString *)deviceName
                               passWord:(NSString *)passWord
                      iscustomLinkModel:(BOOL)linkModel;

/**
 *  修改设备的ip 端口号 用户名  密码
 */
-(BOOL)updateLocalDeviceLickInfoWithYst:(NSString *)ystNUm
                             deviceName:(NSString *)deviceName
                               passWord:(NSString *)passWord
                      iscustomLinkModel:(BOOL)linkModel
                                   port:(NSString*)port
                                     ip:(NSString *)ip;

/**
 *  根据用户名密码云视通号添加设备
 *
 *  @param Ip   ip
 *  @param port   port
 *  @param userName 用户名
 *  @param passWord 密码
 */
- (void)addLocalDeviceInfo:(NSString *)Ip
                      port:(NSString *)port
            deviceUserName:(NSString *)userName
            devicePassWord:(NSString *)passWord;

/**
 *  根据云视通号是否再数组中
 *
 *  @param ystNumber 云通号
 *
 *  @return 云通号的sourceModel
 */
-(BOOL)judgeDeviceHasExist:(NSString *)ystNumber;

/**
 *  把广播到的设备实体转换成sourceModel
 *
 *  @param lanModelList 广播到的设备集合
 *
 *  @return 转换的Model
 */
-(NSArray *)LANModelListConvertToSourceModel:(NSMutableArray *)lanModelList;

/**
 *  新接口添加云视通设备到数组
 *
 *  @param deviceInfo 设备字典
 *  @param ystNum     云视通号
 */
- (void)newInterFaceAddDevice:(NSDictionary *)deviceInfo  ystNum:(NSString *)ystNum;


                                        #pragma mark 映射的处理
/*******************************************************************************************************************/
/**
 *  把从服务器收到的数据映射转化成model
 *
 *  @param tdicDevice 服务器收到的数据
 */
- (void)addDeviceMapDateToDeviceList:(JVCDeviceListMapModel *)deviceListMapModel;

@end
