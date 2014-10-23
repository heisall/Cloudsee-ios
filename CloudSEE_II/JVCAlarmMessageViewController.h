//
//  JVCAlarmMessageViewController.h
//  JVCEditDevice
//
//  Created by chenzhenyang on 14-9-24.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseGeneralTableViewController.h"
#import "JVCCloudSEENetworkHelper.h"

@interface JVCAlarmMessageViewController : JVCBaseGeneralTableViewController <ystNetWorkHelpDelegate,ystNetWorkHelpRemotePlaybackVideoDelegate>
{
    int bStateReload;
    
    NSMutableArray *arrayAlarmList;
}
@property(nonatomic,retain) NSMutableArray *arrayAlarmList;

@end
