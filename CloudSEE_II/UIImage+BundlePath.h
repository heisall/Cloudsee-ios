//
//  UIImage+BundlePath.h
//  CloudSEE_II
//  根据图片名称获取图片的路径，减少内存
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BundlePath)

/**
 *  根据image的名称，获取bundle的path路径
 *
 *  @param imageName 图片名称
 *
 *  @return 图片路径
 */
+(NSString *)imageBundlePath:(NSString *)imageName;

/**
 *  根据设备类型，自动获取iphone5图片的类型，如果是iphone5的情况下，返回图片1_iphone5.png 如果不是iphone5返回原来的图片
 *
 *  @param imageStr 图片的名称
 *
 *  @return 如果是iphone5 在图片的后面追加_iphone5.png 如果不是返回图片的原来的名称
 */
+ (NSString *)correctImageName:(NSString *)imageStr;

/**
 *  返回UIImage的bundle的路径
 *
 *	@param	ImageName	图片的名字
 *  @param  bundleName  bundle的名称
 *
 *	@return	返回指定指定图片名的图片
 */
+(NSString *)getBundleImagePath:(NSString *)ImageName  bundleName:(NSString *)bundleName;

@end
