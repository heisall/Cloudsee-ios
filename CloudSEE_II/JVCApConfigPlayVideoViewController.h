//
//  JVCApConfigPlayVideoViewController.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-10-20.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"
#import "JVCCloudSEENetworkHelper.h"
#import "JVCMonitorConnectionSingleImageView.h"
#import "JVCAPConfingMiddleIphone5.h"
#import "JVCApConfigDeviceViewController.h"
#import "JVCCustomYTOView.h"
#import "JVCCloudSEENetworkHelper.h"
#import "AQSController.h"
#import "AppDelegate.h"

@interface JVCApConfigPlayVideoViewController : JVCBaseWithGeneralViewController <ystNetWorkHelpDelegate,JVCMonitorConnectionSingleImageViewDelegate,JVCAPConfingMiddleIphone5Delegate,ystNetWorkHelpRemoteOperationDelegate,ystNetWorkHelpTextDataDelegate,JVCApConfigDeviceViewControllerDelegate,YTOperationDelegate,ystNetWorkHelpRemoteOperationDelegate,ystNetWorkAudioDelegate,receiveAudioDataDelegate,AppDelegateVideoDelegate> {

    NSString *strYstNumber;
}

@property (nonatomic,retain) NSString *strYstNumber;

-(void)initLayoutWithOperationView:(CGRect )frame;

/**
 *  判断是否打开远程配置
 *
 *  @return yes 打开  no 取消
 */
- (BOOL)judgeAPOpenVideoPlaying;

-(void)ApAudioBtnClick;

/**
 *  显示云台view
 */
- (void)APYTOperationViewShow;

/**
 *  开启语音对讲
 *
 *  @param button 语音对讲的按钮
 */
-(void)ApchatBtnRequest;

/**
 *  配置完成处理
 */
-(void)configFinshed;

/**
 *  断开当前的AP配置连接,不接收回调处理
 */
-(void)apConfigDisconnect;

/**
 *  长按说话
 *
 *  @param longGestureRecognizer 长按对象
 */
-(void)aplongPressedStartTalk:(UILongPressGestureRecognizer *)longGestureRecognizer;

@end
