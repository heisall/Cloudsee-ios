//
//  JVCMoreSettingHelper.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCMoreSettingHelper.h"
#import "JVCMoreSettingModel.h"

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
    //帮助界面
    JVCMoreSettingModel *modelHelp = [[JVCMoreSettingModel alloc] init];
    modelHelp.itemName = @"帮助界面";
    modelHelp.iconImageName = @"mor_IconHelp.png";
    modelHelp.bNewState = YES;
    modelHelp.bBtnState = NO;
    [FistSectionArray addObject:modelHelp];
    [modelHelp release];
    
    //账号信息
    JVCMoreSettingModel *modelUser = [[JVCMoreSettingModel alloc] init];
    modelUser.itemName = @"账号信息";
    modelUser.iconImageName = @"mor_IconUser.png";
    modelUser.bBtnState = NO;
    [FistSectionArray addObject:modelUser];
    [modelUser release];
    
    //功能设置
    JVCMoreSettingModel *modelFunction = [[JVCMoreSettingModel alloc] init];
    modelFunction.itemName = @"功能设置";
    modelFunction.iconImageName = @"mor_IconFun.png";
    modelFunction.bBtnState = NO;
    modelFunction.bNewState = YES;
    [FistSectionArray addObject:modelFunction];
    [modelFunction release];
    
    [arrayList addObject:FistSectionArray];
    
    [FistSectionArray release];
    
    /**
     *  第2部分
     */
    NSMutableArray *secondSectionArray = [[NSMutableArray alloc] init];
    //摇一摇加设备
    JVCMoreSettingModel *modeShark = [[JVCMoreSettingModel alloc] init];
    modeShark.itemName = @"摇一摇加设备";
    modeShark.iconImageName = @"mor_IconShark.png";
    modeShark.bBtnState = NO;
    [secondSectionArray addObject:modeShark];
    [modeShark release];
    
    //关于我们
    JVCMoreSettingModel *modelAbout = [[JVCMoreSettingModel alloc] init];
    modelAbout.itemName = @"关于我们";
    modelAbout.iconImageName = @"mor_IconAbout.png";
    modelAbout.bBtnState = NO;
    [secondSectionArray addObject:modelAbout];
    [modelAbout release];
    
    //意见反馈
    JVCMoreSettingModel *modelSuggest = [[JVCMoreSettingModel alloc] init];
    modelSuggest.itemName = @"意见反馈";
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
    modelItuns.itemName = @"评论";
    modelItuns.iconImageName = @"mor_IconItuns.png";
    modelItuns.bBtnState = NO;
    [thirdSectionArray addObject:modelItuns];
    [modelItuns release];
    
    [arrayList addObject:thirdSectionArray];
    
    [thirdSectionArray release];

    //第四部分
    NSMutableArray *fourthArray = [[NSMutableArray alloc] init];
    //账号注销
    JVCMoreSettingModel *modelBtn = [[JVCMoreSettingModel alloc] init];
    modelBtn.itemName = @"账号注销";
    modelBtn.iconImageName = @"mor_head_0.png";
    modelBtn.bBtnState = YES;
    [fourthArray addObject:modelBtn];
    [modelBtn release];
    
    [arrayList addObject:fourthArray];
    
    [fourthArray release];


    return [arrayList autorelease];
    
}

@end
