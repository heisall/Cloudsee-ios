//
//  JVCURlRequestHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/19/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JVCURLRequestDelegate <NSObject>

@end

@interface JVCURlRequestHelper : NSObject<UIAlertViewDelegate>
{
    id <JVCURLRequestDelegate> delegateUrl;
    
    BOOL bShowNetWorkError;
    
}
@property(nonatomic,assign)id <JVCURLRequestDelegate> delegateUrl;

@property(nonatomic,assign)BOOL bShowNetWorkError;


/**
 *  请求appVersion
 */
- (void)requeAppVersion;

/**
 *  意见与反馈
 *
 *  @param content  内容
 *  @param phoneNum 手机可以为空
 *
 *  @return 1成功 其他 失败
 */
- (int)sendSuggestWithMessage:(NSString *)content
                     phoneNum:(NSString *)phoneNum;


/**
 *  发送日志
 *
 *  @param content 日志内容
 *
 *  @return
 */
- (int)sendLogMesssage:(NSString *)content;
@end
