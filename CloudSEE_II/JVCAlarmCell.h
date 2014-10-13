//
//  JVCAlarmCell.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JVCAlarmModel;
@interface JVCAlarmCell : UITableViewCell

/**
 *  初始化cellview
 */
- (void)initAlermCell:(JVCAlarmModel *)model;

@end
