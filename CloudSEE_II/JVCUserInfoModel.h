//
//  JVCUserInfoModel.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCUserInfoModel : NSObject
{
    
    NSString *userName;         //用户名
    
    NSString *passWord;         //秘密
    
    double loginTimer;          //登录时间
    
}

@property(nonatomic,retain) NSString *userName;
@property(nonatomic,retain) NSString *passWord;


@property(nonatomic,assign) double loginTimer;;

@end
