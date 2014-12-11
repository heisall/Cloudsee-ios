//
//  JVCOperaitonDeviceListTableViewViewController.h
//  CloudSEE_II
//
//  Created by David on 14/12/10.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "JVCBaseGeneralTableViewController.h"
#import "JVCDeviceModel.h"

@interface JVCOperaitonDeviceListTableViewViewController : JVCBaseGeneralTableViewController
{
    NSMutableDictionary *dicDeviceContent;
    
    JVCDeviceModel      *modelDevice;
    
    int                  nLocalChannel;
    
    BOOL                 bNewIpcState;
}
@property(nonatomic,assign) NSMutableDictionary *dicDeviceContent;
@property(nonatomic,retain) JVCDeviceModel      *modelDevice;
@property(nonatomic,assign) int                  nLocalChannel;
@property(nonatomic,assign) BOOL                 bNewIpcState;
- (void)updateOemTableView:(NSMutableDictionary *)dic;
@end
