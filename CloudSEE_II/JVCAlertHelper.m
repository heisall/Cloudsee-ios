//
//  JVCAlertHelper.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/24/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAlertHelper.h"
#import "JVCConfigModel.h"
#import "MBProgressHUD.h"

static  const    int    HUDTAG                  =   10000;//HUd的tag

static  const   NSTimeInterval TIMERDURATION    = 2;//让toast自动消失的时间

@interface JVCAlertHelper ()
{
    
    MBProgressHUD *HUD;

}

@end
@implementation JVCAlertHelper

static JVCAlertHelper *shareAlertHelper = nil;

/**
 *  单例
 *
 *  @return 返回JVCAlertHelper 对象
 */
+(JVCAlertHelper *)shareAlertHelper
{
    @synchronized(self)
    {
        if (shareAlertHelper == nil) {
            
            shareAlertHelper = [[self alloc] init];
        }
        
        return shareAlertHelper;
    }
    
    return shareAlertHelper;

}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareAlertHelper == nil) {
            
            shareAlertHelper = [super allocWithZone:zone];
            
            return shareAlertHelper;
        }
    }
    
    return nil;
}

#pragma mark 系统的alert
/**
 *  只有message的提示
 */
- (void)alertWithMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:nil
                              message:message
                              delegate:nil
                              cancelButtonTitle:LOCALANGER(@"Alert_btn_sure")
                              otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

/**
 *  带标题以及消息的alert
 */
- (void)alertWithTitile:(NSString *)title  andMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:message
                              delegate:nil
                              cancelButtonTitle:LOCALANGER(@"Alert_btn_sure")
                              otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

#pragma mark  toast
/**********************安卓toast显示**********************************/
/**
 *    显示在viewcontroller上面的toast，2秒后自动消失
 *
 *  @param viewController 显示的viewcontroler
 *  @param message        显示的内容
 */
- (void)alertToastWithController:(UIViewController *)viewController  andMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
	hud.mode = MBProgressHUDModeText;
	hud.labelText = message;
	hud.margin = 10.f;
	hud.yOffset = 0.0f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:TIMERDURATION];
    
}

/**
 *  再keywindow上显示文字
 *
 *  @param message 显示的文字
 */
- (void)alertToastWithKeyWindowWithMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
	hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoomOut;
	hud.labelText = message;
	hud.margin = 10.f;
	hud.yOffset = 0.0f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:TIMERDURATION];
}

/**
 *    显示在viewcontroller上面的toast，
 *
 *  @param viewController 显示的viewcontroler
 */
- (void)alertToastWithController:(UIView *)viewControllerView  {
    
    MBProgressHUD *hub = (MBProgressHUD *)[viewControllerView viewWithTag:HUDTAG];
    if (!hub) {
        
        hub = [MBProgressHUD showHUDAddedTo:viewControllerView animated:YES];
        
    }
    hub.tag = HUDTAG;
    
}

/**
 *  在window上显示hub
 */
- (void)alertShowToastOnWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hub = (MBProgressHUD *)[window viewWithTag:HUDTAG];
    if (!hub) {
        
        hub = [MBProgressHUD showHUDAddedTo:window animated:YES];
        
    }
    hub.tag = HUDTAG;
    
}


/**
 *  在window上隐藏hub
 */
-(void)alertHidenToastOnWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hub = (MBProgressHUD *)[window viewWithTag:HUDTAG];
    //    hub.animationType = MBProgressHUDAnimationZoomOut;
    [hub removeFromSuperview];
}

/**
 *  再window上显示用户等待框加文字
 *
 *  @param textString 文字
 *  @param timerDelay 时间
 */
-(void)alertToastOnWindowWithText:(NSString *)textString  delayTime:(int)timerDelay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    hud.labelText = textString;
    
    hud.tag = HUDTAG;
	
    [hud hide:YES afterDelay:timerDelay];
}

/**
 *  判断网路状态
 */
- (void)predicateNetWorkState
{
    if ( [JVCConfigModel shareInstance]._netLinkType == NETLINTYEPE_NONET) {
        
        [self alertToastWithKeyWindowWithMessage:@"没有网路，请查看网络"];
    }
    
    return;
}
@end
