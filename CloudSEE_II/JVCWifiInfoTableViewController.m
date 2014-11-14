//
//  JVCWifiInfoTableViewController.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-14.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCWifiInfoTableViewController.h"

@interface JVCWifiInfoTableViewController ()

@end

@implementation JVCWifiInfoTableViewController

NSString const *kWiFiWithIP                = @"WIFI_IP";    //IP
NSString const *kWiFiWithSubnetMask        = @"WIFI_NM";    //子网掩码
NSString const *kWiFiWithGateway           = @"WIFI_GW";    //默认网关
NSString const *kWiFiWithDNS               = @"WIFI_DNS";  //域名地址
NSString const *kWiFiWithMAC               = @"WIFI_MAC";   //网卡地址

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = NSLocalizedString(@"JVCWifiInfoTableViewController_title", nil);
}

/**
 *  初始化加载
 */
-(void)initLayoutWithTitles {
    
    [super initLayoutWithTitles];
    
    [titles removeAllObjects];
    
    if (!titles) {
        
        titles = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    [titles addObject:(NSString *)kWiFiWithIP];
    [titles addObject:(NSString *)kWiFiWithSubnetMask];
    [titles addObject:(NSString *)kWiFiWithGateway];
    [titles addObject:(NSString *)kWiFiWithDNS];
    [titles addObject:(NSString *)kWiFiWithMAC];
    [titles addObject:(NSString *)kWiredWithCloudSEEID];
    [titles addObject:(NSString *)kWiredWithStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
