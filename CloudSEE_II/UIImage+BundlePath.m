//
//  UIImage+BundlePath.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "UIImage+BundlePath.h"

static const int kImageSeperateCount = 2;//图片的image.png 分割，数组大小为2

@implementation UIImage (BundlePath)

/**
 *  根据image的名称，获取bundle的path路径
 *
 *  @param imageName 图片名称
 *
 *  @return 图片路径
 */
+(NSString *)imageBundlePath:(NSString *)imageName
{
    NSString *path= nil;
    
    NSArray *array = [imageName componentsSeparatedByString:@"."];
    
    if (kImageSeperateCount == array.count ) {
        
        path = [[NSBundle mainBundle] pathForResource:[array objectAtIndex:0] ofType:[array objectAtIndex:1]];
        
        if (path == nil) {
            
            NSString *imageName = [array objectAtIndex:0];
            
            imageName  = [imageName stringByAppendingString:@"@2x"];
            
            path = [[NSBundle mainBundle] pathForResource:imageName ofType:[array objectAtIndex:1]];
            
        }
    }
    
    return path;
    
}

/**
 *  根据设备类型，自动获取iphone5图片的类型，如果是iphone5的情况下，返回图片1_iphone5.png 如果不是iphone5返回原来的图片
 *
 *  @param imageStr 图片的名称
 *
 *  @return 如果是iphone5 在图片的后面追加_iphone5.png 如果不是返回图片的原来的名称
 */
+ (NSString *)correctImageName:(NSString *)imageStr
{
    
    NSString *path= nil;
    
    NSArray *array = [imageStr componentsSeparatedByString:@"."];
    
    if (kImageSeperateCount == array.count ) {
        
        if (iphone5) {
            
            if (array.count == kImageSeperateCount) {//正确
                
                NSString *nameImageHead = [NSString stringWithFormat:@"%@_iphone5",[array objectAtIndex:0]];
                
                path = [[NSBundle mainBundle] pathForResource:nameImageHead ofType:[array objectAtIndex:1]];

            }
            
        }else{
            
            path = [[NSBundle mainBundle] pathForResource:[array objectAtIndex:0] ofType:[array objectAtIndex:1]];
            
            if (path == nil) {
                
                NSString *imageName = [array objectAtIndex:0];
                
                imageName  = [imageName stringByAppendingString:@"@2x"];
                
                path = [[NSBundle mainBundle] pathForResource:imageName ofType:[array objectAtIndex:1]];
                
            }
        
        }        
       
    }
    
    return path;
}

/**
 *  返回UIImage的bundle的路径
 *
 *	@param	ImageName	图片的名字
 *  @param  bundleName  bundle的名称
 *
 *	@return	返回指定指定图片名的图片
 */
+(NSString *)getBundleImagePath:(NSString *)ImageName  bundleName:(NSString *)bundleName{
    
    NSString *main_image_dir_path=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundleName];
    
    NSString *image_path= [main_image_dir_path stringByAppendingPathComponent:ImageName];
    
    NSArray *array = [ImageName componentsSeparatedByString:@"."];
    
    if (kImageSeperateCount == array.count ) {
        
        NSString *imageName = [array objectAtIndex:0];
        imageName  = [imageName stringByAppendingString:@"@2x."];
        imageName = [imageName stringByAppendingString:[array objectAtIndex:1]];
        image_path = [main_image_dir_path stringByAppendingPathComponent:imageName];

    }
    return image_path;
}

@end
