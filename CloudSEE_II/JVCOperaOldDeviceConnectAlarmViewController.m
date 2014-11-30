//
//  JVCOperaOldDeviceConnectAlarmViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCOperaOldDeviceConnectAlarmViewController.h"
#import "JVCCloudSEENetworkMacro.h"
#import "JVCOperDevConManagerCell.h"
#import "JVCRGBHelper.h"
#import "JVCDeviceHelper.h"

@interface JVCOperaOldDeviceConnectAlarmViewController ()
{
    NSMutableArray *arrayFootList;
    
    NSMutableArray *arrayContentList;
    
    BOOL           showAlertState;
    
}

@end

@implementation JVCOperaOldDeviceConnectAlarmViewController
@synthesize deviceModel;

static const int KFootViewMAXHeight = 500;//最大值
static const int KFootViewMAXWith   = 280;//最大值
static const int KLabelOriginX      = 20;//origin
static const int KLabelFontSize     = 12;//字体大小
static const int KFootViewAdd       = 30;//多添加的位置
static const CGFloat         kAlertTostViewTime                   = 2.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initOldDeviceArrayList];
    self.title = LOCALANGER(@"jvc_alarmmanage_title");

    showAlertState = self.deviceModel.isDeviceSwitchAlarm;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [deviceModel release];
    [super dealloc];
}

- (void)initOldDeviceArrayList
{
    
    arrayFootList       = [[NSMutableArray alloc] init];
    
    [arrayFootList addObject:LOCALANGER(@"JVCOperationDeviceConnectManagerSafeStateFoot")];
//    [arrayFootList addObject:LOCALANGER(@"JVCOperationDeviceConnectManagerSafeTimerdurationFoot")];
//    [arrayFootList addObject:LOCALANGER(@"JVCOperationDeviceConnectManagerSafeMoveAttentionFoot")];
    
    arrayContentList    = [[NSMutableArray alloc] init];
    [arrayContentList    addObject:(NSString *)kDeviceAlarm ];
//    [arrayContentList    addObject:(NSString *)kDeviceMotionDetecting];
//    [arrayContentList    addObject:(NSString *)kDeviceAlarmTime0];
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrayFootList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"cellIndentify";
    
    JVCOperDevConManagerCell *cell = (JVCOperDevConManagerCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (cell == nil) {
        
        cell = [[[JVCOperDevConManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.deviceDelegate = self;
    [cell  updateCellContentWithIndex:indexPath.section safeTimer:@"" andSwitchState:deviceModel.isDeviceSwitchAlarm];
    
    if (indexPath.section == JVCOperaDevConManagerCellTypeTimerDuration) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else{
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIColor *color      = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroLoginGray];
    
    NSString *StringTitile = [arrayFootList objectAtIndex:section];
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.text = StringTitile;
    if (color) {
        label.textColor = color;
    }
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.textAlignment = UITextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:KLabelFontSize];
    label.numberOfLines = 0;
    
    CGSize tSize = LABEL_MULTILINE_TEXTSIZE(label.text, label.font, CGSizeMake(KFootViewMAXWith, KFootViewMAXHeight), label.lineBreakMode);
    label.frame = CGRectMake(KLabelOriginX, KFootViewAdd/2.0, tSize.width, tSize.height);
    
    UIView *bgView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, label.height+KFootViewAdd)] autorelease];
    bgView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:label];
    [label release];
    return bgView;
    
}

/**
 *  改变当前设备的安全防护状态
 */
-(void)safeWithChangeStatus{
    
    int alarmType = DEVICE_ALARTM_SWITCH;
    
    JVCDeviceHelper *deviceHelperObj = [JVCDeviceHelper sharedDeviceLibrary];
    JVCDeviceModel  *model           = self.deviceModel;
    JVCAlertHelper *alertObj        = [JVCAlertHelper shareAlertHelper];
    
    if (!model.bDeviceServiceOnlineState) {
        
        [alertObj alertToastWithKeyWindowWithMessage:NSLocalizedString(@"device_off_line", nil) ];
        return;
    }
    
    
    [alertObj alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int result = [deviceHelperObj controlDeviceOperationSwitchButton:(NSString *)kkUserName deviceGuidStr:model.yunShiTongNum operationType:alarmType switchState:!model.isDeviceSwitchAlarm updateText:nil];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [alertObj alertHidenToastOnWindow];
            
            
            if (result != 0) {
                
                [alertObj alertToastOnWindowWithText:NSLocalizedString(@"operation_error", nil) delayTime:kAlertTostViewTime];
                
            }else{
                
                switch (alarmType) {
                        
                    case DEVICE_ALARTM_SWITCH:{
                        model.isDeviceSwitchAlarm  = !model.isDeviceSwitchAlarm;
                        
                        if (model.isDeviceSwitchAlarm) {
                            
                            [alertObj alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_editDevice_Editbtn_safe_open")];
                        }else{
                            [alertObj alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_editDevice_Editbtn_safe_close")];
                            
                        }
                        break;
                    }
                        
                    default:
                        break;
                }
            }
        });
    });
}

- (void)JVCOperDevConManagerClickCallBack:(int)index switchState:(BOOL)state
{
    DDLogVerbose(@"==%d==%d",index,state);
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    switch (index) {
        case JVCOperaDevConManagerCellTypeSafe:
        {
            [self safeWithChangeStatus];
        }
            break;
//        case JVCOperaDevConManagerCellTypeMoventAttention:
//        {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                
//                [alarmManagerHelp setMotionDetecting:state];
//                
//            });
//        }
//            break;
            
        default:
            break;
    }
    
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
