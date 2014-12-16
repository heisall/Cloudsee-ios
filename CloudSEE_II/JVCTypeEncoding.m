//
//  JVCTypeEncoding.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-12-15.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

NSString *const JVCTypeInt          = @"i";
NSString *const JVCTypeFloat        = @"f";
NSString *const JVCTypeDouble       = @"d";
NSString *const JVCTypeLong         = @"q";
NSString *const JVCTypeLongLong     = @"q";
NSString *const JVCTypeChar         = @"c";
NSString *const JVCTypeBOOL         = @"c";
NSString *const JVCTypePointer      = @"*";

NSString *const JVCTypeIvar         = @"^{objc_ivar=}";
NSString *const JVCTypeMethod       = @"^{objc_method=}";
NSString *const JVCTypeBlock        = @"@?";
NSString *const JVCTypeClass        = @"#";
NSString *const JVCTypeSEL          = @":";
NSString *const JVCTypeId           = @"@";

/**
 *  返回值类型(如果是unsigned，就是大写)
 */
NSString *const JVCReturnTypeVoid   = @"v";
NSString *const JVCReturnTypeObject = @"@";



