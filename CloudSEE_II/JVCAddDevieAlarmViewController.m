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
@interface JVCAddDevieAlarmViewController ()
{
    NSMutableArray *arrayAlarmList;
}

@end

@implementation JVCAddDevieAlarmViewController
@synthesize localChannelNum;
static const  int KHeadViewHeight  = 20;//headview的高度
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
    
    [self initArrayList];
        
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
}

/**
 *  初始化arraylist
 */
- (void)initArrayList
{
       arrayAlarmList = [[NSMutableArray alloc] init];
    
    for(int i =0;i<3;i++)
    {
        JVCLockAlarmModel*moeld = [[JVCLockAlarmModel alloc] init];
        moeld.alarmGuid = [NSString stringWithFormat:@"%d",i];
        moeld.alarmName = @"124";
        moeld.alarmType = 1;
        moeld.alarmState = YES;

        [arrayAlarmList addObject:moeld];
        [moeld release];
    }
    
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrayAlarmList.count==0?1:arrayAlarmList.count;
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
    
    if (arrayAlarmList.count == 0) {
        
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
        JVCLockAlarmModel *cellModel = [arrayAlarmList objectAtIndex:indexPath.section];
        [cell initAlarmAddTableViewContentView:cellModel];
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrayAlarmList.count == 0) {//没有设备
        
        if (indexPath.section == 0) {//跳转到添加界面
            [self addLockDeviceViewController];
        }
    }
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    JVCLockAlarmModel *model = [];
//}


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
    [self.navigationController pushViewController:lockAddVC animated:YES];
    [lockAddVC release];
}


/**
 *  断开远程连接方法
 */
- (void)disAlarmRemoteLink
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        ystNetWorkHelperObj.ystNWHDelegate = nil;
        
        [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] disconnect:1];
    });
}
@end
