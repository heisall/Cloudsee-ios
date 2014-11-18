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

@interface JVCDeviceUpdateViewController ()
{
    UITextField *textFieldDevice;
    
    UITextField *textFieldVersion;
    
    JVCHomeIPCUpdate *homeIPC;
}

@end

@implementation JVCDeviceUpdateViewController
@synthesize modelDevice;

static const  kOriginOff_y      = 20;//距离顶端的距离
static const  kSizeSeperate     = 20;//2个textfield的间距

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设备的
    textFieldDevice = [[JVCControlHelper shareJVCControlHelper] textFieldWithLeftLabelText:@"设备号：" backGroundImage:@"tex_field.png"];
    textFieldDevice.frame = CGRectMake((self.view.width - textFieldDevice.width)/2.0, kOriginOff_y, textFieldDevice.width, textFieldDevice.height);
    textFieldDevice.textAlignment = UITextAlignmentLeft;
    textFieldDevice.text = modelDevice.deviceUpdateType;
    textFieldDevice.userInteractionEnabled = NO;
    [self.view addSubview:textFieldDevice];
    //版本的
    textFieldVersion = [[JVCControlHelper shareJVCControlHelper] textFieldWithLeftLabelText:@"型号：" backGroundImage:@"tex_field.png"];
    textFieldVersion.frame = CGRectMake((self.view.width - textFieldVersion.width)/2.0, textFieldDevice.bottom+kSizeSeperate, textFieldVersion.width, textFieldVersion.height);
    textFieldVersion.userInteractionEnabled = NO;
    textFieldVersion.textAlignment = UITextAlignmentLeft;
    textFieldVersion.text = modelDevice.deviceVersion;
    [self.view addSubview:textFieldVersion];
    //升级的btn的
    UIButton *btnUpDate = [[JVCControlHelper shareJVCControlHelper] buttonWithTitile:@"一键升级" normalImage:@"btn_Bg.png" horverimage:nil];
    btnUpDate.frame = CGRectMake(textFieldVersion.left, textFieldVersion.bottom+kSizeSeperate, textFieldVersion.width, btnUpDate.height);
    [btnUpDate addTarget:self  action:@selector(updateDevieVersion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnUpDate];
    
}

//升级
- (void)updateDevieVersion
{
//    homeIPC = [[JVCHomeIPCUpdate alloc] init:modelDevice.deviceType withDeviceModelInt:self.modelDevice.deviceModelInt withDeviceVersion:self.modelDevice.deviceVersion withYstNumber:self.modelDevice.yunShiTongNum withLoginUserName:kkUserName];
    
    homeIPC = [[JVCHomeIPCUpdate alloc] init:modelDevice.deviceType withDeviceModelInt:self.modelDevice.deviceModelInt withDeviceVersion:self.modelDevice.deviceVersion withYstNumber:self.modelDevice.yunShiTongNum withLoginUserName:kkUserName];

    
    JVCHomeIPCUpdateCheckVersionStatusBlock CheckVersionStatusBlock = ^(int result){
    
        DDLogVerbose(@"__%s==%d",__FUNCTION__,result);
        
        if (result == JVCHomeIPCUpdateCheckoutNewVersionHighVersion) {//最新
        
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"没有最新版本"];
                
            });
            
        }else{//升级
//            
//        [[JVCAlertHelper shareAlertHelper] alertControllerWithTitle:@"发现新版本"
//                                                           delegate:self
//                                                       selectAction:@selector(<#selector#>)
//                                                       cancelAction:nil
//                                                        selectTitle:@"更新"
//                                                        cancelTitle:@"取消"];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本" message:nil delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"取消", nil];
                [alertView show];
                [alertView release];
            });
        
        
            
        }
    };
    
    
    JVCHomeIPCDownloadUpdateProgressBlock JVCHomeIPCDownloadUpdateProgressBlock = ^(int result){
        
        DDLogVerbose(@"__%s==%d",__FUNCTION__,result);
    };
    
    JVCHomeIPCErrorBlock errorBlock = ^(int result){
        
        DDLogVerbose(@"__%s==%d",__FUNCTION__,result);
    };
    
    JVCHomeIPCFinshedBlock FinshedBlock = ^(int result){
        
        DDLogVerbose(@"__%s==%d",__FUNCTION__,result);
    };
    
    JVCHomeIPCWriteProgressBlock WriteProgressBlock = ^(int result){
        
        DDLogVerbose(@"__%s==%d",__FUNCTION__,result);
    };
    
    JVCHomeIPCResetBlock ResetBlock = ^(int result){
        
        DDLogVerbose(@"__%s==%d",__FUNCTION__,result);
    };


    
    homeIPC.homeIPCUpdateCheckVersionStatusBlock = CheckVersionStatusBlock;
    
    homeIPC.homeIPCErrorBlock = errorBlock;
    
    homeIPC.homeIPCDownloadUpdateProgressBlock = JVCHomeIPCDownloadUpdateProgressBlock;
    
    homeIPC.homeIPCFinshedBlock = FinshedBlock;
    
    homeIPC.homeIPCWriteProgressBlock = WriteProgressBlock;
    
    homeIPC.homeIPCResetBlock = ResetBlock;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [homeIPC DownloadUpdatePacket];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc
{
    if (homeIPC!=nil) {
        [homeIPC release];
    }
    
    [modelDevice release];
    
    [super dealloc];
}

@end
