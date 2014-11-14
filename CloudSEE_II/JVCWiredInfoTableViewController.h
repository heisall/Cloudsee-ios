//
//  JVCWiredInfoTableViewController.h
//  CloudSEE_II
//  有线连接的网络接入信息（Ip、网关、是否在线）
//  Created by chenzhenyang on 14-11-12.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseGeneralTableViewController.h"
#import "JVCWireTableViewCell.h"

static NSString const *kWiredWithIP                = @"ETH_IP";    //IP
static NSString const *kWiredWithSubnetMask        = @"ETH_NM";    //子网掩码
static NSString const *kWiredWithGateway           = @"ETH_GW";    //默认网关
static NSString const *kWiredWithDNS               = @"ETH_DNS";   //域名地址
static NSString const *kWiredWithMAC               = @"ETH_MAC";   //网卡地址
static NSString const *kWiredWithCloudSEEID        = @"YSTID";     //云视通号
static NSString const *kWiredWithStatus            = @"YSTSTATUS"; //在线状态
static NSString const *kWiredWithCloudSEEGroup     = @"YSTGROUP";  //云视通号组号

@interface JVCWiredInfoTableViewController : JVCBaseGeneralTableViewController <UITableViewDataSource,UITableViewDelegate,JVCWireTableViewCellDelegate>{

    NSMutableDictionary  *mdNetworkInfo;
    NSMutableArray       *titles;
    NSMutableDictionary  *mdCacheNetworkInfo; //暂存可变网络参数的字典
}

@property (nonatomic,retain) NSMutableDictionary            *mdNetworkInfo;

/**
 *  初始化视图标题集合
 */
-(void)initLayoutWithTitles;

/**
 *  判断key值在可改变的字典数组里是否存在
 *
 *  @param key 查询的key
 *
 *  @return 存在返回 YES
 */
-(BOOL)checkKeyIsExistInChangeCacheMdic:(NSString *)key;

/**
 *  初始化功能视图
 */
-(void)initLayoutWithOperationView;

/**
 *  初始化加载可输入的标签字典数组
 */
-(void)initLayoutWithChangeTitles;



@end
