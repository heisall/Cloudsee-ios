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

@interface AppDelegate : UIResponder <UIApplicationDelegate,JVCAccountDelegate>
{
    NSMutableArray *_amOpenGLViewListData; //存放GlView显示类的集合
    
    JVCQRCoderViewController *QRViewController;//二维码扫描view
    
}

@property (strong, nonatomic)   UIWindow *window;
@property(nonatomic,retain)     NSMutableArray *_amOpenGLViewListData;
@property(nonatomic,retain)     JVCQRCoderViewController *QRViewController;

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
@end
