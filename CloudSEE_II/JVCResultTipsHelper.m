//
//  JVCResultTipsHelper.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/25/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCResultTipsHelper.h"
#import "JVCAccountMacro.h"
#import "JVCAlertHelper.h"
#import "JVCPredicateHelper.h"
@implementation JVCResultTipsHelper

static JVCResultTipsHelper *shareResultTipsHelper = nil;

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCResultTipsHelper *)shareResultTipsHelper
{
    @synchronized(self)
    {
        if (shareResultTipsHelper == nil) {
            
            shareResultTipsHelper = [[self alloc] init];
        }
        
        return shareResultTipsHelper;
    }
    
    return shareResultTipsHelper;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareResultTipsHelper == nil) {
            
            shareResultTipsHelper = [super allocWithZone:zone];
            
            return shareResultTipsHelper;
        }
    }
    
    return nil;
}

#pragma mark 判断用户名秘密合法的提示
/**
 *  弹出用户名、密码正则验证的提示
 *
 *  @param result 相应的返回值
 */
- (void)showLoginPredacateAlertWithResult:(int )result
{
    switch (result) {
            
        case LOGINRESULT_USERNAME_NIL:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"LOGINRESULT_USERNAME_NIL")];
            break;
            
        case LOGINRESULT_PASSWORLD_NIL:
            [[JVCAlertHelper shareAlertHelper]  alertToastWithKeyWindowWithMessage:LOCALANGER(@"LOGINRESULT_PASSWORLD_NIL")];
            break;
            
        case LOGINRESULT_USERNAME_ERROR:
            [[JVCAlertHelper shareAlertHelper]  alertToastWithKeyWindowWithMessage:LOCALANGER(@"LOGINRESULT_USERNAME_ERROR")];
            break;
            
        case LOGINRESULT_PASSWORLD_ERROR:
            [[JVCAlertHelper shareAlertHelper]  alertToastWithKeyWindowWithMessage:LOCALANGER(@"LOGINRESULT_PASSWORLD_ERROR")];
            break;
            
            
            
        case LOGINRESULT_ENSURE_PASSWORD_NIL:
            [[JVCAlertHelper shareAlertHelper]  alertToastWithKeyWindowWithMessage:LOCALANGER(@"LOGINRESULT_ENSURE_PASSWORD_NIL")];
            break;
            
        case LOGINRESULT_ENSURE_PASSWORD_ERROR:
            [[JVCAlertHelper shareAlertHelper]  alertToastWithKeyWindowWithMessage:LOCALANGER(@"LOGINRESULT_ENSURE_PASSWORD_ERROR")];
            break;
            
        case LOGINRESULT_EMAIL_ERROR:
            [[JVCAlertHelper shareAlertHelper]  alertToastWithKeyWindowWithMessage:LOCALANGER(@"LOGINRESULT_EMAIL_ERROR")];
            break;
            
        case LOGINRESULT_NOT_EQUAL_USER_PASSWORD:
            [[JVCAlertHelper shareAlertHelper]  alertToastWithKeyWindowWithMessage:LOCALANGER(@"LOGINRESULT_NOT_EQUAL_USER_PASSWORD")];
            break;
            
        case LOGINRESULT_OLD_PASS_EQUAl_NEW_PASSWORD:
            [[JVCAlertHelper shareAlertHelper]  alertToastWithKeyWindowWithMessage:LOCALANGER(@"login_pw_equal")];
            
            break;
        case VALIDATIONUSERNAMETYPE_LENGTH_E+KAddTag:
            [[JVCAlertHelper shareAlertHelper]  alertToastWithKeyWindowWithMessage:LOCALANGER(@"loginResign_LENGTH_E")];
            
            break;
        case VALIDATIONUSERNAMETYPE_NUMBER_E+KAddTag:
            [[JVCAlertHelper shareAlertHelper]  alertToastWithKeyWindowWithMessage:LOCALANGER(@"loginResign_NUMBER_E")];
            
            break;
        case VALIDATIONUSERNAMETYPE_OTHER_E+KAddTag:
            [[JVCAlertHelper shareAlertHelper]  alertToastWithKeyWindowWithMessage:LOCALANGER(@"loginResign_OTHER_E")];
            
            break;
            
        case VALIDATIONUSERNAMETYPE_PHONE_E+KAddTag:
            [[JVCAlertHelper shareAlertHelper]  alertToastWithKeyWindowWithMessage:LOCALANGER(@"home_login_resign_PhoneNum_error")];
            break;
        case VALIDATIONUSERNAMETYPE_EMAIL_E+KAddTag:
            [[JVCAlertHelper shareAlertHelper]  alertToastWithKeyWindowWithMessage:LOCALANGER(@"home_email_error")];
            break;
            
        default:
            break;
    }
}

/**
 *  账号通过验证，调用登录函数收到的错误返回值的提示
 *
 *  @param resutl 相应的返回值
 */
- (void)loginInWithJudegeUserNameStrengthResult:(int)result
{
    switch (result) {
        case USER_HAS_EXIST:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"USER_HAS_EXIST")];
            break;
        case USER_NOT_EXIST:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"USER_NOT_EXIST")];
            break;
        case PASSWORD_ERROR:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"password_error_result")];//loginResign_passWord_error
            break;
        case SESSION_NOT_EXSIT:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"SESSION_NOT_EXSIT")];
            break;
            
        case CONN_OTHER_ERROR:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"CONN_OTHER_ERROR")];
            break;
            
        case REQ_RES_TIMEOUT:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"REQ_RES_TIMEOUT")];
            break;
            
        default:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:[NSString stringWithFormat:@"%@%d",LOCALANGER(@"Login_Default_error"),result+OTHER_ERROR]];
            break;
    }
    
}


/**
 *  修改设备的用户名、密码、昵称的返回值显示信息
 */
- (void)showModifyDeviceInfoResult:(int)result
{
    switch (result) {
        case MODIFY_DEVIE_NICK_NIL:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"MODIFY_DEVIE_NICK_NIL") ];
            break;
            
        case MODIFY_DEVIE_NICK_ERROR:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"MODIFY_DEVIE_NICK_ERROR") ];
            break;
        case MODIFY_DEVIE_USER_NIL:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"MODIFY_DEVIE_USER_NIL") ];
            break;
        case MODIFY_DEVIE_PASSWORD_NIL:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"MODIFY_DEVIE_PASSWORD_NIL") ];
            break;
        case MODIFY_DEVIE_USER_ERROR:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"DEVICE_USERNAME_ERROR") ];
            break;
            
        case MODIFY_DEVIE_PASSWORD_ERROR:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"DEVICE_PASSWORLD_ERROR") ];
            break;
            
        default:
            break;
    }
}

/**
 *  添加设备界面、根据正则的返回值处理提示
 *
 *  @param result 正则的返回值
 */
- (void)showAddDevicePredicateAlert:(int )result
{
    switch (result) {
        case ADDDEVICE_YST_NIL:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"yunshitongNIl", nil)];
            break;
            
        case ADDDEVICE_YST_ERROR:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"nolegalYushitongadd", nil)];
            break;
            
        case ADDDEVICE_USER_NIL:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"UserNameNil", nil)];
            break;
            
        case ADDDEVICE_USER_ERROR:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"DEVICE_USERNAME_ERROR", nil)];
            break;
            
        case ADDDEVICE_PASSWORD_NIL://现在不能用
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"LOGINRESULT_PASSWORLD_NIL", nil)];
            break;
            
        case ADDDEVICE_PASSWORD_ERROR:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"DEVICE_PASSWORLD_ERROR", nil)];
            break;
            
        default:
            break;
    }
    
}

/**
 *  连接模式界面修改
 *
 *  @param result 相应的返回值
 */
- (void)showModifyDevieLinkModelError:(int )result
{
    switch (result) {
            
        case LINKMODEL_USER_NIL:
            [ [JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"LINKMODEL_USER_NIL")];
            break;
        case LINKMODEL_USER_ERROR:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"LINKMODEL_USER_ERROR")];
            break;
        case LINKMODEL_PASSWORD_NIL:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"LINKMODEL_PASSWORD_NIL")];
            break;
        case LINKMODEL_PASSWORD_ERROR:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"LINKMODEL_PASSWORD_ERROR")];
            break;
            
        case LINKMODEL_IP_NIL:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"LINKMODEL_IP_NIL")];
            break;
        case LINKMODEL_IP_ERROR:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"LINKMODEL_IP_ERROR")];
            break;
            
        case LINKMODEL_PORT_NIL:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"LINKMODEL_PORT_NIL")];
            break;
        case LINKMODEL_PORT_ERROR:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"LINKMODEL_PORT_ERROR")];
            break;
            
            
        default:
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:[NSString stringWithFormat:@"%@%d",LOCALANGER(@"LINKMODEL_UNKONWN_ERROR"),result]];
            
            break;
    }
    
}


/**
 *  根据参数提示不同的信息
 *
 *  @param message 提示的信息
 */
- (void)showResultAlertOnModifyVCWithMessage:(int)result
{
    NSString *aletString = nil;
    
    switch (result) {
            
        case USER_HAS_EXIST:
            aletString = LOCALANGER(@"binding_email_exist");
            break;
        case CONN_OTHER_ERROR:
            aletString=LOCALANGER(@"CONN_OTHER_ERROR") ;
            break;
            
        case REQ_RES_TIMEOUT:
            aletString=LOCALANGER(@"REQ_RES_TIMEOUT");
            break;
        default:
            aletString = [NSString stringWithFormat:@"%@%d",LOCALANGER(@"Login_Default_error"),result];
            break;
            
    }
    
    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:aletString];
}

@end
