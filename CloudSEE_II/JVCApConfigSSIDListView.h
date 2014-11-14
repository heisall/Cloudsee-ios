//
//  JVCApConfigSSIDListView.h
//  CloudSEE_II
//  无线网络配置的View类（带热点的）
//  Created by chenzhenyang on 14-11-13.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JVCApConfigSSIDListView;

/**
 *  刷新无线设备热点的函数
 */
typedef void (^JVCApConfigSSIDListViewRefreshSSIDListBlock)();

/**
 *  开始配置无线热点
 *
 *  @param strWifiEnc      wifi的加密方式
 *  @param strWifiAuth     wifi的认证方式
 *  @param strWifiSSid     配置WIFI的SSID名称
 *  @param strWifiPassWord 配置WIFi的密码
 */
typedef void (^JVCApConfigSSIDListViewStartConfigingBlock)(NSString *strWifiEnc,NSString *strWifiAuth,NSString *strWifiSSid,NSString *strWifiPassWor);

@interface JVCApConfigSSIDListView : UIView <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,copy) JVCApConfigSSIDListViewRefreshSSIDListBlock apConfigSSIDListViewRefreshSSIDListBlock;
@property (nonatomic,copy) JVCApConfigSSIDListViewStartConfigingBlock  apConfigSSIDListViewStartConfigingBlock;


/**
 *  初始化Wifi热点列表视图
 */
-(void)initLayoutWithWifiListTableView;

/**
 *  更新设备的WIFi信息
 */
-(void)getDeviceWifiListData;

/**
 *  刷新无线列表信息
 *
 *  @param wifiListData 无线列表信息
 */
-(void)refreshWifiViewShowInfo:(NSMutableArray*)wifiListData;

/**
 *  键盘关闭事件
 */
-(void)resignFirstResponderMath;

/**
 *  开始配置
 */
-(void)startConfig;

/**
 *  关闭获取无线设备列表信息的超时判断
 */
- (void)stopGetWifiListTimer;
@end
