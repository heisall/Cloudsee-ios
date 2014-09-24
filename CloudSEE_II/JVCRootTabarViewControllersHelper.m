//
//  JVCRootTabarViewControllersHelper.m
//  JVCEditDevice
//  UITabarViewController 处理类
//  Created by chenzhenyang on 14-9-24.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCRootTabarViewControllersHelper.h"
#import "JVCEditDeviceListViewController.h"
#import "JVCDeviceListViewController.h"
#import "JVCAlarmMessageViewController.h"
#import "JVCMoreViewController.h"


@implementation JVCRootTabarViewControllersHelper

/**
 *  初始化TabarViewController
 *
 *  @return TabarViewController 的成员集合
 */
-(NSArray *)initWithTabarViewControllers{
    
    
    /**
     *	我的设备模块
     */
    JVCDeviceListViewController *deviceListController = [[JVCDeviceListViewController alloc] init];
    UINavigationController      *deviceNav            = [[UINavigationController alloc] initWithRootViewController:deviceListController];
    [deviceListController release];
    
    /**
     *	报警消息模块
     */
    JVCAlarmMessageViewController *alarmMessageViewController = [[JVCAlarmMessageViewController alloc] init];
    UINavigationController        *alarmMessageViewNav        =[[UINavigationController alloc] initWithRootViewController:alarmMessageViewController];
    
    [alarmMessageViewController release];
    
    /**
     *	设备管理模块
     */
    JVCEditDeviceListViewController *editDeviceViewController =[[JVCEditDeviceListViewController alloc] init];
    UINavigationController          *editDeviceNav            = [[UINavigationController alloc] initWithRootViewController:editDeviceViewController];
    
    [editDeviceViewController release];
    
    /**
     *	更多模块
     */
    JVCMoreViewController  *moreViewController = [[JVCMoreViewController alloc] init];
    UINavigationController *moreNav            = [[UINavigationController alloc] initWithRootViewController:moreViewController];
    [moreViewController release];
    

    NSArray *viewControllers = [[[NSArray alloc] initWithObjects:deviceNav,alarmMessageViewNav,editDeviceNav,moreNav,nil] autorelease];
    
    [deviceNav release];
    [alarmMessageViewNav release];
    [editDeviceNav release];
    [moreNav release];
    
    return viewControllers;
}

@end
