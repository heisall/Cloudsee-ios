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

static const int  kOPENGLMAXCOUNT = 17;//opengl数量

static const int  KWINDOWSFLAG  = 1000;//tag

static const int OPENGLMAXCOUNT  = 16;//opengl显示最大值

static const NSString *DefaultUserName = @"abc";//默认用户名
static const NSString *DefaultPassWord = @"123";      //默认密码

static  const int KPredicateUserNameLegateAddNum            = 100;//正则校验用户名合法时返回值添加100

static const  int KUserNameMaxLength   =  28;//用户名最大长度
static const  int KPassWordMaxLength   =  20;//密码最大长度
static const  int KTextFieldLeftLabelViewWith   =  10;//textfield 左侧label的宽度

static const  int KDevicePassWordMaxLength   =  16;//设备密码最大长度
static const  int KDeviceUserNameMaxLength   =  16;//设备密码最大长度


#define RGBConvertColor(R,G,B,Alpha) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:Alpha]

#define SETLABLERGBCOLOUR(X,Y,Z) [UIColor colorWithRed:X/255.0 green:Y/255.0 blue:Z/255.0 alpha:1.0]

#define RGB_YUANCHENG_BTN_R   255.0
#define RGB_YUANCHENG_BTN_G   255.0
#define RGB_YUANCHENG_BTN_B   255.0

//--------------- 远程回放
#define RGB_YUANCHENG_COLOUM_R 82.0
#define RGB_YUANCHENG_COLOUM_G 32.0
#define RGB_YUANCHENG_COLOUM_B 51.0

#define RGB_YUANCHENG_LABLE_R   47.0
#define RGB_YUANCHENG_LABLE_G   71.0
#define RGB_YUANCHENG_LABLE_B   110.0
