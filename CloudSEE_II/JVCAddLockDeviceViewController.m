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
{
    UIImageView *imageView ;
}

@end

@implementation JVCAddLockDeviceViewController
@synthesize addLockDeviceDelegate;
static const  int KAlarmSuccess         = 1;

static const  int  KBtnTagDoor = 100;//门磁的的tag
static const  int  KBtnTagBra  = 101;//手环的tag
static const  int  KBtnTagHand  = 102;//遥控

static const  int  kEdgeOff    = 50;//向下距离

static const int KOriginX = 40;

static const int KOriginAddHeight = 30;

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
    
    int seperateSize = (self.view.width - 2*btn.width)/3.0;
    btn.frame = CGRectMake(seperateSize, KOriginX, btn.width, btn.height);
    btn.tag = KBtnTagDoor;
    [btn addTarget:self action:@selector(addLockDevice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btnBra  = [controlHelper buttonWithTitile:@"手环设备" normalImage:@"arm_dev_Bra.png" horverimage:nil];
    btnBra.titleEdgeInsets = UIEdgeInsetsMake(kEdgeOff, 0, 0, 0);
    btnBra.frame = CGRectMake(btn.right+seperateSize, btn.top, btn.width, btn.height);
    btnBra.tag = KBtnTagBra;
    [btnBra addTarget:self action:@selector(addLockDevice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBra];
    
    UIButton *btnhand  = [controlHelper buttonWithTitile:@"遥控器设备" normalImage:@"arm_dev_hand.png" horverimage:nil];
    btnhand.titleEdgeInsets = UIEdgeInsetsMake(kEdgeOff, 0, 0, 0);
    btnhand.frame = CGRectMake(btn.left , btn.bottom+KOriginAddHeight, btn.width, btn.height);
    btnhand.tag = KBtnTagHand;
    [btnhand addTarget:self action:@selector(addLockDevice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnhand];

}

- (void)addLockDevice:(UIButton *)btn
{
    int addDeviceType = 1;
    NSString *imageName = nil;
    switch (btn.tag) {
        case KBtnTagDoor:
            imageName = @"add_lock_door.jpg" ;
            break;
        case KBtnTagBra:
        {
            imageName = @"add_lock_door.jpg" ;
            addDeviceType=2;
        }
            break;
            case KBtnTagHand:
        {
            imageName = @"add_lock_door.jpg" ;
            addDeviceType=3;
        }
            break;
    }
    
    
    imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSString *path = [UIImage imageBundlePath:imageName];
    UIImage *imageHelp = [[UIImage alloc] initWithContentsOfFile:path];
    imageView.image = imageHelp;
    [self.view.window addSubview:imageView];
    [imageHelp release];
    [imageView release];
    
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
        
        [imageView removeFromSuperview];
        
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
