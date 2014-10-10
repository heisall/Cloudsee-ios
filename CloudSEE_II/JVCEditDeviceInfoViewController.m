//
//  JVCEditDeviceInfoViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/9/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCEditDeviceInfoViewController.h"
#import "JVCRGBHelper.h"
#import "JVCRGBColorMacro.h"
#import "JVCDeviceModel.h"
#import "JVCDeviceHelper.h"
#import "JVCPredicateHelper.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCResultTipsHelper.h"

static const int    ADDPREDICATE_SUCCESS        = 0;
static const int    TESTORIIGIN_Y               = 30;//距离navicationbar的距离
static const int    SEPERATE                    = 20;//控件之间的距离，纵向
static const int    ADDDEVICE_RESULT_SUCCESS    = 0;//成功
static const int    DEFAULTCHANNELCOUNT         = 4;//莫仍的通道数
static const int    DEFAULRESIGNTFONTSIZE       = 14;//默认的字体大小
static const int    DEFAULTLABELWITH            = 70;//textfield的lefitwiew对应的label的宽度
static const int    kADDDEVICESLIDEHEIGIT       = 100;//向上滑动的高度
static const NSTimeInterval kADDDEVICEANIMATION = 0.5f;//动画时间

static const int    DEVICE_SUCCESSS         = 0;    //删除设备成功

@interface JVCEditDeviceInfoViewController ()
{
    UITextField *deviceNickNameField;//昵称
    UITextField *devieUserName;//用户名
    UITextField *devicePassWord;//密码
    
    UIButton *btnSave;//保存的
    UIButton *btnDelegate;//删除的
}

@end

@implementation JVCEditDeviceInfoViewController
@synthesize deviceModel;
@synthesize deleteDelegate;
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
    self.title = @"编辑设备";
    
    UIControl *controlBg = [[UIControl alloc] initWithFrame:self.view.frame];
    [controlBg addTarget:self action:@selector(resignEditDeviceTextFields) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:controlBg];
    [controlBg release];
    
    UIColor *textColor = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroTextFontColor];
    
    
    //云视通号
    UIImage *imgTextFieldBG = [UIImage imageNamed:@"addDev_textFiedlBg.png"];
    deviceNickNameField = [[UITextField alloc] initWithFrame:CGRectMake((self.view.width- imgTextFieldBG.size.width)/2.0, TESTORIIGIN_Y, imgTextFieldBG.size.width, imgTextFieldBG.size.height)];
    deviceNickNameField.background = imgTextFieldBG;
    deviceNickNameField.textAlignment = UITextAlignmentRight;
    if (textColor) {
        deviceNickNameField.textColor = textColor;
    }
    deviceNickNameField.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:deviceNickNameField];
    UILabel *labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEFAULTLABELWITH, imgTextFieldBG.size.height)];
    labelLeft.backgroundColor = [UIColor clearColor];
    labelLeft.text = @"昵称";
    if (textColor) {
        labelLeft.textColor = textColor;
    }
    labelLeft.textAlignment = UITextAlignmentRight;
    labelLeft.font = [UIFont systemFontOfSize:DEFAULRESIGNTFONTSIZE];
    deviceNickNameField.leftViewMode = UITextFieldViewModeAlways;
    deviceNickNameField.leftView = labelLeft;
    [labelLeft release];
    UILabel *labelRight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, imgTextFieldBG.size.height)];
    labelRight.backgroundColor = [UIColor clearColor];
    deviceNickNameField.rightViewMode = UITextFieldViewModeAlways;
    deviceNickNameField.rightView = labelRight;
    deviceNickNameField.text = deviceModel.nickName;
    [deviceNickNameField becomeFirstResponder];
    [labelRight release];
    
    //用户名
    devieUserName = [[UITextField alloc] initWithFrame:CGRectMake((self.view.width- imgTextFieldBG.size.width)/2.0, deviceNickNameField.bottom+SEPERATE, deviceNickNameField.width, deviceNickNameField.height)];
    devieUserName.background = imgTextFieldBG;
    devieUserName.textAlignment = UITextAlignmentRight;
    if (textColor) {
        devieUserName.textColor = textColor;
    }
    devieUserName.text = (NSString *)DefaultUserName;
    devieUserName.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:devieUserName];
    UILabel *labelNameLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEFAULTLABELWITH, imgTextFieldBG.size.height)];
    labelNameLeft.backgroundColor = [UIColor clearColor];
    labelNameLeft.text = @"用户名";
    if (textColor) {
        labelNameLeft.textColor = textColor;
    }
    labelNameLeft.textAlignment = UITextAlignmentRight;
    labelNameLeft.font = [UIFont systemFontOfSize:DEFAULRESIGNTFONTSIZE];
    devieUserName.leftViewMode = UITextFieldViewModeAlways;
    devieUserName.leftView = labelNameLeft;
    [labelNameLeft release];
    UILabel *labelUserRight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, imgTextFieldBG.size.height)];
    labelUserRight.backgroundColor = [UIColor clearColor];
    devieUserName.rightViewMode = UITextFieldViewModeAlways;
    devieUserName.rightView = labelUserRight;
    devieUserName.text = deviceModel.userName;
    [labelUserRight release];
    
    //密码
    devicePassWord = [[UITextField alloc] initWithFrame:CGRectMake((self.view.width- imgTextFieldBG.size.width)/2.0, devieUserName.bottom+SEPERATE, devieUserName.width, devieUserName.height)];
    devicePassWord.background = imgTextFieldBG;
    devicePassWord.textAlignment = UITextAlignmentRight;
    devicePassWord.keyboardType = UIKeyboardTypeASCIICapable;
    devicePassWord.delegate = self;
    devicePassWord.text = (NSString *)DefaultPassWord;
    
    if (textColor) {
        
        devicePassWord.textColor = textColor;
    }
    devicePassWord.secureTextEntry = YES;
    [self.view addSubview:devicePassWord];
    UILabel *labelPassLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEFAULTLABELWITH, imgTextFieldBG.size.height)];
    labelPassLeft.backgroundColor = [UIColor clearColor];
    if (textColor) {
        
        labelPassLeft.textColor = textColor;
    }
    labelPassLeft.text = @"密码";
    labelPassLeft.textAlignment = UITextAlignmentRight;
    labelPassLeft.font = [UIFont systemFontOfSize:DEFAULRESIGNTFONTSIZE];
    devicePassWord.leftViewMode = UITextFieldViewModeAlways;
    devicePassWord.leftView = labelPassLeft;
    [labelPassLeft release];
    UILabel *labelPassRight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, imgTextFieldBG.size.height)];
    labelPassRight.backgroundColor = [UIColor clearColor];
    devicePassWord.rightViewMode = UITextFieldViewModeAlways;
    devicePassWord.rightView = labelPassRight;
    devicePassWord.text = deviceModel.passWord;
    [labelPassRight release];
    
    
    UIImage *imgBtnNor = [UIImage imageNamed:@"addDev_btnHor.png"];
    UIImage *imgBtnHor = [UIImage imageNamed:@"addDev_btnNor.png"];
    int seperate = (self.view.width -2*imgBtnNor.size.width)/3.0;
    //
    //高级按钮
    btnDelegate = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelegate.frame = CGRectMake(seperate, devicePassWord.bottom+SEPERATE, imgBtnNor.size.width, imgBtnNor.size.height);
    [btnDelegate setBackgroundImage:imgBtnNor forState:UIControlStateNormal];
    [btnDelegate setTitle:@"删除" forState:UIControlStateNormal];
    [btnDelegate addTarget:self action:@selector(deleteDevice) forControlEvents:UIControlEventTouchUpInside];
    [btnDelegate setBackgroundImage:imgBtnHor forState:UIControlStateHighlighted];
    [self.view addSubview:btnDelegate];
    
    //保存按钮
    btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame = CGRectMake(seperate+btnDelegate.right, btnDelegate.top, imgBtnNor.size.width, imgBtnNor.size.height);
    [btnSave setBackgroundImage:imgBtnNor forState:UIControlStateNormal];
    [btnSave setBackgroundImage:imgBtnHor forState:UIControlStateHighlighted];
    [btnSave setTitle:@"保存" forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(saveDeviceInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSave];

    
    
    
}

#pragma mark textfield的委托方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == devicePassWord) {
        [self editDeviceSlideUp];
    }
}

#pragma mark 删除设备的事件
- (void)deleteDevice
{
    [[JVCAlertHelper shareAlertHelper]alertShowToastOnWindow];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
      int result = [[JVCDeviceHelper sharedDeviceLibrary] deleteDeviceInAccount:[deviceModel.yunShiTongNum uppercaseString]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
            
            if (DEVICE_SUCCESSS == result ) {//成功后，把数据从本地列表中删除,返回
                
                [[JVCDeviceSourceHelper shareDeviceSourceHelper] deleteDevieWithModel:deviceModel];
                
                [[JVCAlertHelper shareAlertHelper]alertWithMessage:NSLocalizedString(@"delete_Success", nil)];
                
                if ([[JVCDeviceSourceHelper shareDeviceSourceHelper]deviceListArray].count == 0) {//判断设备列表中是否还有设备，如果没有
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];

                }else{
                
                    [self.navigationController popViewControllerAnimated:YES];

                }
                
                if (deleteDelegate !=nil && [deleteDelegate respondsToSelector:@selector(deleteDeviceInfoCallBack)]) {//删除设备的回调
                    [deleteDelegate deleteDeviceInfoCallBack];
                }
                
            }else{//失败
            
                [[JVCAlertHelper shareAlertHelper]alertWithMessage:NSLocalizedString(@"delete_Failt", nil)];

            }
        });
    
    });
    
}

/**
 *  保存设备信息
 */
- (void)saveDeviceInfo
{
    int reslutPredicat = [[JVCPredicateHelper shareInstance] modifyDevicePredicatWithNickName:deviceNickNameField.text andUserName:devieUserName.text andPassWord:devicePassWord.text];
    
    if (MODIFY_DEVIE_SUCCESS == reslutPredicat) {//成功
        
        [[JVCAlertHelper shareAlertHelper ]alertShowToastOnWindow];
        //调用修改方法
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            int result =   [[JVCDeviceHelper sharedDeviceLibrary] modifyDeviceConnectInfo:deviceModel.yunShiTongNum userName:devieUserName.text password:devicePassWord.text nickName:deviceNickNameField.text ];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [[JVCAlertHelper shareAlertHelper ]alertHidenToastOnWindow];

                if (DEVICE_SUCCESSS == result) {//修改成功
                    
                    deviceModel.nickName = deviceNickNameField.text;
                    deviceModel.userName = devieUserName.text;
                    deviceModel.passWord =  devicePassWord.text;

                    [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:NSLocalizedString(@"Edit_Success", nil)];
                    
                    [self.navigationController popViewControllerAnimated:YES];
  
                    
                }else{//修改不成功
                    
                    [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:NSLocalizedString(@"Edit_failt", nil)];


                }
            
            });
        
        });
        

        
    }else{//失败
        
        [[JVCResultTipsHelper shareResultTipsHelper]showModifyDeviceInfoResult:reslutPredicat];
    }

}

/**
 *  注销所有的textfield
 */
- (void)resignEditDeviceTextFields
{
    [self editDeviceSlideDown];
    
    [deviceNickNameField    resignFirstResponder];
    [devicePassWord         resignFirstResponder];
    [devieUserName          resignFirstResponder];
}

/**
 *  向上滑动
 */
- (void)editDeviceSlideUp
{
    [UIView animateWithDuration:kADDDEVICEANIMATION animations:^{
        
        self.view.frame = CGRectMake(0, -kADDDEVICESLIDEHEIGIT, self.view.width, self.view.height);
    }];
}

/**
 *  变会正常的位置
 */
- (void)editDeviceSlideDown
{
    [UIView animateWithDuration:kADDDEVICEANIMATION animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    }];
}

- (void)dealloc
{
    [deviceModel release];
    [super dealloc];
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