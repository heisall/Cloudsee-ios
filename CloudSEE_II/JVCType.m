//
//  JVCType.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-12-15.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCType.h"
#import "JVCTypeEncoding.h"
#import "JVCFoundation.h"

@implementation JVCType

- (instancetype)initWithTypeIdentifier:(NSString *)strTypeIdentifier
{
    if (self = [super init]) {
        
        self.strTypeIdentifier = strTypeIdentifier;
    }
    
    return self;
}

-(void)setStrTypeIdentifier:(NSString *)strTypeIdentifier{

    _strTypeIdentifier = strTypeIdentifier;
    
    if (_strTypeIdentifier.length == 0 || [_strTypeIdentifier isEqualToString:JVCTypeSEL] ||
        [_strTypeIdentifier isEqualToString:JVCTypeIvar] ||
        [_strTypeIdentifier isEqualToString:JVCTypeMethod]) {
        
        _KVCDisabled = YES;
        
    } else if ([_strTypeIdentifier hasPrefix:@"@"] && _strTypeIdentifier.length > 3) {
        
        // 去掉@"和"，截取中间的类型名称
        _strTypeIdentifier = [_strTypeIdentifier substringFromIndex:2];
        _strTypeIdentifier = [_strTypeIdentifier substringToIndex:_strTypeIdentifier.length - 1];
        
        _typeClass      = NSClassFromString(_strTypeIdentifier);
        
        _fromFoundation = [JVCFoundation isClassFromFoundation:_typeClass];
    }
}


@end
