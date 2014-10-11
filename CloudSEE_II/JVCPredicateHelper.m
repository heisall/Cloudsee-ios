//
//  JVCPredicateHelper.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/24/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCPredicateHelper.h"
#import "JVCSystemUtility.h"
#import "JVCAccountMacro.h"

@implementation JVCPredicateHelper

static JVCPredicateHelper *_shareInstance = nil;
/**
 *  单例
 *
 *  @return 返回JVCPredicateHelper的单例
 */
+ (JVCPredicateHelper *)shareInstance
{
    @synchronized(self)
    {
        if (_shareInstance == nil) {
            
            _shareInstance = [[self alloc] init ];
            
        }
        return _shareInstance;
    }
    return _shareInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (_shareInstance == nil) {
            
            _shareInstance = [super allocWithZone:zone];
            
            return _shareInstance;
            
        }
    }
    return nil;
}


/**
 *  判断字符串是否为空
 *
 *  @param string 传入的字符串
 *
 *  @return yes 为空  no：不为空
 */
- (BOOL)predicateBlankString:(NSString *)string
{
    if(string == nil)
    {
        return  YES;
    }
    if (string == NULL) {
        
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        return YES;
    }
    
    return NO;
}

/**
 *  判断添加设备的云视通号、用户名、密码是否合法
 *
 *  @param YSTNum   云视通号
 *  @param userName 用户名
 *  @param passWord 密码
 *
 *备注：添加设备的设备的密码可以为空，为了与修改设备逻辑不一样，这里密码可以为空
 *  @return 判断结果  0：成功 1：云视通号为空 2：云视通号不合法  3：用户名不为空 4：用户名不合法 5：密码为空 6：密码不合法
 */
- (int)addDevicePredicateYSTNUM:(NSString *)YSTNum  andUserName:(NSString *)userName  andPassWord:(NSString *)passWord
{
    if ([self predicateBlankString:YSTNum]) {
        
        return ADDDEVICE_YST_NIL;
        
    }else if(![self predicateYSTIsLegal:YSTNum])
    {
        return ADDDEVICE_YST_ERROR;
        
    }else if([self predicateBlankString:userName])
    {
        return ADDDEVICE_USER_NIL;
        
    }else if(![self predicateDeviceName:userName])
    {
        return ADDDEVICE_USER_ERROR;
        
    }else if(![self predicateAddDevicePassWord:passWord])
    {
        return ADDDEVICE_PASSWORD_ERROR;
    }
    return ADDDEVICE_SUCCESS;
    
}

/**
 *  判断添加设备的云视通号、用户名、密码是否合法
 *
 *  @param YSTNum   云视通号
 *  @param userName 用户名
 *  @param passWord 密码
 *
 *备注：添加设备的设备的密码可以为空，为了与修改设备逻辑不一样，这里密码可以为空
 *  @return 判断结果  0：成功 1：云视通号为空 2：云视通号不合法  3：用户名不为空 4：用户名不合法 5：密码为空 6：密码不合法
 */
- (int)addDeviceToAccountPredicateYSTNUM:(NSString *)YSTNum
{
    if ([self predicateBlankString:YSTNum]) {
        
        return ADDDEVICE_YST_NIL;
        
    }else if(![self predicateYSTIsLegal:YSTNum])
    {
        return ADDDEVICE_YST_ERROR;
        
    }
    return ADDDEVICE_SUCCESS;
    
}


/**
 *  判断设备的用户名是否合法
 *
 *  @param strDeviceName 设备的用户名
 *
 *  @return yes 合法 、no不合法
 */
-(BOOL)predicateDeviceName:(NSString *)strDeviceName
{
    NSString * regex = @"^[A-Za-z0-9_\\-]{1,16}$";
    
    return [self judgeLegalWithPredicateString:regex andCompareString:strDeviceName];
}

/**
 *  判断添加用户名是否合法
 *
 *  @param strDeviceName 设备的用户名
 *
 *  @return yes 合法 、no不合法
 */
-(BOOL)predicateAddDevicePassWord:(NSString *)strDeviceName
{
    NSString * regex = @"^.{0,16}$";
    
    return [self judgeLegalWithPredicateString:regex andCompareString:strDeviceName];
}

/**
 *  判断云视通是否合法
 *
 *  @param ystNum 云视通号码
 *
 *  @return yes：合法  no：非法
 */
-(BOOL)predicateYSTIsLegal:(NSString *)ystNum
{
    
    //  合法云视通A1-ABCD2147483647
    int kk=0;
    for (kk=0; kk<ystNum.length; kk++) {
		unsigned char c=[ystNum characterAtIndex:kk];
		if (c<='9' && c>='0') {
			break;
		}
	}
    
    if (kk>3||kk==0) {//超过4个字母或者没有字母
        
        return NO;
    }
	NSString *iYstNum=[ystNum substringFromIndex:kk];
    
    
    NSString * regexYST = @"^[1-9][0-9]{0,9}$";  //输入任意字符，但是必须要在（4～20）位之间
    
    if ([self judgeLegalWithPredicateString:regexYST andCompareString:iYstNum]) {
        
        if (iYstNum.doubleValue <= INT32_MAX) {
            
            return YES;
            
        }else{
            
            return NO;
            
        }
        
    }else{
        
        return NO;
    }
    
}

/**
 *	判断用户名是否合法
 *
 *	@param	accountName	校验的用户名
 *  思路：新判断是否是手机号 ，然后判断是否是邮箱（先判断字符串中是否有@） 然后再判断是否是用户名
 *
 *	@return	VALIDATIONUSERNAMETYPE_S=0,          //校验通过
 VALIDATIONUSERNAMETYPE_LENGTH_E=-1,  //用户名长度只能在4-28位字符之间；
 VALIDATIONUSERNAMETYPE_NUMBER_E=-2,//用户名不能全为数字
 VALIDATIONUSERNAMETYPE_OTHER_E=-3, //用户名只能由中文、英文、数字及“_”、“-”组成
 VALIDATIONUSERNAMETYPE_EMAIL_E = -5,//邮箱格式不正确
 */
-(int)predicateUserNameIslegal:(NSString *)accountName
{
    
    NSString * regex = @"^.{4,28}$";  //输入任意字符，但是必须要在（4～18）位之间
    
    if (![self judgeLegalWithPredicateString:regex andCompareString:accountName]) {
        
        return VALIDATIONUSERNAMETYPE_LENGTH_E+KPredicateUserNameLegateAddNum;
    }
    
    
    //判断是不是手机号,只有再中文环境下有效
   BOOL bSystemlanguage =  [[JVCSystemUtility shareSystemUtilityInstance]judgeAPPSystemLanguage];
    
    if(bSystemlanguage)
    {
        if ([self predicateUserNameISLegalPhome:accountName]) {
            
            return VALIDATIONUSERNAMETYPE_S+KPredicateUserNameLegateAddNum;
        }
    }
    
    //判断字符串中又@
    if ([accountName rangeOfString:@"@"].location != NSNotFound) {
        
        BOOL result = [self predicateUserNameISLegalEmail:accountName];
        
        if (result) {
            
            return VALIDATIONUSERNAMETYPE_S;
            
        }else{
            
            return VALIDATIONUSERNAMETYPE_EMAIL_E+KPredicateUserNameLegateAddNum;
        }
    }
    
    regex = @"^([+-]?)\\d*\\.?\\d+$";
    
    if ([self judgeLegalWithPredicateString:regex andCompareString:accountName]) {
        
        return VALIDATIONUSERNAMETYPE_NUMBER_E+KPredicateUserNameLegateAddNum;
    }
    
    
    regex = @"^[A-Za-z0-9_\\-]+$";
    
    if (![self judgeLegalWithPredicateString:regex andCompareString:accountName]) {
        
        return VALIDATIONUSERNAMETYPE_OTHER_E+KPredicateUserNameLegateAddNum;
    }
    
    return VALIDATIONUSERNAMETYPE_S;
}

/**
 *  判断是否是邮箱以及是否是手机号
 *
 *  @param str 传入的比较字段
 *
 *  @return yes 是合法的  no不合法
 */
- (BOOL)predicateUserNameISLegalPhome:(NSString *)str
{
    NSString *phoneRegex = @"^([1][3578]\\d{9})$";
    
    BOOL bPhone= NO;
    
    NSString *tStr = NSLocalizedString(@"ch", nil);
    
    if([tStr isEqualToString:@"中国"])
    {
        bPhone = [self judgeLegalWithPredicateString:phoneRegex andCompareString:str];
    }else{
        
        return YES ;
    }
    
    return bPhone;
    
    
}

/**
 *  判断是否是邮箱以及是否是手机号
 *
 *  @param str 传入的比较字段
 *
 *  @return yes 是合法的  no不合法
 */
- (BOOL)predicateUserNameISLegalEmail:(NSString *)str
{
    
    BOOL bEmail = [self predicateEMAILIslegal:str ];
    
    return bEmail;
}

/**
 *	判断用户的安全邮箱是否合法
 *
 *	@param	emailStr	邮箱
 *
 *	@return	YES 符合 NO 非法
 */
-(BOOL)predicateEMAILIslegal:(NSString *)emailStr{
    
    NSString * regex = @"^\\w+((-\\w+)|(\\.\\w+))*\\@[A-Za-z0-9]+((\\.|-)[A-Za-z0-9]+)*\\.[A-Za-z0-9]+$";
    
    if (emailStr.length>28) {//邮箱长度定义为28
        
        return NO;
    }
    return [self judgeLegalWithPredicateString:regex andCompareString:emailStr];
    
}

/**
 *  检测注册用户名、密码、确认密码、邮箱是否合法
 *
 *  @param userName       用户名
 *  @param passWord       密码
 *  @param enSurePassWord 确认密码
 *  @param email          邮箱
 *
 *  @return 返回相应的枚举字段
 */
- (int)predicatUserResignWithUser:(NSString *)userName
                      andPassWord:(NSString *)passWord
                andEnsurePassWord:(NSString *)enSurePassWord
{
    
    /**
     *  判断用户名是否为空
     */
    if ([self predicateBlankString:userName]) {
        
        return LOGINRESULT_USERNAME_NIL;
    }
    /**
     *  判断用户名是否合法
     */
    if ([self predicateUserNameIslegal:userName] != VALIDATIONUSERNAMETYPE_S) {
        
        return [self predicateUserNameIslegal:userName]+100;
    }
    /**
     *  判断密码是否为空
     */
    if ([self predicateBlankString:passWord]) {
        
        return LOGINRESULT_PASSWORLD_NIL;
    }
    /**
     *  判断密码是否合法
     */
    if (![self PredicateResignPasswordIslegal:passWord]) {
        
        return LOGINRESULT_PASSWORLD_ERROR;
    }
    /**
     *  判断确认密码
     */
    if ([self predicateBlankString:enSurePassWord]) {
        
        return LOGINRESULT_ENSURE_PASSWORD_NIL;
        
    }
    if (![passWord isEqualToString:enSurePassWord]) {
        
        return LOGINRESULT_ENSURE_PASSWORD_ERROR;
    }
    /**
     *  合法
     */
    return LOGINRESULT_SUCCESS;
    
    
}



/**
 *	判断注册界面密码是否合法
 *
 *	@param	passwordStr	验证的密码 密码可以6到20位字符数字或符号的组合
 *
 *	@return	YES 符合 NO 非法
 */
-(BOOL)PredicateResignPasswordIslegal:(NSString *)passwordStr
{
    
    NSString * regex = @"^.{6,20}$";  //输入任意字符，但是必须要在（6～20）位之间
    
    return [self judgeLegalWithPredicateString:regex andCompareString:passwordStr];
}

- (BOOL)judgeLegalWithPredicateString:(NSString *)predicateStr  andCompareString:(NSString *)strCompare
{
    NSPredicate *predicateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", predicateStr];
    return [predicateTest evaluateWithObject:strCompare];
}

/**
 *  判断旧密码、新密码、确认密码、是否合法
 *
 *  @param OldPassWord 用户输入的用户名
 *  @param NewPassWord 新密码
 *  @param enSurePassWord 确认密码
 *  @param userSavePassWord         本地保存的用户名
 *
 *0登录成功、1：用户名为空、2：密码为空、3：用户名不合法、4：密码不合法、 5确认密码不合法、6邮箱不合法 、7与本地保存的秘密不一致
 *  @return 返回相应的数值
 */
- (int)predicateUserOldPassWord:(NSString *)OldPassWord
                    NewPassWord:(NSString *)NewPassWord
                 EnsurePassWord:(NSString *)enSurePassWord
               UserSavePassWord:(NSString *)userSavePassWord
{
    /**
     *  判断用户名是否为空
     */
    if ([self predicateBlankString:OldPassWord]) {
        
        return LOGINRESULT_PASSWORLD_NIL;
    }
    /**
     *  判断用户名是否合法
     */
    if (![self PredicateResignPasswordIslegal:OldPassWord]) {
        
        return LOGINRESULT_PASSWORLD_ERROR;
    }
    /**
     *  本地保存的用户名密码与现在的用户名密码是否一致
     */
    if (![userSavePassWord isEqualToString:OldPassWord]) {
        
        return LOGINRESULT_NOT_EQUAL_USER_PASSWORD;
    }
    /**
     *  判断密码是否为空
     */
    if ([self predicateBlankString:NewPassWord]) {
        
        return LOGINRESULT_PASSWORLD_NIL;
    }
    /**
     *  判断密码是否合法
     */
    if (![self PredicateResignPasswordIslegal:NewPassWord]) {
        
        return LOGINRESULT_PASSWORLD_ERROR;
    }
    
    if ([self predicateBlankString:enSurePassWord]) {
        
        return  LOGINRESULT_ENSURE_PASSWORD_NIL;
    }
    
    if (![enSurePassWord isEqualToString:NewPassWord]) {
        
        return LOGINRESULT_ENSURE_PASSWORD_ERROR;
    }
    
    if ([NewPassWord isEqualToString:OldPassWord]) {
        
        return LOGINRESULT_OLD_PASS_EQUAl_NEW_PASSWORD;
    }
    
    /**
     *  合法
     */
    return LOGINRESULT_SUCCESS;
    
}

/**
 *  修改设备昵称、用户名、密码的时候，判断一下相应的字段是否合法
 *
 *  @param nickName 昵称
 *  @param userName 用户名
 *  @param passWord 密码
 *
 *  @return 相应的返回值
 */
- (int)modifyDevicePredicatWithNickName:(NSString *)nickName
                            andUserName:(NSString *)userName
                            andPassWord:(NSString *)passWord
{
    if ([self predicateBlankString:nickName]) {
        
        return MODIFY_DEVIE_NICK_NIL;
        
    }else if(![self predicateDeviceNickName:nickName])
    {
        
        return MODIFY_DEVIE_NICK_ERROR;
        
    }else if ([self predicateBlankString:userName])
    {
        
        return MODIFY_DEVIE_USER_NIL;
        
    }else if(![self predicateDeviceName:userName])
    {
        return MODIFY_DEVIE_USER_ERROR;
        
    }else if(![self predicateAddDevicePassWord:passWord])
    {
        return MODIFY_DEVIE_PASSWORD_ERROR;
    }
    
    return MODIFY_DEVIE_SUCCESS;
}

/**
 *  判断昵称是否合法
 *
 *  @param strNickName 昵称
 *
 *  @return  yes 合法  no：不合法
 */
- (BOOL)predicateDeviceNickName:(NSString *)strNickName
{
    
    BOOL result=TRUE;
    
    NSString *regex = @"^[a-zA-Z0-9_.()\\u4E00-\\u9FA5-\\+]+$";
    
    if (![self judgeLegalWithPredicateString:regex andCompareString:strNickName]) {
        
        return FALSE;
    }
    
    if (strlen([strNickName UTF8String])>20) {
        
        return FALSE;
    }
    
    return result;
    
}

/**
 *  判断昵称是否合法
 *
 *  @param nickName 昵称
 *
 *  @return 0 成功  其他失败
 */
- (int)predicateChannelNickName:(NSString *)nickName
{
    if ([self predicateBlankString:nickName]) {
        
        return MODIFY_DEVIE_NICK_NIL;
        
    }else if(![self predicateDeviceNickName:nickName])
    {
        
        return MODIFY_DEVIE_NICK_ERROR;
        
    }
    return MODIFY_DEVIE_SUCCESS;
}

/**
 *  判断邮箱是否合法
 *
 *  @param email 邮箱
 *
 *  @return 相应的用户名
 */
- (int)predicateEmailLegal:(NSString *)email
{
    if (![self predicateEMAILIslegal:email]) {
        
        return LOGINRESULT_EMAIL_ERROR;
        
    }
    /**
     *  合法
     */
    return LOGINRESULT_SUCCESS;
}

@end
