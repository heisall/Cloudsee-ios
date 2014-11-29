//
//  JVCOperationDeviceAlarmTimerViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/28/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCOperationDeviceAlarmTimerViewController.h"
#import "JVCLelftBtn.h"

@interface JVCOperationDeviceAlarmTimerViewController ()
{
    JVCLelftBtn *startBtn;
    
    JVCLelftBtn *endBtn;
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
    // Do any additional setup after loading the view.
    
    [self initAlarmContent];
    
    [self setBtnsTitles];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//"JVCOperationDevAlarmStart" = "Start time";
//"JVCOperationDevAlarmEnd"   = "End time";
- (void)initAlarmContent
{
    startBtn = [[JVCLelftBtn alloc] initwitLeftString:LOCALANGER(@"JVCOperationDevAlarmStart") frame:CGRectMake(0, KOriginY, self.view.width, KBtnHeight)];
    [startBtn.btn addTarget:self action:@selector(showStartTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    [startBtn release];
    
     endBtn = [[JVCLelftBtn alloc] initwitLeftString:LOCALANGER(@"JVCOperationDevAlarmStart") frame:CGRectMake(0, KSPan+startBtn.bottom, self.view.width, KBtnHeight)];
    [endBtn.btn addTarget:self action:@selector(showStartTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:endBtn];
    [endBtn release];
    
    UIImage *imgBtnNor = [UIImage imageNamed:@"addDev_btnHor.png"];
    UIImage *imgBtnHor = [UIImage imageNamed:@"addDev_btnNor.png"];
    int seperate = (self.view.width -2*imgBtnNor.size.width)/3.0;

    //高级按钮
    UIButton  *btnDelegate = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelegate.frame = CGRectMake(seperate,endBtn.bottom+KSPan, imgBtnNor.size.width, imgBtnNor.size.height);
    [btnDelegate setBackgroundImage:imgBtnNor forState:UIControlStateNormal];
    [btnDelegate setTitle:LOCALANGER(@"Jvc_editDeviceInfo_Delete") forState:UIControlStateNormal];
//    [btnDelegate addTarget:self action:@selector(deleteDevice) forControlEvents:UIControlEventTouchUpInside];
    [btnDelegate setBackgroundImage:imgBtnHor forState:UIControlStateHighlighted];
    [self.view addSubview:btnDelegate];
    
    //保存按钮
    UIButton  *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.frame = CGRectMake(seperate+btnDelegate.right, btnDelegate.top, imgBtnNor.size.width, imgBtnNor.size.height);
    [btnSave setBackgroundImage:imgBtnNor forState:UIControlStateNormal];
    [btnSave setBackgroundImage:imgBtnHor forState:UIControlStateHighlighted];
    [btnSave setTitle:LOCALANGER(@"Jvc_editDeviceInfo_Save") forState:UIControlStateNormal];
//    [btnSave addTarget:self action:@selector(saveDeviceInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSave];

    
    
}

/**
 *  设置按钮的标题
 */
- (void)setBtnsTitles
{
    [startBtn.btn   setTitle:self.alarmStartTimer forState:UIControlStateNormal];
    [endBtn.btn     setTitle:self.alarmEndTimer forState:UIControlStateNormal];

}

- (void)showStartTimer
{

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
