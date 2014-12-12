//
//  JVCJson2Model.h
//  CloudSEE_II
//  实体类和model互转的类 
//  Created by chenzhenyang on 14-12-11.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCJson2Model : NSObject

/**
 *  字典转Model
 *
 *  @param dict 字典
 *
 *  @return model
 */
-(id)initModelWithDict:(NSDictionary *)dic;

/**
 *  字典映射到model
 *
 *  @param dict 映射的字典
 */
-(void)modelWithDict:(NSDictionary *)dict;

/**
 *  获取Model转字典
 *
 *  @param model model
 *
 *  @return model对应的字典
 */
-(NSDictionary *)dictionaryWithModel;

@end
