//
//  JVCAddDeviceViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAddDeviceViewController.h"
#import "JVCRGBHelper.h"
#import "JVCPredicateHelper.h"
#import "JVCDeviceHelper.h"
#import "JVCDeviceMacro.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCChannelScourseHelper.h"
#import "JVCAPConfigPreparaViewController.h"
#import "JVCCloudSEENetworkHelper.h"
#import "JVCLANScanWithSetHelpYSTNOHelper.h"
#import "JVCResultTipsHelper.h"
#import "JVCConfigModel.h"
#import "JVCLabelFieldSView.h"



static const int         ADDPREDICATE_SUCCESS        = 0;
static const int         TESTORIIGIN_Y               = 30;     //距离navicationbar的距离
static const CGFloat     SEPERATE                    = 15.0f;  //控件之间的距离，纵向
static const int         ADDDEVICE_RESULT_SUCCESS    = 0;      //成功
static const int         DEFAULRESIGNTFONTSIZE       = 14;      //默认的字体大小
static const int         DEFAULTLABELWITH            = 70;      //textfield的lefitwiew对应的label的宽度
static const CGFloat     kADDDEVICESLIDEHEIGIT       = 100.0f;  //向上滑动的高度
static const NSTimeInterval kADDDEVICEANIMATION = 0.5f;         //动画时间
static const int         kAddDeviceWithWlanTimeOut   = 5;       //添加设备从服务器获取通道数的超时时间
static const CGFloat     ktitleWithLeft              = 8.0f;   //控件之间的距离，纵向

@interface JVCAddDeviceViewController ()
{
    UITextField *textFieldYST;//云视通
    UITextField *textFieldUserName;//用户名
    UITextField *textFieldPassWord;//密码
    
    UIButton *btnSave;//保存按钮
    UIButton *btnAdvace;//高级按钮
    UIButton *btnAP;//Ap按钮
    BOOL   isShowUSerAndPW;//旋转的标志
    CGRect rectRectFrame;  //原始的数据
    JVCLabelFieldSView *contentView;
    
    int  nAddDeviceChanelCount;//添加通道的数量
}

@end

@implementation JVCAddDeviceViewController
@synthesize addDeviceDelegate;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[JVCAlertHelper shareAlertHelper]  alertHidenToastOnWindow];

    if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_ACCOUNT) {
        
        NSString *ystNum = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kSAVEYSTNUM];
        
        if (ystNum.length>0) {
            
            textFieldYST.text = ystNum;
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:(NSString *)kSAVEYSTNUM];
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = LOCALANGER(@"jvc_addDevice_title");

    contentView = [[JVCLabelFieldSView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    contentView.delegate = self;
    [contentView initViewWithTitlesArray:[NSArray arrayWithObjects:LOCALANGER(@"jvc_addDevice_YstNUm"),LOCALANGER(@"jvc_addDevice_userName"),LOCALANGER(@"jvc_addDevice_password"),nil]  ];
    
    [self.view addSubview:contentView];
    

    //云视通
    textFieldYST = [contentView textFieldWithIndex:0];
    [textFieldYST becomeFirstResponder];
    textFieldYST.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textFieldYST.delegate = self;
    //用户名
    textFieldUserName = [contentView textFieldWithIndex:1];
    textFieldUserName.delegate = self;
    textFieldUserName.text = (NSString *)DefaultUserName;

    //密码
    textFieldPassWord = [contentView textFieldWithIndex:2];
    textFieldPassWord.text =(NSString *)DefaultPassWord;
    textFieldPassWord.delegate = self;
    textFieldPassWord.secureTextEntry = YES;
    
    
    textFieldYST.keyboardType = UIKeyboardTypeASCIICapable;

}

/**
 *  保存云视通到账号,备注这里的“abc” “123”都用不动，只是为了让她满足正则，主要方便本地添加设备
 */
- (void)saveDevice
{
    int result = [[JVCPredicateHelper shareInstance]addDevicePredicateYSTNUM:textFieldYST.text andUserName:textFieldUserName.text andPassWord:textFieldPassWord.text];
    
    if (ADDPREDICATE_SUCCESS == result) {
            
            [self resignADDDeviceTextFields];
            
            //判断是否超过最大值以及数据表中是否有这个设备
            int result = [[JVCDeviceSourceHelper shareDeviceSourceHelper] addDevicePredicateHaveYSTNUM:textFieldYST.text];
            
            if (ADDDEVICE_HAS_EXIST == result) {//存在
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_addDevice_has_Device")];
                
            }else if(ADDDEVICE_MAX_MUX == result)//超过最大值
            {
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_addDevice_has_Device_totalNum")];
                
            }else{//开始添加
                
                [self  addDeviceToAccount:textFieldYST.text.uppercaseString deviceUserName:textFieldUserName.text passWord:textFieldPassWord.text];
            }
        
    }else{
        
        [[JVCResultTipsHelper shareResultTipsHelper]showAddDevicePredicateAlert:result];
    }
    
}

/**
 *  添加设备，即先把设备绑定到自己的账号中，然后获取设备的详细信息
 *
 */
- (void)addDeviceToAccount:(NSString *)ystNum  deviceUserName:(NSString *) name  passWord:(NSString *)passWord
{
    [[JVCAlertHelper shareAlertHelper]alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        int resutl =  [[JVCDeviceHelper sharedDeviceLibrary] addDeviceToAccount:textFieldYST.text.uppercaseString userName:textFieldUserName.text password:textFieldPassWord.text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (ADDDEVICE_RESULT_SUCCESS == resutl) {//成功,获取设备的信息
                
                [self getNewAddDeviceInfo];
                
            }else{//失败
                
                [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_addDevice_add_error")];
            }
        });
    });
}

- (void)getNewAddDeviceInfo
{

    [[JVCDeviceSourceHelper shareDeviceSourceHelper] addLocalDeviceInfo:textFieldYST.text.uppercaseString deviceUserName:textFieldUserName.text devicePassWord:textFieldPassWord.text];

    [[JVCAlertHelper shareAlertHelper]alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *resutlDic =  [[JVCDeviceHelper sharedDeviceLibrary] getDeviceInfoByDeviceGuid:textFieldYST.text.uppercaseString ];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /**
             *  判断返回的字典是不是nil
             */
            if (![[JVCSystemUtility shareSystemUtilityInstance] judgeDictionIsNil:resutlDic] ) {
                DDLogInfo(@"===![[JVCSystemUtility shareSystemUtilityInstance] judgeDictionIsNil:resutlDic");
                /**
                 *  判断返回字典的rt字段是否为0
                 */
                if ( [[JVCSystemUtility shareSystemUtilityInstance] JudgeGetDictionIsLegal:resutlDic]) {//成功，把收到的字典转化为model类型
                    
                    /**
                     *  给的返回数据中没有云视通信息，所有要吧云视通号传过去
                     */
                  JVCDeviceModel *tempMode =   [[JVCDeviceSourceHelper shareDeviceSourceHelper] convertDeviceDictionToModelAndInsertDeviceList:resutlDic withYSTNUM:textFieldYST.text.uppercaseString];
                    
                    [tempMode retain];
                    
                    NSMutableArray *newModelList = [NSMutableArray arrayWithCapacity:10];
                    
                    [newModelList addObject:[[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceModelWithYstNumberConvertLocalCacheModel:tempMode.yunShiTongNum]];
                    
                    [[JVCLANScanWithSetHelpYSTNOHelper sharedJVCLANScanWithSetHelpYSTNOHelper] setDevicesHelper:newModelList];
                    
                    //从云视通服务器获取设备的通道数
                    [self getDeviceChannelNums:textFieldYST.text.uppercaseString];
                    [tempMode release];

                    
                }else{
                    
                    DDLogInfo(@"==error2=![[AddDeviceLogicMaths shareInstance] judgeDictionIsNil:deviceInfoMdic]");
                    
                    
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_addDevice_add_error")];
                    
                }
                
            }else{//空
                
                DDLogInfo(@"==error3=![[AddDeviceLogicMaths shareInstance] judgeDictionIsNil:deviceInfoMdic]");
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"adddevice_net_error")];

            }
        });
    });

}

/**
 *  重云视通获取设备的通道数
 *
 *  @param ystNumber 云视通
 */
- (void)getDeviceChannelNums:(NSString *)ystNumber
{
    
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int channelCount = [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] WanGetWithChannelCount:ystNumber nTimeOut:kAddDeviceWithWlanTimeOut];
        DDLogVerbose(@"ystServicDeviceChannel=%d",channelCount);
        
        channelCount = channelCount <= 0 ? DEFAULTCHANNELCOUNT : channelCount;
        
        nAddDeviceChanelCount = channelCount;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [self addDeviceChannelToServerWithNum:channelCount];
        });
        
    });
}

/**
 *  往服务器添加设备的通道
 */
- (void)addDeviceChannelToServerWithNum:(int )channelNum
{
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //把通道数添加到服务器
      int reusult =   [[JVCDeviceHelper sharedDeviceLibrary] addChannelToDevice:textFieldYST.text.uppercaseString addChannelCount:channelNum];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (ADDDEVICE_RESULT_SUCCESS !=reusult) {//失败
                
              //  [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"JDCSVC_GetDeviceChannel_Error")];
                [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
  
                [self showAddChannelAlert];
       
                
            }else{//成功后，获取设备的所有信息
            
                
                [self getChannelsDetailInfo];
            }

        });
        
    });
}

/**
 *  获取设备的通道的详细信息
 */
- (void)getChannelsDetailInfo
{
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *channelAllInfoMdic=[[JVCDeviceHelper sharedDeviceLibrary] getDeviceChannelListData:textFieldYST.text.uppercaseString];
        DDLogInfo(@"获取设备的所有通道信息=%@",channelAllInfoMdic);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /**
             *  判断返回的字典是不是nil
             */
            if (![[JVCSystemUtility shareSystemUtilityInstance] judgeDictionIsNil:channelAllInfoMdic]  ) {
                
                //把获取的设备通道信息的josn数据转换成model集合
                [[JVCChannelScourseHelper shareChannelScourseHelper] channelInfoMDicConvertChannelModelToMArrayPoint:channelAllInfoMdic deviceYstNumber:textFieldYST.text.uppercaseString];
                
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"adddevice_net_success")];
                if (addDeviceDelegate !=nil &&[addDeviceDelegate respondsToSelector:@selector(addDeviceSuccessCallBack)]) {
                    
                    [addDeviceDelegate addDeviceSuccessCallBack];
                }
                
                [self.navigationController popViewControllerAnimated:YES];

//                [self serachCloseFindDevice];
                
            }else{//空
                
             //   [self serachCloseFindDevice];JDCSVC_GetDeviceChannel_Error
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_adddevice_addChannel_error")];
                
            }
            

        });
        
    });
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setTextFieldStateNormal];
    [self setTextFieldStateSelect:textField];
    
    if (textField == textFieldPassWord) {
        
        [self addDeviceSlideUp];
    }
}

/**
 *  设置backGround的背景颜色
 */
- (void)setTextFieldStateNormal
{

    NSString *imagePath = [UIImage imageBundlePath:@"tex_field.png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    [textFieldYST setBackground:image];
    [textFieldUserName setBackground:image];
    [textFieldPassWord setBackground:image];
    [image release];
}

/**
 *  设置backGround的背景颜色
 */
- (void)setTextFieldStateSelect:(UITextField *)textField
{
    NSString *imagePath = [UIImage imageBundlePath:@"tex_field_sec.png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    [textField setBackground:image];
    [image release];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == textFieldUserName) {
        
        if(range.location>=KDeviceUserNameMaxLength)
            
            return NO;
    }else{
        
        if (range.location>=KDevicePassWordMaxLength) {
            
            return NO;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self addDeviceSlideDown];
    return YES;
}

/**
 *  向上滑动
 */
- (void)addDeviceSlideUp
{
    [UIView animateWithDuration:kADDDEVICEANIMATION animations:^{
    
        self.view.frame = CGRectMake(0, -kADDDEVICESLIDEHEIGIT, self.view.width, self.view.height);
    }];
}

/**
 *  变会正常的位置
 */
- (void)addDeviceSlideDown
{
    [UIView animateWithDuration:kADDDEVICEANIMATION animations:^{
        
       self.view.frame = CGRectMake(0, 0.0, self.view.width, self.view.height);
        
    }];
}

/**
 *  设置云视通textfield的文本
 */
- (void)YstTextFieldTextL:(NSString *)yunNum
{
    textFieldYST.text = yunNum;
}

/**
 *  注销键盘
 */
-(void)resignADDDeviceTextFields
{
    [textFieldYST       resignFirstResponder];
    [textFieldUserName  resignFirstResponder];
    [textFieldPassWord  resignFirstResponder];
    
    [self addDeviceSlideDown];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [contentView release];
    
    [super dealloc];
}

/**
 *  按钮按下的回调
 */
- (void)JVCLabelFieldBtnClickCallBack
{
    [self saveDevice];
}

/**
 *  背景被按下的回调
 */
- (void)touchUpInsiderBackGroundCallBack
{
    [self resignADDDeviceTextFields];
}

- (void)showAddChannelAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCALANGER(@"jvc_addDevicChannel_CountError") message:nil delegate:self  cancelButtonTitle:LOCALANGER(@"jvc_addDevicChannel_CountError_ok")  otherButtonTitles:LOCALANGER(@"jvc_addDevicChannel_CountError_Cancel") , nil];
    [alertView show];
    [alertView release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex  == 0) {//重新添加
        
        [self addDeviceChannelToServerWithNum:nAddDeviceChanelCount];

    }
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
