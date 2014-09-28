//
//  JVCEditViewControllerDropListViewCell.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-26.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JVCEditViewControllerDropListViewCell : UITableViewCell

/**
 *  初始化单个设备视图
 */
-(void)initWithLayoutView:(NSString *)titleName;

/**
 *  设置当前选中行
 *
 *  @param selected 是否选中
 */
-(void)setViewSelectedView:(BOOL)selected;
@end
