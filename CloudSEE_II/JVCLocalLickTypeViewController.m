//
//  JVCLocalLickTypeViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/14/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCLocalLickTypeViewController.h"
#import "JVCDeviceMacro.h"
#import "JVCDeviceSourceHelper.h"

@interface JVCLocalLickTypeViewController ()
{
    UITextField *textFieldYst;
    UITextField *textFieldYstName;
    UITextField *textFieldYstPassWord;
    
    UITextField *textFieldIP;
    UITextField *textFieldPort;
    UITextField *textFieldIPName;
    UITextField *textFieldIPPassWord;
}

@end

@implementation JVCLocalLickTypeViewController

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
    
    //ip
    textFieldIP = [IPLinkView textFieldWithIndex:0];

    //ip端口
    textFieldPort = [IPLinkView textFieldWithIndex:1];

    //ip用户名
    textFieldIPName = [IPLinkView textFieldWithIndex:2];

    //ip 密码
    textFieldIPPassWord = [IPLinkView textFieldWithIndex:3];

    
    //云视通
    textFieldYst = [YStLinkView textFieldWithIndex:0];

    //云视通用户名
    textFieldYstName = [YStLinkView textFieldWithIndex:1];


    //云视通密码
    textFieldYstPassWord = [YStLinkView textFieldWithIndex:2];



}

/**
 *  处理按钮按下保存事件的返回值
 *
 *  @param linkType 返回值
 */
- (void)modiyDeviceLinkModelToServer:(int)linkType
{
    
    BOOL result = NO;
    
    if (linkType == CONNECTTYPE_YST) {
        
        result = [[JVCDeviceSourceHelper shareDeviceSourceHelper] updateLocalDeviceNickNameWithYst:self.deviceModel.yunShiTongNum NickName:self.deviceModel.nickName deviceName:textFieldYstName.text passWord:textFieldYstPassWord.text iscustomLinkModel:NO];
    }else{
        
        NSString *strIp = [[JVCSystemUtility shareSystemUtilityInstance]getIpOrNetHostString:textFieldIP.text];
        
        [strIp retain];
        
        result = [[JVCDeviceSourceHelper shareDeviceSourceHelper] updateLocalDeviceLickInfoWithYst:self.deviceModel.yunShiTongNum
                                                                                        deviceName:textFieldIPName.text
                                                                                          passWord:textFieldIPPassWord.text iscustomLinkModel:YES
                                                                                              port:textFieldPort.text ip:strIp];
        [strIp release];

      

    }
            
    [self ModifyDeviceLinkYSTTypeResult:!result];
            
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
