//
//  JVCRegisterViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCRegisterViewController.h"
#import "JVCAccountHelper.h"
#import "JVCPredicateHelper.h"
#import "JVCAccountMacro.h"
#import "JVCResultTipsHelper.h"
#import "JVCRGBHelper.h"

static const int ORIGIN_Y  = 40;//第一个textfield距离顶端的距离

static const int SEPERATE  = 30;//textfield之间的间距

static const NSTimeInterval ANIMATIONTIME  = 0.5;//动画的时间

static const int SLIDEHEIGINT  = -100;//动画的时间

static const int RESISTERRESULT_SUCCESS  = 0;//返回值成功

static  NSString const *APPNAME  = @"CloudSEE";//app标识

static const int RESIGNFONT  = 14;//font 的大小

static const int PREDICATESECCESS  = 0 ;//正则校验成功

@interface JVCRegisterViewController ()
{
    /**
     *  用户名
     */
    UITextField *textFieldUser;
    
    /**
     *  用户名的提示lable
     */
    UILabel *labUser;
    
    /**
     *  密码
     */
    UITextField *textFieldPassWord;
    
    /**
     *  密码的提示label
     */
    UILabel *labPassWord;

    /**
     *  确认密码
     */
    UITextField *textFieldEnSurePassWord;
    
    /**
     *  密码的提示label
     */
    UILabel *labEnPassWord;
    
}

@end

@implementation JVCRegisterViewController

@synthesize resignDelegate;

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
    [textFieldUser release];
    textFieldUser = nil;
    
    [labUser release];
    labUser = nil;
    
    [textFieldPassWord release];
    textFieldEnSurePassWord = nil;
    
    [labPassWord release];
    labUser = nil;
    
    [textFieldEnSurePassWord release];
    textFieldEnSurePassWord = nil;
    
    [labEnPassWord release];
    labEnPassWord = nil;
    
    [super dealloc];
}

- (void) viewDidLayoutSubviews {
    
    if (IOS_VERSION>=IOS7) {
        
        CGRect viewBounds = self.view.bounds;
        
        CGFloat topBarOffset = self.topLayoutGuide.length;
        
        viewBounds.origin.y = topBarOffset * -1;
        
        self.view.bounds = viewBounds;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**
     *  设置背景的点击事件
     */
    UIControl *control = [[UIControl alloc] initWithFrame:self.view.frame];
    
    [control addTarget:self action:@selector(resignTextFields) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:control];
    
    [control release];
    
    self.navigationController.navigationBar.hidden = NO;
    
    
    /**
     *  设置标题
     */
    self.title = @"注册";
    
    UIImage *imgTextFieldBg = [UIImage imageNamed:@"reg_fieldBg.png"];
    
    //用户名
    textFieldUser = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width - imgTextFieldBg.size.width)/2.0, ORIGIN_Y, imgTextFieldBg.size.width, imgTextFieldBg.size.height)];
    
    textFieldUser.borderStyle = UITextBorderStyleNone;
    
    textFieldUser.delegate = self;
    
    [textFieldUser setBackground:imgTextFieldBg];
    
    [self.view addSubview:textFieldUser];
    
    //用户名提示
    labUser = [[UILabel alloc] initWithFrame:CGRectMake(textFieldUser.left, textFieldUser.bottom, textFieldUser.width, SEPERATE)];
    labUser.backgroundColor = [UIColor clearColor];
    labUser.font = [UIFont systemFontOfSize:RESIGNFONT];
    [self.view addSubview:labUser];
    
    //密码
    textFieldPassWord = [[UITextField alloc] initWithFrame:CGRectMake(textFieldUser.frame.origin.x, textFieldUser.bottom+SEPERATE, imgTextFieldBg.size.width, imgTextFieldBg.size.height)];
    
    textFieldPassWord.borderStyle = UITextBorderStyleNone;
    
    textFieldPassWord.delegate = self;
    
    textFieldPassWord.secureTextEntry = YES;
    
    [textFieldPassWord setBackground:imgTextFieldBg];
    
    [self.view addSubview:textFieldPassWord];
    
    //密码的提示
    labPassWord = [[UILabel alloc] initWithFrame:CGRectMake(textFieldPassWord.left, textFieldPassWord.bottom, textFieldUser.width, SEPERATE)];
    labPassWord.backgroundColor = [UIColor clearColor];
    labPassWord.font = [UIFont systemFontOfSize:RESIGNFONT];
    [self.view addSubview:labPassWord];
    
    //确认密码
    textFieldEnSurePassWord = [[UITextField alloc] initWithFrame:CGRectMake(textFieldPassWord.left, textFieldPassWord.bottom+SEPERATE, imgTextFieldBg.size.width, imgTextFieldBg.size.height)];
    
    textFieldEnSurePassWord.delegate = self;
    
    textFieldEnSurePassWord.borderStyle = UITextBorderStyleNone;
    
    textFieldEnSurePassWord.secureTextEntry = YES;
    
    [textFieldEnSurePassWord setBackground:imgTextFieldBg];
    
    [self.view addSubview:textFieldEnSurePassWord];
    
    //密码的提示
    labEnPassWord = [[UILabel alloc] initWithFrame:CGRectMake(textFieldPassWord.left, textFieldEnSurePassWord.bottom, textFieldUser.width, SEPERATE)];
    labEnPassWord.backgroundColor = [UIColor clearColor];
    labEnPassWord.font = [UIFont systemFontOfSize:RESIGNFONT];
    [self.view addSubview:labEnPassWord];
    
    //注册按钮
    UIImage *imageBtn = [UIImage imageNamed:@"reg_btnBg.png"];
    
    UIButton *btnResign = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnResign.frame = CGRectMake((self.view.width - imageBtn.size.width)/2.0, textFieldEnSurePassWord.bottom+SEPERATE, imageBtn.size.width, imageBtn.size.height);
    
    [btnResign setBackgroundImage:imageBtn forState:UIControlStateNormal];
    
    [btnResign addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    
    [btnResign setTitle:@"注册" forState:UIControlStateNormal];
    
    [self.view addSubview:btnResign];
    
}

#pragma mark textfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == textFieldEnSurePassWord) {
        
        [self slideUP];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField.text.length==0) {
        
        return;
    }
    
    if (textField == textFieldUser) {//判断用户名是否被注册过用户名
        
        int resultValue = [[JVCPredicateHelper shareInstance] predicateUserNameIslegal:textFieldUser.text];
        
        if (PREDICATESECCESS != resultValue) {//校验没有通过
            
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
                case VALIDATIONUSERNAMETYPE_EMAIL_E:
                    _strTitle =LOCALANGER(@"home_email_error");
                    break;
                default:
                    break;
            }
            
            [self setUserLabelRed];
            labUser.text =_strTitle;
            
        }else{//校验通过
        
            [self judgeUserNameHasResign];
            
        }

    }else if(textFieldPassWord == textField)//密码
    {
        BOOL bStatePassWord = [[JVCPredicateHelper shareInstance] PredicateResignPasswordIslegal:textFieldPassWord.text];
    
        if (!bStatePassWord) {//失败
            
            labPassWord.text = LOCALANGER(@"loginResign_passWord_error");//LOGINRESULT_PASSWORLD_ERROR

        }else{
            
            labPassWord.text =@"";
        }
        
        if ([[JVCPredicateHelper shareInstance] PredicateResignPasswordIslegal:textFieldEnSurePassWord.text]) {
            
            if(![textFieldPassWord.text isEqualToString:textFieldEnSurePassWord.text]) {
                
                labEnPassWord.text =LOCALANGER(@"PasswordNoEqual");
            }
            
        }else{
            
            if (textFieldEnSurePassWord.text.length>0) {
                
                labEnPassWord.text =LOCALANGER(@"loginResign_passWord_error");
                
            }
        }
    }else
    {
        if([[JVCPredicateHelper shareInstance] PredicateResignPasswordIslegal:textFieldPassWord.text]) {
            
            if (![textFieldEnSurePassWord.text isEqualToString:textFieldPassWord.text]) {
                
                labEnPassWord.text =LOCALANGER(@"PasswordNoEqual");
            }
        }
        
        BOOL resutl = [[JVCPredicateHelper shareInstance] PredicateResignPasswordIslegal:textFieldEnSurePassWord.text];
        
        if (!resutl) {
            
            labEnPassWord.text = LOCALANGER(@"loginResign_passWord_error");
            
        }else{
        
            labEnPassWord.text=@"";
        
        }
    }
}

/**
 *  判断用户名是否被注册过
 */
- (void)judgeUserNameHasResign
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int exitResult = [[JVCAccountHelper sharedJVCAccountHelper] IsUserExist:textFieldUser.text];
        
        DDLogInfo(@"再这里就行了修改，回头要去掉==exitResult= 0;");
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            [self handleJudgeUserNameHsaResign:exitResult];
        });
        
    });

}

/**
 *  根据返回的数据处理结果
 *
 *  @param tType 注册的返回结果信息
 */
- (void)handleJudgeUserNameHsaResign:(int )tType
{
        if (tType == USER_HAS_EXIST) {
            
            [self setUserLabelRed];

            labUser.text = LOCALANGER(@"home_login_resign_user_exit");
            
        }else if(tType == USER_NOT_EXIST){
            
            [self setUserLabelBlue];
            labUser.text = LOCALANGER(@"home_login_resign_user_noFound");
        }else if(tType == PHONE_NUM_ERROR){
            
            [self setUserLabelRed];
            labUser.text = LOCALANGER(@"home_login_resign_PhoneNum_error");
        }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 注销所有的textfield
- (void)resignTextFields
{
    [self slideDown];
    
    [textFieldUser resignFirstResponder];
    
    [textFieldPassWord resignFirstResponder];

    [textFieldEnSurePassWord resignFirstResponder];
    

}
#pragma mark 注册按钮按下时间
- (void)signUp
{
    
    /**
     *  检索用户输入的字符串是否合法
     */
    int resultPredicate = [[JVCPredicateHelper shareInstance] predicatUserResignWithUser:textFieldUser.text andPassWord:textFieldPassWord.text andEnsurePassWord:textFieldEnSurePassWord.text ];
    
    if (LOGINRESULT_SUCCESS == resultPredicate) {//成功，判断用户名是否被注册过
    
        [self resignUserToServer];
        
    }else{//不成功
        
        [[JVCResultTipsHelper shareResultTipsHelper] showLoginPredacateAlertWithResult:resultPredicate];
        
    }
}

/**
 *  往服务器注册用户
 */
- (void)resignUserToServer
{
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int result = [[JVCAccountHelper sharedJVCAccountHelper] UserRegister:textFieldUser.text passWord:textFieldPassWord.text appTypeName:APPNAME];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
            
            DDLogInfo(@"%s==注册收到的返回值 =%d",__FUNCTION__,result);
            
            [self dealWithRegisterResutl:result];
            
        });
        
    });

}

#pragma mark 处理注册的返回结果
- (void)dealWithRegisterResutl:(int)iResult
{
    if (RESISTERRESULT_SUCCESS == iResult) {//成功，把用户名密码保存起来
        
        kkUserName = textFieldUser.text;
        kkPassword = textFieldPassWord.text;
        
        if (resignDelegate !=nil && [resignDelegate  respondsToSelector:@selector(registerUserSuccessCallBack)]) {
            
            [resignDelegate registerUserSuccessCallBack];
        }
        
        [self.navigationController popViewControllerAnimated:NO];
        
    }else{//失败
    
        DDLogError(@"=%s=注册失败收到的返回值=%d",__FUNCTION__,iResult);
        [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:@"注册失败"];
    }
}



#pragma mark 界面向上滑动
/**
 *  向上滚动试图
 */
- (void)slideUP
{
    [UIView animateWithDuration:ANIMATIONTIME animations:^{
        
        self.view.frame = CGRectMake(0, SLIDEHEIGINT, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

/**
 *  向下滚动试图
 */
- (void)slideDown
{
    [UIView animateWithDuration:ANIMATIONTIME animations:^{
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    }];
}

#pragma mark 设置lable的颜色值为红色
- (void)setUserLabelRed
{
    UIColor *redColor  = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroRed];
    
    if (redColor) {
        
        labUser.textColor = redColor;
    }
}

#pragma mark 设置lable的颜色值为蓝色
- (void)setUserLabelBlue
{
    UIColor *redColor  = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroBlue];
    
    if (redColor) {
        
        labUser.textColor = redColor;
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
