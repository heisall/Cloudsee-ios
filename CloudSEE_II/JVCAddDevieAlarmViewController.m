//
//  JVCAddDevieAlarmViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/20/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAddDevieAlarmViewController.h"
#import "JVCDeviceAlarmNoDeviceTableViewCell.h"
#import "JVDeviceCAlarmAddTableViewCell.h"
#import "JVCLockAlarmModel.h"
#import "JVCAddLockDeviceViewController.h"
#import "JVCCloudSEENetworkMacro.h"
#import "JVCCloudSEENetworkHelper.h"
#import "JVCAlarmMacro.h"
#import "JVCEditLockDeviceNickNameViewController.h"
@interface JVCAddDevieAlarmViewController ()
{
    int delegateRow;
    
    int selectRow;
}

@end

@implementation JVCAddDevieAlarmViewController
@synthesize localChannelNum;
@synthesize arrayAlarmList;
static const  int KHeadViewHeight  = 20;//headview的高度
static const  int KSuccess         = 1;

@synthesize delegateAddArm;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"报警设置";
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加按钮
    UIImage *imageRight = [UIImage imageNamed:@"dev_add.png"];
    UIButton *RightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, imageRight.size.width, imageRight.size.height)];
    [RightBtn setImage:imageRight forState:UIControlStateNormal];
    [RightBtn addTarget:self action:@selector(addLockDeviceViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:RightBtn];
    self.navigationItem.rightBarButtonItem=rightBarBtn;
    [RightBtn release];
    [rightBarBtn release];

    
}
- (void)BackClick
{
    [self disAlarmRemoteLink];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayAlarmList.count==0?1:self.arrayAlarmList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.arrayAlarmList.count == 0) {
        
        static NSString *cellIndentify = @"cellIndentiyNoDevice";
        JVCDeviceAlarmNoDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
        if (cell==nil) {
            cell = [[[JVCDeviceAlarmNoDeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify] autorelease];
        }
        [cell initTableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
    
        static NSString *cellIndentify = @"cellIndentiyf";
        
        JVDeviceCAlarmAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
        
        if (cell==nil) {
            
            cell = [[[JVDeviceCAlarmAddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify] autorelease];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        JVCLockAlarmModel *cellModel = [self.arrayAlarmList objectAtIndex:indexPath.section];
        [cell initAlarmAddTableViewContentView:cellModel];
        [cell.switchDevcie addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
        cell.switchDevcie.tag = indexPath.section;

        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arrayAlarmList.count == 0) {//没有设备
        
        if (indexPath.section == 0) {//跳转到添加界面
            [self addLockDeviceViewController];
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    delegateRow = indexPath.section;
    
    JVCLockAlarmModel *model = [self.arrayAlarmList objectAtIndex:indexPath.section];
    
    JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    ystNetWorkHelperObj.ystNWRODelegate                      = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper *netWorkHelper = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        netWorkHelper.ystNWTDDelegate = self;
        
          [ystNetWorkHelperObj RemoteDeleteDeviceAlarm:AlarmLockChannelNum withAlarmType:model.alarmType withAlarmGuid:model.alarmGuid];

        
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
                
                break;
            case TextChatType_deleteAlarm://删除报警的
                [self handleDelegateDeviceAlarmResult:objYstNetWorkHelpSendData];
                break;
            case TextChatType_editAlarm:
                [self handleEditSwithchResult:objYstNetWorkHelpSendData];
            break;
            default:
                break;
        }
        
    });
    
}

- (void)handleDelegateDeviceAlarmResult:(id)result
{
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *tdic = (NSDictionary *)result;
        
        int responResult = [[tdic objectForKey:Alarm_Lock_RES] integerValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            switch (responResult) {
                case AlarmLockTypeRes_OK:
                    [self handleDeletateSuccessResult];
                    break;
                case AlarmLockTypeRes_Fail:
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"删除失败"];
                    break;
                default:
                    break;
            }
            
        });
        
        
    }else{
        
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"删除失败"];
        
    }
}

- (void)handleEditSwithchResult:(id)result
{
    JVCLockAlarmModel *model = [self.arrayAlarmList objectAtIndex:selectRow];
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *tdic = (NSDictionary *)result;
        
        int responResult = [[tdic objectForKey:Alarm_Lock_RES] integerValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            switch (responResult) {
                case AlarmLockTypeRes_OK:
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"修改成功"];

                    model.alarmState = ! model.alarmState;
                    break;
                case AlarmLockTypeRes_Fail:
                {
                    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"修改失败"];
                    
                    JVDeviceCAlarmAddTableViewCell *cell =(JVDeviceCAlarmAddTableViewCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectRow]];
                    cell.switchDevcie.on =!cell.switchDevcie.on;

                }
                    break;
                default:
                    break;
            }
            
        });
        
        
    }else{
        
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"修改失败"];
        
        JVDeviceCAlarmAddTableViewCell *cell =(JVDeviceCAlarmAddTableViewCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectRow]];
        cell.switchDevcie.on =!cell.switchDevcie.on;
        
    }
}

- (void)handleDeletateSuccessResult
{
    [self.arrayAlarmList removeObjectAtIndex:delegateRow];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KHeadViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, KHeadViewHeight)] autorelease];
    //    UILabel *labelTimer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headView.frame.size.height)];
    //    labelTimer.backgroundColor = [UIColor clearColor];
    //    JDCSAppDelegate *delegate = (JDCSAppDelegate *)[UIApplication sharedApplication].delegate;
    //    alarmModel *tcellModel = [delegate._dealNotificationArray objectAtIndex:section];
    //    labelTimer.textAlignment = UITextAlignmentCenter;
    //    labelTimer.text = tcellModel.strAlarmTime;
    //    labelTimer.textColor =  SETLABLERGBCOLOUR(61.0, 115.0, 175.0);
    //    [labelTimer setFont:[UIFont systemFontOfSize:14]];
    //    [headView addSubview:labelTimer];
    //    [labelTimer release];
    return headView;
    
}

- (void)addLockDeviceViewController
{
    JVCAddLockDeviceViewController *lockAddVC = [[JVCAddLockDeviceViewController alloc] init];
    lockAddVC.addLockDeviceDelegate = self;
    [self.navigationController pushViewController:lockAddVC animated:YES];
    [lockAddVC release];
}

/**
 *  绑定设备成功的回调
 *
 *  @param tdic 设备的字典
 */
- (void)AddLockDeviceSuccessCallBack:(NSDictionary *)tdic
{
    [self.navigationController popViewControllerAnimated:NO];
    
    JVCLockAlarmModel *model = [[JVCLockAlarmModel alloc] initAlarmLockModelWithDictionary:tdic];
    [self.arrayAlarmList insertObject:model atIndex:0];
    
    JVCEditLockDeviceNickNameViewController *editVC = [[JVCEditLockDeviceNickNameViewController alloc] init];
    editVC.alertmodel = model;
    [self.navigationController pushViewController:editVC animated:YES];
    [editVC release];
        
}

- (void)switchValueChange:(UISwitch *)switchSelect
{
    selectRow = switchSelect.tag;
    
    JVCLockAlarmModel *model = [self.arrayAlarmList objectAtIndex:switchSelect.tag];
    
    JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
    
    ystNetWorkHelperObj.ystNWRODelegate                      = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper *netWorkHelper = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        netWorkHelper.ystNWTDDelegate = self;
        
        [ystNetWorkHelperObj RemoteEditDeviceAlarm:AlarmLockChannelNum withAlarmType:model.alarmType withAlarmGuid:model.alarmGuid withAlarmEnable:switchSelect.on withAlarmName:model.alarmName];
        
        
    });
    

}

/**
 *  断开远程连接方法
 */
- (void)disAlarmRemoteLink
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        ystNetWorkHelperObj.ystNWHDelegate = nil;
        
        [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] disconnect:AlarmLockChannelNum];
    });
}
@end
