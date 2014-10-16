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
#import "JVCDeviceMacro.h"
#import "JVCAlarmMacro.h"
#import "JVCSignleAlarmDisplayView.h"

@interface JVCAlarmMessageViewController ()
{
    NSMutableArray *arrayAlarmList;
}

@end

@implementation JVCAlarmMessageViewController
static const int KSUCCESS = 0;//成功

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
    /**
     *  放到异步线程里面
     */
   id result =  [[JVCDeviceHelper sharedDeviceLibrary]getAccountByDeviceAlarmList:0];
    
    if ([result isKindOfClass:[NSDictionary class]]) {//是字典类型的
        
        NSDictionary *resultDic = (NSDictionary *)result;
        
        if ([[resultDic objectForKey:DEVICE_JSON_RT] intValue ] == KSUCCESS) {//成功
            
            NSArray *arrayList = [resultDic objectForKey:JK_ALARM_INFO];
            
            for (NSDictionary *tdic in arrayList) {
                
                JVCAlarmModel *model = [[JVCAlarmModel alloc] initAlarmModelWithDictionary:tdic];
                
                [arrayAlarmList addObject:model];
               // [model release];
                
            
            }
            [self.tableView reloadData];
            
        }else{
            [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:@"获取报警信息失败"];
        }
    }
    
    [self.tableView performSelector:@selector(headerEndRefreshing) withObject:nil afterDelay:1];

}

#pragma mark tableview的
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayAlarmList.count;
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
    JVCAlarmModel *modelcell = [arrayAlarmList objectAtIndex:indexPath.row];
    [cell initAlermCell:modelcell];
    [modelcell release];

    // Configure the cell...

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JVCAlarmModel *cellModel = [arrayAlarmList objectAtIndex:indexPath.section];
    JVCAlarmCell *homecell = (JVCAlarmCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageViewNew = (UIImageView *)[homecell.contentView viewWithTag:10005];
    [imageViewNew removeFromSuperview];
    
//    if (!cellModel.iFlag) {
//        
//        if (reduceTabbarDelegate !=nil &&[reduceTabbarDelegate respondsToSelector:@selector(reduceTabbarCountCallBack)]) {
//            
//            [reduceTabbarDelegate reduceTabbarCountCallBack];
//        }
//        
//    }
//    cellModel.iFlag = YES;
    
    //    if (cellModel.strAlarmLocalPicURL) {
    //        ShowAlertImageViewController *showImage = [[ShowAlertImageViewController alloc] init];
    //        showImage._modelAlarm = cellModel;
    //        showImage.hidesBottomBarWhenPushed = YES;
    //        [delegate._popViewCon.navigationController pushViewController:showImage animated:YES];
    //        [showImage release];
    //
    //    }else{
    //        [OperationSet showText:LOCALANGER(@"home_no_picture") andPraent:self andTime:1 andYset:0];
    //    }
    //获取视频url
//    [self getVideoUrlWithAlertModel:cellModel];
    
    //弹出图片
    [self showJVHAlarmVideoWithModel:cellModel];

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


- (void)showJVHAlarmVideoWithModel:(JVCAlarmModel *)model
{
    [model retain];
    
    JVCSignleAlarmDisplayView *alarmView = [[JVCSignleAlarmDisplayView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    alarmView.tag = 138354;
    alarmView.tAlarmModel = model;
    alarmView.palyVideoDelegate = self;
    [alarmView initView];
    
    CABasicAnimation *forwardAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    forwardAnimation.duration = 1;
    forwardAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5f :1.7f :0.6f :0.85f];
    forwardAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    forwardAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:forwardAnimation, nil];
    animationGroup.delegate = self;
    animationGroup.duration = forwardAnimation.duration + 1;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    static NSString * const kAddAnimation = @"kAddAnimation";
    
    [self.view.window addSubview:alarmView];
    [alarmView.layer addAnimation:animationGroup forKey:kAddAnimation];
    
    [alarmView showToastAlert];
    
    [alarmView release];
    
    [model release];
 
}

-(void)removeJVHAlarmShowView
{
    JVCSignleAlarmDisplayView *viewContent = (JVCSignleAlarmDisplayView *)[self.view.window viewWithTag:138354];
    if (viewContent) {
        [viewContent removeFromSuperview];
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
