//
//  JVCRGBHelper.h
//  JVCEditDevice
//  颜色的助手类，用于获取颜色的rgb值
//  Created by chenzhenyang on 14-9-23.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCRGBHelper : NSObject

/**
 *  根据key返回RGB对象
 *
 *  @param strkeyName 对象的键值
 *
 *  @return RGB对象
 */
-(id)objectForKeyName:(NSString const *)strkeyName;

@end
