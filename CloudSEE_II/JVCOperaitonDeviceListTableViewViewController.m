//
//  JVCOperaitonDeviceListTableViewViewController.m
//  CloudSEE_II
//
//  Created by David on 14/12/10.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "JVCOperaitonDeviceListTableViewViewController.h"
#import "JVCCloudSEENetworkMacro.h"
#import "UIImage+BundlePath.h"
#import "JVCOEMCellTableViewCell.h"
#import "DCRoundSwitch.h"
#import "JVCCloudSEENetworkHelper.h"
#import "JVCTimeZoonViewController.h"
#import "JVCOperaDeviceConnectManagerTableViewController.h"
#import "JVCOperaOldDeviceConnectAlarmViewController.h"
#import "JVCAlarmHelper.h"

@interface JVCOperaitonDeviceListTableViewViewController ()
{
    NSMutableArray *arrayDicKey;
}

@end

@implementation JVCOperaitonDeviceListTableViewViewController
@synthesize dicDeviceContent;
@synthesize modelDevice;
@synthesize nLocalChannel;
@synthesize bNewIpcState;

static NSString const *kDeviceAlarmSafe                           =  @"deviceSafe";           //安全防护
static  const int      kOEMDefaultHeigt                           =  20;                      //默认footView的高度


//-(id)init {
//    
//    if (self = [super init]) {
//        
//        NSMutableDictionary *mdInfo = [[NSMutableDictionary alloc] initWithCapacity:10];
//        self.dicDeviceContent              = mdInfo;
//        [mdInfo release];
//        
//    }
//    
//    return self;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    DDLogVerbose(@"%s=====%@",__FUNCTION__,self.dicDeviceContent);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = LOCALANGER(@"remoteSetDevice");
    // Do any additional setup after loading the view.
    [self initArrayKey];
    
}

- (void)dealloc
{
    [modelDevice        release];
//    [dicDeviceContent   release];
    [arrayDicKey        release];
    [super              dealloc];
}

//初始化key值
- (void)initArrayKey
{
    arrayDicKey = [[NSMutableArray alloc] initWithCapacity:10];
    [arrayDicKey addObject:(NSString *)kDevicePNMode];
    [arrayDicKey addObject:(NSString *)kDeviceFlashMode];
    [arrayDicKey addObject:(NSString *)kDeviceTimezone];
    
    NSMutableArray *arrayContent = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSString *key in arrayDicKey) {
        
        if (![[self.dicDeviceContent allKeys] containsObject:key]) {
           
            [arrayContent addObject:key];

            
        }
    }
    [arrayDicKey removeObjectsInArray:arrayContent];
    //插入报警设置
    [arrayDicKey insertObject:(NSString *)kDeviceAlarmSafe atIndex:0];

    [arrayContent release];
    
    
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrayDicKey.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"cellIndentify";
    
    JVCOEMCellTableViewCell *cell = (JVCOEMCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (cell == nil) {
        
        cell = [[[JVCOEMCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.tag            = indexPath.section;
    cell.contentArray   = arrayDicKey;
    cell.delegateOEM    = self;
    cell.dicDevice      = self.dicDeviceContent;
    cell.stringCellIndetidy = [arrayDicKey objectAtIndex:indexPath.section];
    [cell               initContentView];
 
    if ([cell.stringCellIndetidy isEqualToString: (NSString *)kDeviceTimezone]) {
        
        cell.labelContent.text = [NSString stringWithFormat:@"%@(%@)",cell.labelContent.text,[self getCurrentTimerZoneWithCelltag:indexPath.section]];
    }
    
       return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kOEMDefaultHeigt;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *bgView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kOEMDefaultHeigt)] autorelease];
    bgView.backgroundColor = [UIColor clearColor];
    return bgView;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *stringIndex = [arrayDicKey objectAtIndex:indexPath.section];
    
    int iOemIndex = [[JVCAlarmHelper shareAlarmHelper] getOemDeviceListIndex:stringIndex];
    
    DDLogVerbose(@"%s====%@===%d",__FUNCTION__,stringIndex,iOemIndex);
    switch (iOemIndex) {
        case JVCOEMCellType_SAFE://防护
            [self gotoAlarmSettingVC];
            break;
        case JVCOEMCellType_FlashModel://闪光灯
        {
            [self showFlshModelView];
        }
            
            break;
        case JVCOEMCellType_TimerZone:
        {
            [self gotTimeZoonSetting];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 闪关灯
- (void)showFlshModelView
{
    if (IOS8) {
        
        UIAlertController *controlAlert = [UIAlertController alertControllerWithTitle:LOCALANGER(@"FlashMode") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [controlAlert addAction:[UIAlertAction actionWithTitle:LOCALANGER(@"JVCCloudSEENetworkDeviceFlashMode_0") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self setDeviceFlashModelWithIndex:JVCCloudSEENetworkDeviceFlashModeAuto];
        }]];
        
        [controlAlert addAction:[UIAlertAction actionWithTitle:LOCALANGER(@"JVCCloudSEENetworkDeviceFlashMode_1") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self setDeviceFlashModelWithIndex:JVCCloudSEENetworkDeviceFlashModeOpen];

        }]];
        
        [controlAlert addAction:[UIAlertAction actionWithTitle:LOCALANGER(@"JVCCloudSEENetworkDeviceFlashMode_2") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self setDeviceFlashModelWithIndex:JVCCloudSEENetworkDeviceFlashModeClose];

        }]];
        
        [controlAlert addAction:[UIAlertAction actionWithTitle:LOCALANGER(@"home_ap_Alert_NO") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }]];
        
        [self presentViewController:controlAlert animated:YES completion:nil];
        
    }else{
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:LOCALANGER(@"FlashMode") delegate:self cancelButtonTitle:LOCALANGER(@"home_ap_Alert_NO")  destructiveButtonTitle: nil otherButtonTitles:LOCALANGER(@"JVCCloudSEENetworkDeviceFlashMode_0"),LOCALANGER(@"JVCCloudSEENetworkDeviceFlashMode_1"),LOCALANGER(@"JVCCloudSEENetworkDeviceFlashMode_2"), nil];
        [sheet showInView:self.view.window];
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [sheet release];
    }

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case JVCCloudSEENetworkDeviceFlashModeAuto:
        case JVCCloudSEENetworkDeviceFlashModeOpen:
        case JVCCloudSEENetworkDeviceFlashModeClose:
            [self setDeviceFlashModelWithIndex:buttonIndex];
            break;
            
        default:
            break;
    }
}

#pragma mark 时区
- (void)gotTimeZoonSetting
{
    JVCTimeZoonViewController *timeZomeVC = [[JVCTimeZoonViewController alloc] init];
//    TimeZoonViewController *timeZomeVC=[TimeZoonViewController shareTimeZoneInstance];
    timeZomeVC.TimeZoneDelegate = self;
    timeZomeVC.strCurrentTimer = [self.dicDeviceContent objectForKey:kDeviceTimezone];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:timeZomeVC animated:NO];
    
}

/**
 *  时区按下的回调
 *
 *  @param index 选中的时区
 */
- (void)setDeviceTimerZoneWithIndex:(int)index
{
    DDLogVerbose(@"%s===%d",__FUNCTION__,index);
    
    NSString *defaultString = [self.dicDeviceContent objectForKey:(NSString *)kDeviceTimezone];
    
    if (defaultString.intValue !=index) {
        
        [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
        
        JVCCloudSEENetworkHelper *netWorkObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        [netWorkObj RemoteOperationSendDataToDevice:self.nLocalChannel remoteOperationType:TextChatType_setDeviceTimezone remoteOperationCommand:index];
    }
    
   
}

#pragma mark 跳转到设置报警设置界面
- (void)gotoAlarmSettingVC
{
//    if (self.bNewIpcState) {
    
            JVCOperaDeviceConnectManagerTableViewController *viewController = [[JVCOperaDeviceConnectManagerTableViewController alloc] init];
                [viewController.deviceDic addEntriesFromDictionary:self.dicDeviceContent];
                viewController.nLocalChannel = self.nLocalChannel;
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
        
//    }else{
//                    JVCOperaOldDeviceConnectAlarmViewController *deviceAlarmVC = [[JVCOperaOldDeviceConnectAlarmViewController alloc] init];
//                    deviceAlarmVC.deviceModel = self.modelDevice;
//                    [self.navigationController pushViewController:deviceAlarmVC animated:YES];
//                    [deviceAlarmVC release];
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//选中的事件，开关的
- (void)JVCOEMCELLClickCallBack:(int)indexType idObject:(id)object
{
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    if (indexType == JVCOEMCellType_PNMode) {
        if ([object isKindOfClass:[DCRoundSwitch class]]) {
            DCRoundSwitch *switchCell = (DCRoundSwitch *)object;
                
            JVCCloudSEENetworkHelper *netWorkObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
            
           [netWorkObj RemoteOperationSendDataToDevice:self.nLocalChannel remoteOperationType:TextChatType_setDevicePNMode remoteOperationCommand:switchCell.on];
        
        }
    }
}


/**
 *  时区按下的回调
 *
 *  @param index 选中的时区
 */
- (void)setDeviceFlashModelWithIndex:(int)index
{
    
    NSString *defaultString = [self.dicDeviceContent objectForKey:(NSString *)kDeviceFlashMode];
    
    if (defaultString.intValue !=index) {

    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    JVCCloudSEENetworkHelper *netWorkObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    [netWorkObj RemoteOperationSendDataToDevice:self.nLocalChannel remoteOperationType:TextChatType_setDeviceFlashMode remoteOperationCommand:index];
    }
}

#pragma mark 刷新
/**
 *  刷新显示状态
 *
 *  @param dic 收到的字典状态
 */
- (void)updateOemTableView:(NSMutableDictionary *)dic
{
    [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
    self.dicDeviceContent = dic;
    
    [self.tableView reloadData];
    
}

//获取时区
- (NSString *)getCurrentTimerZoneWithCelltag:(int)cellTag
{
    NSString *timerZone = nil;

    NSString *keyValue = [self.dicDeviceContent objectForKey:[arrayDicKey objectAtIndex:cellTag]];
    
    if (keyValue !=nil) {
        
        NSMutableArray *_arrTimeZoneList = [[NSMutableArray alloc] initWithCapacity:10];
        
        for (int i = 0; i<25; i++) {
            
            NSMutableDictionary *tdic = [[NSMutableDictionary alloc] init];
            
            int timeInfo = 12 -i;
            
            NSString *tStr = [NSString stringWithFormat:@"HomeTimeZone_%d",i+1];
            [tdic setObject:LOCALANGER(tStr) forKey:KTIMEZOME];
            
            [tdic setObject:[NSNumber numberWithInt:timeInfo] forKey:KTIMEINFO];
            
            [_arrTimeZoneList addObject:tdic];
            
            [tdic release];
        }
        
        for (NSDictionary *tdic in _arrTimeZoneList) {
            
            NSNumber *currentTimer = [tdic objectForKey: KTIMEINFO];
            
            if (currentTimer.intValue == keyValue.intValue) {
                
                timerZone = [tdic objectForKey:KTIMEZOME];
            }
        }
        
        [_arrTimeZoneList release];
        
    }
    
    return timerZone;

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
