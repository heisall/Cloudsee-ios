//
//  JVCLocalAddDeviceViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCLocalAddDeviceViewController.h"
#import "JVCLocalDeviceDateBaseHelp.h"
#import "JVCChannelScourseHelper.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCCloudSEENetworkHelper.h"
#import "JVCConfigModel.h"
@interface JVCLocalAddDeviceViewController ()

@end

@implementation JVCLocalAddDeviceViewController
static const int    kAddLocalDeviceWithWlanTimeOut       = 5;   //添加设备从服务器获取通道数的超时时间

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 *  添加设备，即先把设备绑定到自己的账号中，然后获取设备的详细信息
 *
 */
- (void)addDeviceToAccount:(NSString *)ystNum  deviceUserName:(NSString *) name  passWord:(NSString *)passWord
{
    
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int channelCount  = DEFAULTCHANNELCOUNT;
        
        if ( [JVCConfigModel shareInstance]._netLinkType != NETLINTYEPE_NONET) {
            
             channelCount = [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] WanGetWithChannelCount:ystNum nTimeOut:kAddLocalDeviceWithWlanTimeOut];
            
        };

        DDLogVerbose(@"ystServicDeviceChannel=%d",channelCount);
        
        channelCount = channelCount <= 0 ? DEFAULTCHANNELCOUNT : channelCount;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

            /**
             *  添加设备
             */
            [[JVCLocalDeviceDateBaseHelp shareDataBaseHelper] addLocalDeviceToDataBase:ystNum deviceName:name passWord:passWord];
            //设备添加到设备数组中
            [[JVCDeviceSourceHelper shareDeviceSourceHelper] addLocalDeviceInfo:ystNum
                                                                 deviceUserName:name
                                                                 devicePassWord:passWord];

            //添加通道
            [[JVCChannelScourseHelper shareChannelScourseHelper] addLocalChannelsWithDeviceModel:ystNum channelNums:channelCount];
            
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"adddevice_net_success")];
            
            if (addDeviceDelegate !=nil &&[addDeviceDelegate respondsToSelector:@selector(addDeviceSuccessCallBack)]) {
                
                [addDeviceDelegate addDeviceSuccessCallBack];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    });

   
    
   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
