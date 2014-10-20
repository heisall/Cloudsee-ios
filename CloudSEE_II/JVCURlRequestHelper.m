//
//  JVCURlRequestHelper.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/19/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCURlRequestHelper.h"

@interface JVCURlRequestHelper ()
{
    NSMutableData *receivedata;
}

@end

@implementation JVCURlRequestHelper
@synthesize delegateUrl;
static  const NSString *KMODELTYPEGETUPDATEINFO  =  @"1006";//版本号
static  const  NSString  *KVersion =  @"Version";
static  const  NSString  *KRequestType =  @"RequestType";
static  const  NSString  *KRequestTypeValue =  @"3";

static  const  NSString  *KLanguage =  @"Language";
static  const  NSString  *KMobileType=  @"MobileType";
static  const  NSString  *KMobileTypeValue=  @"2";
static const  int  KAnimationTimer  = 5;//超时时间

static JVCURlRequestHelper *shareJVCUrlRequestHelper = nil;

static const  NSString * KSErVER_URl_VERSION_HEADER  = @"http://wmap.yoosee.cc/MobileWeb.aspx";//请求版本更新的


/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCURlRequestHelper *)shareJVCUrlRequestHelper
{
    @synchronized(self)
    {
        if (shareJVCUrlRequestHelper == nil) {
            
            shareJVCUrlRequestHelper = [[self alloc] init];
            
            [shareJVCUrlRequestHelper initReceiveDate];
            
        }
        
        return shareJVCUrlRequestHelper;
    }
    
    return shareJVCUrlRequestHelper;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareJVCUrlRequestHelper == nil) {
            
            shareJVCUrlRequestHelper = [super allocWithZone:zone];
            
            return shareJVCUrlRequestHelper;
        }
    }
    
    return nil;
}

- (void)initReceiveDate
{
    receivedata = [[NSMutableData alloc] init];
}

/**
 *  请求appVersion
 */
- (void)requeAppVersion
{
    NSMutableDictionary *paramer = [[NSMutableDictionary alloc] init];
    [paramer setObject:KRequestTypeValue forKey:KRequestType];
    if ([[JVCSystemUtility shareSystemUtilityInstance]judgeAPPSystemLanguage]) {
        [paramer setObject:@"1" forKey:KLanguage];
    }else{
        [paramer setObject:@"2" forKey:KLanguage];
    }
    [paramer setObject:KMODELTYPEGETUPDATEINFO forKey:KVersion];
    [paramer setObject:KMobileTypeValue forKey:KMobileType];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",KSErVER_URl_VERSION_HEADER,[self getRequestKeyString: paramer]]]];
    [request setTimeoutInterval:KAnimationTimer];
    
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self] ;
    
   
    [request release];
    
    if (connect) {
        
        [receivedata resetBytesInRange:NSMakeRange(0, [receivedata length])];
        [receivedata setLength:0];
      
    }else{
        
        [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:@"网路超时"];
    }
    [paramer release];

}

- (NSString *)getRequestKeyString:(NSDictionary *)tDic
{
    NSArray *keyArray =[tDic allKeys];
    
    NSMutableString *singString = [[NSMutableString alloc] init];
    
    for (int i=0;i<keyArray.count;i++) {
        NSString *keyString = [keyArray objectAtIndex:i];
        if (singString.length == 0) {
            [singString appendFormat:@"%@=%@",keyString,[tDic objectForKey:keyString]];
        }else{
            [singString appendFormat:@"&%@=%@",keyString,[tDic objectForKey:keyString]];
        }
    }
    
    return singString;
}

#pragma mark 异步请求数据的delegate方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedata appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:@"网路超时"];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (delegateUrl !=nil  && [delegateUrl respondsToSelector:@selector(URlRequestSuccessCallBack:)]) {
        
        [delegateUrl URlRequestSuccessCallBack:receivedata];
    }
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // NSLog(@"receive");
}


@end
