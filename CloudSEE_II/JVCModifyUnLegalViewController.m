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
    
    self.title = @"重置信息";
    
    self.navigationController.navigationBarHidden = NO;
    
    NSString *strImage = [UIImage imageBundlePath:@"con_fieldUnSec.png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:strImage];
    
    UILabel *LabelTitleUser = [[UILabel alloc] initWithFrame: CGRectMake(KLabelOriginX, KLabelOriginY, KLabelWith, image.size.height)];
    LabelTitleUser.text = @"用户名";
    LabelTitleUser.backgroundColor = [UIColor clearColor];
    LabelTitleUser.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:LabelTitleUser];
    [LabelTitleUser release];
    
    UILabel *labelLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KLabelFieldSpan, image.size.height)];
    labelLeftView.backgroundColor = [UIColor clearColor];
    userTextField = [[UITextField alloc] initWithFrame:CGRectMake(LabelTitleUser.right+KLabelFieldSpan, LabelTitleUser.top, image.size.width, image.size.height)];
    userTextField.backgroundColor = [UIColor colorWithPatternImage:image];
    userTextField.leftViewMode = UITextFieldViewModeAlways;
    userTextField.keyboardType = UIKeyboardTypeASCIICapable;
    userTextField.leftView = labelLeftView;
    [labelLeftView release];
    [self.view addSubview:userTextField];
    
    userLabel = [[UILabel alloc] initWithFrame:CGRectMake(KLabelOriginX, userTextField.bottom, self.view.width - 2*KLabelOriginX, KSpan)];
    userLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:userLabel];
    
    UILabel *LabelTitlePW = [[UILabel alloc] initWithFrame: CGRectMake(KLabelOriginX, userTextField.bottom+KSpan, KLabelWith, image.size.height)];
    LabelTitlePW.text = @"密码";
    LabelTitlePW.backgroundColor = [UIColor clearColor];
    LabelTitlePW.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:LabelTitlePW];
    [LabelTitlePW release];
    
    UILabel *labelLeftViewPW = [[UILabel alloc] initWithFrame:CGRectMake(0,0, KLabelLeftWith, image.size.height)];
    labelLeftViewPW.backgroundColor = [UIColor clearColor];
    passWordField = [[UITextField alloc] initWithFrame:CGRectMake(LabelTitlePW.right+KLabelFieldSpan, LabelTitlePW.top, image.size.width, image.size.height)];
    passWordField.backgroundColor = [UIColor colorWithPatternImage:image];
    passWordField.leftViewMode = UITextFieldViewModeAlways;
    passWordField.keyboardType = UIKeyboardTypeASCIICapable;
    passWordField.leftView = labelLeftViewPW;
    [labelLeftViewPW release];
    [self.view addSubview:passWordField];

    passWordLabel = [[UILabel alloc] initWithFrame:CGRectMake(KLabelOriginX, LabelTitlePW.top, self.view.width - 2*KLabelOriginX, KSpan)];
    passWordLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:passWordLabel];
    
    NSString *btnPath = [UIImage imageBundlePath:@"con_Btn.png"];
    UIImage *imagebtn = [[UIImage alloc] initWithContentsOfFile:btnPath];
    UIButton *btnClick = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClick.frame = CGRectMake(userTextField.left, passWordField.bottom+KSpan, userTextField.size.width, imagebtn.size.height);
    [btnClick setTitle:@"完成" forState:UIControlStateNormal];
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
    int resultValue = [[JVCPredicateHelper shareInstance] predicateUserNameIslegal:userTextField.text];
    if (resultValue == kSuccessModifyUserLegat) {//合法
        
        [[JVCAlertHelper shareAlertHelper]alertShowToastOnWindow];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            int exitResult = [[JVCAccountHelper sharedJVCAccountHelper] IsUserExist:userTextField.text];
            
            DDLogInfo(@"再这里就行了修改，回头要去掉==exitResult= 0;");
            
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

/**
 *  根据返回的数据处理结果
 *
 *  @param tType 注册的返回结果信息
 */
- (void)handleJudgeUserNameHsaResignResult:(int )tType
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
    
    if (tType != USER_NOT_EXIST) {
        
        [[JVCResultTipsHelper shareResultTipsHelper] loginInWithJudegeUserNameStrengthResult:tType];

    }else{
        [self modifyUnLegalUserInfoSeccess];
    }
    
}

- (void)modifyUnLegalUserInfoSeccess
{
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
