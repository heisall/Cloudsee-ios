//
//  JVCDeviceListAdvertCell.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/24/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
static const int             kTableViewCellAdeviceHeigit             = 140;   //广告条的高度

@interface JVCDeviceListAdvertCell : UITableViewCell<UIScrollViewDelegate>

/**
 *  初始化cell
 */
- (void)initCellContent;

@end
