//
//  JVCOnlyShowWifiView.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-14.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCOnlyShowWifiView.h"
#import "JVCConfigModel.h"

@implementation JVCOnlyShowWifiView
@synthesize onlyShowWifiViewDetailBlock;
@synthesize onlyShowWifiViewAPOpen;

static const CGFloat        kTitleTVWithHeight                 = 24.0f;
static const CGFloat        kUserNameTextFieldWithTitleLeft    = 10.0f;
static const CGFloat        kPasswordWithUserNameTextFieldTop  = 32.0f;
static const CGFloat        kUserNameTextFieldWithTop          = 35.0f;
static const CGFloat        kDetailButtonWithTop               = 40.0f;
static const CGFloat        kButtonButtonWithTop               = 20.0f;

- (id)initWithFrame:(CGRect)frame withSSIDName:(NSString *)ssid withPassword:(NSString *)password
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initLayoutWithInputSSidAndPassword:ssid withPassword:password];
        
    }
    return self;
}

-(void)dealloc {

    [onlyShowWifiViewDetailBlock release];
    DDLogVerbose(@"%s----------------------",__FUNCTION__);
    [super dealloc];
}

/**
 *  初始化加载热点和密码的文本框
 */
-(void)initLayoutWithInputSSidAndPassword:(NSString *)ssid withPassword:(NSString *)password{
    
    UIImage *tImageBg =[UIImage imageNamed:@"ap_textBg.png"];
    
    UIView *textFieldBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, tImageBg.size.height+20)];
    textFieldBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:textFieldBg];
    [textFieldBg release];
    
    UIImageView *timageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-tImageBg.size.width)/2.0, 20, tImageBg.size.width, tImageBg.size.height)];
    timageView.image = tImageBg;
    timageView.tag =202;
    [self addSubview:timageView];
    [timageView release];
    
    UILabel *tlebel             = [[UILabel alloc] initWithFrame:CGRectMake(0.0,0.0 , 30.0, kTitleTVWithHeight)];
    tlebel.backgroundColor      = [UIColor clearColor];
    tlebel.text = @"  ";
    
    UITextField *_tfContentInfo = [[UITextField alloc] init];
    _tfContentInfo.frame        = CGRectMake((self.frame.size.width - tImageBg.size.width)/2.0+kUserNameTextFieldWithTitleLeft, kUserNameTextFieldWithTop,tImageBg.size.width - kUserNameTextFieldWithTitleLeft, kTitleTVWithHeight);
    _tfContentInfo.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _tfContentInfo.keyboardAppearance=UIKeyboardAppearanceAlert;
    _tfContentInfo.text         = ssid;
    _tfContentInfo.enabled      = FALSE;
    [self addSubview:_tfContentInfo];
    
    UITextField *_tfContentInfoPw    = [[UITextField alloc] init];
    _tfContentInfoPw.frame           = CGRectMake(_tfContentInfo.frame.origin.x, _tfContentInfo.frame.origin.x + _tfContentInfo.frame.size.height + kPasswordWithUserNameTextFieldTop ,tImageBg.size.width - kUserNameTextFieldWithTitleLeft, kTitleTVWithHeight);
    [_tfContentInfoPw setBorderStyle:UITextBorderStyleNone];
    _tfContentInfoPw.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _tfContentInfoPw.keyboardType    = UIKeyboardTypeASCIICapable;
    _tfContentInfoPw.returnKeyType   = UIReturnKeyDone;
    _tfContentInfoPw.enabled         = FALSE;
    _tfContentInfoPw.clearButtonMode = UITextFieldViewModeAlways;
    _tfContentInfoPw.secureTextEntry = YES;
    _tfContentInfoPw.enabled         = FALSE;
    _tfContentInfoPw.text            = password;
    [self addSubview:_tfContentInfoPw];
    
    //查看详细信息
    UIImage *tBtnBg = [UIImage imageNamed:@"nws_wifiDetail.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((self.frame.size.width-tBtnBg.size.width)/2.0, _tfContentInfoPw.frame.size.height+_tfContentInfoPw.origin.y+kDetailButtonWithTop, tBtnBg.size.width, tBtnBg.size.height);
    [button setTitle:NSLocalizedString(@"jvcOnlyShowWiFiView_detail", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showWifiDetail) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:tBtnBg forState:UIControlStateNormal];
    [self addSubview:button];
    
    if ([JVCAppParameterModel shareJVCAPPParameter].isEnableAPModel) {
        
        UIButton *APButton = [UIButton buttonWithType:UIButtonTypeCustom];
        APButton.frame = CGRectMake((self.frame.size.width-tBtnBg.size.width)/2.0, button.frame.size.height+button.origin.y+kButtonButtonWithTop, tBtnBg.size.width, tBtnBg.size.height);
        [APButton setTitle:NSLocalizedString(@"jvcOnlyShowWiFiView_openAp", nil) forState:UIControlStateNormal];
        [APButton addTarget:self action:@selector(apOpenClick) forControlEvents:UIControlEventTouchUpInside];
        [APButton setBackgroundImage:tBtnBg forState:UIControlStateNormal];
        [self addSubview:APButton];
    }
   
    [tlebel release];
}


-(void)showWifiDetail {

    if (self.onlyShowWifiViewDetailBlock) {
        
        self.onlyShowWifiViewDetailBlock();
    }
}

-(void)apOpenClick{

    if (self.onlyShowWifiViewAPOpen) {
        
        self.onlyShowWifiViewAPOpen();
    }
}


@end
