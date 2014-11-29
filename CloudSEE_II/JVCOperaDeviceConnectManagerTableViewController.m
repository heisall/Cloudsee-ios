//
//  JVCOperaDeviceConnectManagerTableViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/28/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCOperaDeviceConnectManagerTableViewController.h"
#import "JVCOperDevConManagerCell.h"
#import "JVCRGBHelper.h"
#import "JVCRGBColorMacro.h"
#import "JVCDeviceModel.h"
#import "JVCOperationDeviceAlarmTimerViewController.h"
@interface JVCOperaDeviceConnectManagerTableViewController ()
{
    NSMutableArray *arrayFootList;
}

@end

@implementation JVCOperaDeviceConnectManagerTableViewController
@synthesize deviceModel;
static const int KFootViewMAXHeight = 500;//最大值
static const int KFootViewMAXWith   = 280;//最大值
static const int KLabelOriginX      = 20;//origin
static const int KLabelFontSize     = 12;//字体大小
static const int KFootViewAdd       = 30;//多添加的位置


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = LOCALANGER(@"jvc_alarmmanage_title");
    [self initArrayList];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
}

- (void)initArrayList
{

    arrayFootList       = [[NSMutableArray alloc] init];
    [arrayFootList addObject:LOCALANGER(@"JVCOperationDeviceConnectManagerSafeStateFoot")];
    [arrayFootList addObject:LOCALANGER(@"JVCOperationDeviceConnectManagerSafeTimerdurationFoot")];
    [arrayFootList addObject:LOCALANGER(@"JVCOperationDeviceConnectManagerSafeMoveAttentionFoot")];

}



- (void)dealloc
{
    [arrayFootList release];
    [deviceModel release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (deviceModel.isDeviceSwitchAlarm) {
        
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
    cell.deviceDelegate = self;
    [cell  updateCellContentWithIndex:indexPath.section safeTimer:@"08:00-10:12"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == JVCOperaDevConManagerCellTypeTimerDuration) {
        
        JVCOperationDeviceAlarmTimerViewController *deviceAlarm = [[JVCOperationDeviceAlarmTimerViewController alloc] init];
        deviceAlarm.alarmStartTimer = @"00:00";
        deviceAlarm.alarmEndTimer   = @"23:23";
        [self.navigationController pushViewController:deviceAlarm animated:YES];
        [deviceAlarm                release];

    }
}

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
            deviceModel.isDeviceSwitchAlarm = state;
            [self.tableView reloadData];
        }
            break;
        case JVCOperaDevConManagerCellTypeTimerDuration:
        {
            JVCOperationDeviceAlarmTimerViewController *deviceAlarm = [[JVCOperationDeviceAlarmTimerViewController alloc] init];
            deviceAlarm.alarmStartTimer = @"12:12";
            deviceAlarm.alarmEndTimer   = @"23:23";
            [self.navigationController pushViewController:deviceAlarm animated:YES];
            [deviceAlarm                release];
        }
            break;
        case JVCOperaDevConManagerCellTypeMoventAttention:
        {
     
        }
            break;
            
        default:
            break;
    }
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
