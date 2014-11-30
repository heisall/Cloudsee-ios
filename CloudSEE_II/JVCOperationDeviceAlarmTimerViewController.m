//
//  JVCOperationDeviceAlarmTimerViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/28/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCOperationDeviceAlarmTimerViewController.h"
#import "JVCLelftBtn.h"
#import "JVCPredicateHelper.h"

typedef NS_ENUM(int, JVCAlarmPickType) {

    JVCAlarmPickTypeStartTag    = 100,//开始的tag
    JVCAlarmPickTypeEndTag      = 101,//结束的tag

};

@interface JVCOperationDeviceAlarmTimerViewController ()
{
    JVCLelftBtn *startBtn;
    JVCLelftBtn *endBtn;
    
    JVCCustomDatePickerView *customDataPickerView ;
}

@end

@implementation JVCOperationDeviceAlarmTimerViewController
@synthesize alarmEndTimer;
@synthesize alarmStartTimer;
@synthesize delegateAlarm;

static const int KOriginY       =   20;
static const int KBtnHeight     =   40;
static const int KSPan          =   20;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = LOCALANGER(@"JVCOperationDeviceConnectManagerSafeTimerduration");
    [self initAlarmContent];
    [self setBtnsTitles];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)initAlarmContent
{
    startBtn = [[JVCLelftBtn alloc] initwitLeftString:LOCALANGER(@"JVCOperationDevAlarmStart") frame:CGRectMake(0, KOriginY, self.view.width, KBtnHeight)];
    [startBtn.btn addTarget:self action:@selector(showTimerPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    startBtn.btn.tag = JVCAlarmPickTypeStartTag;
    [startBtn release];
    
     endBtn = [[JVCLelftBtn alloc] initwitLeftString:LOCALANGER(@"JVCOperationDevAlarmStart") frame:CGRectMake(0, KSPan+startBtn.bottom, self.view.width, KBtnHeight)];
    [endBtn.btn addTarget:self action:@selector(showTimerPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:endBtn];
    endBtn.btn.tag = JVCAlarmPickTypeEndTag;
    [endBtn release];
    
    UIImage *imgBtnNor = [UIImage imageNamed:@"addDev_btnHor.png"];
    UIImage *imgBtnHor = [UIImage imageNamed:@"addDev_btnNor.png"];
    int seperate = (self.view.width -2*imgBtnNor.size.width)/3.0;

    //高级按钮
    UIButton  *btnDelegate = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelegate.frame = CGRectMake(seperate,endBtn.bottom+KSPan, imgBtnNor.size.width, imgBtnNor.size.height);
    [btnDelegate setBackgroundImage:imgBtnNor forState:UIControlStateNormal];
    [btnDelegate setTitle:LOCALANGER(@"JVCOperationDeviceConnectManagerSafeAllDay") forState:UIControlStateNormal];
    [btnDelegate addTarget:self action:@selector(setTimerAllDay) forControlEvents:UIControlEventTouchUpInside];
    [btnDelegate setBackgroundImage:imgBtnHor forState:UIControlStateHighlighted];
    [self.view addSubview:btnDelegate];
    
    //保存按钮
    UIButton  *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame = CGRectMake(seperate+btnDelegate.right, btnDelegate.top, imgBtnNor.size.width, imgBtnNor.size.height);
    [btnSave setBackgroundImage:imgBtnNor forState:UIControlStateNormal];
    [btnSave setBackgroundImage:imgBtnHor forState:UIControlStateHighlighted];
    [btnSave setTitle:LOCALANGER(@"Jvc_editDeviceInfo_Save") forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(setDeviceSafeTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSave];
}

- (void)setTimerAllDay
{
    [startBtn.btn   setTitle:LOCALANGER(@"JVCOperationDeviceConnectManagerSafeAllDay") forState:UIControlStateNormal];
    [endBtn.btn     setTitle:LOCALANGER(@"JVCOperationDeviceConnectManagerSafeAllDay")  forState:UIControlStateNormal];
    self.alarmStartTimer = (NSString *) kAlarmTimerStart;
    self.alarmEndTimer   = (NSString *)kAlarmTimerEnd;
    
    //调保存按钮
    if (delegateAlarm !=nil &&[delegateAlarm respondsToSelector:@selector(jvcOperationDevieAlarmStartTimer:endTimer:)]) {
        [delegateAlarm jvcOperationDevieAlarmStartTimer:self.alarmStartTimer endTimer:self.alarmEndTimer];
    }
}

/**
 *  设置按钮的标题
 */
- (void)setBtnsTitles
{
    int reuslt =  [[JVCPredicateHelper shareInstance] predicateAlarmTimer:self.alarmStartTimer endTimer:self.alarmEndTimer];
    
    switch (reuslt) {
        case JVCAlarmTimerType_AllDay:
        {
            [startBtn.btn   setTitle:LOCALANGER(@"JVCOperationDeviceConnectManagerSafeAllDay") forState:UIControlStateNormal];
            [endBtn.btn     setTitle:LOCALANGER(@"JVCOperationDeviceConnectManagerSafeAllDay")  forState:UIControlStateNormal];

        }
            break;
        case JVCAlarmTimerType_UNLegal:
        {
            [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:LOCALANGER(@"JVCOperationDeviceConnectManagerSafeTimerUnLegal")];
            self.alarmStartTimer = startBtn.btn.titleLabel.text;
            self.alarmEndTimer = endBtn.btn.titleLabel.text;
            
            [startBtn.btn   setTitle:self.alarmStartTimer forState:UIControlStateNormal];
            [endBtn.btn     setTitle:self.alarmEndTimer forState:UIControlStateNormal];
        }
            break;
        case JVCAlarmTimerType_Legal:
        {
            [startBtn.btn   setTitle:self.alarmStartTimer forState:UIControlStateNormal];
            [endBtn.btn     setTitle:self.alarmEndTimer forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
       


}

- (void)showTimerPicker:(UIButton *)button
{
     customDataPickerView        = [[JVCCustomDatePickerView alloc] initWithFrame:self.view.window.frame withSelectTime:button.titleLabel.text];
    customDataPickerView.jvcCustomDatePickerViewDelegate = self;
    
    [self.view.window addSubview:customDataPickerView];
    customDataPickerView.tag    = button.tag;

    [customDataPickerView release];
}

#pragma --------------------- JVCCustomDatePickerView delegate
-(void)JVCCustomDatePickerViewSelectedFinshedCallBack:(NSString *)strSelectedTime withButtonClickIndex:(int)nClickIndex {

    int selectTag = customDataPickerView.tag;
    [customDataPickerView removeFromSuperview];
    
    if (nClickIndex == JVCCustomDatePickerViewClickTypeSure) {
        return;
    }

    if (selectTag == JVCAlarmPickTypeStartTag) {//开始的
        
        self.alarmStartTimer = strSelectedTime;
        
        if ([endBtn.btn.titleLabel.text isEqualToString:LOCALANGER(@"JVCOperationDeviceConnectManagerSafeAllDay")]) {
            [endBtn.btn setTitle:(NSString *)kAlarmTimerEnd forState:UIControlStateNormal];
            
            self.alarmEndTimer   = (NSString *)kAlarmTimerEnd;
        }
        
    }else{
        
        self.alarmEndTimer = strSelectedTime;
        
        if ([startBtn.btn.titleLabel.text isEqualToString:LOCALANGER(@"JVCOperationDeviceConnectManagerSafeAllDay")]) {
            [startBtn.btn setTitle:(NSString *)kAlarmTimerStart forState:UIControlStateNormal];
            
            self.alarmStartTimer = (NSString *) kAlarmTimerStart;
        }
    }
    
    [self setBtnsTitles];
    
    DDLogVerbose(@"%s---------------%@",__FUNCTION__,strSelectedTime);

}

/**
 *  点击保存按钮
 */
- (void)setDeviceSafeTimer
{
    if (delegateAlarm !=nil &&[delegateAlarm respondsToSelector:@selector(jvcOperationDevieAlarmStartTimer:endTimer:)]) {
        [delegateAlarm jvcOperationDevieAlarmStartTimer:self.alarmStartTimer endTimer:self.alarmEndTimer];
    }
}

- (void)dealloc
{
    [alarmStartTimer    release];
    [alarmEndTimer      release];
    [super              dealloc];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
