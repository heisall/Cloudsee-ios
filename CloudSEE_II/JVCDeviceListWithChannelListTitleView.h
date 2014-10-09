//
//  JVCDeviceListWithChannelListTitleView.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-28.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseRgbBackgroundColorView.h"

@interface JVCDeviceListWithChannelListTitleView : JVCBaseRgbBackgroundColorView {

    int nChannelValueWithIndex;  //通道号在通道集合中的索引
}

@property (nonatomic,assign) int nChannelValueWithIndex;

/**
 *  初始化标签视图
 *
 *  @param title 标题
 */
-(void)initWithTitleView:(NSString *)title ;

@end
