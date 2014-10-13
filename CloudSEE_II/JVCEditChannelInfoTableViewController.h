//
//  JVCEditChannelInfoTableViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/9/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseGeneralTableViewController.h"

@interface JVCEditChannelInfoTableViewController : JVCBaseGeneralTableViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *YstNum;
}


@property(nonatomic,retain)NSString *YstNum;//通道数组


@end
