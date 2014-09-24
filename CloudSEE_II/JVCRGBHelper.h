//
//  JVCRGBHelper.h
//  JVCEditDevice
//  颜色的助手类，用于获取颜色的rgb值
//  Created by chenzhenyang on 14-9-23.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVCRGBModel.h"

@interface JVCRGBHelper : NSObject {
    
    JVCRGBModel *rgbModel;       //当前选择的RgbModel
}

@property (nonatomic,retain) JVCRGBModel *rgbModel;

/**
 *  单例
 *
 *  @return 返回AddDeviceAlertMaths的单例
 */
+ (JVCRGBHelper *)shareJVCRGBHelper;

/**
 *  设置当前颜色助手类选择的RGB对象
 *
 *  @param strkeyName RGB颜色的Key
 *
 *  @return RGB对象
 */
- (BOOL)setObjectForKey:(NSString const *)strkeyName;

@end
