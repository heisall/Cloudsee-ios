//
//  JVCIPAddViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/18/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCIPAddViewController.h"
#import "JVCResultTipsHelper.h"
#import "JVCPredicateHelper.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCLocalDeviceDateBaseHelp.h"
#import "JVCChannelScourseHelper.h"

@interface JVCIPAddViewController ()
{
    UITextField *textFieldIP;
    UITextField *textFieldPort;
    UITextField *textFieldIPName;
    UITextField *textFieldIPPassWord;
}

@end

@implementation JVCIPAddViewController
@synthesize deviceModel;
static const int KIPAddDeviceSlideUpHeight = 100;//向上滑动的距离
static const int KIPAddDeviceSuccess = 0;//ip添加设备成功
static const NSTimeInterval KIPAddDeviceAnimationTimer = 0.5;//动画时间

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
    self.title = LOCALANGER(@"jvc_addDevice_ipadd_titile");
    NSString *imageSlideStr      = [UIImage imageBundlePath:@"con_Slide.png"];
    UIImage *imageSlide     = [[UIImage alloc] initWithContentsOfFile:imageSlideStr];
    
    JVCLabelFieldSView *IPLinkView = [[JVCLabelFieldSView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    IPLinkView.delegate = self;
    [IPLinkView initViewWithTitlesArray:[NSArray arrayWithObjects:LOCALANGER(@"jvc_addDevice_ipadd_titile"),LOCALANGER(@"jvc_addDevice_ipadd_Port"),LOCALANGER(@"jvc_addDevice_ipadd_user"),LOCALANGER(@"jvc_addDevice_ipadd_pw"),nil]  ];
    
    [self.view addSubview:IPLinkView];
    
    
    //ip
    textFieldIP = [IPLinkView textFieldWithIndex:0];
    textFieldIP.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textFieldIP.delegate = self;
    //ip端口
    textFieldPort = [IPLinkView textFieldWithIndex:1];
    textFieldPort.text = @"9101";
    textFieldPort.keyboardType = UIKeyboardTypeNumberPad;
    textFieldPort.delegate = self;
    //ip用户名
    textFieldIPName = [IPLinkView textFieldWithIndex:2];
    textFieldIPName.text =(NSString *)DefaultUserName;
    textFieldIPName.delegate = self;
    //ip 密码
    textFieldIPPassWord = [IPLinkView textFieldWithIndex:3];
    textFieldIPPassWord.text = (NSString *)DefaultPassWord;
    textFieldIPPassWord.secureTextEntry = YES;
    textFieldIPPassWord.delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  按钮按下的回调
 */
- (void)JVCLabelFieldBtnClickCallBack
{
    
        int result = [[JVCPredicateHelper shareInstance] PredicateLinkTypeUserName:textFieldIPName.text PassWord:textFieldIPPassWord.text Ip:textFieldIP.text port:textFieldPort.text];
        if (KIPAddDeviceSuccess == result) {//正则校验用户名密码合法，调用判断用户名强度的方法
            
            [self addDeviceToLocalDdatebase];
            
        }else{//正则校验失败，提示相应的错误
            
            [[JVCResultTipsHelper shareResultTipsHelper] showModifyDevieLinkModelError:result];
        }
   
}

/**
 *  把设备添加到本地
 */
- (void)addDeviceToLocalDdatebase
{
   
    [[JVCLocalDeviceDateBaseHelp shareDataBaseHelper] addLocalIPDeviceToDataBase:textFieldIP.text port:textFieldPort.text deviceName:textFieldIPName.text passWord:textFieldIPPassWord.text];
    
    //设备添加到设备数组中
    [[JVCDeviceSourceHelper shareDeviceSourceHelper] addLocalDeviceInfo:textFieldIP.text port:textFieldPort.text deviceUserName:textFieldIPName.text devicePassWord:textFieldIPPassWord.text];
    //添加通道
    [[JVCChannelScourseHelper shareChannelScourseHelper] addLocalChannelsWithDeviceModel:textFieldIP.text];
    
    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"adddevice_net_success")];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark  向上滑动
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == textFieldIPName || textField == textFieldIPPassWord) {
        
        [self addIpDeviceSlideUp];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self addIpDeviceSlideDown];
    
    return YES;
}


/**
 *  背景被按下的回调
 */
- (void)touchUpInsiderBackGroundCallBack
{
    [self resiginIpAddDeviceTextFields];
    
    [self addIpDeviceSlideDown];
}



-(void)resiginIpAddDeviceTextFields
{
    [textFieldIP resignFirstResponder];
    //ip端口
    [textFieldPort resignFirstResponder];
    //ip用户名
    [textFieldIPName resignFirstResponder];
    //ip 密码
    [textFieldIPPassWord resignFirstResponder];
}

/**
 *  向上滑动
 */
- (void)addIpDeviceSlideUp
{
    [UIView animateWithDuration:KIPAddDeviceAnimationTimer animations:^{
    
        self.view.frame = CGRectMake(0, -KIPAddDeviceSlideUpHeight, self.view.width, self.view.height);
    
    }];
}

/**
 *  先下滑动
 */
- (void)addIpDeviceSlideDown
{
    [UIView animateWithDuration:KIPAddDeviceAnimationTimer animations:^{
        
        self.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        
    }];
}


- (void)dealloc
{
    [deviceModel release];
    [super dealloc];
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
