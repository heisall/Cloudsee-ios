//
//  JVCRGBHelper.m
//  JVCEditDevice
//  颜色助手类 主要作用是获取指定颜色的RGB值对象
//  Created by chenzhenyang on 14-9-23.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCRGBHelper.h"

@interface JVCRGBHelper () {
    
    NSMutableDictionary *mdicRgbModelList;
}

@end

@implementation JVCRGBHelper


static JVCRGBHelper *jvcRGBHelper = nil;



/**
 *  初始化颜色的辅助类
 *
 *  @return 颜色助手类对象
 */
-(id)init {
    
    if (self = [super init]) {
        
        mdicRgbModelList = [[NSMutableDictionary alloc] initWithCapacity:10];
        
        [self initAppRgbColors];
        [self initEditDeviceViewRgbColors];
        [self initDeviceListViewRgbColors];
        [self initTabarViewRgbColors];
        [self initRegisterRgbColors];
        [self initWithChanelListView];
        [self initLoginViewRgbColors];
        [self initViewControllerRGBColors];
    }
    
    return self;
}

/**
 *  单例
 *
 *  @return 返回JVCRGBHelper的单例
 */
+ (JVCRGBHelper *)shareJVCRGBHelper
{
    @synchronized(self)
    {
        if (jvcRGBHelper == nil) {
            
            jvcRGBHelper = [[self alloc] init];
            
        }
        return jvcRGBHelper;
    }
    return jvcRGBHelper;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (jvcRGBHelper == nil) {
            
            jvcRGBHelper = [super allocWithZone:zone];
            
            return jvcRGBHelper;
        }
    }
    return nil;
}

/**
 *  初始化应用程序的一些背景色，
 */
-(void)initAppRgbColors {
    
    JVCRGBModel *navBackgroundColor   = [[JVCRGBModel alloc] init];  //导航条背景色，蓝色
    navBackgroundColor.r = 0.0f;
    navBackgroundColor.g = 122.0f;
    navBackgroundColor.b = 255.0f;
    
    [mdicRgbModelList setObject:navBackgroundColor forKey:kJVCRGBColorMacroNavBackgroundColor];
    
    [navBackgroundColor release];
}

/**
 *  初始化设备编辑界面的RGB集合
 */
-(void)initEditDeviceViewRgbColors{
    
    JVCRGBModel *green   = [[JVCRGBModel alloc] init];  //绿色
    green.r = 106.0f;
    green.g = 184.0f;
    green.b = 64.0f;
    
    JVCRGBModel *skyBlue = [[JVCRGBModel alloc] init];  //天蓝色
    skyBlue.r = 16.0f;
    skyBlue.g = 196.0f;
    skyBlue.b = 217.0f;
    
    JVCRGBModel *orange = [[JVCRGBModel alloc] init]; //橙色
    orange.r = 240.0f;
    orange.g = 137.0f;
    orange.b = 47.0f;
    
    JVCRGBModel *deepRed = [[JVCRGBModel alloc] init]; //深红
    deepRed.r = 232.0f;
    deepRed.g = 75.0f;
    deepRed.b = 80.0f;
    
    JVCRGBModel *yellow  = [[JVCRGBModel alloc] init];  //黄色
    yellow.r = 245.0f;
    yellow.g = 193.0f;
    yellow.b = 50.0f;
    
    
    JVCRGBModel *purple  = [[JVCRGBModel alloc] init]; //紫红
    purple.r = 153.0f;
    purple.g = 66.0f;
    purple.b = 138.0f;
    
    JVCRGBModel *editDeviceButtonFont  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    editDeviceButtonFont.r = 255.0f;
    editDeviceButtonFont.g = 254.0f;
    editDeviceButtonFont.b = 251.0f;
    
    
    JVCRGBModel *topBarItemSelectFontColor = [[JVCRGBModel alloc] init];
    
    topBarItemSelectFontColor.r            = 0.0f;
    topBarItemSelectFontColor.g            = 88.0f;
    topBarItemSelectFontColor.b            = 168.0f;
    
    JVCRGBModel *topBarItemUnselectFontColor = [[JVCRGBModel alloc] init];
    
    topBarItemUnselectFontColor.r            = 47.0f;
    topBarItemUnselectFontColor.g            = 48.0f;
    topBarItemUnselectFontColor.b            = 47.0f;
    
    JVCRGBModel *topBarItemSelectUnderlineViewColor = [[JVCRGBModel alloc] init];
    
    topBarItemSelectUnderlineViewColor.r            = 0.0f;
    topBarItemSelectUnderlineViewColor.g            = 122.0f;
    topBarItemSelectUnderlineViewColor.b            = 255.0f;
    
    JVCRGBModel *topToolBarBackgroundColor = [[JVCRGBModel alloc] init];
    
    topToolBarBackgroundColor.r            = 239.0f;
    topToolBarBackgroundColor.g            = 239.0f;
    topToolBarBackgroundColor.b            = 239.0f;
    
    JVCRGBModel *toolBarDropButtonBackgroundColor = [[JVCRGBModel alloc] init];
    
    toolBarDropButtonBackgroundColor.r            = 236.0f;
    toolBarDropButtonBackgroundColor.g            = 236.0f;
    toolBarDropButtonBackgroundColor.b            = 236.0f;
    
    JVCRGBModel *dropListCellTitleUnselectedColor = [[JVCRGBModel alloc] init]; //设备编辑界面下拉表格的默认字体颜色
    
    dropListCellTitleUnselectedColor.r            = 75.0f;
    dropListCellTitleUnselectedColor.g            = 75.0f;
    dropListCellTitleUnselectedColor.b            = 75.0f;
    
    [mdicRgbModelList setObject:orange  forKey:kJVCRGBColorMacroOrange];
    [mdicRgbModelList setObject:yellow  forKey:kJVCRGBColorMacroYellow];
    [mdicRgbModelList setObject:skyBlue forKey:kJVCRGBColorMacroSkyBlue];
    [mdicRgbModelList setObject:purple  forKey:kJVCRGBColorMacroPurple];
    [mdicRgbModelList setObject:deepRed forKey:kJVCRGBColorMacroDeepRed];
    [mdicRgbModelList setObject:green   forKey:kJVCRGBColorMacroGreen];
    
    [mdicRgbModelList setObject:editDeviceButtonFont               forKey:kJVCRGBColorMacroEditDeviceButtonFont];
    [mdicRgbModelList setObject:topBarItemUnselectFontColor        forKey:kJVCRGBColorMacroEditDeviceTopBarItemUnselectFontColor];
    [mdicRgbModelList setObject:topBarItemSelectFontColor          forKey:kJVCRGBColorMacroEditDeviceTopBarItemSelectFontColor];
    [mdicRgbModelList setObject:topBarItemSelectUnderlineViewColor forKey:kJVCRGBColorMacroEditDeviceTopBarItemSelectUnderlineViewColor];
    [mdicRgbModelList setObject:topToolBarBackgroundColor          forKey:kJVCRGBColorMacroEditTopToolBarBackgroundColor];
    [mdicRgbModelList setObject:toolBarDropButtonBackgroundColor   forKey:kJVCRGBColorMacroEditToolBarDropButtonBackgroundColor];
    [mdicRgbModelList setObject:dropListCellTitleUnselectedColor   forKey:kJVCRGBColorMacroEditDropListViewCellTitleFontUnselectedColor];
    
    [orange release];
    [yellow release];
    [skyBlue release];
    [purple release];
    [deepRed release];
    [green release];
    [editDeviceButtonFont release];
    [topBarItemSelectFontColor release];
    [topBarItemUnselectFontColor release];
    [topBarItemSelectUnderlineViewColor release];
    [topToolBarBackgroundColor release];
    [toolBarDropButtonBackgroundColor release];
    [dropListCellTitleUnselectedColor release];
}

/**
 *  初始化试图的backgrou的颜色
 */
- (void)initViewControllerRGBColors
{
    JVCRGBModel *whiteVCBackGround  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    whiteVCBackGround.r = 245.0f;
    whiteVCBackGround.g = 245.0f;
    whiteVCBackGround.b = 245.0f;
    [mdicRgbModelList setObject:whiteVCBackGround forKey:kJVCRGBColorMacroViewControllerBackGround];
    [whiteVCBackGround release];

}

/**
 *  初始化设备列表界面的RGB集合
 */
-(void)initDeviceListViewRgbColors{
    
    JVCRGBModel *white  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    white.r = 255.0f;
    white.g = 255.0f;
    white.b = 255.0f;
    
    JVCRGBModel *labTextClolr  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    labTextClolr.r = 125.0f;
    labTextClolr.g = 133.0f;
    labTextClolr.b = 147.0f;
    
    [mdicRgbModelList setObject:labTextClolr forKey:kJVCRGBColorMacroDeviceListLabelGray];
    [mdicRgbModelList setObject:white forKey:kJVCRGBColorMacroWhite];
    
    [white release];
    [labTextClolr release];
}



/**
 *  初始化设备列表界面的RGB集合
 */
-(void)initTabarViewRgbColors{
    
    JVCRGBModel *tabarWhite  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    tabarWhite.r = 245.0f;
    tabarWhite.g = 245.0f;
    tabarWhite.b = 245.0f;
    
    [mdicRgbModelList setObject:tabarWhite forKey:kJVCRGBColorMacroTabarTitleFontColor];
    
    [tabarWhite release];
}

#pragma mark 初始化注册界面提示的颜色值
- (void)initRegisterRgbColors
{
    JVCRGBModel *registerRed  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    registerRed.r = 217.0f;
    registerRed.g = 34.0f;
    registerRed.b = 38.0f;
    
    JVCRGBModel *registerBlue  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    registerBlue.r = 21.0f;
    registerBlue.g = 103.0f;
    registerBlue.b = 255.0f;
    
    [mdicRgbModelList setObject:registerRed forKey:kJVCRGBColorMacroRed];
    [mdicRgbModelList setObject:registerBlue forKey:kJVCRGBColorMacroBlue];

    [registerRed release];
    [registerBlue release];

    
}

/**
 *  初始化通道选择的RGB
 */
-(void)initWithChanelListView{
    
    JVCRGBModel *lakeBlue  = [[JVCRGBModel alloc] init]; //湖蓝色
    lakeBlue.r = 66.0f;
    lakeBlue.g = 189.0f;
    lakeBlue.b = 232.0f;
    
    JVCRGBModel *mediumYellow  = [[JVCRGBModel alloc] init]; //中黄
    mediumYellow.r = 245.0f;
    mediumYellow.g = 193.0f;
    mediumYellow.b = 50.0f;
    
    JVCRGBModel *grassGreen  = [[JVCRGBModel alloc] init]; //草绿
    grassGreen.r = 108.0f;
    grassGreen.g = 193.0f;
    grassGreen.b = 67.0f;
    
    JVCRGBModel *warmOrange  = [[JVCRGBModel alloc] init]; //暖橙色
    warmOrange.r = 253.0f;
    warmOrange.g = 142.0f;
    warmOrange.b = 53.0f;
    
    [mdicRgbModelList setObject:lakeBlue     forKey:kJVCRGBColorMacroDeviceListWithChannelListLakeBlue];
    [mdicRgbModelList setObject:mediumYellow forKey:kJVCRGBColorMacroDeviceListWithChannelListMediumYellow];
    [mdicRgbModelList setObject:grassGreen   forKey:kJVCRGBColorMacroDeviceListWithChannelListGrassGreen];
    [mdicRgbModelList setObject:warmOrange   forKey:kJVCRGBColorMacroDeviceListWithChannelListWarmOrange];
    
    [lakeBlue release];
    [mediumYellow release];
    [grassGreen release];
    [warmOrange release];
}

#pragma mark 初始化登录界面的颜色值
- (void)initLoginViewRgbColors
{
    JVCRGBModel *loginUserGray  = [[JVCRGBModel alloc] init];
    loginUserGray.r = 143.0f;
    loginUserGray.g = 143.0f;
    loginUserGray.b = 143.0f;
    
    JVCRGBModel *loginDemoBlue  = [[JVCRGBModel alloc] init];
    loginDemoBlue.r = 0.0f;
    loginDemoBlue.g = 122.0f;
    loginDemoBlue.b = 255.0f;
    
    [mdicRgbModelList setObject:loginUserGray forKey:kJVCRGBColorMacroLoginGray];
    [mdicRgbModelList setObject:loginDemoBlue forKey:kJVCRGBColorMacroLoginBlue];
    
    [loginUserGray release];
    [loginDemoBlue release];
    
}

/**
 *  根据RGBModel的键值获取UIColor对象
 *
 *  @param strkeyName RGBModel的键
 *  @param alpha      透明度
 *
 *  @return UIColor对象 不存在返回nil
 */
-(UIColor *)rgbColorForKey:(NSString const *)strkeyName alpha:(CGFloat)alpha {
    
    if ([mdicRgbModelList objectForKey:strkeyName]) {
        
        JVCRGBModel *rgbModel  = (JVCRGBModel *)[mdicRgbModelList objectForKey:strkeyName];
        
        return RGBConvertColor(rgbModel.r, rgbModel.g, rgbModel.b, alpha);
        
    }else {
        
        return nil;
    }
}

/**
 *  根据RGBModel的键值获取UIColor对象
 *
 *  @param strkeyName RGBModel的键
 *
 *  @return UIColor对象 不存在返回nil
 */
-(UIColor *)rgbColorForKey:(NSString const *)strkeyName {
    
    if ([mdicRgbModelList objectForKey:strkeyName]) {
        
        JVCRGBModel *rgbModel  = (JVCRGBModel *)[mdicRgbModelList objectForKey:strkeyName];
        
        return RGBConvertColor(rgbModel.r, rgbModel.g, rgbModel.b, 1.0f);
        
    }else {
        
        return nil;
    }
}

/**
 *  释放颜色助手类对象
 */
-(void)dealloc{
    
    [mdicRgbModelList release];
    [super dealloc];
}


@end
