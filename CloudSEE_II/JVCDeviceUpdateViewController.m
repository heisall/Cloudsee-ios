//
//  JVCDeviceUpdateViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/17/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDeviceUpdateViewController.h"
#import "JVCControlHelper.h"

@interface JVCDeviceUpdateViewController ()
{
    UITextField *textFieldDevice;
    
    UITextField *textFieldVersion;
}

@end

@implementation JVCDeviceUpdateViewController
static const  kOriginOff_y      = 20;//距离顶端的距离
static const  kSizeSeperate     = 20;//2个textfield的间距

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设备的
    textFieldDevice = [[JVCControlHelper shareJVCControlHelper] textFieldWithLeftLabelText:@"设备号：" backGroundImage:@"tex_field.png"];
    textFieldDevice.frame = CGRectMake((self.view.width - textFieldDevice.width)/2.0, kOriginOff_y, textFieldDevice.width, textFieldDevice.height);
    textFieldDevice.userInteractionEnabled = NO;
    [self.view addSubview:textFieldDevice];
    //版本的
    textFieldVersion = [[JVCControlHelper shareJVCControlHelper] textFieldWithLeftLabelText:@"型号：" backGroundImage:@"tex_field.png"];
    textFieldVersion.frame = CGRectMake((self.view.width - textFieldVersion.width)/2.0, textFieldDevice.bottom+kSizeSeperate, textFieldVersion.width, textFieldVersion.height);
    textFieldVersion.userInteractionEnabled = NO;
    [self.view addSubview:textFieldVersion];
    //升级的btn的
    UIButton *btnUpDate = [[JVCControlHelper shareJVCControlHelper] buttonWithTitile:@"一键升级" normalImage:@"btn_Bg.png" horverimage:nil];
    btnUpDate.frame = CGRectMake(textFieldVersion.left, textFieldVersion.bottom+kSizeSeperate, textFieldVersion.width, btnUpDate.height);
    [self.view addSubview:btnUpDate];
    
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

@end
