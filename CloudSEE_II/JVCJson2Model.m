//
//  JVCJson2Model.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-12-11.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCJson2Model.h"
#import <objc/runtime.h>

@implementation JVCJson2Model

/**
 *  采用反射获取该类的属性key
 *
 *  @return 所有的属性key集合
 */
-(NSArray *)propertysInModel
{
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        [keys addObject:propertyName];
        
        [propertyName release];
        
    }
    
    free(properties);
    
    return keys;
}

/**
 *  字典转Model
 *
 *  @param dict 字典
 *
 *  @return model
 */
-(id)initModelWithDict:(NSDictionary *)dict
{
    self = [super init];
        
    if (self != nil) {
        
        [self modelWithDict:dict];
    }
    
    return self;
}

/**
 *  字典映射到model
 *
 *  @param dict 映射的字典
 */
-(void)modelWithDict:(NSDictionary *)dict
{
    BOOL ret = NO;
    
    NSArray *propertyKeys = [self propertysInModel];
    
    [propertyKeys retain];
    
    for (NSString *key in propertyKeys) {
        
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            ret = ([dict valueForKey:key] == nil) ? NO:YES;
            
        }else{
            
            ret = [dict respondsToSelector:NSSelectorFromString(key)];
        }
        
        if (ret) {
            
            id propertyValue = [dict valueForKey:key];
            
            if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
                
                [self setValue:propertyValue forKey:key];
            }
        }
    }
    
    [propertyKeys release];
}

/**
 *  获取Model转字典
 *
 *  @param model model
 *
 *  @return model对应的字典
 */
-(NSDictionary *)dictionaryWithModel {
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSArray *properties = [self propertysInModel];
    
    [properties retain];
    
    // 遍历所有属性
    for (NSString *key in properties) {
        
        id propertyValue = [self valueForKey:key];
        
        if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
            
            [dict setValue:propertyValue forKey:key];
        }
    }
    
    [properties release];
    
    
    return [dict autorelease];
}

@end
