//
//  JVCVoiceencInputSSIDWithPasswordViewController.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-10-13.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCVoiceencInputSSIDWithPasswordViewController.h"
#import "JVCSystemUtility.h"
#import "JVCVoiceencViewController.h"
#import "JVCSystemSoundHelper.h"
#import "JVCRGBHelper.h"


@interface JVCVoiceencInputSSIDWithPasswordViewController (){
    
    UITextField *ssidTextField;
    UITextField *password;
}

@end

@implementation JVCVoiceencInputSSIDWithPasswordViewController

static const    CGFloat   kSSidTextFieldBgTop             = 50.0;
static const    CGFloat   kTextFiledWithLeft              = 8.0;
static const    CGFloat   kNextButtonWithTextFiledBgTop   = 30.0;
static const    CGFloat   kShowPassWordViewLength         = 15.0; //显示密码的隐藏View，相比原图多的长度
static const    CGFloat   kTitleLableFontSize             = 14.0;
static const    CGFloat   kTitleLableFontHeight           = kTitleLableFontSize + 4.0;
static const    CGFloat   kTitleLableWithBgViewBottom     = 15.0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.title = LOCALANGER(@"jvc_voice_add_prepareconfig");
        
    }
    
    return self;
}

/**
 *  发现一个新设备，提示音
 */
-(void)playSound {
    
    NSString *path = [[NSBundle mainBundle ] pathForResource:NSLocalizedString(@"jvc_voice_add_info", nil) ofType:@"mp3"];
    
    if (path) {
        
         [[JVCSystemSoundHelper shareJVCSystemSoundHelper] playSound:path withIsRunloop:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *textImagBg     = [UIImage imageNamed:@"voi_txt_bg.png"];
    
    UIImageView *textBgView = [[UIImageView alloc] init];
    
    CGRect rectTextBg;
    
    rectTextBg.origin.x               = (self.view.frame.size.width - textImagBg.size.width)/2.0;
    rectTextBg.origin.y               = kSSidTextFieldBgTop;
    rectTextBg.size                   = textImagBg.size;
    textBgView.frame                  = rectTextBg;
    textBgView.image                  = textImagBg;
    textBgView.backgroundColor        = [UIColor clearColor];
    textBgView.userInteractionEnabled = YES;
    
    [self.view addSubview:textBgView];
    
    UILabel *titleLbl        = [[UILabel alloc] init];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.lineBreakMode   = NSLineBreakByWordWrapping;
    titleLbl.numberOfLines   = 1;
    titleLbl.font            = [UIFont systemFontOfSize:kTitleLableFontSize];
    titleLbl.frame           = CGRectMake(rectTextBg.origin.x, rectTextBg.origin.y - kTitleLableWithBgViewBottom - kTitleLableFontHeight, rectTextBg.size.width,kTitleLableFontHeight);
    titleLbl.text            = LOCALANGER(@"jvc_voice_add_prepareconfig_help");

    [self.view addSubview:titleLbl];
    [titleLbl release];
    
    CGSize textFiledSize    = textImagBg.size;
    textFiledSize.height    = textFiledSize.height / 2.0;
    textFiledSize.width     = textFiledSize.width - kTextFiledWithLeft*2;
    
    ssidTextField        = [[UITextField alloc] init];
    CGRect ssidRect;
    ssidRect.size        = textFiledSize;
    ssidRect.origin.x    = kTextFiledWithLeft;
    
    ssidTextField.frame  = ssidRect;
    
    ssidTextField.autocorrectionType     = UITextAutocorrectionTypeNo;
    ssidTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    ssidTextField.text                   = [[JVCSystemUtility shareSystemUtilityInstance] currentPhoneConnectWithWifiSSID];
    ssidTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    ssidTextField.enabled                = FALSE;
    ssidTextField.borderStyle            = UITextBorderStyleNone;
    
    [self addTextFieldWithRightView:ssidTextField withRightView:@"voi_wifi.png"];
    
    [textBgView addSubview:ssidTextField];
    [ssidTextField release];
    
    password                 = [[UITextField alloc] init];
    
    CGRect rectPassword      = ssidTextField.frame;
    
    rectPassword.origin.y    = ssidTextField.frame.size.height + ssidTextField.frame.origin.y;
    password.frame           = rectPassword;
    password.returnKeyType   = UIReturnKeyDone;
    password.borderStyle     = UITextBorderStyleNone;
    password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    password.delegate        = self;
    password.keyboardType = UIKeyboardTypeASCIICapable;
    [self addTextFieldWithRightView:password withRightView:@"voi_show_pw.png"];
    
    [textBgView addSubview:password];
    
    [password becomeFirstResponder];
    
    
    UIView *showPasswordView            = [[UIView alloc] init];
    showPasswordView.backgroundColor    = [UIColor clearColor];
    
    CGRect rectShowPassWord      = password.rightView.frame;
    
    rectShowPassWord.size.width += kShowPassWordViewLength * 2;
    rectShowPassWord.size.height+= kShowPassWordViewLength * 2;
    rectShowPassWord.origin.x    = password.frame.size.width + password.frame.origin.x - rectShowPassWord.size.width + kShowPassWordViewLength;
    rectShowPassWord.origin.y    = password.frame.origin.y + (password.frame.size.height - password.rightView.frame.size.height)/2.0 - kShowPassWordViewLength;
    
    showPasswordView.frame       = rectShowPassWord;
    
    [textBgView addSubview:showPasswordView];
    
    UITapGestureRecognizer *singleCilck = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPassword)];
    singleCilck.numberOfTapsRequired    = 1;
    [showPasswordView addGestureRecognizer:singleCilck];
    [singleCilck release];
    
    [showPasswordView release];
    
    [password release];
    
    UIImage *nextButtonImage = [UIImage imageNamed:@"voi_input_next.png"];
    
    CGRect rectNextButton;
    rectNextButton.size      = nextButtonImage.size;
    rectNextButton.origin.x  = (self.view.frame.size.width - rectNextButton.size.width)/2.0;
    rectNextButton.origin.y  = textBgView.frame.size.height + textBgView.frame.origin.y + kNextButtonWithTextFiledBgTop;
    
    UIButton *button         = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor   = [UIColor clearColor];
    button.frame             = rectNextButton;
    [button setBackgroundImage:nextButtonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:LOCALANGER(@"jvc_voice_add_next") forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [textBgView release];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self playSound];
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:YES];
    [[JVCSystemSoundHelper shareJVCSystemSoundHelper] stopSound];
}


/**
 *  显示和隐藏密码框的文本
 */
-(void)showPassword{
    
    password.secureTextEntry = !password.secureTextEntry;
    
    if (password.secureTextEntry) {
        
        [self addTextFieldWithRightView:password withRightView:@"voi_show_pw.png"];

    }else{
    
        [self addTextFieldWithRightView:password withRightView:@"voi_hiden_pw.png"];
    }
}

/**
 *  添加文本框的右边图标视图
 *
 *  @param textField 需要添加的文本框
 *  @param imagePath 图片的名称和文本
 */
-(void)addTextFieldWithRightView:(UITextField *)textField withRightView:(NSString *)imagePath{
    
    UIImage *ssidRightImageIcon         = [UIImage imageNamed:imagePath];
    
    UIImageView *ssidTextFieldRightIcon = [[UIImageView alloc] initWithImage:ssidRightImageIcon];
    
    textField.rightView             = ssidTextFieldRightIcon;
    textField.rightViewMode         = UITextFieldViewModeAlways;
    
    [ssidTextFieldRightIcon release];
}

/**
 *  下一步，开始配置
 */
-(void)nextClick{
    
    JVCVoiceencViewController *voiccenc = [[JVCVoiceencViewController alloc] init];
    voiccenc.strPassword                = password.text;
    voiccenc.strSSID                    = ssidTextField.text;
    [self.navigationController pushViewController:voiccenc animated:YES];
    [voiccenc release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc{

    [super dealloc];
}


@end
