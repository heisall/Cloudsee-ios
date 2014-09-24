//
//  JVCSystemUtility.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCSystemUtility.h"

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
 *  根据设备类型，自动获取iphone5图片的类型，如果是iphone5的情况下，返回图片1_iphone5.png 如果不是iphone5返回原来的图片
 *
 *  @param imageStr 图片的名称
 *
 *  @return 如果是iphone5 在图片的后面追加_iphone5.png 如果不是返回图片的原来的名称
 */
-(NSString *)getImageByImageName:(NSString *)imageStr
{
    
    if (iphone5) {
        
        NSArray *ArrayImageName = [imageStr componentsSeparatedByString:@"."];
        
        if (ArrayImageName.count == 2) {//正确
            
            return [NSString stringWithFormat:@"%@_iphone5.png",[ArrayImageName objectAtIndex:0]];
        }
    }
    
    return imageStr;
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

@end
