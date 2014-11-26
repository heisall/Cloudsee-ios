//
//  AppDelegate.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-22.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVCQRCoderViewController.h"
#import "JVCAccountHelper.h"
@class JVCAlarmModel;

@protocol AppDelegateVideoDelegate<NSObject>

/**
 *  停止视频播放（锁屏幕）
 */
-(void)stopPlayVideoCallBack;


/**
 *  视频播放（解锁屏幕）
 */
-(void)continuePlayVideoCallBack;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,JVCAccountDelegate,UITabBarControllerDelegate>
{
    NSMutableArray                 *_amOpenGLViewListData;     //存放GlView显示类的集合
    JVCQRCoderViewController       *QRViewController;          //二维码扫描view
    NSString                       *localtionString;
    id <AppDelegateVideoDelegate>  appDelegateVideoDelegate;
}

enum tabarViewItem {

    tabarViewItem_editDevice = 2,

};

@property (strong, nonatomic)   UIWindow *window;
@property(nonatomic,retain)     NSMutableArray *_amOpenGLViewListData;
@property(nonatomic,retain)     JVCQRCoderViewController *QRViewController;
@property(nonatomic,retain)     NSString *localtionString;
@property(nonatomic,assign)     id <AppDelegateVideoDelegate>  appDelegateVideoDelegate;
/**
 *  初始化TabarViewControllers
 */
-(void)initWithTabarViewControllers;

/**
 *  重新登录后，初始化TabarViewControllers
 */
-(void)UpdateTabarViewControllers;

/**
 *  presentLoginViewController
 */
- (void)presentLoginViewController;

/**
 *  关闭设备列表界面的timer
 */
- (void)stopDeviceListTimer;

/**
 *  往报警列表界面中插入一条数据
 *
 *  @param alarmModel alarm数据
 */
- (void)addCurrentAlarmInalarmMessageViewController:(JVCAlarmModel*)alarmModel;

/**
 *  获取用户的报警信息字段，与服务器统一
 */
- (void)getUserAlarmState;

/**
 *  添加设备广播
 */
- (void)startDeviceLANSerchAllDevice;
@end
