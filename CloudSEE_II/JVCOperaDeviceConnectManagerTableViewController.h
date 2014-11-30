//
//  JVCOperaDeviceConnectManagerTableViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/28/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseGeneralTableViewController.h"
#import "JVCOperDevConManagerCell.h"

@class JVCDeviceModel;
@interface JVCOperaDeviceConnectManagerTableViewController : JVCBaseGeneralTableViewController <JVCOperDevConManagerDelegate>
{
    NSMutableDictionary *deviceDic;
    int                  nLocalChannel;
}
@property(nonatomic,retain) NSMutableDictionary *deviceDic;
@property(nonatomic,assign) int                  nLocalChannel;

/**
 *  刷新视图
 */
-(void)refreshInfo;

/**
 *  刷新显示状态
 *
 *  @param dic 收到的字典状态
 */
- (void)updateTableView:(NSMutableDictionary *)dic;
@end
