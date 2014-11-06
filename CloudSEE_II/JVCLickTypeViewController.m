//
//  JVCLickTypeViewController.m
//  CloudSEE_II
//  连接模式
//  Created by Yanghu on 10/10/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCLickTypeViewController.h"
#import "JVCRGBHelper.h"
#import "JVCDeviceModel.h"
#import "JVCDeviceMacro.h"
#import "JVCPredicateHelper.h"
#import "JVCResultTipsHelper.h"
#import "JVCDeviceHelper.h"
typedef enum {
    textFieldType_User      = 0,   //用户名
    textFieldType_PassWord  = 1,  // 密码
    textFieldType_Enable    = 2,  //不让用
    textFieldType_IP        = 3,  // ip
    textFieldType_Port      = 4,  //端口号

} textFieldType;

@interface JVCLickTypeViewController ()
{
    UIImageView *imageViewSlide ;//滚动的横线
    
    UIButton *btnIP;
    UIButton *btnYst;
    
    UITextField *textFieldYst;
    UITextField *textFieldYstName;
    UITextField *textFieldYstPassWord;

    UITextField *textFieldIP;
    UITextField *textFieldPort;
    UITextField *textFieldIPName;
    UITextField *textFieldIPPassWord;
}

@end

@implementation JVCLickTypeViewController
@synthesize YStLinkView;
@synthesize IPLinkView;
@synthesize deviceModel;

static const int              KHeadViewHeigin          = 44;   //head头的高度
static const NSTimeInterval   KLinkTypeAnimationTimer  = 0.5;  //动画时间
static const int              KLabelFont               = 16;   //距离左边框的位置
static const int              KLinkTypeSUCCESS         = 0;    //成功
static const NSTimeInterval   KANIMATIONTIME           = 0.5;  //动画时间
static const int              KSLIDEHEIGINT            = -100; //动画的时间

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
    
    //头模块
    [self initHeadView];
    //滑动模块
    [self initSlideView];
    [self initIPView];
    [self initYSTView];
    
    if (deviceModel.linkType == CONNECTTYPE_IP) {//ip连接
        
        [self.view bringSubviewToFront:IPLinkView];
        YStLinkView.hidden = YES;
        IPLinkView.hidden = NO;
        
    }else{
        
        [self.view bringSubviewToFront:YStLinkView];
        IPLinkView.hidden = YES;
        YStLinkView.hidden = NO;
    }
    
    self.title = LOCALANGER(@"jvc_licktype_title");
}

/**
 *  初始化headView
 */
- (void)initHeadView
{
    btnIP = [UIButton buttonWithType:UIButtonTypeCustom];
    btnIP.frame = CGRectMake(0, 0, self.view.width/2.0, KHeadViewHeigin);
    [btnIP setTitle:LOCALANGER(@"jvc_licktype_Ip") forState:UIControlStateNormal];
    btnIP.titleLabel.font = [UIFont systemFontOfSize:KLabelFont];

    //设置标题的颜色
    JVCRGBHelper *rgbHelper = [JVCRGBHelper shareJVCRGBHelper];
    
    UIColor *selectColor = [rgbHelper rgbColorForKey: kJVCRGBColorMacroEditDeviceTopBarItemSelectFontColor];
    UIColor *unSelectColor = [rgbHelper rgbColorForKey: kJVCRGBColorMacroEditDeviceTopBarItemUnselectFontColor];
    btnYst = [UIButton buttonWithType:UIButtonTypeCustom];
    btnYst.frame = CGRectMake(btnIP.right, btnIP.top, self.view.width/2.0, KHeadViewHeigin);
    [btnYst setTitle:LOCALANGER(@"jvc_licktype_YST") forState:UIControlStateNormal];
    btnYst.titleLabel.font = [UIFont systemFontOfSize:KLabelFont];

    //设置标题的颜色
    
    if (selectColor) {
        
        [btnYst setTitleColor:selectColor forState:UIControlStateSelected];
        [btnIP setTitleColor:selectColor forState:UIControlStateSelected];
    }
    
    if (unSelectColor) {
        
        [btnYst setTitleColor:unSelectColor forState:UIControlStateNormal];
        [btnIP setTitleColor:unSelectColor forState:UIControlStateNormal];

    }
    
    [btnYst addTarget:self action:@selector(animationSlideView:) forControlEvents:UIControlEventTouchUpInside];
    [btnIP addTarget:self action:@selector(animationSlideView:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btnYst];
    [self.view addSubview:btnIP];
}

/**
 *  初始化滑动模块
 */
- (void)initSlideView
{
    NSString *imageSlideStr      = [UIImage imageBundlePath:@"con_Slide.png"];
    UIImage *imageSlide     = [[UIImage alloc] initWithContentsOfFile:imageSlideStr];
    
    NSString *imageStr      = [UIImage imageBundlePath:@"con_line.png"];
    UIImage *imageLine      = [[UIImage alloc] initWithContentsOfFile:imageStr];
    
    UIImageView *imageViewLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, KHeadViewHeigin, self.view.width, imageSlide.size.height)];
    imageViewLine.image     = imageLine;
    [imageLine release];
    [self.view addSubview:imageViewLine];
    [imageViewLine release];
    
     imageViewSlide = [[UIImageView alloc] initWithFrame:CGRectMake(0, KHeadViewHeigin, self.view.width/2.0, imageSlide.size.height)];
    imageViewSlide.image     = imageSlide;
    [imageSlide release];
    [self.view addSubview:imageViewSlide];
    
    if (deviceModel.linkType == CONNECTTYPE_IP) {//ip连接
        
        [self animationSlideView:btnIP];
        
    }else{
        
        [self animationSlideView:btnYst];
    }
}

/**
 *  初始化ipView
 */
- (void)initIPView
{
    NSString *imageSlideStr      = [UIImage imageBundlePath:@"con_Slide.png"];
    UIImage *imageSlide     = [[UIImage alloc] initWithContentsOfFile:imageSlideStr];
    
    IPLinkView = [[JVCLabelFieldSView alloc] initWithFrame:CGRectMake(0, KHeadViewHeigin+imageSlide.size.height, self.view.width, self.view.height)];
    IPLinkView.delegate = self;
    [IPLinkView initViewWithTitlesArray:[NSArray arrayWithObjects:LOCALANGER(@"jvc_addDevice_ipadd_titile"),LOCALANGER(@"jvc_addDevice_ipadd_Port"),LOCALANGER(@"jvc_addDevice_ipadd_user"),LOCALANGER(@"jvc_addDevice_ipadd_pw"),nil]  ];
    
    [self.view addSubview:IPLinkView];
    
    
    //ip
    textFieldIP = [IPLinkView textFieldWithIndex:0];
    textFieldIP.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textFieldIP.text = deviceModel.ip;
    textFieldIP.delegate = self;
    //ip端口
    textFieldPort = [IPLinkView textFieldWithIndex:1];
    
    if (deviceModel.port.length>0) {
        
        textFieldPort.text = deviceModel.port;
        
    }else{
        
        textFieldPort.text = @"9101";
    }
    
    textFieldPort.keyboardType = UIKeyboardTypeNumberPad;
    textFieldPort.delegate = self;
    //ip用户名
    textFieldIPName = [IPLinkView textFieldWithIndex:2];
    textFieldIPName.text = deviceModel.userName;
    textFieldIPName.delegate = self;
    //ip 密码
    textFieldIPPassWord = [IPLinkView textFieldWithIndex:3];
    textFieldIPPassWord.text = deviceModel.passWord;
    textFieldIPPassWord.secureTextEntry = YES;
    textFieldIPPassWord.delegate = self;

    IPLinkView.hidden = YES;
    [imageSlide release];
}

/**
 *  初始化云视通view
 */
- (void)initYSTView
{
    NSString *imageSlideStr      = [UIImage imageBundlePath:@"con_Slide.png"];
    UIImage *imageSlide     = [[UIImage alloc] initWithContentsOfFile:imageSlideStr];
    
    YStLinkView = [[JVCLabelFieldSView alloc] initWithFrame:CGRectMake(0, KHeadViewHeigin+imageSlide.size.height, self.view.width, self.view.height)];
    YStLinkView.delegate = self;
    [YStLinkView initViewWithTitlesArray:[NSArray arrayWithObjects:LOCALANGER(@"jvc_addDevice_ipadd_yst"),LOCALANGER(@"jvc_addDevice_ipadd_user"),LOCALANGER(@"jvc_addDevice_ipadd_pw"),nil]  ];
    
    [self.view addSubview:YStLinkView];
    
    //云视通
    textFieldYst = [YStLinkView textFieldWithIndex:0];
    textFieldYst.text = deviceModel.yunShiTongNum;
    textFieldYst.backgroundColor = [UIColor lightGrayColor];
    textFieldYst.enabled = NO;
    textFieldYst.delegate = self;
    //云视通用户名
    textFieldYstName = [YStLinkView textFieldWithIndex:1];
    textFieldYstName.text = deviceModel.userName;
    textFieldYstName.delegate = self;
    //云视通密码
    textFieldYstPassWord = [YStLinkView textFieldWithIndex:2];
    textFieldYstPassWord.text = deviceModel.passWord;
    textFieldYstPassWord.secureTextEntry = YES;
    textFieldYstPassWord.delegate = self;
    [imageSlide release];
}


/**
 *  动画事件
 *
 *  @param btn 按下的btn
 */
- (void)animationSlideView:(UIButton *)btn
{
    if (btn.selected == YES) {
        
        return;
    }
    
    [self setBtnUnSelected];
    
    btn.selected = YES;
    
    [UIView animateWithDuration:KLinkTypeAnimationTimer animations:^{
    
        CGRect frame = imageViewSlide.frame;
        frame.origin.x = btn.frame.origin.x;
        imageViewSlide.frame =frame;
        
    }];
    
    CATransition  *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.type = @"rippleEffect";
    
    
    if (IPLinkView.hidden) {//ip连接
        
        [self.view bringSubviewToFront:IPLinkView];
        YStLinkView.hidden = YES;
        IPLinkView.hidden = NO;
    }else{
        [self.view bringSubviewToFront:YStLinkView];
        YStLinkView.hidden = NO;
        IPLinkView.hidden = YES;
    }
    
    [self.view.layer addAnimation:animation forKey:nil];

}

- (void)setBtnUnSelected
{
    btnYst.selected = NO;
    btnYst.transform = CGAffineTransformIdentity;
    btnIP.selected  = NO;
    btnIP.transform = CGAffineTransformIdentity;
}


/**
 *  按钮按下的回调
 */
- (void)JVCLabelFieldBtnClickCallBack
{
    
    if (IPLinkView.hidden == YES) {//修改的是云视通
        
        int result = [[JVCPredicateHelper shareInstance] predicateModifyLinkModelYSTWithName:textFieldYstName.text andPassWord:textFieldYstPassWord.text];
        
        if (KLinkTypeSUCCESS == result) {//正则校验用户名密码合法，调用判断用户名强度的方法
        
            [self modiyDeviceLinkModelToServer:CONNECTTYPE_YST];
            
        }else{//正则校验失败，提示相应的错误
            
            [[JVCResultTipsHelper shareResultTipsHelper] showModifyDevieLinkModelError:result];
        }
        
    }else//修改改的是ip
    {
        
        int result = [[JVCPredicateHelper shareInstance] PredicateLinkTypeUserName:textFieldIPName.text PassWord:textFieldIPPassWord.text Ip:textFieldIP.text port:textFieldPort.text];
        
        if (KLinkTypeSUCCESS == result) {//正则校验用户名密码合法，调用判断用户名强度的方法
            
            
            [self modiyDeviceLinkModelToServer:CONNECTTYPE_IP];
            
        }else{//正则校验失败，提示相应的错误
            
            [[JVCResultTipsHelper shareResultTipsHelper] showModifyDevieLinkModelError:result];
        }
    }
}


/**
 *  背景被按下的回调
 */
- (void)touchUpInsiderBackGroundCallBack
{
    [self resiginLinkTypeTextFields];
    
    [self slideDownLinkType];
}

/**
 *  处理按钮按下保存事件的返回值
 *
 *  @param linkType 返回值
 */
- (void)modiyDeviceLinkModelToServer:(int)linkType
{
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int result = -1;
        
        if (linkType == CONNECTTYPE_YST) {
            
           result = [[JVCDeviceHelper sharedDeviceLibrary] modifyDeviceLinkModel:deviceModel.yunShiTongNum linkType:linkType userName:textFieldYstName.text password:textFieldYstPassWord.text ip:@"" port:@"" ];

        }else{
        
            NSString *strIp = [[JVCSystemUtility shareSystemUtilityInstance] getIpOrNetHostString:textFieldIP.text];
            
            [strIp retain];
            
             result = [[JVCDeviceHelper sharedDeviceLibrary] modifyDeviceLinkModel:deviceModel.yunShiTongNum linkType:linkType userName:textFieldIPName.text password:textFieldIPPassWord.text ip:strIp port:textFieldPort.text];
            
            [strIp release];
        }
      
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
            
            [self ModifyDeviceLinkYSTTypeResult:result];
            
            
        });
    });

}

/**
 *  修改连接类型的回调函数
 *
 *  @param result 0 成功 其他失败  -5 超时
 */
- (void)ModifyDeviceLinkYSTTypeResult:(int)result
{
    DDLogInfo(@"修改设备连接类型收到的返回值=%d",result);
    
    if ( KLinkTypeSUCCESS == result) {//成功
        
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"Modify_LinkType_success")];
        
        if (IPLinkView.hidden == YES) {//云视通的保存数据方法
            
            [self saveYSTlingDate];
            
        }else{
            
            [self saveIpLinkTypeDate];
            
        }
        
        deviceModel.isCustomLinkModel = deviceModel.linkType == CONNECTTYPE_YST ? FALSE : TRUE;
        
    }else{
        
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"Modify_LinkType_fail")];
    }
}

/**
 *  云视通连接的保存事件
 */
- (void)saveYSTlingDate
{
    deviceModel.userName = textFieldYstName.text;
    deviceModel.passWord = textFieldYstPassWord.text;
    
    deviceModel.linkType = CONNECTTYPE_YST;
    textFieldIPName.text = deviceModel.userName;
    textFieldIPPassWord.text = deviceModel.passWord;
    
    [self.navigationController popViewControllerAnimated:YES];

}

/**
 *  保存ip链接数据
 */
- (void)saveIpLinkTypeDate
{
    if ([[JVCPredicateHelper shareInstance] isIP:textFieldIP.text]) {//ip直接保存
        
        deviceModel.ip = textFieldIP.text;

    }else{//域名，转化一下保存
    
        deviceModel.ip =[[JVCSystemUtility shareSystemUtilityInstance] getIpOrNetHostString: textFieldIP.text];

    }
    deviceModel.port = textFieldPort.text;
    deviceModel.userName = textFieldIPName.text;
    deviceModel.passWord = textFieldIPPassWord.text;
    
    deviceModel.linkType = CONNECTTYPE_IP;
    textFieldYstName.text = deviceModel.userName;
    textFieldYstPassWord.text = deviceModel.passWord;
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  关闭键盘事件
 */
-(void)deallocWithViewDidDisappear{

    [self resiginLinkTypeTextFields];

}

- (void)dealloc
{
    [YStLinkView release];
    [IPLinkView release];
    [deviceModel release];
    [imageViewSlide release];

    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    NSString *imagePath     = [UIImage imageBundlePath:@"con_fieldSec.png"];
    UIImage *imageSec    = [[UIImage alloc] initWithContentsOfFile:imagePath];
    textField.backgroundColor = [UIColor colorWithPatternImage:imageSec];
    [imageSec release];
    
    if( textField == textFieldIPName ||textField == textFieldIPPassWord)
    {
        [self slideUPLinkType];
    }
    if (!iphone5) {
        if( textField == textFieldYstPassWord )
        {
            [self slideUPLinkType];
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *imagePath     = [UIImage imageBundlePath:@"con_fieldUnSec.png"];
    UIImage *imageSec    = [[UIImage alloc] initWithContentsOfFile:imagePath];
    textField.backgroundColor = [UIColor colorWithPatternImage:imageSec];
    [imageSec release];
    
    if( textField == textFieldIPName ||textField == textFieldIPPassWord)
    {
        if (self.view.top >0) {
            
            [self slideDownLinkType];

        }
    }
    if (!iphone5) {
        if( textField == textFieldYstPassWord )
        {
            [self slideDownLinkType];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self slideDownLinkType];
    
    return YES;
}


#pragma mark 界面向上滑动
/**
 *  向上滚动试图
 */
- (void)slideUPLinkType
{
    [UIView animateWithDuration:KANIMATIONTIME animations:^{
        
        self.view.frame = CGRectMake(0, KSLIDEHEIGINT, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

/**
 *  向下滚动试图
 */
- (void)slideDownLinkType
{
    [UIView animateWithDuration:KANIMATIONTIME animations:^{
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    }];
}



-(void)resiginLinkTypeTextFields
{
    [textFieldIP resignFirstResponder];
    //ip端口
    [textFieldPort resignFirstResponder];
    //ip用户名
    [textFieldIPName resignFirstResponder];
    //ip 密码
    [textFieldIPPassWord resignFirstResponder];
    //云视通
    [textFieldYst resignFirstResponder];
    //云视通用户名
    [textFieldYstName resignFirstResponder];
    //云视通密码
    [textFieldYstPassWord resignFirstResponder];

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
