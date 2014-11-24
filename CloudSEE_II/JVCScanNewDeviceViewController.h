//
//  JVCScanNewDeviceViewController.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-10-13.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"
#import "JVCLANScanWithSetHelpYSTNOHelper.h"
#import"JVCDeviceMathsHelper.h"
#import "JVCSystemSoundHelper.h"

static const  CGFloat   kNewDeviceImageViewWithRadius        = 100.0f;
static const  int       kNewDeviceButtonWithTag              = 100000;
static const  CGFloat   kNewDeviceWithanimateWithDuration    = 1.0f;
static const  CGFloat   kNewDeviceImageViewWithMinScale      = 0.1f;
static const  CGFloat   kNewDeviceImageViewWithMinAlpha      = 0.1f;
static const  CGFloat   kDeviceImageViewWithMinAlpha         = 0.7f;
static const  int       kNewDeviceWithMaxCount               = 5;

typedef NS_ENUM(int, JVCSCanType) {
    
    JVCSCanType_addDevice   = 0,//扫描出来后，添加
    JVCSCanType_ReSCan      = 1,//重新添加
    JVCSCanType_NOmal       = 2,//不响应点击事件
    
};

@interface JVCScanNewDeviceViewController : JVCBaseWithGeneralViewController <JVCLANScanWithSetHelpYSTNOHelperDelegate,JVCDeviceMathDelegate,UIAlertViewDelegate,JVCSystemSoundHelperDelegate> {
    
    CGFloat         scanfNewDevice_x;
    CGFloat         scanfNewDevice_y;
    NSMutableArray *amLanSearchModelList;
    
    int             nSelectedIndex;

}


/**
 *  判断当前生成的按钮不重合在扫描图标上
 *
 *  @param x x坐标
 *  @param y y坐标
 *
 *  @return 不重叠返回YES 采用中心点距离判断
 */
-(BOOL)checkNewDevicePoint:(CGFloat)x withY:(CGFloat)y;

/**
 *  根据标签返回一个新设备的按钮
 *
 *  @param tag 标签
 *
 *  @return 新设备的按钮
 */
-(UIButton *)newDeviceuttonWithTag:(int)tag;

/**
 *  获取一个范围内的随机数 [from,to），包括from，不包括to
 *
 *  @param from 最小边界值
 *  @param to   最大边界值
 *
 *  @return 随机数
 */
-(int)getRandomNumber:(int)from to:(int)to;

/**
 *  判断当前的缓存数据中 广播到的设备是否存在
 *
 *  @param ystNumber 云视通号
 *
 *  @return 存在返回YES 否则返回NO
 */
-(BOOL)checkLanSearchModelIsExist:(NSString *)ystNumber;

/**
 *  停止扫描设备
 */
-(void)stopScanfDeviceTimer;

/**
 *  添加新设备
 */
-(void)addNewScanDevice:(UIButton *)button;

/**
 *  添加设备接口
 */
- (void)addQRdevice;

/**
 *  设置添加的设备不是新设备状态
 */
-(void)setDeviceButtonNoNewStatus;

/**
 *  局域网扫描设备
 */
-(void)scanfDeviceList;

@end
