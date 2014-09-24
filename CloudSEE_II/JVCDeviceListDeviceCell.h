//
//  JVCDeviceListDeviceCell.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/24/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeviceCellSelectToPlayDelegate <NSObject>

/**
 *  选中要播放的设备的回调
 *
 *  @param selectIndex 选中的播放设备号
 */
- (void)selectDeviceToPlayWithIndex:(int)selectIndex;

@end

@interface JVCDeviceListDeviceCell : UITableViewCell
{
    NSMutableArray *_arrayCellClolors;//存放当前数组的
    
    id<DeviceCellSelectToPlayDelegate>deviceCellDelegate;
}

@property(nonatomic,retain)NSMutableArray *_arrayCellClolors;
@property(nonatomic,assign)id<DeviceCellSelectToPlayDelegate>deviceCellDelegate;
/**
 *  初始化设备列表界面
 */
- (void)initCellContent:(NSMutableArray *)arrayColor;
@end
