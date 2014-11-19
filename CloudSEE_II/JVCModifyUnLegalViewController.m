//
//  JVCModifyUnLegalViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/11/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCModifyUnLegalViewController.h"
#import "JVCPredicateHelper.h"
#import "JVCResultTipsHelper.h"
#import "JVCAccountMacro.h"
#import "JVCRGBHelper.h"
#import "JVCAccountHelper.h"
#import "JVCDataBaseHelper.h"
#import "JVCDataBaseHelper.h"
#import "JVCLogHelper.h"

@interface JVCModifyUnLegalViewController ()
{
    
    UITextField *userTextField;//用户名
    UILabel     *userLabel;
    UITextField *passWordField;//密码
    UILabel     *passWordLabel;

}

@end

@implementation JVCModifyUnLegalViewController
@synthesize delegate;

static const int  kSuccessModifyUserLegat = 0;//收到的消息正确
static const float KLabelOriginX    = 20;//距离左侧的距离
static const float KLabelOriginY    = 40;//距离顶端的距离
static const float KLabelWith       = 60;//距离顶端的距离
static const float KSpan            = 20;//label之间的距离
static const float KLabelFieldSpan  = 5;//label与textfield之间的距离
static const float KLabelLeftWith   = 10;//textfield左侧的leftview宽度
static const int   KlabelFont       = 14;//labbel的字体大小
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    DDLogVerbose(@"=====%s",__FUNCTION__);
    [userTextField  release];
    [userLabel      release];
    [passWordField  release];
    [passWordLabel  release];
    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self resignTextFields];
    
    [super viewDidDisappear:animated];
}


- (void)BackClick
{
    //并且把秘密置换成功
    [[JVCDataBaseHelper shareDataBaseHelper] updateUserAutoLoginStateWithUserName:kkUserName loginState:kLoginStateOFF];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = LOCALANGER(@"jvc_Unmod_titile");
    
    self.navigationController.navigationBarHidden = NO;
    
    JVCRGBHelper *rgbLabelHelper      = [JVCRGBHelper shareJVCRGBHelper];
    UIColor *labColor  = [rgbLabelHelper rgbColorForKey:kJVCRGBColorMacroLoginGray];
    
    NSString *strImage = [UIImage imageBundlePath:@"con_fieldUnSec.png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:strImage];
    
    UILabel *LabelTitleUser = [[UILabel alloc] initWithFrame: CGRectMake(KLabelOriginX, KLabelOriginY, KLabelWith, image.size.height)];
    LabelTitleUser.text = LOCALANGER(@"jvc_Unmod_user");
    LabelTitleUser.backgroundColor = [UIColor clearColor];
    LabelTitleUser.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:LabelTitleUser];
    if (labColor) {
        LabelTitleUser.textColor = labColor;
    }
    [LabelTitleUser release];
    
    UILabel *labelLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KLabelFieldSpan, image.size.height)];
    labelLeftView.backgroundColor = [UIColor clearColor];
    userTextField = [[UITextField alloc] initWithFrame:CGRectMake(LabelTitleUser.right+KLabelFieldSpan, LabelTitleUser.top, image.size.width, image.size.height)];
    userTextField.backgroundColor = [UIColor colorWithPatternImage:image];
    userTextField.leftViewMode = UITextFieldViewModeAlways;
    userTextField.keyboardType = UIKeyboardTypeASCIICapable;
    userTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    userTextField.returnKeyType = UIReturnKeyDone;
    if (labColor) {
        userTextField.textColor = labColor;
    }
    userTextField.leftView = labelLeftView;
    [labelLeftView release];
    [self.view addSubview:userTextField];
    

    
    userLabel = [[UILabel alloc] initWithFrame:CGRectMake(KLabelOriginX, userTextField.bottom, self.view.width - 2*KLabelOriginX, KSpan)];
    userLabel.font = [UIFont systemFontOfSize:KlabelFont];
    if (labColor) {
        userTextField.textColor = labColor;
    }
    userLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:userLabel];
    
    UILabel *LabelTitlePW = [[UILabel alloc] initWithFrame: CGRectMake(KLabelOriginX, userTextField.bottom+KSpan, KLabelWith, image.size.height)];
    LabelTitlePW.text = LOCALANGER(@"jvc_Unmod_pw");
    LabelTitlePW.backgroundColor = [UIColor clearColor];
    LabelTitlePW.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:LabelTitlePW];
    if (labColor) {
        LabelTitlePW.textColor = labColor;
    }
    [LabelTitlePW release];
    
    UILabel *labelLeftViewPW = [[UILabel alloc] initWithFrame:CGRectMake(0,0, KLabelLeftWith, image.size.height)];
    labelLeftViewPW.backgroundColor = [UIColor clearColor];
    passWordField = [[UITextField alloc] initWithFrame:CGRectMake(LabelTitlePW.right+KLabelFieldSpan, LabelTitlePW.top, image.size.width, image.size.height)];
    passWordField.backgroundColor = [UIColor colorWithPatternImage:image];
    passWordField.leftViewMode = UITextFieldViewModeAlways;
    passWordField.keyboardType = UIKeyboardTypeASCIICapable;
    passWordField.returnKeyType = UIReturnKeyDone;
    passWordField.leftView = labelLeftViewPW;
    [labelLeftViewPW release];
    [self.view addSubview:passWordField];

    passWordLabel = [[UILabel alloc] initWithFrame:CGRectMake(KLabelOriginX, LabelTitlePW.top, self.view.width - 2*KLabelOriginX, KSpan)];
    passWordLabel.font = [UIFont systemFontOfSize:KlabelFont];
    passWordLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:passWordLabel];
    
    NSString *btnPath = [UIImage imageBundlePath:@"con_Btn.png"];
    UIImage *imagebtn = [[UIImage alloc] initWithContentsOfFile:btnPath];
    UIButton *btnClick = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClick.frame = CGRectMake(userTextField.left, passWordField.bottom+KSpan, userTextField.size.width, imagebtn.size.height);
    [btnClick setTitle:LOCALANGER(@"jvc_Unmod_btntit") forState:UIControlStateNormal];
    [btnClick setBackgroundImage:imagebtn forState:UIControlStateNormal];
    [btnClick addTarget:self action:@selector(modifyUnlegatUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClick];
    [image release];
    [imagebtn release];

    userTextField.delegate = self;
    passWordField.delegate = self;
    passWordField.secureTextEntry = YES;
    
}

/**
 *  按钮按下
 */
- (void)modifyUnlegatUserInfo
{
    int resultValue = [[JVCPredicateHelper shareInstance] predicatUserName:userTextField.text PassWord:passWordField.text];
    if (resultValue == kSuccessModifyUserLegat) {//合法
        
        [[JVCAlertHelper shareAlertHelper]alertShowToastOnWindow];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            int exitResult = [[JVCAccountHelper sharedJVCAccountHelper] ResetUserNameAndPassword:userTextField.text newPassword:passWordField.text];
            
            [[JVCLogHelper shareJVCLogHelper] writeDataToFile:[NSString stringWithFormat:@"%s==%d",__FUNCTION__,exitResult] fileType:LogType_LoginManagerLogPath];

            dispatch_async(dispatch_get_main_queue(),^{
                
                [[JVCAlertHelper shareAlertHelper]alertHidenToastOnWindow];
                
                [self handleJudgeUserNameHsaResignResult:exitResult];
            });
            
        });

        
    }else{
    
        [[JVCResultTipsHelper shareResultTipsHelper] showLoginPredacateAlertWithResult:resultValue];
    }

}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length==0) {
        return;
    }
    
    if (textField == userTextField) {
        
        userLabel.text = @"";
        
        int resultValue = [[JVCPredicateHelper shareInstance] predicateUserNameIslegal:userTextField.text];
        
        if (resultValue == kSuccessModifyUserLegat) {//合法
            
            [self judgeUserNameHasResign];
            
        }else{
            
            if (VALIDATIONUSERNAMETYPE_S != resultValue) {
                
                NSString *_strTitle = nil;
                switch (resultValue) {
                        
                    case VALIDATIONUSERNAMETYPE_LENGTH_E:
                        _strTitle =LOCALANGER(@"loginResign_LENGTH_E");
                        break;
                    case VALIDATIONUSERNAMETYPE_NUMBER_E:
                        _strTitle =LOCALANGER(@"loginResign_NUMBER_E");
                        break;
                    case VALIDATIONUSERNAMETYPE_OTHER_E:
                        _strTitle =LOCALANGER(@"loginResign_OTHER_E");
                        break;
                        
                    default:
                        break;
                }
                [self setUserLabelRed:userLabel];
                userLabel.text =_strTitle;
            }
        }
    }else{
        BOOL bStatePassWord = [[JVCPredicateHelper shareInstance] PredicateResignPasswordIslegal:passWordField.text];
        
        if (!bStatePassWord) {//失败
            [self setUserLabelRed:passWordLabel];
            passWordLabel.text = LOCALANGER(@"loginResign_passWord_error");//LOGINRESULT_PASSWORLD_ERROR
            
        }else{
            [self setUserLabelBlue:passWordLabel];
            passWordLabel.text =@"";
        }

    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == userTextField) {
        
        if(range.location>=KUserNameMaxLength)
            
            return NO;
    }else{
        
        if (range.location>=KPassWordMaxLength) {
            
            return NO;
        }
    }
    return YES;
}

/**
 *  判断用户名是否被注册过
 */
- (void)judgeUserNameHasResign
{
    [[JVCAlertHelper shareAlertHelper]alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int exitResult = [[JVCAccountHelper sharedJVCAccountHelper] IsUserExist:userTextField.text];
        
        DDLogInfo(@"再这里就行了修改，回头要去掉==exitResult= 0;");
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            [[JVCAlertHelper shareAlertHelper]alertHidenToastOnWindow];

            [self handleJudgeUserNameHsaResign:exitResult];
        });
        
    });
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

/**
 *  根据返回的数据处理结果
 *
 *  @param tType 注册的返回结果信息
 */
- (void)handleJudgeUserNameHsaResignResult:(int )tType
{
    if (tType == SUCCESS) {//成功
        [self modifyUnLegalUserInfoSeccess];
    }else{
        
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_Unmod_resultError")];
    }
}

- (void)modifyUnLegalUserInfoSeccess
{
    JVCDataBaseHelper *fmdbHelp =  [JVCDataBaseHelper shareDataBaseHelper] ;
    [fmdbHelp writeUserInfoToDataBaseWithUserName:userTextField.text passWord:passWordField.text];
    
    kkUserName = userTextField.text.lowercaseString;
    kkPassword = passWordField.text.lowercaseString;
    
    if(delegate !=nil && [delegate respondsToSelector:@selector(modifyUserAndPWSuccessCallBack)])
    {
        [delegate modifyUserAndPWSuccessCallBack];
        
        [self.navigationController popViewControllerAnimated:NO];
    }
}

/**
 *  根据返回的数据处理结果
 *
 *  @param tType 注册的返回结果信息
 */
- (void)handleJudgeUserNameHsaResign:(int )tType
{
    if (tType == USER_HAS_EXIST) {
        
        [self setUserLabelRed:userLabel];
        
        userLabel.text = LOCALANGER(@"home_login_resign_user_exit");
        
    }else if(tType == USER_NOT_EXIST){
        
        [self setUserLabelBlue:userLabel];
        userLabel.text = LOCALANGER(@"home_login_resign_user_noFound");
    }else if(tType == PHONE_NUM_ERROR){
        
        [self setUserLabelRed:userLabel];
        userLabel.text = LOCALANGER(@"home_login_resign_PhoneNum_error");
    }
    
}

- (void)deallocWithViewDidDisappear
{
    [super deallocWithViewDidDisappear];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 设置lable的颜色值为红色
- (void)setUserLabelRed:(UILabel *)label
{
    UIColor *redColor  = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroRed];
    
    if (redColor) {
        
        label.textColor = redColor;
    }
}

#pragma mark 设置lable的颜色值为蓝色
- (void)setUserLabelBlue:(UILabel *)label
{
    UIColor *redColor  = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroBlue];
    
    if (redColor) {
        
        label.textColor = redColor;
    }
}

- (void)resignTextFields
{
    [userTextField  resignFirstResponder];
    [passWordField  resignFirstResponder];
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
