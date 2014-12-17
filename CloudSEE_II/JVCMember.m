//
//  JVCMember.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-12-15.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCMember.h"
#import "JVCFoundation.h"

@implementation JVCMember

/**
 *  初始化
 *
 *  @param memberInObject 成员属于的对象
 *
 *  @return 初始化好的对象
 */
- (instancetype)initWithMemberInObject:(id)memberInObject{

    if (self = [super init]) {
        
        _memberInObject = memberInObject;
    }
    
    return self;
}

-(void)setMemberInObject:(id)memberInObject {

    _memberInObject = memberInObject;
    _memberInClassFromFoundation = [JVCFoundation isClassFromFoundation:memberInObject];
}


@end
