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
#import "JVCChannelScourseHelper.h"

static const int    ADDPREDICATE_SUCCESS        = 0;
static const int    TESTORIIGIN_Y               = 30;//距离navicationbar的距离
static const int    SEPERATE                    = 15;//控件之间的距离，纵向
static const int    ADDDEVICE_RESULT_SUCCESS    = 0;//成功
static const int    DEFAULTCHANNELCOUNT         = 4;//莫仍的通道数
static const int    DEFAULRESIGNTFONTSIZE       = 15;//默认的字体大小
static const int    DEFAULTLABELWITH            = 80;//textfield的lefitwiew对应的label的宽度
static const int    kADDDEVICESLIDEHEIGIT       = 100;//向上滑动的高度
static const NSTimeInterval kADDDEVICEANIMATION = 0.5f;//动画时间

static const int    DEVICE_SUCCESSS         = 0;    //删除设备成功
static const int    KLeftLabelWith          = 0;    //删除设备成功

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
    self.title = LOCALANGER(@"Jvc_editDeviceInfo_Title");
    
    UIControl *controlBg = [[UIControl alloc] initWithFrame:self.view.frame];
    [controlBg addTarget:self action:@selector(resignEditDeviceTextFields) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:controlBg];
    [controlBg release];
    
    UIColor *textColor = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroTextFontColor];
    
    
    //云视通号
    UIImage *imgTextFieldBG = [UIImage imageNamed:@"tex_field.png"];
    deviceNickNameField = [[UITextField alloc] initWithFrame:CGRectMake((self.view.width- imgTextFieldBG.size.width)/2.0, TESTORIIGIN_Y, imgTextFieldBG.size.width, imgTextFieldBG.size.height)];
    deviceNickNameField.background = imgTextFieldBG;
    deviceNickNameField.textAlignment = UITextAlignmentRight;
    if (textColor) {
        deviceNickNameField.textColor = textColor;
    }
    deviceNickNameField.contentVerticalAlignment  =  UIControlContentVerticalAlignmentCenter;
    deviceNickNameField.delegate = self;
    deviceNickNameField.contentVerticalAlignment  =  UIControlContentVerticalAlignmentCenter;

    [self.view addSubview:deviceNickNameField];
    UILabel *labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEFAULTLABELWITH, imgTextFieldBG.size.height)];
    labelLeft.backgroundColor = [UIColor clearColor];
    labelLeft.text = LOCALANGER(@"Jvc_editDeviceInfo_nickName");
    if (textColor) {
        labelLeft.textColor = textColor;
    }
    labelLeft.textAlignment = UITextAlignmentLeft;
    labelLeft.font = [UIFont systemFontOfSize:DEFAULRESIGNTFONTSIZE];
    deviceNickNameField.leftViewMode = UITextFieldViewModeAlways;
    deviceNickNameField.returnKeyType = UIReturnKeyDone;
    
    deviceNickNameField.delegate = self;
    deviceNickNameField.leftView = labelLeft;
    [labelLeft release];
    UILabel *labelRight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10.0f, imgTextFieldBG.size.height)];
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
    devieUserName.returnKeyType = UIReturnKeyDone;
    devieUserName.contentVerticalAlignment  =  UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:devieUserName];
    UILabel *labelNameLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEFAULTLABELWITH, imgTextFieldBG.size.height)];
    labelNameLeft.backgroundColor = [UIColor clearColor];
    labelNameLeft.text = LOCALANGER(@"Jvc_editDeviceInfo_userName");
    if (textColor) {
        labelNameLeft.textColor = textColor;
    }
    labelNameLeft.textAlignment = UITextAlignmentLeft;
    labelNameLeft.font = [UIFont systemFontOfSize:DEFAULRESIGNTFONTSIZE];
    devieUserName.leftViewMode = UITextFieldViewModeAlways;
    devieUserName.returnKeyType = UIReturnKeyDone;
    devieUserName.delegate = self;
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
    devicePassWord.returnKeyType = UIReturnKeyDone;
    devicePassWord.contentVerticalAlignment  =  UIControlContentVerticalAlignmentCenter;
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
    labelPassLeft.text =LOCALANGER(@"Jvc_editDeviceInfo_PW") ;
    labelPassLeft.textAlignment = UITextAlignmentLeft;
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
    [btnDelegate setTitle:LOCALANGER(@"Jvc_editDeviceInfo_Delete") forState:UIControlStateNormal];
    [btnDelegate addTarget:self action:@selector(deleteDevice) forControlEvents:UIControlEventTouchUpInside];
    [btnDelegate setBackgroundImage:imgBtnHor forState:UIControlStateHighlighted];
    [self.view addSubview:btnDelegate];
    
    //保存按钮
    btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame = CGRectMake(seperate+btnDelegate.right, btnDelegate.top, imgBtnNor.size.width, imgBtnNor.size.height);
    [btnSave setBackgroundImage:imgBtnNor forState:UIControlStateNormal];
    [btnSave setBackgroundImage:imgBtnHor forState:UIControlStateHighlighted];
    [btnSave setTitle:LOCALANGER(@"Jvc_editDeviceInfo_Save") forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(saveDeviceInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSave];

    
    
    
}

#pragma mark textfield的委托方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setTextFieldStateNormal];
    [self setTextFieldStateSelect:textField];
    if (textField == devicePassWord) {
        [self editDeviceSlideUp];
    }
}

/**
 *  设置backGround的背景颜色
 */
- (void)setTextFieldStateNormal
{
    NSString *imagePath = [UIImage imageBundlePath:@"tex_field.png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    [devieUserName setBackground:image];
    [deviceNickNameField setBackground:image];
    [devicePassWord setBackground:image];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == devicePassWord) {
        
        [self editDeviceSlideDown];
    }
    return YES;
}

#pragma mark 删除设备的事件
- (void)deleteDevice
{
    [[JVCAlertHelper shareAlertHelper]alertShowToastOnWindow];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
      int result = [[JVCDeviceHelper sharedDeviceLibrary] deleteDeviceInAccount:[deviceModel.yunShiTongNum uppercaseString]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
            
            [self handeleDeleteDeviceRusult:result];
        });
    
    });
    
}

/**
 *  处理设备删除返回值的方法
 *
 *  @param result 返回值
 */
- (void)handeleDeleteDeviceRusult:(int )result
{
    if (DEVICE_SUCCESSS == result ) {//成功后，把数据从本地列表中删除,返回
        
        [[JVCChannelScourseHelper shareChannelScourseHelper]deleteChannelsWithDeviceYstNumber:deviceModel.yunShiTongNum];

        [[JVCDeviceSourceHelper shareDeviceSourceHelper] deleteDevieWithModel:deviceModel];
        
        [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:NSLocalizedString(@"delete_Success", nil)];
        
        if (deleteDelegate !=nil && [deleteDelegate respondsToSelector:@selector(deleteDeviceInfoCallBack)]) {//删除设备的回调
           
            [self.deleteDelegate deleteDeviceInfoCallBack];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
            

        
    }else{//失败
        
        [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:NSLocalizedString(@"delete_Failt", nil)];
        
    }
}
/**
 *  保存设备信息
 */
- (void)saveDeviceInfo
{
    int reslutPredicat = [[JVCPredicateHelper shareInstance] modifyDevicePredicatWithNickName:deviceNickNameField.text andUserName:devieUserName.text andPassWord:devicePassWord.text];
    
    if (MODIFY_DEVIE_SUCCESS == reslutPredicat) {//成功
    
        [self editDeviceInfoPredicateSuccess:deviceNickNameField.text userName:devieUserName.text passWord:devicePassWord.text  ];
        
    }else{//失败
        
        [[JVCResultTipsHelper shareResultTipsHelper]showModifyDeviceInfoResult:reslutPredicat];
    }

}

/**
 *  正则判断成功后，调用修改方法
 */
- (void)editDeviceInfoPredicateSuccess:(NSString *)nickName  userName:(NSString *)userName  passWord:(NSString *)password
{
    [[JVCAlertHelper shareAlertHelper ]alertShowToastOnWindow];
    //调用修改方法
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int result =   [[JVCDeviceHelper sharedDeviceLibrary] modifyDeviceConnectInfo:deviceModel.yunShiTongNum userName:devieUserName.text password:devicePassWord.text nickName:deviceNickNameField.text ];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[JVCAlertHelper shareAlertHelper ]alertHidenToastOnWindow];
            
            [self handelModifyDeviceInfoResult:result];
            
        });
        
    });
}

/**
 *  处理修改设备信息返回值的方法
 *
 *  @param result 返回值
 */
- (void)handelModifyDeviceInfoResult:(int )result
{
    if (DEVICE_SUCCESSS == result) {//修改成功
        
        deviceModel.nickName = deviceNickNameField.text;
        deviceModel.userName = devieUserName.text;
        deviceModel.passWord =  devicePassWord.text;
        
        [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:NSLocalizedString(@"edit_success", nil)];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }else{//修改不成功
        
        [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:NSLocalizedString(@"edit_falt", nil)];
        
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
