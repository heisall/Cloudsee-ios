//
//  JVCSystemUtility.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCSystemUtility.h"
#import "JVCDeviceMacro.h"

static NSString const *APPLANGUAGE = @"zh-Hans";//简体中文的标志

@implementation JVCSystemUtility

static JVCSystemUtility *shareInstance = nil;


+ (JVCSystemUtility *)shareSystemUtilityInstance
{
    @synchronized(self)
    {
        if (shareInstance == nil) {
            
            shareInstance = [[self alloc] init];
        }
        return shareInstance;
    }
    return shareInstance;
}


+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareInstance == nil) {
            
            shareInstance = [super allocWithZone: zone];
            
            return shareInstance;
        }
    }
    return nil;
}




/**
 *  判断文件是否存在
 *
 *  @param checkFilePath 检查的文件名称
 *
 *  @return 存在返回TRUE
 */
-(BOOL)checkLocalFileExist:(NSString *)checkFilePath{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    return  [fileManager fileExistsAtPath:checkFilePath];
}

/**
 *  获取应用的app的Documents目录
 *
 *  @return 应用的app的Documents目录
 */
- (NSString *)getAppDocumentsPath
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [pathArray objectAtIndex:0];
}

/**
 *  获取应用的app的Caches目录
 *
 *  @return 应用的app的Caches目录
 */
- (NSString *)getAppCachesPath
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [pathArray objectAtIndex:0];
}

/**
 *  获取app的Temp路径
 *
 *  @return app的temp路径
 */
- (NSString *)getAppTempPath
{
    return NSTemporaryDirectory();
}

/**
 *  创建appDocuments下面的目录
 *
 *  @param fileName 文件名称
 *
 *  @return 创建好的应用目录
 */
- (NSString *)getAppDocumentsPathWithName:(NSString *)fileName
{
    NSString *DocumentsPath = [self getAppDocumentsPath];
    
    return [DocumentsPath stringByAppendingPathComponent:fileName];
}

/**
 *  判断字典是不是为空
 *
 *  @param infoId 字典类型的数据
 *
 *  @return yes:空  no：非空
 */
- (BOOL)judgeDictionIsNil:(NSDictionary *)infoId
{
    if (infoId != nil) {
        return NO;
    }
    return YES ;
}

/**
 *  判断收到的字典是否合法，只有再rt字段等于0的时候才是合法
 *
 *  @param dicInfo 传入的字典字段
 *
 *  @return yes：合法  no：不合法
 */
- (BOOL)JudgeGetDictionIsLegal:(NSDictionary *)dicInfo
{
    if (DEVICESERVICERESPONSE_SUCCESS ==  [[dicInfo objectForKey:DEVICE_JSON_RT] intValue]) {
        
        return YES;
    }
    return NO;
}

/**
 *  判断系统的语言
 *
 *  @return yes  中文  no英文
 */
- (BOOL)judgeAPPSystemLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    
    NSString *currentLanguage = [languages objectAtIndex:0];

    if([currentLanguage isEqualToString:(NSString *)APPLANGUAGE])
    {
        return YES;
    }
    return NO;
}

/**
 *  初始化返回按钮
 *
 *  @param event  按下的事件
 *  @param sender 发送对象
 *
 *  @return 返回UIBarButtonItem
 */
- (UIBarButtonItem *)navicationBarWithTouchEvent:(SEL)event  Target:(id)sender
{
    NSString *path= nil;
    
    path = [[NSBundle mainBundle] pathForResource:@"nav_back" ofType:@"png"];
    
    if (path == nil) {
        
        path = [[NSBundle mainBundle] pathForResource:@"nav_back@2x" ofType:@"png"];

    }
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:sender action:event forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    [image release];
    
    return [barButtonItem autorelease];
    
}

/**
 *  随机返回图片路径（基于时间截）
 *
 *  @return 路径
 */
- (NSString *)getRandomPicLocalPath
{
    NSString *appCachePaht = [self getAppTempPath];
    
    NSTimeInterval timerInterval = [[NSDate date] timeIntervalSince1970];
    
    NSString *picString = [NSString stringWithFormat:@"%lf.pic",timerInterval];
    
    [appCachePaht stringByAppendingPathComponent:picString];

    return appCachePaht;
}

/**
 *  随机返回图片路径（基于时间截）
 *
 *  @return 路径
 */
- (NSString *)getRandomVideoLocalPath
{
    NSString *appCachePaht = [self getAppTempPath];
    
    NSTimeInterval timerInterval = [[NSDate date] timeIntervalSince1970];
    
    NSString *picString = [NSString stringWithFormat:@"%lf.MP4",timerInterval];
    
    [appCachePaht stringByAppendingPathComponent:picString];
    
    return appCachePaht;
}

@end
