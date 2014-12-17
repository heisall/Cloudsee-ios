//
//  JVCDeviceMapModel.m
//  CloudSEE_II
//
//  Created by David on 14/12/16.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "JVCDeviceMapModel.h"

@implementation JVCDeviceMapModel
@synthesize aswitch,atime,dimols,dsls,dstypeint,dtype,dvlt,dvport,dwifi;
@synthesize dguid,dname,dstype,dsv,dvip,dvpassword,dvusername;


- (id)init
{
    if (self = [super init]) {
        
        aswitch = -1;
    }
    return self;
}
- (void)dealloc
{
    [dguid release];
    [dname release];
    [dstype release];
    [dsv release];
    [dvip release];
    [dvpassword release];
    [dvusername release];
    
    [super dealloc];
}
@end
