//
//  JVCMoreContentCell.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVCMoreSettingModel.h"

@interface JVCMoreContentCell : UITableViewCell

/**
 *  根据model初始化
 *
 *  @param model mode类型数据
 */
- (void)initContentCells:(JVCMoreSettingModel *)model;

@end
