//
//  JVCLocalEditDeviceInfoViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/14/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCLocalEditDeviceInfoViewController.h"
#import "JVCLocalDeviceDateBaseHelp.h"
#import "JVCDeviceModel.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCChannelScourseHelper.h"
@interface JVCLocalEditDeviceInfoViewController ()

@end

@implementation JVCLocalEditDeviceInfoViewController

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
 *  删除事件
 */
- (void)deleteDevice
{
    [[JVCChannelScourseHelper shareChannelScourseHelper]deleteLocalChannelsWithYStNum:self.deviceModel.yunShiTongNum];

  BOOL bResult =  [[JVCDeviceSourceHelper shareDeviceSourceHelper] deleteLocalDeviceInfo:self.deviceModel.yunShiTongNum];
    
    [self handeleDeleteDeviceRusult:!bResult];
}

/**
 *  正则判断成功后，调用修改方法
 */
- (void)editDeviceInfoPredicateSuccess:(NSString *)nickName  userName:(NSString *)userName  passWord:(NSString *)password
{
   BOOL result =  [[JVCDeviceSourceHelper shareDeviceSourceHelper] updateLocalDeviceNickNameWithYst:self.deviceModel.yunShiTongNum NickName:nickName deviceName:userName passWord:password iscustomLinkModel:self.deviceModel.isCustomLinkModel];
    
    [self handelModifyDeviceInfoResult:!result];
   
    
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
