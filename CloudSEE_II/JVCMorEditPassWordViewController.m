//
//  JVCMorEditPassWordViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/29/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCMorEditPassWordViewController.h"
#import "JVCPredicateHelper.h"
#import "JVCResultTipsHelper.h"
#import "JVCAccountHelper.h"

/**
 *  textFeild 的类型
 */
enum TEXTFIELDTYPE
{
    TEXTFIELDTYPE_OLDPASSWORD=0,//老密码
    TEXTFIELDTYPE_NEWPASSWORD,//新密码
    TEXTFIELDTYPE_ENSUREPASSWORD,//确认密码
    
};

static const int  SYSTEM_FONT           = 16;//字体大小
static const int TEXTFIELD_SEPERATE     = 20;//间距
static const int KEDITPWDSLIDEHEIGINT   = 100;//滑动距离
static const NSTimeInterval KANIMATIN_DURARTION = 0.5;//动画时间
static const int kPredicateSuccess   = 0;//正则校验成功

@interface JVCMorEditPassWordViewController ()
{
    /**
     *  老密码
     */
    UITextField *_textFieldOldPassWord;
    
    /**
     *  新密码
     */
    UITextField *_textFieldNewPassWord;
    
    /**
     *  确认新密码
     */
    UITextField *_textFieldEnSurePassWord;
    
    /**
     *  uicontroll
     */
    UIControl *mControll;
    

}

@end

@implementation JVCMorEditPassWordViewController

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
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self initControll];
    
    _textFieldOldPassWord = [self initTextFieldWithTextFieldType:TEXTFIELDTYPE_OLDPASSWORD];
    _textFieldNewPassWord = [self initTextFieldWithTextFieldType:TEXTFIELDTYPE_NEWPASSWORD];
    _textFieldEnSurePassWord = [self initTextFieldWithTextFieldType:TEXTFIELDTYPE_ENSUREPASSWORD];
    
    [mControll addSubview:_textFieldOldPassWord];
    [mControll addSubview:_textFieldNewPassWord];
    [mControll addSubview:_textFieldEnSurePassWord];

    [self initSaveBtn];
}

- (void)initControll
{
    mControll = [[UIControl alloc] initWithFrame:self.view.frame];
    mControll.backgroundColor = [UIColor clearColor];
    [mControll addTarget:self action:@selector(resignEditPWDTextFields) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mControll];
    
}

/**
 *  注销所有的响应者
 */
- (void)resignEditPWDTextFields
{
    [self editPwdSlideDown];
    
    [_textFieldOldPassWord resignFirstResponder];
    [_textFieldNewPassWord resignFirstResponder];
    [_textFieldEnSurePassWord resignFirstResponder];
}

/**
 *  初始化textfield模块
 */
- (UITextField *)initTextFieldWithTextFieldType:(int )textFieldType
{
    /**
     *  用户名
     */
    UIImage *tImage = [UIImage imageNamed:@"inputTextbg.png"];
    UITextField  * _textFieldUserName = [[UITextField alloc] initWithFrame:CGRectMake(20, 20+textFieldType*(tImage.size.height+TEXTFIELD_SEPERATE), tImage.size.width, tImage.size.height) ];
    _textFieldUserName.delegate = self;
    _textFieldUserName.borderStyle = UITextBorderStyleNone;
    _textFieldUserName.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    _textFieldUserName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_textFieldUserName setBackground:tImage];
    _textFieldUserName.autocorrectionType = NO;
    _textFieldUserName.textAlignment = UITextAlignmentLeft;
    _textFieldUserName.secureTextEntry = YES;
    NSString *strTitle = nil;
    switch (textFieldType) {
        case TEXTFIELDTYPE_OLDPASSWORD:
            strTitle =NSLocalizedString(@"oldPW", nil);
            break;
        case TEXTFIELDTYPE_NEWPASSWORD:
            strTitle =NSLocalizedString(@"newPW", nil);
            break;
        case TEXTFIELDTYPE_ENSUREPASSWORD:
            strTitle =NSLocalizedString(@"newInsurePw", nil);
            break;
            
        default:
            strTitle =@"";
            break;
    }
    _textFieldUserName.placeholder = strTitle;
    
    
    return _textFieldUserName ;
}

/**
 *  完成按钮
 */
- (void)initSaveBtn
{
    UIImage *tImageBtn = [UIImage imageNamed:@"mor_editPwdBtnBg.png"];
    UIButton *tFinishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tFinishBtn.frame = CGRectMake(20, _textFieldEnSurePassWord.frame.size.height+_textFieldEnSurePassWord.frame.origin.y+30, tImageBtn.size.width, tImageBtn.size.height);
    [tFinishBtn addTarget:self action:@selector(modifyUserPassWord) forControlEvents:UIControlEventTouchUpInside];
    [tFinishBtn setBackgroundImage:tImageBtn forState:UIControlStateNormal];
    [tFinishBtn setTitle:NSLocalizedString(@"Finish", nil) forState:UIControlStateNormal];
    [tFinishBtn.titleLabel setFont:[UIFont systemFontOfSize:SYSTEM_FONT]];
    [mControll addSubview:tFinishBtn];
    
}

- (void)modifyUserPassWord
{
    [self editPwdSlideDown];
    
    int result =[[JVCPredicateHelper shareInstance] predicateUserOldPassWord:_textFieldOldPassWord.text
                                                     NewPassWord:_textFieldNewPassWord.text
                                                  EnsurePassWord:_textFieldEnSurePassWord.text UserSavePassWord:kkPassword];
    NSLog(@"%d===%d",kkLoginState,kkGustureStgate);
    
    if (result == kPredicateSuccess) {//正则判断成功，修改功能调用
        
        [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//            int  result =[[JVCAccountHelper sharedJVCAccountHelper] ModifyUserPassword:_textFieldOldPassWord.text newPassWord:_textFieldNewPassWord.text];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//            
//                if (result == kPredicateSuccess) {//成功
//                    
//                    [OperationSet saveUserName:[[OperationSet getUserDic] objectForKey:USERINFO_NAME] andPassWord:_textFieldNewPassWord.text  andState:NO];
//                    
//                    //[[AccountAlertObject shareAccountAlertInstance] showAlertWithStringText:LOCALANGER(@"Modify_Pw_success")];
//                    
//                    // [self.navigationController popViewControllerAnimated:YES ];
//                    
//                    [self loginOutInModifyUserPassWord];
//                    
//                }else{//失败
//                    
//                    [[AccountAlertObject shareAccountAlertInstance]  showAlertWithStringText:LOCALANGER(@"Modify_PW_fail")];
//                }
//
//            });
//        
//        });
//        
//        [[AccountMethods shareAccountMathsInstance]ModifyUserPassWordWithOldPassWord:_textFieldOldPassWord.text andNewPassWord:_textFieldNewPassWord.text];
//        [AccountMethods shareAccountMathsInstance].modifyDelegate = self;
        
    }else{//正则判断失败
        
        [[JVCResultTipsHelper shareResultTipsHelper] showLoginPredacateAlertWithResult:result ];
    }
}

#pragma textfield的delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _textFieldEnSurePassWord) {
        
        [self editPwdSlideUp];
    }
}


#pragma mark 动画移动
#pragma mark 让控件上弹
- (void)editPwdSlideUp
{
    [UIView animateWithDuration:KANIMATIN_DURARTION animations:^{
        
        self.view.frame = CGRectMake(0, -KEDITPWDSLIDEHEIGINT, self.view.width, self.view.height);
    
    }];
    
}

- (void)editPwdSlideDown
{
    
    self.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
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
