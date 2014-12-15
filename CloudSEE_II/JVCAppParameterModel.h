//
//  JVCAppParameterModel.h
//  CloudSEE_II
//
//  Created by David on 14/12/15.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(int, JVCRegisterType) {
    
    JVCRegisterType_Default         = 0,//没有注册协议
    JVCRegisterType_China           = 1,//中文环境下有
    JVCRegisterType_ALL             = 2,//全有

    
};

/**
 程序的抓拍方式
 */
enum JVCConfigModelCaptureModeType{
    
    JVCConfigModelCaptureModeTypeDecoder = 0,  //解码抓拍
    JVCConfigModelCaptureModeTypeDevice  = 1,  //设备抓拍（主要应用于惠通设备，闪光灯抓拍）
};

@interface JVCAppParameterModel : NSObject
{
    //默认值为no  ，yes为支持，NO不支持
    BOOL        bHasDemoPoint;         //是否有演示点
    BOOL        bHasFeedback;          //是否有意见与反馈
    BOOL        bHasVoiceDevice;       //是否有声波添加
    BOOL        bHasGuidHelp;           //是否有引导图
    BOOL        bHasAdvertising;       //是否有广告位
    BOOL        isEnableAPModel;        //是否启用STA切换AP功能 fase 正常  yes启用sta和ap切换

    int         nHasRegister;          //注册协议
    int         nUpdateIdentification; //升级应用标识
    int         nCaptureMode;      //抓拍的模式

    NSString    *appleID;               //程序的id
    NSString    *userName;              //用户名
    NSString    *passWord;              //密码
    

}

@property(nonatomic,assign)BOOL        bHasDemoPoint;
@property(nonatomic,assign)BOOL        bHasFeedback;
@property(nonatomic,assign)BOOL        bHasVoiceDevice;
@property(nonatomic,assign)BOOL        bHasGuidHelp;
@property(nonatomic,assign)BOOL        bHasAdvertising;
@property(nonatomic,assign)BOOL        isEnableAPModel;

@property(nonatomic,assign)int         nHasRegister;
@property(nonatomic,assign)int         nUpdateIdentification;
@property(nonatomic,assign)int         nCaptureMode;      //抓拍的模式

@property(nonatomic,retain)NSString    *appleID;
@property(nonatomic,retain)NSString    *userName;
@property(nonatomic,retain)NSString    *passWord;

/**
 *  单利
 *
 *  @return 返回单利对象
 */
+(JVCAppParameterModel *)shareJVCAPPParameter;

@end
