//
//  JVCWiredInputInfoTableViewController.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-13.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCWiredInfoTableViewController.h"

@class JVCWiredInputInfoTableViewController;

/**
 *  保存网路配置的事件
 *
 *  @param jvcWiredInfoTableViewController
 */
typedef void (^JVCWiredInputInfoTableViewSaveBlock)(NSString *strIp,NSString *strSubnetMask,NSString *strDefaultGateway,NSString *strDns);

@interface JVCWiredInputInfoTableViewController : JVCWiredInfoTableViewController

@property (nonatomic,copy) JVCWiredInputInfoTableViewSaveBlock  wiredInfoTableViewSaveBlock;

@end
