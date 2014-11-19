//
//  JVCBindingEmailViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/11/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBindingEmailViewController.h"
#import "JVCAccountHelper.h"
#import "JVCPredicateHelper.h"
#import "JVCResultTipsHelper.h"
#import "JVCRGBHelper.h"
#import "JVCLogHelper.h"

@interface JVCBindingEmailViewController ()
{
    UITextField *_textFieldEmail;
}

@end

@implementation JVCBindingEmailViewController
@synthesize delegateEmail;

static const int  KSYSTEM_FONT      = 16;//font字体大小
static const int  KLabelOriginX     = 20;//距离左侧的距离
static const int  KLabelOriginY     = 30;//距离顶端的距离
static const int  KLabelWith        = 60;//labe的宽度
static const int  KLabelSpan        = 10;//间距
static const int  KBtnSpan          = 30;//间距
static const int  KLabeLeftViewWith = 10;//leftview的大小

static const int  KEmailMAXNum      = 28;//email的大小
static const int  KSUCCESS          = 0;//成功

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
    self.tenCentKey = kTencentKey_bindEamil;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    
    self.title= LOCALANGER(@"Binding_email_title");
    
    [self initTextField];
    
    [self initRightBtn];
}

- (void)dealloc
{
    [_textFieldEmail    release];
    [super              dealloc];
}

- (void) viewDidLayoutSubviews {
    if (IOS_VERSION>=IOS7) {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        viewBounds.origin.y = topBarOffset * -1;
        self.view.bounds = viewBounds;
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self resignTextField];
    
    [super viewDidDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  初始化TextField
 */
- (void)initTextField
{
    
    UIControl *control = [[UIControl alloc] initWithFrame:self.view.frame];
    [control addTarget:self action:@selector(resignTextField) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    [control release];
    
    NSString *path = [UIImage imageBundlePath:@"con_fieldSec.png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    UILabel *labelEmail = [[UILabel alloc] initWithFrame:CGRectMake(KLabelOriginX, KLabelOriginY, KLabelWith, image.size.height)];
    labelEmail.backgroundColor = [UIColor clearColor];
    JVCRGBHelper *rgbLabelHelper      = [JVCRGBHelper shareJVCRGBHelper];
    UIColor *labColorGray  = [rgbLabelHelper rgbColorForKey:kJVCRGBColorMacroLoginGray];
    if (labColorGray) {
        
        labelEmail.textColor = labColorGray;
        
    }
    labelEmail.text = LOCALANGER(@"Binding_email");
    [self.view addSubview:labelEmail];
    [labelEmail release];
    
    _textFieldEmail = [[UITextField alloc] initWithFrame:CGRectMake(labelEmail.right+KLabelSpan, labelEmail.top, image.size.width, image.size.height) ];
    _textFieldEmail.delegate = self;
    _textFieldEmail.borderStyle = UITextBorderStyleNone;
    _textFieldEmail.returnKeyType = UIReturnKeyDone;
    _textFieldEmail.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    _textFieldEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UILabel *lableLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KLabeLeftViewWith, _textFieldEmail.height)];
    lableLeft.backgroundColor = [UIColor clearColor];
    _textFieldEmail.leftViewMode = UITextFieldViewModeAlways;
    _textFieldEmail.leftView = lableLeft;
    _textFieldEmail.keyboardType = UIKeyboardTypeASCIICapable;
    [_textFieldEmail becomeFirstResponder];
    [lableLeft release];
    [_textFieldEmail setBackground:image];
    if (labColorGray) {
        
        _textFieldEmail.textColor = labColorGray;
        
    }
    _textFieldEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:_textFieldEmail];
    
    [image release];
    //完成按钮
    //    UIImage *tImageBtn = [UIImage imageNamed:[NSString stringWithFormat:@"btnBG_%d.png",delegate.selectSkin]];
    
    NSString *pathBtn = [UIImage imageBundlePath:@"con_Btn.png"];
    UIImage *tImageBtn = [[UIImage alloc] initWithContentsOfFile:pathBtn];
    
    UIButton *tFinishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tFinishBtn.frame = CGRectMake(_textFieldEmail.left, _textFieldEmail.frame.size.height+_textFieldEmail.frame.origin.y+KBtnSpan, tImageBtn.size.width, tImageBtn.size.height);
    [tFinishBtn addTarget:self action:@selector(bingEmail) forControlEvents:UIControlEventTouchUpInside];
    [tFinishBtn setBackgroundImage:tImageBtn forState:UIControlStateNormal];
    [tFinishBtn setTitle:NSLocalizedString(@"binding_finish", nil) forState:UIControlStateNormal];
    [tFinishBtn.titleLabel setFont:[UIFont systemFontOfSize:KSYSTEM_FONT]];
    [self.view addSubview:tFinishBtn];
    [tImageBtn release];
    
    NSString *pathAlert = [UIImage imageBundlePath:@"bin_Alert.png"];
    UIImage *_imgAlert = [[UIImage alloc] initWithContentsOfFile:pathAlert];
    UIImageView *imageViewAlert = [[UIImageView alloc] initWithFrame:CGRectMake(labelEmail.frame.origin.x, tFinishBtn.frame.origin.y+tFinishBtn.frame.size.height+KBtnSpan, _imgAlert.size.width, _imgAlert.size.height)];
    imageViewAlert.image = _imgAlert;
    [self.view addSubview:imageViewAlert];
    [imageViewAlert release];
    [_imgAlert release];
    NSString *_strTitle = LOCALANGER(@"DeviceModifyViewController_binding");
    
    CGSize _size = [_strTitle sizeWithFont:[UIFont systemFontOfSize:KSYSTEM_FONT] constrainedToSize:CGSizeMake(self.view.width -imageViewAlert.frame.size.width - 2*KLabelOriginX , 300) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *_lblAlert = [[UILabel alloc] initWithFrame:CGRectMake(imageViewAlert.frame.origin.x+imageViewAlert.frame.size.width, imageViewAlert.frame.origin.y,self.view.frame.size.width -imageViewAlert.right , _size.height)];
    
    _lblAlert.numberOfLines = 0;
    _lblAlert.lineBreakMode = UILineBreakModeWordWrap;
    _lblAlert.backgroundColor = [UIColor clearColor];
    _lblAlert.text = _strTitle;
    [_lblAlert setFont:[UIFont systemFontOfSize:KSYSTEM_FONT]];
    [self.view addSubview:_lblAlert];
    [_lblAlert release];
    
}

/**
 *  注销textfield
 */
- (void)resignTextField
{
    [_textFieldEmail resignFirstResponder];
}

/**
 *  设置返回按钮
 */
- (void)initRightBtn
{
    //设置navicationbar的返回按钮
    UIButton *tbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tbtn addTarget:self action:@selector(skipClick) forControlEvents:UIControlEventTouchUpInside];
    [tbtn.titleLabel setFont:[UIFont systemFontOfSize:KSYSTEM_FONT]];
    tbtn.frame = CGRectMake(0, 0,45 , 37);
    [tbtn setTitle:LOCALANGER(@"binding_skip") forState:UIControlStateNormal];
    //    [tbtn setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *tLeftItem = [[UIBarButtonItem alloc] initWithCustomView:tbtn];
    // self.navigationItem.leftBarButtonItem = tLeftItem;
    self.navigationItem.rightBarButtonItem = tLeftItem;
    [tLeftItem release];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location>=KUserNameMaxLength) {
        
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


/**
 *  绑定email事件
 */
- (void)bingEmail
{
    int result = [[JVCPredicateHelper shareInstance] predicateEmailLegal:_textFieldEmail.text];
    
    if (KSUCCESS ==  result ) {//成功
    
        [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];

        //直接绑定邮箱
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            int exitResult = [[JVCAccountHelper sharedJVCAccountHelper] bindMailToAccount:_textFieldEmail.text];

            [[JVCLogHelper shareJVCLogHelper] writeDataToFile:[NSString stringWithFormat:@"%s==%d",__FUNCTION__,result] fileType:LogType_LoginManagerLogPath];

            dispatch_async(dispatch_get_main_queue(),^{
                
                [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
                
                [self handleBindEmailResult:exitResult];
            });
            
        });
        
    }else{//不成功
        [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

        [[JVCResultTipsHelper shareResultTipsHelper] showLoginPredacateAlertWithResult:result];
        
        [_textFieldEmail becomeFirstResponder];
    }
    
}


- (void)handleBindEmailResult:(int )result
{
    if (result == KSUCCESS) {//成功
        
        [self finishBindingEmail];
        
    }else{
        [_textFieldEmail becomeFirstResponder];

        [[JVCResultTipsHelper shareResultTipsHelper] showResultAlertOnModifyVCWithMessage:result];
    }
}

/**
 *  跳过按钮
 */
- (void)skipClick
{
    [self finishBindingEmail];
}

- (void)finishBindingEmail
{
    if (delegateEmail !=nil && [delegateEmail respondsToSelector:@selector(FinishAndSkipBindingEmailCallback)]) {
        [delegateEmail FinishAndSkipBindingEmailCallback];
    }
}



@end
