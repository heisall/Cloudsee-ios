//
//  JVCCustomMember.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-12-15.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCCustomMember.h"
#import "JVCType.h"

@implementation JVCCustomMember

/**
 *  初始化
 *
 *  @param ivar             成员变量
 *  @param propertyInObject 成员变量属于的对象
 *
 *  @return 初始化好的对象
 */
- (instancetype)initWithIvar:(Ivar)ivar withPropertyInObject:(id)propertyInObject{

    if (self = [super initWithMemberInObject:propertyInObject]) {
        
        self.ivar = ivar;
    }
    return self;

}

-(void)setIvar:(Ivar)ivar {

    _ivar = ivar;
    
    // 1.成员变量名
    _name = [NSString stringWithUTF8String:ivar_getName(ivar)];
    
    // 2.属性名
    if ([_name hasPrefix:@"_"]) {
        
        _propertyName = [_name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        
    } else {
        
        _propertyName = _name;
    }
    
    // 3.成员变量的类型符
    NSString *strTypeIdentifier = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
    
    DDLogVerbose(@"001------strTypeIdentifier=%@",strTypeIdentifier);
    _type = [[JVCType alloc] initWithTypeIdentifier:strTypeIdentifier];
}

-(void)setPropertyValue:(id)propertyValue{

    if (_type.KVCDisabled) return;
    [_memberInObject setValue:propertyValue forKey:_propertyName];
    
    DDLogVerbose(@"%@----finshed---------name=%@----result=%@",_memberInObject,_propertyName,propertyValue);

}

-(id)propertyValue{

    if (_type.KVCDisabled) return [NSNull null];
    return [_memberInObject valueForKey:_propertyName];
}

@end
