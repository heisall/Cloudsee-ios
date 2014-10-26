//
//  JVCDemoCell.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/14/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
static const  int  KCellHeight  = 225;//邓静给的值
@class JVCDeviceModel;
@interface JVCDemoCell : UITableViewCell
{
    UIImageView *imageView;
}
@property(nonatomic,assign)UIImageView *imageView;
/**
 *  初始化cell
 */
- (void)initCellWithModel:(JVCDeviceModel *)model;

@end
