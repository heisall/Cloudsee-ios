//
//  JVCSystemConfigMacro.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

/**
 *  判刑是否是iphone5设备
 */
#define iphone5  ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size):NO)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define LOCALANGER(A)  NSLocalizedString(A, nil)

#define IOS7    7.0

#define SETCOLOR(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];

static NSString *const kAPPIDNUM  = @"583826804";

#define RGBConvertColor(R,G,B,Alpha) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:Alpha]
