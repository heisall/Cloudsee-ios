//
//  JVCURlRequestHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/19/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JVCURLRequestDelegate <NSObject>

/**
 *  请求成功的回调
 */
- (void)URlRequestSuccessCallBack:(NSMutableData *)receive;

@end

@interface JVCURlRequestHelper : NSObject
{
    id <JVCURLRequestDelegate> delegateUrl;
}
@property(nonatomic,assign)id <JVCURLRequestDelegate> delegateUrl;


/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCURlRequestHelper *)shareJVCUrlRequestHelper;

/**
 *  请求appVersion
 */
- (void)requeAppVersion;
@end
