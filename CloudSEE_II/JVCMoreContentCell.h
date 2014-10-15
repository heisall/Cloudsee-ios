//
//  JVCMoreContentCell.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVCMoreSettingModel.h"

@protocol JVCMoreCellSwitchDelegate <NSObject>

/**
 *  修改switch按钮的回调方法
 *
 *  @param state 开关状态
 */
- (void)modifySwitchState:(BOOL)state;

@end

@interface JVCMoreContentCell : UITableViewCell
{
    id<JVCMoreCellSwitchDelegate>delegateSwitch;
}
@property(nonatomic,assign)id<JVCMoreCellSwitchDelegate>delegateSwitch;
/**
 *  根据model初始化
 *
 *  @param model mode类型数据
 */
- (void)initContentCells:(JVCMoreSettingModel *)model;

@end
