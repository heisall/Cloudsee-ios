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
@end
