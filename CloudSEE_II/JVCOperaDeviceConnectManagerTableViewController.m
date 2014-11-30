//
//  JVCOperaDeviceConnectManagerTableViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/28/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//
//static NSString const *kDeviceMotionDetecting     =  @"bMDEnable";        //移动侦测
//static NSString const *kDeviceAlarm               =  @"bAlarmEnable";     //安全防护
//static NSString const *kDeviceAlarmTime0          =  @"alarmTime0";       //安全防护时间段

#import "JVCOperaDeviceConnectManagerTableViewController.h"
#import "JVCRGBHelper.h"
#import "JVCRGBColorMacro.h"
#import "JVCDeviceModel.h"
#import "JVCOperationDeviceAlarmTimerViewController.h"
#import "JVCCloudSEENetworkHelper.h"
#import "JVCAlarmManagerHelper.h"

@interface JVCOperaDeviceConnectManagerTableViewController ()
{
    NSMutableArray *arrayFootList;
    NSMutableArray *arrayContentList;
    BOOL            nDevieAlarmState;
    JVCAlarmManagerHelper *alarmManagerHelp;
}

@end

@implementation JVCOperaDeviceConnectManagerTableViewController
@synthesize deviceDic;
@synthesize nLocalChannel;
static const int KFootViewMAXHeight = 500;//最大值
static const int KFootViewMAXWith   = 280;//最大值
static const int KLabelOriginX      = 20;//origin
static const int KLabelFontSize     = 12;//字体大小
static const int KFootViewAdd       = 30;//多添加的位置


-(id)init {

    if (self = [super init]) {
        
        NSMutableDictionary *mdInfo = [[NSMutableDictionary alloc] initWithCapacity:10];
        self.deviceDic              = mdInfo;
        [mdInfo release];
    }

    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = LOCALANGER(@"jvc_alarmmanage_title");
    
    [self initArrayList];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    alarmManagerHelp = [[JVCAlarmManagerHelper alloc] init:self.nLocalChannel];
    
    [self initLayoutWithStatus];
    
}

/**
 *  初始化按钮的一些状态
 */
-(void)initLayoutWithStatus {
    
    if (arrayContentList.count < 3) {
        
        return;
    }
    
    NSString *strDeviceAlarmStatus = [self.deviceDic objectForKey:[arrayContentList objectAtIndex:0]];
    
    if (strDeviceAlarmStatus) {
        
        nDevieAlarmState = strDeviceAlarmStatus.intValue;
    }
    
//    NSString *strDeviceAlarmTime = [self.deviceDic objectForKey:[arrayContentList objectAtIndex:2]];
//    
//    if (strDeviceAlarmTime) {
//        
//        NSArray          *times         = [strDeviceAlarmTime componentsSeparatedByString:@"-"];
//        
//        JVCSystemUtility *systemUtility = [JVCSystemUtility shareSystemUtilityInstance];
//        
//        if (times.count ==2) {
//            
//            NSDate *dateBegin = [systemUtility strHoursConvertDateHours:[times objectAtIndex:0]];
//            NSDate *dateEnd   = [systemUtility strHoursConvertDateHours:[times objectAtIndex:1]];
//            DDLogVerbose(@"%@---$$$$$$$$$----%@",[times objectAtIndex:0],[times objectAtIndex:1]);
//            [self.deviceDic setObject:[NSString stringWithFormat:@"%@-%@",dateBegin,dateEnd] forKey:[arrayContentList objectAtIndex:2]];
//        }
//    }
}

/**
 *  刷新视图
 */
-(void)refreshInfo{

    [self initLayoutWithStatus];
    [self.tableView reloadData];
}

- (void)initArrayList
{

    arrayFootList       = [[NSMutableArray alloc] init];
    
    [arrayFootList addObject:LOCALANGER(@"JVCOperationDeviceConnectManagerSafeStateFoot")];
    [arrayFootList addObject:LOCALANGER(@"JVCOperationDeviceConnectManagerSafeTimerdurationFoot")];
    [arrayFootList addObject:LOCALANGER(@"JVCOperationDeviceConnectManagerSafeMoveAttentionFoot")];
    
    arrayContentList    = [[NSMutableArray alloc] init];
    [arrayContentList    addObject:(NSString *)kDeviceAlarm ];
    [arrayContentList    addObject:(NSString *)kDeviceMotionDetecting];
    [arrayContentList    addObject:(NSString *)kDeviceAlarmTime0];
}



- (void)dealloc
{
    [alarmManagerHelp release];
    [arrayFootList release];
    [deviceDic     release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (nDevieAlarmState ) {
        
        return arrayFootList.count;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"cellIndentify";
    
    JVCOperDevConManagerCell *cell = (JVCOperDevConManagerCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (cell == nil) {
        
        cell = [[[JVCOperDevConManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tag = indexPath.row;
    NSString  *switchState    = [self.deviceDic objectForKey:[arrayContentList objectAtIndex:indexPath.section]];
    cell.deviceDelegate = self;
    
    [cell  updateCellContentWithIndex:indexPath.section safeTimer:[self.deviceDic objectForKey:(NSString *)kDeviceAlarmTime0] andSwitchState:switchState.intValue];
    
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

//static NSString const *kDeviceMotionDetecting     =  @"bMDEnable";        //移动侦测
//static NSString const *kDeviceAlarm               =  @"bAlarmEnable";     //安全防护
//static NSString const *kDeviceAlarmTime0          =  @"alarmTime0";       //安全防护时间段
//static NSString const *kDeviceAlarmStart          =  @"dayStart";           //开始时间
//static NSString const *kDeviceAlarmEnd            =  @"dayEnd";
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == JVCOperaDevConManagerCellTypeTimerDuration) {
        
        JVCOperationDeviceAlarmTimerViewController *deviceAlarm = [[JVCOperationDeviceAlarmTimerViewController alloc] init];
        deviceAlarm.alarmStartTimer = [self.deviceDic objectForKey:(NSString *)kDeviceAlarmStart];
        deviceAlarm.alarmEndTimer   = [self.deviceDic objectForKey:(NSString *)kDeviceAlarmEnd];
        [self.navigationController pushViewController:deviceAlarm animated:YES];
        [deviceAlarm                release];

    }
}

///**
// *  获取报警时间
// *
// *  @return 报警时间
// */
//- (NSString *)getAlarmDuration
//{
//    NSString * [NSString stringWithFormat:@"%@",[self.deviceDic objectForKey:(NSString *)kDeviceAlarmTime0]]];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSString *StringTitile = [arrayFootList objectAtIndex:section];
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.text = StringTitile;
   
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.textAlignment = UITextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:KLabelFontSize];
    label.numberOfLines = 0;

    CGSize tSize = LABEL_MULTILINE_TEXTSIZE(label.text, label.font, CGSizeMake(KFootViewMAXWith, KFootViewMAXHeight), label.lineBreakMode);
    [label release];
    return tSize.height+KFootViewAdd;

}


- (void)JVCOperDevConManagerClickCallBack:(int)index switchState:(BOOL)state
{
    DDLogVerbose(@"==%d==%d",index,state);
    
    switch (index) {
        case JVCOperaDevConManagerCellTypeSafe:
        {
//            deviceModel.isDeviceSwitchAlarm = state;
            [alarmManagerHelp setAlarmStatus:state];
            [self.deviceDic setObject:[NSString stringWithFormat:@"%d",state] forKey:[arrayContentList objectAtIndex:JVCOperaDevConManagerCellTypeSafe ]];
            nDevieAlarmState = state;
            [self.tableView reloadData];
    
        }
            break;
        case JVCOperaDevConManagerCellTypeMoventAttention:
        {
            [alarmManagerHelp setMotionDetecting:state];
        }
            break;
            
        default:
            break;
    }
}

- (void)updateTableView:(NSMutableDictionary *)dic
{
    self.deviceDic = dic;
    
    nDevieAlarmState = [[self.deviceDic objectForKey:[arrayContentList objectAtIndex:0]] intValue];
    
    [self.tableView reloadData];

}


/**
 *  必须要有，重写父类的去除cell上面的内容
 */
- (void)deallocWithViewDidDisappear
{

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
