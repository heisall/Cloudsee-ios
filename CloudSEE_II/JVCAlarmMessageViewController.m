//
//  JVCAlarmMessageViewController.m
//  JVCEditDevice
//  报警
//  Created by chenzhenyang on 14-9-24.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCAlarmMessageViewController.h"
#import "JVCAlarmCell.h"
#import "JVCAlarmModel.h"
#import "JVCDeviceHelper.h"

@interface JVCAlarmMessageViewController ()
{
    NSMutableArray *arrayAlarmList;
}

@end

@implementation JVCAlarmMessageViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        
        UITabBarItem *moreItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"报警消息", nil) image:nil tag:1];
        [moreItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_message_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_message_unselect.png"]];
        self.tabBarItem = moreItem;
        [moreItem release];
        
        self.title = self.tabBarItem.title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrayAlarmList  = [[NSMutableArray alloc] init];
    
    
}

/**
 *  下拉刷新事件
 */
- (void)headerRereshingData
{
    [[JVCDeviceHelper sharedDeviceLibrary]getAccountByDeviceAlarmList:0];
    
    [self.tableView performSelector:@selector(headerEndRefreshing) withObject:nil afterDelay:1];

}

#pragma mark tableview的
#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;//arrayAlarmList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *imageCellBg = [UIImage imageNamed:@"arm_cellbg.png"];
    
    return imageCellBg.size.height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"cellIndentify";
    JVCAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (cell ==nil) {
        
        cell = [[[JVCAlarmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify] autorelease];
    }
    JVCAlarmModel *modelcell = [[JVCAlarmModel alloc] init];
    modelcell.bNewAlarmFlag = YES;
    modelcell.iAlarmType =2;
    modelcell.strALarmDeviceNickName = @"大门口";
    [cell initAlermCell:modelcell];
    [modelcell release];

    // Configure the cell...

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)] autorelease];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)dealloc
{
    [arrayAlarmList release];
    
    [super dealloc];
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
