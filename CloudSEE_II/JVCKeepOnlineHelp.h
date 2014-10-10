//
//  JVCKeepOnlineHelp.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/10/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVCAccountHelper.h"


@interface JVCKeepOnlineHelp : NSObject<JVCAccountDelegate,UIAlertViewDelegate>

/**
 *  单例
 *
 *  @return 返回JVCKeepOnlineHelp的单例
 */
+ (JVCKeepOnlineHelp *)shareKeepOnline;

/**
 *  启心跳
 */
-(void)startKeepOnline;

/**
 *  停心跳
 */
-(void)stopKeepOnline;

/**
 *  注销用户，这个里面有停心跳
 */
- (void)userLoginOut;
@end
