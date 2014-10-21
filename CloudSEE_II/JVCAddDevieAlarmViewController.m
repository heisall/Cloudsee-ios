//
//  JVCAddDevieAlarmViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/20/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAddDevieAlarmViewController.h"

@interface JVCAddDevieAlarmViewController ()
{
    NSMutableArray *arrayAlarmList;
}

@end

@implementation JVCAddDevieAlarmViewController
static const  int KHeadViewHeight  = 40;//headview的高度
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
    
    
}

/**
 *  初始化arraylist
 */
- (void)initArrayList
{
       arrayAlarmList = [[NSMutableArray alloc] init];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"cellIndentiyf";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    
    if (cell==nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify] autorelease];
    }
    
    for (UIView *contentView in cell.contentView.subviews) {
        [contentView removeFromSuperview];
    }
    
//    //摄像头
//    NSString *pathImage = [UIImage imageBundlePath:@"edi_camer.png" ];
//    UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathImage];
//    UIImageView *canmerImage = [[UIImageView alloc] initWithFrame:CGRectMake(kOffSet_x, (cell.height-image.size.height)/2,image.size.width, image.size.height)];
//    [canmerImage setImage:image];
//    [cell.contentView addSubview:canmerImage];
//    [canmerImage release];
//    
//    //textField
//    JVCChannelModel *tCellNode = [arrayChannelsList objectAtIndex:indexPath.row];
//    UILabel *channelNickNameLab = [[UILabel alloc] initWithFrame:CGRectMake(kOffSet_x+kSeperate+canmerImage.frame.size.width, canmerImage.frame.origin.y, kChannelTextFieldWith, image.size.height)];
//    channelNickNameLab.tag = kChannelTextFieldTag;
//    channelNickNameLab.text = tCellNode.strNickName;
//    channelNickNameLab.enabled = NO;
//    //     channelNickNameFid.returnKeyType = UIReturnKeyDone;
//    channelNickNameLab.font = [UIFont systemFontOfSize:KChannelTextFieldFont];
//    channelNickNameLab.backgroundColor = [UIColor clearColor];
//    [cell.contentView addSubview:channelNickNameLab];
//    [channelNickNameLab release];
//    
//    [image release];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.channelModel =  [arrayChannelsList objectAtIndex:indexPath.row];
//    channelNickNameField.text = channelModel.strNickName ;
//    [self.tableView setContentOffset:CGPointZero];
//    [self tranfromanimation];
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



@end
