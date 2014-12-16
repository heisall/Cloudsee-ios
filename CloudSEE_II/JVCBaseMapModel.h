//
//  JVCBaseMapModel.h
//  CloudSEE_II
//
//  Created by David on 14/12/16.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JVCJson2Model.h"

@interface JVCBaseMapModel : NSObject
{
    int  mid;
    int  mt;
    int  rt;//返回值  0 成功  1 失败
}
@property(nonatomic,assign)int  mid;
@property(nonatomic,assign)int  mt;
@property(nonatomic,assign)int  rt;
@end
