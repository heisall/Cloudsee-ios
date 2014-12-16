//
//  NSObject+JVCJson2Model.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-12-15.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JVCJson2ModelDelegate <NSObject>

@optional

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class
 */
- (NSDictionary *)modelClassNameInArray;

@end

@interface NSObject (JVCJson2Model) <JVCJson2ModelDelegate>

/**
 *  通过字典来创建一个模型
 *  @param keyValues 字典
 *  @return 新建的对象
 */
+ (instancetype)modelWithDic:(NSDictionary *)keyValues;

@end
