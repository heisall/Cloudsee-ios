//
//  JVCAddLockDeviceViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAddLockDeviceViewController.h"
#import "JVCControlHelper.h"
#import "JVCEditLockDeviceNickNameViewController.h"
#import "JVCAlarmMacro.h"
@interface JVCAddLockDeviceViewController ()

@end

@implementation JVCAddLockDeviceViewController
@synthesize addLockDeviceDelegate;
static const  int KAlarmSuccess         = 1;

static const  int  KBtnTagDoor = 100;//门磁的的tag
static const  int  KBtnTagBra  = 101;//手环的tag
static const  int  kEdgeOff    = 100;//向下距离

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
    
    [self  initContentView];
    
    self.title = @"添加设备";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initContentView
{
    JVCControlHelper *controlHelper = [JVCControlHelper shareJVCControlHelper];
    UIButton *btn  = [controlHelper buttonWithTitile:@"门磁设备" normalImage:@"arm_dev_dor.png" horverimage:nil];
    btn.titleEdgeInsets = UIEdgeInsetsMake(kEdgeOff, 0, 0, 0);
    btn.frame = CGRectMake((self.view.width-btn.width)/2.0, (self.view.height- btn.height*2)/3.0, btn.width, btn.height);
    btn.tag = KBtnTagDoor;
    [btn addTarget:self action:@selector(addLockDevice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btnBra  = [controlHelper buttonWithTitile:@"手环设备" normalImage:@"arm_dev_Bra.png" horverimage:nil];
    btnBra.titleEdgeInsets = UIEdgeInsetsMake(kEdgeOff, 0, 0, 0);
    btnBra.frame = CGRectMake((self.view.width-btnBra.width)/2.0, btn.bottom+(self.view.height- btn.height*2)/3.0, btn.width, btn.height);
    btnBra.tag = KBtnTagBra;
    [btnBra addTarget:self action:@selector(addLockDevice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBra];

}

- (void)addLockDevice:(UIButton *)btn
{
    int addDeviceType = 1;

    switch (btn.tag) {
        case KBtnTagDoor:
            break;
        case KBtnTagBra:
            addDeviceType=2;
            break;
    }
    
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    ystNetWorkHelperObj.ystNWRODelegate                      = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper *netWorkHelper = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        netWorkHelper.ystNWTDDelegate = self;
        
      //  [ystNetWorkHelperObj RemoteDeleteDeviceAlarm:AlarmLockChannelNum withAlarmType:1 withAlarmGuid:8];
        
        [ystNetWorkHelperObj RemoteOperationSendDataToDevice:AlarmLockChannelNum remoteOperationType:TextChatType_setAlarmType remoteOperationCommand:addDeviceType];
        
        //[ystNetWorkHelperObj RemoteOperationSendDataToDevice:kLocalDeviceChannelNum remoteOperationType:TextChatType_getAlarmType remoteOperationCommand:-1];
        
    });
}

/**
 *  文本聊天返回的回调
 *
 *  @param nYstNetWorkHelpTextDataType 文本聊天的状态类型
 *  @param objYstNetWorkHelpSendData   文本聊天返回的内容
 */
-(void)ystNetWorkHelpTextChatCallBack:(int)nYstNetWorkHelpTextDataType objYstNetWorkHelpSendData:(id)objYstNetWorkHelpSendData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

        switch (nYstNetWorkHelpTextDataType) {
            case TextChatType_getAlarmType://获取列表的
                break;
            case TextChatType_setAlarmType://添加报警设备
                
                [self handleTextChatCallback:objYstNetWorkHelpSendData];
                
                break;
            case TextChatType_deleteAlarm://删除报警的
                
                break;
            default:
                break;
        }
    
    });
 
}

- (void)handleTextChatCallback:(id)sender
{
    if ([sender isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *tdic = (NSDictionary *)sender;
        
        int responResult = [[tdic objectForKey:Alarm_Lock_RES] integerValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
      
            switch (responResult) {
                case AlarmLockTypeRes_OK:
                    [self editLockDeviceNickName:tdic];
                    break;
                case AlarmLockTypeRes_Fail:
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"绑定失败"];
                    break;
                case AlarmLockTypeRes_MaxCount:
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"超过最大绑定值"];
                    break;
                default:
                    break;
            }
                
        });
        
        
    }else{
    
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"绑定失败"];

    }
}

- (void)editLockDeviceNickName:(NSDictionary *)dic
{
    int result = [[dic objectForKey:Alarm_Lock_RES] integerValue];
    if (result == KAlarmSuccess) {
        
        if ( addLockDeviceDelegate !=nil && [addLockDeviceDelegate respondsToSelector:@selector(AddLockDeviceSuccessCallBack:)]) {
            [addLockDeviceDelegate AddLockDeviceSuccessCallBack:dic];
        }
//        
//        JVCEditLockDeviceNickNameViewController *editVC = [[JVCEditLockDeviceNickNameViewController alloc] init];
//        [self.navigationController pushViewController:editVC animated:YES];
//        [editVC release];
        
        [self.navigationController popViewControllerAnimated:YES];
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
