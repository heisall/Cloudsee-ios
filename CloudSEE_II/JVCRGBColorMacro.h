//
//  JVCRGB.h
//  JVCEditDevice
//  颜色模块常量头文件
//  Created by chenzhenyang on 14-9-23.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#ifndef JVCEditDevice_JVCRGB_h
#define JVCEditDevice_JVCRGB_h

//视频编辑界面的RGB列表
static NSString const *  kJVCRGBColorMacroOrange   = @"orange";
static NSString const *  kJVCRGBColorMacroYellow   = @"yellow";
static NSString const *  kJVCRGBColorMacroSkyBlue  = @"skyBlue";
static NSString const *  kJVCRGBColorMacroPurple   = @"purple";
static NSString const *  kJVCRGBColorMacroDeepRed  = @"deepRed";
static NSString const *  kJVCRGBColorMacroGreen    = @"green";
static NSString const *  kJVCRGBColorMacroEditDeviceButtonFont    = @"editDeviceButtonFont";

#define RGBConvertColor(R,G,B,Alpha) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:Alpha]

//设备列表
static NSString const *  kJVCRGBColorMacroWhite   = @"white";

//TabarViewController
static NSString const *  kJVCRGBColorMacroTabarWhite   = @"tabarWhite";


#endif
