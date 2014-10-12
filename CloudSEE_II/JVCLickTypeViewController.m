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
    
    JVCLabelFieldSView *YStLinkView;
    
    JVCLabelFieldSView *IPLinkView;

    
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
@synthesize deviceModel;
static const int KHeadViewHeigin    = 44;//head头的高度
static const NSTimeInterval   KLinkTypeAnimationTimer  = 0.5;//动画时间
static const int KLabelFont      = 16;//距离左边框的位置
static const int KLinkTypeSUCCESS      = 0;//成功
static const NSTimeInterval KANIMATIONTIME = 0.5;//动画时间
static const int KSLIDEHEIGINT  = -100;//动画的时间

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
}

/**
 *  初始化headView
 */
- (void)initHeadView
{
    btnIP = [UIButton buttonWithType:UIButtonTypeCustom];
    btnIP.frame = CGRectMake(0, 0, self.view.width/2.0, KHeadViewHeigin);
    [btnIP setTitle:@"域名/IP地址" forState:UIControlStateNormal];
    btnIP.titleLabel.font = [UIFont systemFontOfSize:KLabelFont];

    //设置标题的颜色
    JVCRGBHelper *rgbHelper = [JVCRGBHelper shareJVCRGBHelper];
    
    UIColor *selectColor = [rgbHelper rgbColorForKey: kJVCRGBColorMacroEditDeviceTopBarItemSelectFontColor];
    UIColor *unSelectColor = [rgbHelper rgbColorForKey: kJVCRGBColorMacroEditDeviceTopBarItemUnselectFontColor];
    btnYst.titleLabel.font = [UIFont systemFontOfSize:KLabelFont];
    btnYst = [UIButton buttonWithType:UIButtonTypeCustom];
    btnYst.frame = CGRectMake(btnIP.right, btnIP.top, self.view.width/2.0, KHeadViewHeigin);
    [btnYst setTitle:@"云视通号" forState:UIControlStateNormal];
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
    [IPLinkView initViewWithTitlesArray:[NSArray arrayWithObjects:@"IP",@"端口号",@"用户名",@"密码",nil]  ];
    
    [self.view addSubview:IPLinkView];
    
    //ip
    textFieldIP = [IPLinkView textFieldWithIndex:0];
    textFieldIP.text = deviceModel.ip;
    textFieldIP.delegate = self;
    //ip端口
    textFieldPort = [IPLinkView textFieldWithIndex:1];
    textFieldPort.text = deviceModel.port;
    textFieldPort.delegate = self;
    //ip用户名
    textFieldIPName = [IPLinkView textFieldWithIndex:2];
    textFieldIPName.text = deviceModel.userName;
    textFieldIPName.delegate = self;
    //ip 密码
    textFieldIPPassWord = [IPLinkView textFieldWithIndex:3];
    textFieldIPPassWord.text = deviceModel.passWord;
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
    [YStLinkView initViewWithTitlesArray:[NSArray arrayWithObjects:@"云视通",@"用户名",@"密码",nil]  ];
    
    [self.view addSubview:YStLinkView];
    
    //云视通
    textFieldYst = [YStLinkView textFieldWithIndex:0];
    textFieldYst.text = deviceModel.yunShiTongNum;
    textFieldYst.enabled = NO;
    textFieldYst.delegate = self;
    //云视通用户名
    textFieldYstName = [YStLinkView textFieldWithIndex:1];
    textFieldYstName.text = deviceModel.userName;
    textFieldYstName.delegate = self;
    //云视通密码
    textFieldYstPassWord = [YStLinkView textFieldWithIndex:2];
    textFieldYstPassWord.text = deviceModel.passWord;
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
    [self setBtnUnSelected];
    
    btn.selected = YES;
    
    [UIView animateWithDuration:KLinkTypeAnimationTimer animations:^{
    
        CGRect frame = imageViewSlide.frame;
        DDLogVerbose(@"%@===%@",NSStringFromCGRect(frame),NSStringFromCGRect(imageViewSlide.frame));
        frame.origin.x = btn.frame.origin.x;
        imageViewSlide.frame =frame;
        DDLogVerbose(@"[0000=%@===%@",NSStringFromCGRect(frame),NSStringFromCGRect(imageViewSlide.frame));

        btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
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
        
        int result = [[JVCPredicateHelper shareInstance] loginPredicateUserName:textFieldYstName.text andPassWord:textFieldYstPassWord.text];
        
        if (KLinkTypeSUCCESS == result) {//正则校验用户名密码合法，调用判断用户名强度的方法
            
            [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
            
            [self modiyDeviceLinkModelToServer:CONNECTTYPE_YST];
            
            
        }else{//正则校验失败，提示相应的错误
            
            
            [[JVCResultTipsHelper shareResultTipsHelper] showLoginPredacateAlertWithResult:result];
        }
        
    }else//修改改的是ip
    {
        int result = [[JVCPredicateHelper shareInstance] PredicateLinkTypeUserName:textFieldIPName.text PassWord:textFieldIPPassWord.text Ip:textFieldIP.text port:textFieldPort.text];
        if (KLinkTypeSUCCESS == result) {//正则校验用户名密码合法，调用判断用户名强度的方法
            
            [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
            
            [self modiyDeviceLinkModelToServer:CONNECTTYPE_IP];
            
            
        }else{//正则校验失败，提示相应的错误
            
            
            [[JVCResultTipsHelper shareResultTipsHelper] showLoginPredacateAlertWithResult:result];
        }

        
    }
    
}

- (void)modiyDeviceLinkModelToServer:(int)linkType
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        int result = [[JVCDeviceHelper sharedDeviceLibrary] modifyDeviceLinkModel:deviceModel.yunShiTongNum linkType:linkType userName:textFieldYstName.text password:textFieldYstPassWord.text ip:@"" port:@"" ];
        
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
    
    textFieldIPName.text = deviceModel.userName;
    textFieldIPPassWord.text = deviceModel.passWord;
}

/**
 *  保存ip链接数据
 */
- (void)saveIpLinkTypeDate
{

    deviceModel.userName = textFieldYstName.text;
    deviceModel.passWord = textFieldYstPassWord.text;
}

- (void)dealloc
{
    [deviceModel release];
    
    [imageViewSlide release];

    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self slideDownLinkType];
    }
    if (!iphone5) {
        if( textField == textFieldYstPassWord )
        {
            [self slideDownLinkType];
        }
    }
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
