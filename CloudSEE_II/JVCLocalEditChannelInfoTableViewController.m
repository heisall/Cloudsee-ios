//
//  JVCLocalEditChannelInfoTableViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/14/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCLocalEditChannelInfoTableViewController.h"
#import "JVCChannelScourseHelper.h"
#import "JVCDeviceSourceHelper.h"

@interface JVCLocalEditChannelInfoTableViewController ()

@end

@implementation JVCLocalEditChannelInfoTableViewController

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
    self.tableView.delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  修改通道昵称的方法
 */
- (void)handlePredicatChannelNickNameSuccess:(NSString *)channelName
{
    
    int result =  [[JVCChannelScourseHelper shareChannelScourseHelper] editLocalChannelNickName:channelName channelIDNum:self.channelModel.iLocalIdNum];
    
    [self handleEdicteNickNameSuccessResult:!result];
        
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JVCChannelModel *deleteChannelModel = [self.arrayChannelsList objectAtIndex:indexPath.row];
    
    if (arrayChannelsList.count == 1) {//如果只有一个通道了，删除通道相当于删除设备
        
        [self deleteDeviceWhenNoChannels:deleteChannelModel];
        
    }else{//删除通道
        
      BOOL result =   [[JVCChannelScourseHelper shareChannelScourseHelper] deleteLocalChannelWithId:deleteChannelModel.iLocalIdNum];
        
        [self handleDeleteChannelResult:!result deleteModel:deleteChannelModel];
    }
    
}

/**
 *  删除设备，如果没有通道的时候
 */
- (void)deleteDeviceWhenNoChannels:(JVCChannelModel *)channelModelDelete
{
    
    [[JVCChannelScourseHelper shareChannelScourseHelper]deleteLocalChannelWithId:channelModelDelete.iLocalIdNum];
    BOOL result =[[JVCDeviceSourceHelper shareDeviceSourceHelper] deleteLocalDeviceInfo:channelModelDelete.strDeviceYstNumber];
        
    [self handleDeleteDeviceWithNoChannel:!result channelModel:channelModelDelete];

}

/**
 *  添加通道方法
 */
- (void)addDeviceChannlesMaths
{
    [[JVCChannelScourseHelper shareChannelScourseHelper] addLocalChannelsWithDeviceModel:self.YstNum];
    
    //刷新列表
    [self updateTableview];
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
