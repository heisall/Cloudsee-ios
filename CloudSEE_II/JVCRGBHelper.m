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
        [self initAddDeviceTextColor];
        [self initAddDevicePopViewRGBColors];
        [self initDemoViewRgbColors];
        [self initPlayBackCellLabelColor];
        [self initAlertCellLabelColor];
        [self initLickTypeViewRGBColors];
        [self initMoreUserLabelViewRGBColors];
        [self initWithVoiceConfig];
        [self initPlayBackCellLabelColor];
        [self initWithResignDownLineLabe];
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
    
    
    JVCRGBModel *blue  = [[JVCRGBModel alloc] init]; //蓝色
    blue.r = 56.0f;
    blue.g = 143.0f;
    blue.b = 229.0f;
    
    JVCRGBModel *skyBlue  = [[JVCRGBModel alloc] init]; //天蓝色
    skyBlue.r = 19.0f;
    skyBlue.g = 197.0f;
    skyBlue.b = 206.0f;
    
    JVCRGBModel *green  = [[JVCRGBModel alloc] init]; //绿色
    green.r = 131.0f;
    green.g = 201.0f;
    green.b = 20.0f;
    
    JVCRGBModel *yellow  = [[JVCRGBModel alloc] init]; //黄色
    yellow.r = 243.0f;
    yellow.g = 182.0f;
    yellow.b = 19.0f;
    
    
    JVCRGBModel *white  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    white.r = 255.0f;
    white.g = 255.0f;
    white.b = 255.0f;
    
    JVCRGBModel *labTextClolr  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    labTextClolr.r = 125.0f;
    labTextClolr.g = 133.0f;
    labTextClolr.b = 147.0f;
    
    [mdicRgbModelList setObject:blue         forKey:kJVCRGBColorMacroDeviceListBlue];
    [mdicRgbModelList setObject:skyBlue      forKey:kJVCRGBColorMacroDeviceListSkyBlue];
    [mdicRgbModelList setObject:green        forKey:kJVCRGBColorMacroDeviceListGreen];
    [mdicRgbModelList setObject:yellow       forKey:kJVCRGBColorMacroDeviceListYellow];
    [mdicRgbModelList setObject:labTextClolr forKey:kJVCRGBColorMacroDeviceListLabelGray];
    [mdicRgbModelList setObject:white        forKey:kJVCRGBColorMacroWhite];
    
    [blue release];
    [skyBlue release];
    [yellow release];
    [green release];
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
    
    JVCRGBModel *tabarTitleColor  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    tabarTitleColor.r = 0.0f;
    tabarTitleColor.g = 122.0f;
    tabarTitleColor.b = 255.0f;
    
    [mdicRgbModelList setObject:tabarTitleColor forKey:kJVCRGBColorMacroTabarItemTitleColor];
    
    [tabarTitleColor release];
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

#pragma mark 初始化demo模块的颜色值
- (void)initDemoViewRgbColors
{
    JVCRGBModel *demoLine = [[JVCRGBModel alloc] init];
    demoLine.r = 188.0f;
    demoLine.g = 188.0f;
    demoLine.b = 188.0f;
    
    JVCRGBModel *loginTitle  = [[JVCRGBModel alloc] init];
    loginTitle.r = 125.0f;
    loginTitle.g = 125.0f;
    loginTitle.b = 125.0f;
    
    JVCRGBModel *loginTimer  = [[JVCRGBModel alloc] init];
    loginTimer.r = 171.0f;
    loginTimer.g = 171.0f;
    loginTimer.b = 171.0f;
    
    [mdicRgbModelList setObject:demoLine forKey:kDemoLineColor];
    [mdicRgbModelList setObject:loginTitle forKey:kDemoTitle];
    [mdicRgbModelList setObject:loginTimer forKey:kDemoTimer];

    [demoLine release];
    [loginTitle release];
    [loginTimer release];
    
}

/**
 *  初始化远程回放的cell的事件
 */
- (void)initPlayBackCellLabelColor
{
    JVCRGBModel *playBackLabel  = [[JVCRGBModel alloc] init];
    playBackLabel.r = 171.0f;
    playBackLabel.g = 171.0f;
    playBackLabel.b = 171.0f;
    
    [mdicRgbModelList setObject:playBackLabel forKey:kPlayBackCellLabelColor];
    
    [playBackLabel release];

}

/**
 *  初始化远程回放的cell的事件
 */
- (void)initAlertCellLabelColor
{
    JVCRGBModel *alarmLabel  = [[JVCRGBModel alloc] init];
    alarmLabel.r = 85.0f;
    alarmLabel.g = 85.0f;
    alarmLabel.b = 85.0f;
    
    [mdicRgbModelList setObject:alarmLabel forKey:kJVCRGBColorMacroAlertCellColor];
    
    [alarmLabel release];
    
}

/**
 *  初始化添加设备界面的RGB集合
 */
-(void)initAddDeviceTextColor{
    
    JVCRGBModel *textColor  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    textColor.r = 81.0f;
    textColor.g = 82.0f;
    textColor.b = 82.0f;
    
    [mdicRgbModelList setObject:textColor forKey:kJVCRGBColorMacroTextFontColor];
    
    [textColor release];
}

/**
 *  初始化试图的backgrou的颜色
 */
- (void)initAddDevicePopViewRGBColors
{
    JVCRGBModel *PopViewBoard  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    PopViewBoard.r = 200.0f;
    PopViewBoard.g = 199.0f;
    PopViewBoard.b = 204.0f;
    [mdicRgbModelList setObject:PopViewBoard forKey:kJVCRGBColorMacroPopBoardColor];
    [PopViewBoard release];
    
    JVCRGBModel *PopViewBg = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    PopViewBg.r = 86.0f;
    PopViewBg.g = 86.0f;
    PopViewBg.b = 86.0f;
    [mdicRgbModelList setObject:PopViewBg forKey:kJVCRGBColorMacroPopBgColor];
    [PopViewBg release];

    
}


/**
*  初始化试图的backgrou的颜色
*/
- (void)initLickTypeViewRGBColors
{
    JVCRGBModel *leftViewColor  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    leftViewColor.r = 82.0f;
    leftViewColor.g = 82.0f;
    leftViewColor.b = 82.0f;
    [mdicRgbModelList setObject:leftViewColor forKey:KLickTypeLeftLabelColor];
    [leftViewColor release];
    
    JVCRGBModel *textFieldColor = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    textFieldColor.r = 86.0f;
    textFieldColor.g = 86.0f;
    textFieldColor.b = 86.0f;
    [mdicRgbModelList setObject:textFieldColor forKey:KLickTypeTextFieldColor];
    [textFieldColor release];
    
    
}

/**
 *  初始化试图更多界面的labe（用户名的）
 */
- (void)initMoreUserLabelViewRGBColors
{
    JVCRGBModel *moreViewColor  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    moreViewColor.r = 37.0f;
    moreViewColor.g = 133.0f;
    moreViewColor.b = 229.0f;
    [mdicRgbModelList setObject:moreViewColor forKey:KMoreUserLabeTextColor];
    [moreViewColor release];
}

/**
 *  初始化视频播放的
 */
-(void)initWithPlayVideo{
    
    JVCRGBModel *titleColor  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    titleColor.r = 96.0;
    titleColor.g = 103.0f;
    titleColor.b = 114.0f;
    [mdicRgbModelList setObject:titleColor forKey:KPlayVideoBottomTitleDefaultFontColor];
    [titleColor release];
}

/**
 *  初始化视频播放的
 */
-(void)initWithResignDownLineLabe{
    
    JVCRGBModel *DownLineLabe  = [[JVCRGBModel alloc] init]; //视频编辑的功能按钮的颜色
    DownLineLabe.r = 67.0;
    DownLineLabe.g = 102.0f;
    DownLineLabe.b = 160.0f;
    [mdicRgbModelList setObject:DownLineLabe forKey:KJVCresigDownLabecolor];
    [DownLineLabe release];
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
 *  初始化声波配置流程
 */
-(void)initWithVoiceConfig {

    JVCRGBModel *info  = [[JVCRGBModel alloc] init];
    info.r = 64.0f;
    info.g = 63.0f;
    info.b = 65.0f;
    [mdicRgbModelList setObject:info forKey:kJVCRGBColorMacroVoiceConfigInfo];
    [info release];
    
    JVCRGBModel *ssid  = [[JVCRGBModel alloc] init];
    ssid.r = 0.0f;
    ssid.g = 122.0f;
    ssid.b = 255.0f;
    [mdicRgbModelList setObject:ssid forKey:kJVCRGBColorMacroVoiceConfigSSID];
    [ssid release];

    JVCRGBModel *demo  = [[JVCRGBModel alloc] init];
    demo.r = 0.0f;
    demo.g = 122.0f;
    demo.b = 255.0f;
    [mdicRgbModelList setObject:demo forKey:kJVCRGBColorMacroVoiceConfigDemo];
    [demo release];
    
    JVCRGBModel *send  = [[JVCRGBModel alloc] init];
    send.r = 82.0f;
    send.g = 82.0f;
    send.b = 82.0f;
    [mdicRgbModelList setObject:send forKey:kJVCRGBColorMacroVoiceConfigSend];
    [send release];
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
