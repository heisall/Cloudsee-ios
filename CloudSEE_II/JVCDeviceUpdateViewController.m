//
//  JVCDeviceUpdateViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/17/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDeviceUpdateViewController.h"
#import "JVCControlHelper.h"
#import "JVCHomeIPCUpdate.h"
#import "CustomIOS7AlertView.h"
#import "LDProgressView.h"

typedef NS_ENUM(int , deviceUpdateAlertType) {
    
    deviceUpdateAlertType_update    = 0,//设备更新的
    deviceUpdateAlertType_reset     = 1,//设备重置的
};

@interface JVCDeviceUpdateViewController ()
{
    UITextField *textFieldDevice;
    UITextField *textFieldVersion;
    __block JVCHomeIPCUpdate *homeIPC;
        
    LDProgressView *_progressView;
    
    CustomIOS7AlertView *alertViewios7;
}

@end

@implementation JVCDeviceUpdateViewController
@synthesize modelDevice;

static const CGFloat  kOriginOff_y      = 20.0f;     //距离顶端的距离
static const CGFloat  kSizeSeperate     = 20.0f;     //2个textfield的间距
static const int      kCancelWithTime   = 1000*1000; //2个textfield的间距

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LOCALANGER(@"EditDeviceDetailViewController_device_title");

    //设备的
    textFieldDevice = [[JVCControlHelper shareJVCControlHelper] textFieldWithLeftLabelText:LOCALANGER(@"JvcDeviceUpdatedevice") backGroundImage:@"tex_field.png"];
    textFieldDevice.frame = CGRectMake((self.view.width - textFieldDevice.width)/2.0, kOriginOff_y, textFieldDevice.width, textFieldDevice.height);
    textFieldDevice.textAlignment = UITextAlignmentRight;
    textFieldDevice.text = LOCALANGER(modelDevice.deviceUpdateType.lowercaseString);

    
    textFieldDevice.userInteractionEnabled = NO;
    [self.view addSubview:textFieldDevice];
    //版本的
    textFieldVersion = [[JVCControlHelper shareJVCControlHelper] textFieldWithLeftLabelText:LOCALANGER(@"JvcDeviceUpdateModel") backGroundImage:@"tex_field.png"];
    textFieldVersion.frame = CGRectMake((self.view.width - textFieldVersion.width)/2.0, textFieldDevice.bottom+kSizeSeperate, textFieldVersion.width, textFieldVersion.height);
    textFieldVersion.userInteractionEnabled = NO;
    textFieldVersion.textAlignment = UITextAlignmentRight;
    textFieldVersion.text = modelDevice.deviceVersion;
    [self.view addSubview:textFieldVersion];
    //升级的btn的
    UIButton *btnUpDate = [[JVCControlHelper shareJVCControlHelper] buttonWithTitile:LOCALANGER(@"home_device_advance_update") normalImage:@"btn_Bg.png" horverimage:nil];
    btnUpDate.frame = CGRectMake(textFieldVersion.left, textFieldVersion.bottom+kSizeSeperate, textFieldVersion.width, btnUpDate.height);
    [btnUpDate addTarget:self  action:@selector(updateDevieVersion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnUpDate];
    
    //初始化设备升级的助手类
    homeIPC = [[JVCHomeIPCUpdate alloc] init:self.modelDevice.deviceType withDeviceModelInt:self.modelDevice.deviceModelInt withDeviceVersion:self.modelDevice.deviceVersion withYstNumber:self.modelDevice.yunShiTongNum withLoginUserName:kkUserName];
    
}

- (void)BackClick
{
    self.modelDevice.deviceVersion =  textFieldVersion.text;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//升级
- (void)updateDevieVersion
{
    self.modelDevice.deviceVersion = textFieldVersion.text;
    
    JVCHomeIPCUpdateCheckVersionStatusBlock CheckVersionStatusBlock = ^(int result,NSString *strNewVersion){
        
        DDLogVerbose(@"%s---------retainCount = %d",__FUNCTION__,self.retainCount);
    
        
        if (result == JVCHomeIPCUpdateCheckoutNewVersionHighVersion) {//最新
        
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"EditDeviceDetailViewController_device_no_new_version")];
                
            });
            
        }else{//升级

            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

                [[JVCAlertHelper shareAlertHelper] alertControllerWithTitle:[NSString stringWithFormat:@"%@%@",LOCALANGER(@"home_device_advance_titile"),strNewVersion] delegate:self selectAction:@selector(startDown) cancelAction:nil selectTitle:LOCALANGER(@"home_device_advance_update") cancelTitle:LOCALANGER(@"jvc_DeviceList_APquit") alertTage:deviceUpdateAlertType_update];

            });
        }
    };
    
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    [homeIPC checkIpcIsNewVersion:CheckVersionStatusBlock];
}

/**
 *  如果线程正在循环下载确保线程退出
 */
-(void)cancelHomeIPC {
    
    while (true) {
        
        if (homeIPC) {
            
            [homeIPC CancelDownloadUpdate];
            
            usleep(kCancelWithTime);
            
        }else {
        
            break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if(alertView.tag == deviceUpdateAlertType_update)
   {
       if (buttonIndex == 0) {
           
           [self startDown];
       }
       
   }else if(alertView.tag == deviceUpdateAlertType_reset)
   {
       if (buttonIndex == 0) {
           
           [self startReset];
       }
   }
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    [self cancelDeviceDown];
}

/**
 *  重启设备
 */
- (void)startReset
{
    JVCHomeIPCResetBlock ResetBlock = ^(int result,NSString *strNewVersion){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
            
            if (result == JVCHomeIPCResetSuccess) {
                
                textFieldVersion.text = strNewVersion;
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"EditDeviceDetailViewController_device_updateSuccess")];
            }else{
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"EditDeviceDetailViewController_device_update_error")];
                
            }
            
        });
        
    };
    
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    [homeIPC resetDevice:ResetBlock];
}

/**
 *  开始下载
 */
- (void)startDown
{
    
    JVCHomeIPCDownloadUpdateProgressBlock JVCHomeIPCDownloadUpdateProgressBlock = ^(int result){
        
        DDLogVerbose(@"__%s=JVCHomeIPCDownloadUpdateProgressBlock=%d",__FUNCTION__,result);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (alertViewios7 == nil ) {
                
                [self creatAlertWithProgress:YES andTitle:LOCALANGER(@"EditDeviceDetailViewController_device_downing")];
            }else{
                
                [self updataPregressView:result];
            }
        });
        
    };
    
    JVCHomeIPCWriteProgressBlock WriteProgressBlock = ^(int result){
        
        DDLogVerbose(@"__%s=JVCHomeIPCWriteProgressBlock=%d",__FUNCTION__,result);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (alertViewios7 == nil ) {
                
                [self creatAlertWithProgress:NO andTitle:LOCALANGER(@"EditDeviceDetailViewController_device_setting")];
            }else{
                
                [self updataPregressView:result];
            }
        });
    };
    
    JVCHomeIPCErrorBlock errorBlock = ^(int result){
        
        NSString *errorString = nil;
        
        switch (result) {
            case JVCHomeIPCErrorUpdateError:
                errorString = LOCALANGER(@"EditDeviceDetailViewController_device_down_upload_error");
                break;
            case JVCHomeIPCErrorTimeout:
                errorString = LOCALANGER(@"EditDeviceDetailViewController_device_down_upload_error");
                break;
            case JVCHomeIPCErrorWriteError:
                errorString = LOCALANGER(@"EditDeviceDetailViewController_device_update_error");
                break;
                
            default:
                errorString = LOCALANGER(@"EditDeviceDetailViewController_device_down_upload_error");
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
            
            [self dismissAlertViewAndProgressView];
            
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:errorString];
        });
    };
    
    JVCHomeIPCFinshedBlock FinshedBlock = ^(int result){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
            
            [self dismissAlertViewAndProgressView];
            
            switch (result) {
                case JVCHomeIPCFinshedDownload:
                    break;
                case JVCHomeIPCFinshedWrite:
                {
                     DDLogVerbose(@"%s-----###############019--------relf.retainCount=%d",__FUNCTION__,self.retainCount);
                    [[JVCAlertHelper shareAlertHelper] alertControllerWithTitle:LOCALANGER(@"EditDeviceDetailViewController_device_restart") delegate:self selectAction:@selector(startReset) cancelAction:nil selectTitle:LOCALANGER(@"EditDeviceDetailViewController_device_restart_click") cancelTitle:LOCALANGER(@"jvc_DeviceList_APquit") alertTage:deviceUpdateAlertType_reset];
                    
                }
                    break;
                case JVCHomeIPCFinshedCancelDownload:{
                    
                    [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:LOCALANGER(@"EditDeviceDetailViewController_device_cancel")];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        });
    };

    [[JVCAlertHelper shareAlertHelper]alertShowToastOnWindow];
    
     [homeIPC DownloadUpdatePacket:FinshedBlock withDownloadUpdateProgress:JVCHomeIPCDownloadUpdateProgressBlock  withHomeIPCWriteProgress:WriteProgressBlock withDownloadUpdateProgressError:errorBlock];
}

/**
 *  取消下载事件
 */
- (void)cancelDeviceDown
{
    [homeIPC CancelDownloadUpdate];
}

/**
 * 让alerview 取消
 */
- (void)dismissAlertViewAndProgressView
{
    _progressView.progress = 0.0;

    [alertViewios7 close];
    [alertViewios7 setDelegate:nil];
    alertViewios7 = nil;

}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


/**
 *  初始化alertview ，带着进度条，取消按钮的
 */
- (void)creatAlertWithProgress:(BOOL)hasProgress  andTitle:(NSString *)title
{
    
        if (hasProgress) {
            
            alertViewios7= [[CustomIOS7AlertView alloc] initwithCancel:NO];
            
        }else{
            alertViewios7= [[CustomIOS7AlertView alloc] initwithCancel:YES];
            
        }
        UIView *_contentview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 120)];
        
        UILabel *_lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,20, 240, 40)];
        _lblTitle.numberOfLines = 0;
        _lblTitle.font = [UIFont systemFontOfSize:15];
        _lblTitle.lineBreakMode = UILineBreakModeCharacterWrap;
        _lblTitle.textAlignment = UITextAlignmentCenter;
        _lblTitle.text = title;
        _lblTitle.backgroundColor = [UIColor clearColor];
        [_contentview addSubview:_lblTitle];
        [_lblTitle release];
    
        _progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(20, 70, 220, 20)];
        _progressView.color = [UIColor colorWithRed:0.00f green:0.64f blue:0.00f alpha:1.00f];
        _progressView.flat = @YES;
        _progressView.progress = 0.00;
        _progressView.animate = @YES;

        alertViewios7.tag = 100000;
        [_contentview addSubview:_progressView];
        [_progressView release];
        // Add some custom content to the alert view
        [alertViewios7 setContainerView:_contentview];
        [_contentview release];
        
        [alertViewios7 setDelegate:self];
    
        [alertViewios7 setUseMotionEffects:true];
        
        [alertViewios7 show];
        [alertViewios7 release];
}

/**
 *  更新progressveiw
 */
-(void)updataPregressView:(int )progressNum
{
    _progressView.progress =  progressNum/100.0;
}


- (void)dealloc
{
    [homeIPC release];
    [modelDevice release];
    
    DDLogVerbose(@"%s-------------##################",__FUNCTION__);
    
    [super dealloc];
}

@end
