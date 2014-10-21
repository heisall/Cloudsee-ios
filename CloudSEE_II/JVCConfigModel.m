//
//  JVCConfigModel.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCConfigModel.h"

@implementation JVCConfigModel

@synthesize _bISLocalLoginIn;
@synthesize _netLinkType;
@synthesize _iWatchType;
@synthesize tempModelInsert;
@synthesize _bInitAccountSDKSuccess;
@synthesize _bNewVersion;
static JVCConfigModel *_shareInstance = nil;
/**
 *  单例
 *
 *  @return 返回AddDeviceAlertMaths的单例
 */
+ (JVCConfigModel *)shareInstance
{
    @synchronized(self)
    {
        if (_shareInstance == nil) {
            
            _shareInstance = [[self alloc] init ];
            
            _shareInstance._bISLocalLoginIn = 0;
            _shareInstance._netLinkType     = NETLINTYEPE_WIFI_init;
        }
        return _shareInstance;
    }
    return _shareInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (_shareInstance == nil) {
            
            _shareInstance = [super allocWithZone:zone];
            
            return _shareInstance;
            
        }
    }
    return nil;
}


@end
