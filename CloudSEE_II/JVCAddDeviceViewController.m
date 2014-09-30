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
#import "JVCSystemUtility.h"
#import "JVCChannelScourseHelper.h"
#import "JVCAPConfigPreparaViewController.h"



static const int    ADDPREDICATE_SUCCESS        = 0;
static const int    TESTORIIGIN_Y               = 30;//距离navicationbar的距离
static const int    SEPERATE                    = 20;//控件之间的距离，纵向
static const int    ADDDEVICE_RESULT_SUCCESS    = 0;//成功
static const int    DEFAULTCHANNELCOUNT         = 4;//莫仍的通道数
static const int    DEFAULRESIGNTFONTSIZE       = 14;//默认的字体大小
static const int    DEFAULTLABELWITH            = 70;//textfield的lefitwiew对应的label的宽度
static const int    kADDDEVICESLIDEHEIGIT       = 100;//向上滑动的高度
static const NSTimeInterval kADDDEVICEANIMATION = 0.5f;//动画时间




@interface JVCAddDeviceViewController ()
{
    UITextField *textFieldYST;//云视通
    
    UITextField *textFieldUserName;//用户名
    
    UITextField *textFieldPassWord;//密码
    
    UIButton *btnSave;//保存按钮
    
    UIButton *btnAdvace;//高级按钮
    
    UIButton *btnAP;//Ap按钮
    
    BOOL isShowUSerAndPW;//旋转的标志
    
    CGRect rectRectFrame;//原始的数据


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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加设备";

    rectRectFrame = self.view.frame;
    
    /**
     *  设置背景为白色
     */
//    JVCRGBHelper *rgbHelper = [JVCRGBHelper shareJVCRGBHelper];
//    
//    if ([rgbHelper rgbColorForKey:kJVCRGBColorMacroEditTopToolBarBackgroundColor]) {
//        
//        self.view.backgroundColor = [rgbHelper rgbColorForKey:kJVCRGBColorMacroWhite];
//    }
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UIControl *controlBg = [[UIControl alloc] initWithFrame:self.view.frame];
    [controlBg addTarget:self action:@selector(resignADDDeviceTextFields) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:controlBg];
    [controlBg release];
        
   //云视通号
    UIImage *imgTextFieldBG = [UIImage imageNamed:@"addDev_textFiedlBg.png"];
    textFieldYST = [[UITextField alloc] initWithFrame:CGRectMake((self.view.width- imgTextFieldBG.size.width)/2.0, TESTORIIGIN_Y, imgTextFieldBG.size.width, imgTextFieldBG.size.height)];
    textFieldYST.background = imgTextFieldBG;
    textFieldYST.textAlignment = UITextAlignmentRight;
    textFieldYST.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:textFieldYST];
    UILabel *labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEFAULTLABELWITH, imgTextFieldBG.size.height)];
    labelLeft.backgroundColor = [UIColor clearColor];
    labelLeft.text = @"云视通号";
    labelLeft.textAlignment = UITextAlignmentRight;
    labelLeft.font = [UIFont systemFontOfSize:DEFAULRESIGNTFONTSIZE];
    textFieldYST.leftViewMode = UITextFieldViewModeAlways;
    textFieldYST.leftView = labelLeft;
    [labelLeft release];
    UILabel *labelRight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, imgTextFieldBG.size.height)];
    labelRight.backgroundColor = [UIColor clearColor];
    textFieldYST.rightViewMode = UITextFieldViewModeAlways;
    textFieldYST.rightView = labelRight;
    [labelRight release];

    UIImage *imgBtnNor = [UIImage imageNamed:@"addDev_btnHor.png"];
    UIImage *imgBtnHor = [UIImage imageNamed:@"addDev_btnNor.png"];
    int seperate = (self.view.width -2*imgBtnNor.size.width)/3.0;
    //高级按钮
    btnAdvace = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdvace.frame = CGRectMake(seperate, textFieldYST.bottom+SEPERATE, imgBtnNor.size.width, imgBtnNor.size.height);
    [btnAdvace setBackgroundImage:imgBtnNor forState:UIControlStateNormal];
    [btnAdvace setTitle:@"高级" forState:UIControlStateNormal];
    [btnAdvace addTarget:self action:@selector(showUserAndPW) forControlEvents:UIControlEventTouchUpInside];
    [btnAdvace setBackgroundImage:imgBtnHor forState:UIControlStateHighlighted];
    [self.view addSubview:btnAdvace];
    
    //保存按钮
    btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame = CGRectMake(btnAdvace.right+seperate, btnAdvace.top, imgBtnNor.size.width, imgBtnNor.size.height);
    [btnSave setBackgroundImage:imgBtnNor forState:UIControlStateNormal];
    [btnSave setBackgroundImage:imgBtnHor forState:UIControlStateHighlighted];
    [btnSave setTitle:@"保存" forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(saveDevice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSave];
    
    //ap按钮
    btnAP = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAP.frame = CGRectMake(btnAdvace.left, btnAdvace.bottom+SEPERATE, self.view.width - 2*seperate, btnSave.frame.size.height);
    [btnAP setBackgroundImage:imgBtnNor forState:UIControlStateNormal];
    [btnAP setBackgroundImage:imgBtnHor forState:UIControlStateHighlighted];
    [btnAP setTitle:@"添加无线设备" forState:UIControlStateNormal];
    [btnAP addTarget:self action:@selector(AddWlanDevice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAP];
    
    //用户名
    textFieldUserName = [[UITextField alloc] initWithFrame:CGRectMake((self.view.width- imgTextFieldBG.size.width)/2.0, textFieldYST.bottom+SEPERATE, textFieldYST.width, textFieldYST.height)];
    textFieldUserName.background = imgTextFieldBG;
    textFieldUserName.textAlignment = UITextAlignmentRight;
    textFieldUserName.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:textFieldUserName];
    UILabel *labelNameLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEFAULTLABELWITH, imgTextFieldBG.size.height)];
    labelNameLeft.backgroundColor = [UIColor clearColor];
    labelNameLeft.text = @"用户名";
    labelNameLeft.textAlignment = UITextAlignmentRight;
    labelNameLeft.font = [UIFont systemFontOfSize:DEFAULRESIGNTFONTSIZE];
    textFieldUserName.leftViewMode = UITextFieldViewModeAlways;
    textFieldUserName.leftView = labelNameLeft;
    [labelNameLeft release];
    UILabel *labelUserRight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, imgTextFieldBG.size.height)];
    labelUserRight.backgroundColor = [UIColor clearColor];
    textFieldUserName.rightViewMode = UITextFieldViewModeAlways;
    textFieldUserName.rightView = labelUserRight;
    [labelUserRight release];
    textFieldUserName.hidden = YES;
    
    //密码
    textFieldPassWord = [[UITextField alloc] initWithFrame:CGRectMake((self.view.width- imgTextFieldBG.size.width)/2.0, textFieldUserName.bottom+SEPERATE, textFieldYST.width, textFieldYST.height)];
    textFieldPassWord.background = imgTextFieldBG;
    textFieldPassWord.textAlignment = UITextAlignmentRight;
    textFieldPassWord.keyboardType = UIKeyboardTypeASCIICapable;
    textFieldPassWord.delegate = self;
    textFieldPassWord.secureTextEntry = YES;
    [self.view addSubview:textFieldPassWord];
    UILabel *labelPassLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEFAULTLABELWITH, imgTextFieldBG.size.height)];
    labelPassLeft.backgroundColor = [UIColor clearColor];
    labelPassLeft.text = @"密码";
    labelPassLeft.textAlignment = UITextAlignmentRight;
    labelPassLeft.font = [UIFont systemFontOfSize:DEFAULRESIGNTFONTSIZE];
    textFieldPassWord.leftViewMode = UITextFieldViewModeAlways;
    textFieldPassWord.leftView = labelPassLeft;
    [labelPassLeft release];
    UILabel *labelPassRight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, imgTextFieldBG.size.height)];
    labelPassRight.backgroundColor = [UIColor clearColor];
    textFieldPassWord.rightViewMode = UITextFieldViewModeAlways;
    textFieldPassWord.rightView = labelPassRight;
    [labelPassRight release];
    textFieldPassWord.hidden = YES;


}

- (void)showUserAndPW
{
    isShowUSerAndPW =!isShowUSerAndPW;
    CATransition  *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.type = @"rippleEffect";
    //  animation.subtype = kCATransitionFromRight;
    
    [self showNameAndPw];
    [self.view.layer addAnimation:animation forKey:nil];
    
}

- (void)showNameAndPw
{
    UIImage *tImageBG = [UIImage imageNamed:@"addDev_textFiedlBg.png"];
    if (isShowUSerAndPW) {
        CGRect rectFrame =btnAdvace.frame;
        rectFrame.origin.y +=2*(SEPERATE+tImageBG.size.height);
        btnAdvace.frame = rectFrame;
        
        CGRect rectFrameSave =btnSave.frame;
        rectFrameSave.origin.y +=2*(SEPERATE+tImageBG.size.height);
        btnSave.frame = rectFrameSave;
        
        textFieldPassWord.hidden = NO;
        textFieldUserName.hidden = NO;
        [btnAdvace setTitle:LOCALANGER(@"返回") forState:UIControlStateNormal];
        btnAP.frame = CGRectMake(textFieldYST.frame.origin.x,btnAdvace.frame.origin.y+SEPERATE+btnAdvace.frame.size.height, textFieldYST.frame.size.width, btnAP.height);
    }else{
        CGRect rectFrame =btnAdvace.frame;
        rectFrame.origin.y -=2*(SEPERATE+tImageBG.size.height);
        btnAdvace.frame = rectFrame;
        
        CGRect rectFrameSave =btnSave.frame;
        rectFrameSave.origin.y -=2*(SEPERATE+tImageBG.size.height);
        btnSave.frame = rectFrameSave;
        [btnAdvace setTitle:LOCALANGER(@"高级") forState:UIControlStateNormal];
        
        textFieldPassWord.hidden = YES;
        textFieldUserName.hidden = YES;
        btnAP.frame = CGRectMake(textFieldYST.frame.origin.x,btnAdvace.frame.origin.y+SEPERATE+btnAdvace.frame.size.height, textFieldYST.frame.size.width, btnAP.height);
        
    }
    
    
}

- (void)AddWlanDevice
{
    JVCAPConfigPreparaViewController *configViewController = [[JVCAPConfigPreparaViewController alloc] init];
    [self.navigationController pushViewController:configViewController animated:YES];
    [configViewController release];
}
/**
 *  保存云视通到账号,备注这里的“abc” “123”都用不动，只是为了让她满足正则，主要方便本地添加设备
 */
- (void)saveDevice
{
    int result = [[JVCPredicateHelper shareInstance]addDeviceToAccountPredicateYSTNUM:textFieldYST.text ];
    
    if (ADDPREDICATE_SUCCESS == result) {//成功
        
        [self resignADDDeviceTextFields];
        
        //判断是否超过最大值以及数据表中是否有这个设备
        int result = [[JVCDeviceSourceHelper shareDeviceSourceHelper] addDevicePredicateHaveYSTNUM:textFieldYST.text];

        if (ADDDEVICE_HAS_EXIST == result) {//存在
            
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"设备列表中已存在"];

        }else if(ADDDEVICE_MAX_MUX == result)//超过最大值
        {
        
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"超过最大值"];

        }else{//开始添加
        
            [self  addDeviceToAccount];
        }

        
    }else
    {
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"云视通不合法"];
    }
}

/**
 *  添加设备，即先把设备绑定到自己的账号中，然后获取设备的详细信息
 *
 */
- (void)addDeviceToAccount
{
    [[JVCAlertHelper shareAlertHelper]alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        int resutl =  [[JVCDeviceHelper sharedDeviceLibrary] addDeviceToAccount:textFieldYST.text userName:textFieldUserName.text password:textFieldPassWord.text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

            
            if (ADDDEVICE_RESULT_SUCCESS == resutl) {//成功,获取设备的信息
                
                [self getNewAddDeviceInfo];
                
            }else{//失败
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"添加失败")];
            }
        });
    });
}

- (void)getNewAddDeviceInfo
{
    [[JVCAlertHelper shareAlertHelper]alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *resutlDic =  [[JVCDeviceHelper sharedDeviceLibrary] getDeviceInfoByDeviceGuid:textFieldYST.text ];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
    
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
                    
                  JVCDeviceModel *tempMode =   [[JVCDeviceSourceHelper shareDeviceSourceHelper] convertDeviceDictionToModelAndInsertDeviceList:resutlDic withYSTNUM:textFieldYST.text];
                    
                    [tempMode retain];
                    
                    //从云视通服务器获取设备的通道数
                    [self getDeviceChannelNums:textFieldYST.text];
                    [tempMode release];
                    
                }else{
                    
                    DDLogInfo(@"==error2=![[AddDeviceLogicMaths shareInstance] judgeDictionIsNil:deviceInfoMdic]");
                    
                    
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"adddevice_error")];
                    
                }
                
            }else{//空
                
                DDLogInfo(@"==error3=![[AddDeviceLogicMaths shareInstance] judgeDictionIsNil:deviceInfoMdic]");
                
                [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
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
    int i;
    
    for (i=0; i<ystNumber.length; i++) {
        
        unsigned char c=[ystNumber characterAtIndex:i];
        if (c<='9' && c>='0') {
            
            break;
        }
    }
    
    NSString *sGroup=[ystNumber substringToIndex:i];
    NSString *iYstNum=[ystNumber substringFromIndex:i];
    
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //从服务器获取设备的通道数
       //int channelCount =JVC_WANGetChannelCount([sGroup UTF8String],[iYstNum intValue],5);
        int channelCount = 4;
        DDLogVerbose(@"ystServicDeviceChannel=%d",channelCount);
        
        if (channelCount<=0) {
            
            channelCount=DEFAULTCHANNELCOUNT;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
            
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
      int reusult =   [[JVCDeviceHelper sharedDeviceLibrary] addChannelToDevice:textFieldYST.text addChannelCount:channelNum];

        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (ADDDEVICE_RESULT_SUCCESS !=reusult) {//失败
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"adddevice_net_error")];

                
            }else{//成功后，获取设备的所有信息
            
                [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
                
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
        
        NSDictionary *channelAllInfoMdic=[[JVCDeviceHelper sharedDeviceLibrary] getDeviceChannelListData:textFieldYST.text];
        DDLogInfo(@"获取设备的所有通道信息=%@",channelAllInfoMdic);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

            /**
             *  判断返回的字典是不是nil
             */
            if (![[JVCSystemUtility shareSystemUtilityInstance] judgeDictionIsNil:channelAllInfoMdic]  ) {
                
                //把获取的设备通道信息的josn数据转换成model集合
                [[JVCChannelScourseHelper shareChannelScourseHelper] channelInfoMDicConvertChannelModelToMArrayPoint:channelAllInfoMdic deviceYstNumber:textFieldYST.text];
                
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"添加设备成功")];
                if (addDeviceDelegate !=nil &&[addDeviceDelegate respondsToSelector:@selector(addDeviceSuccessCallBack)]) {
                    
                    [addDeviceDelegate addDeviceSuccessCallBack];
                }
                
                [self.navigationController popViewControllerAnimated:YES];

//                [self serachCloseFindDevice];
                
            }else{//空
                
             //   [self serachCloseFindDevice];
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"通道为空")];

            }
            

        });
        
    });
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == textFieldPassWord) {
        
        [self addDeviceSlideUp];
    }
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
        DDLogVerbose(@"%@",NSStringFromCGRect(rectRectFrame));
        self.view.frame = rectRectFrame;
    }];
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
