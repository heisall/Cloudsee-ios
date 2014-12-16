//
//  NSObject+JVCJson2Model.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-12-15.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "NSObject+JVCJson2Model.h"
#import "NSObject+JVCMember.h"

@implementation NSObject (JVCJson2Model)


/**
 *  通过字典来创建一个模型
 *  @param keyValues 字典
 *  @return 新建的对象
 */
+ (instancetype)modelWithDic:(NSDictionary *)keyValues
{

    id model = [[self alloc] init];
    
    [model setKeyValues:keyValues];
    
    return model;
}

/**
 *  将字典的键值对转成模型属性
 *  @param keyValues 字典
 */
- (void)setKeyValues:(NSDictionary *)keyValues
{

    [self enumerateIvarsWithBlock:^(JVCCustomMember *ivar, BOOL *stop) {
        
        // 来自Foundation框架的成员变量，直接返回
        if (ivar.memberInClassFromFoundation){

            return;
        }
        
        // 1.取出属性值
        NSString *key = ivar.propertyName;
        
        id value = keyValues[key];
        
        if (!value || [value isKindOfClass:[NSNull class]]) return;
    
        // 2.如果是模型属性
        if (ivar.type.typeClass && !ivar.type.isFromFoundation) {
            
            value = [ivar.type.typeClass modelWithDic:value];
            
        } else if ([self respondsToSelector:@selector(modelClassNameInArray)]) {
            
            // 3.字典数组-->模型数组
            Class objectClass = self.modelClassNameInArray[ivar.propertyName];
            
            if (objectClass) {
                
                value = [objectClass modelArrayWithDicArray:value];
            }
        }
        
        // 4.赋值
        ivar.propertyValue = value;
    }];
    
}

#pragma mark - 字典数组转模型数组
/**
 *  通过字典数组来创建一个模型数组
 *  @param keyValuesArray 字典数组
 *  @return 模型数组
 */
+ (NSArray *)modelArrayWithDicArray:(NSArray *)dicArray
{
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:10];
    
    for (NSDictionary *keyValues in dicArray) {
        
        if (![keyValues isKindOfClass:[NSDictionary class]]) continue;
        
        id model = [self modelWithDic:keyValues];
        
        [modelArray addObject:model];
    }
    
    return modelArray;
}

@end
