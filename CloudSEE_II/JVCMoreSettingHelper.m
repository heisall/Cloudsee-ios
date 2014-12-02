//
//  JVCMoreSettingHelper.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCMoreSettingHelper.h"
#import "JVCMoreSettingModel.h"
#import "JVCMoreUserSettingModel.h"
#import "JVCConfigModel.h"

@implementation JVCMoreSettingHelper

static JVCMoreSettingHelper *shareMoreSettingHelper = nil;

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCMoreSettingHelper *)shareDataBaseHelper
{
    @synchronized(self)
    {
        if (shareMoreSettingHelper == nil) {
            
            shareMoreSettingHelper = [[self alloc] init];
        }
        
        return shareMoreSettingHelper;
    }
    
    return shareMoreSettingHelper;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareMoreSettingHelper == nil) {
            
            shareMoreSettingHelper = [super allocWithZone:zone];
            
            return shareMoreSettingHelper;
        }
    }
    
    return nil;
}

/**
 *  获取设备列表
 */
- (NSMutableArray *)getMoreSettingList
{
    NSMutableArray *arrayList = [[NSMutableArray alloc] init];
    
    /**
     *  用户信息,这个model是为了占位置，不用
     */
    NSMutableArray *HeadSectionArray = [[NSMutableArray alloc] init];
    
    //这个界面不用
    JVCMoreSettingModel *modehead = [[JVCMoreSettingModel alloc] init];
    modehead.itemName = @"不用";
    modehead.iconImageName = @"mor_head_0.png";
    modehead.bBtnState = NO;
    [HeadSectionArray addObject:modehead];
    [modehead release];
    
    [arrayList addObject:HeadSectionArray];
    
    [HeadSectionArray release];
    
    /**
     *  第一部分
     */
    NSMutableArray *FistSectionArray = [[NSMutableArray alloc] init];
    //报警
    JVCMoreSettingModel *modelHelp = [[JVCMoreSettingModel alloc] init];
    modelHelp.itemName = LOCALANGER(@"jvc_more_alarm");
    modelHelp.iconImageName = @"mor_Iconalarm.png";
    modelHelp.bNewState = NO;
    modelHelp.bBtnState = MoreSettingCellType_AccountSwith;
//    modelHelp.bSwitchState = kkToken
    [FistSectionArray addObject:modelHelp];
    [modelHelp release];
    
    //修改密码
    JVCMoreSettingModel *modelUser = [[JVCMoreSettingModel alloc] init];
    modelUser.itemName = LOCALANGER(@"jvc_more_editPw");
    modelUser.iconImageName = @"mor_Iconmdy.png";
    modelUser.bBtnState = MoreSettingCellType_index;
    [FistSectionArray addObject:modelUser];
    [modelUser release];
    
    //功能设置
//    JVCMoreSettingModel *modelFunction = [[JVCMoreSettingModel alloc] init];
//    modelFunction.itemName = @"报警";
//    modelFunction.iconImageName = @"mor_IconFun.png";
//    modelFunction.bBtnState = NO;
//    modelFunction.bNewState = MoreSettingCellType_Switch;
//    [FistSectionArray addObject:modelFunction];
//    [modelFunction release];
    
    //报警
    JVCMoreSettingModel *deviceHelp = [[JVCMoreSettingModel alloc] init];
    deviceHelp.itemName = LOCALANGER(@"jvc_more_screen_set");
    deviceHelp.iconImageName = @"mor_DevBrowse.png";
    deviceHelp.bNewState = NO;
    deviceHelp.bBtnState = MoreSettingCellType_CustomSwitc;
    [FistSectionArray addObject:deviceHelp];
    [deviceHelp release];
    
    [arrayList addObject:FistSectionArray];
    [FistSectionArray release];
    
    /**
     *  第2部分
     */
    NSMutableArray *secondSectionArray = [[NSMutableArray alloc] init];
    //检测更新
    JVCMoreSettingModel *modeShark = [[JVCMoreSettingModel alloc] init];
    modeShark.itemName = LOCALANGER(@"jvc_more_checkVersion");
    modeShark.iconImageName = @"mor_IconCheck.png";
    modeShark.bBtnState = NO;
    modeShark.bNewState =  [JVCConfigModel shareInstance]._bNewVersion ;;
    [secondSectionArray addObject:modeShark];
    [modeShark release];
    
//    //帮助
//    JVCMoreSettingModel *modelHelpSwitch = [[JVCMoreSettingModel alloc] init];
//    modelHelpSwitch.itemName = LOCALANGER(@"jvc_more_help");
//    modelHelpSwitch.iconImageName = @"mor_IconHelp.png";
//    modelHelpSwitch.bBtnState = MoreSettingCellType_Switch;
//    [secondSectionArray addObject:modelHelpSwitch];
//    [modelHelpSwitch release];

    
    //版本号
    JVCMoreSettingModel *modelAbout = [[JVCMoreSettingModel alloc] init];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app版本
    
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    modelAbout.itemName =[NSString stringWithFormat:@"%@                             V%@",LOCALANGER(@"version"),app_Version];
    modelAbout.iconImageName = @"mor_IconAbout.png";
    modelAbout.bBtnState = NO;
    [secondSectionArray addObject:modelAbout];
    [modelAbout release];
    
    //意见反馈
    JVCMoreSettingModel *modelSuggest = [[JVCMoreSettingModel alloc] init];
    modelSuggest.itemName = LOCALANGER(@"jvc_more_suggest");
    modelSuggest.iconImageName = @"mor_IconSug.png";
    modelSuggest.bBtnState = NO;
    [secondSectionArray addObject:modelSuggest];
    [modelSuggest release];

    [arrayList addObject:secondSectionArray];
    
    [secondSectionArray release];
    
    /**
     *  第三部分
     */
    NSMutableArray *thirdSectionArray = [[NSMutableArray alloc] init];
    //评论
    JVCMoreSettingModel *modelItuns = [[JVCMoreSettingModel alloc] init];
    modelItuns.itemName = LOCALANGER(@"jvc_more_appStore");
    modelItuns.iconImageName = @"mor_IconItuns.png";
    modelItuns.bBtnState = NO;
    
    [thirdSectionArray addObject:modelItuns];
    [modelItuns release];
    
    [arrayList addObject:thirdSectionArray];
    
    [thirdSectionArray release];
    
    
    //第四部分
    NSMutableArray *FiveArray = [[NSMutableArray alloc] init];
    //账号注销
    JVCMoreSettingModel *mediaBtn = [[JVCMoreSettingModel alloc] init];
    mediaBtn.itemName = LOCALANGER(@"jvc_more_media_title");
    mediaBtn.iconImageName = @"mor_pm1.png";
    mediaBtn.bBtnState = MoreSettingCellType_index;
    [FiveArray addObject:mediaBtn];
    [arrayList addObject:FiveArray];
    [mediaBtn release];
    [FiveArray release];
    
    //第五部分
    NSMutableArray *fourthArray = [[NSMutableArray alloc] init];
    //账号注销
    JVCMoreSettingModel *modelBtn = [[JVCMoreSettingModel alloc] init];
    modelBtn.itemName = LOCALANGER(@"jvc_more_userOut");
    modelBtn.iconImageName = @"mor_pm1.png";
    modelBtn.bBtnState = YES;
    [fourthArray addObject:modelBtn];
    [modelBtn release];
    
    [arrayList addObject:fourthArray];
    [fourthArray release];


    return [arrayList autorelease];
    
}


/**
 *  获取更多界面用户设置
 */
- (NSMutableArray *)getMoreUserSettingList
{
    NSMutableArray *arrayUserList = [[NSMutableArray alloc] init];
    
    //自动登录
    JVCMoreUserSettingModel *modelUserLogin = [[JVCMoreUserSettingModel alloc] init];
    modelUserLogin.titleString = @"自动登录";
    modelUserLogin.footString = @"关闭自动登录工恩呢刚，会同时关闭手势密码功能";
    modelUserLogin.typeFlag = TYPEFLAG_SWitch;
    [arrayUserList addObject:modelUserLogin];
    [modelUserLogin release];
    
    //修改密码
    JVCMoreUserSettingModel *modelEditUserName = [[JVCMoreUserSettingModel alloc] init];
    modelEditUserName.titleString = @"修改密码";
    modelEditUserName.footString = @"";
    modelEditUserName.typeFlag = TYPEFLAG_Indicator;
    [arrayUserList addObject:modelEditUserName];
    [modelEditUserName release];
    
    //手势秘密
    JVCMoreUserSettingModel *modelGuest = [[JVCMoreUserSettingModel alloc] init];
    modelGuest.titleString = @"手势密码";
    modelGuest.footString = @"开启手势秘密时会同时开启自动登录功能";
    modelGuest.typeFlag = TYPEFLAG_SWitch;
    [arrayUserList addObject:modelGuest];
    [modelGuest release];
    
    //手势秘密
    JVCMoreUserSettingModel *modelEditGuest = [[JVCMoreUserSettingModel alloc] init];
    modelEditGuest.titleString = @"修改手势密码";
    modelEditGuest.footString = @"";
    modelEditGuest.typeFlag = TYPEFLAG_None;
    [arrayUserList addObject:modelEditGuest];
    [modelEditGuest release];

    
    return [arrayUserList autorelease];
    
}
@end
