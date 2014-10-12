//
//  JVCDeviceListNoDevieCell.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  enum{
    DEVICECLICKTYpe_Wire        =0,//有限设备
    DEVICECLICKTYpe_WireLess    =1,//无线限设备

}DEVICECLICKTYpe;
@protocol addDeviceDelegate <NSObject>

/**
 *  选中设备类型
 */
- (void)addDeviceTypeCallback:(int)linkType;

@end

@interface JVCDeviceListNoDevieCell : UITableViewCell
{
    id<addDeviceDelegate>addDelegate;
}
@property(nonatomic,assign)    id<addDeviceDelegate>addDelegate;

/**
 *  初始化cell
 */
- (void)initContentCellWithHeigint:(CGFloat)frameHeight;

@end
