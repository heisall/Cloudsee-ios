//
//  JVCRegisterViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCRegisterViewController.h"
#import "JVCAccountHelper.h"

static const int ORIGIN_Y  = 40;//第一个textfield距离顶端的距离

static const int SEPERATE  = 30;//textfield之间的间距

static const NSTimeInterval ANIMATIONTIME  = 0.5;//动画的时间

static const int SLIDEHEIGINT  = -100;//动画的时间

static const int RESISTERRESULT_SUCCESS  = 0;//返回值成功

static  NSString const *APPNAME  = @"CloudSEE";//app标识


@interface JVCRegisterViewController ()
{
    /**
     *  用户名
     */
    UITextField *textFieldUser;
    
    /**
     *  密码
     */
    UITextField *textFieldPassWord;
    
    /**
     *  确认密码
     */
    UITextField *textFieldEnSurePassWord;
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
    
    [textFieldPassWord release];
    textFieldEnSurePassWord = nil;
    
    [textFieldEnSurePassWord release];
    textFieldEnSurePassWord = nil;
    
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
    
    [textFieldUser setBackground:imgTextFieldBg];
    
    [self.view addSubview:textFieldUser];
    
    //密码
    textFieldPassWord = [[UITextField alloc] initWithFrame:CGRectMake(textFieldUser.frame.origin.x, textFieldUser.bottom+SEPERATE, imgTextFieldBg.size.width, imgTextFieldBg.size.height)];
    
    textFieldPassWord.borderStyle = UITextBorderStyleNone;
    
    textFieldPassWord.secureTextEntry = YES;
    
    [textFieldPassWord setBackground:imgTextFieldBg];
    
    [self.view addSubview:textFieldPassWord];
    
    //确认密码
    textFieldEnSurePassWord = [[UITextField alloc] initWithFrame:CGRectMake(textFieldPassWord.left, textFieldPassWord.bottom+SEPERATE, imgTextFieldBg.size.width, imgTextFieldBg.size.height)];
    
    textFieldEnSurePassWord.delegate = self;
    
    textFieldEnSurePassWord.borderStyle = UITextBorderStyleNone;
    
    textFieldEnSurePassWord.secureTextEntry = YES;
    
    [textFieldEnSurePassWord setBackground:imgTextFieldBg];
    
    [self.view addSubview:textFieldEnSurePassWord];
    
    //注册按钮
    UIImage *imageBtn = [UIImage imageNamed:@"reg_btnBg.png"];
    
    UIButton *btnResign = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnResign.frame = CGRectMake((self.view.width - imageBtn.size.width)/2.0, textFieldEnSurePassWord.bottom+SEPERATE, imageBtn.size.width, imageBtn.size.height);
    
    [btnResign setBackgroundImage:imageBtn forState:UIControlStateNormal];
    
    [btnResign addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    
    [btnResign setTitle:@"注册" forState:UIControlStateNormal];
    
    [self.view addSubview:btnResign];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == textFieldEnSurePassWord) {
        
        [self slideUP];
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
