//
//  JVCKeepOnlineHelp.m
//  CloudSEE_II
//  保持在线的帮助类
//  Created by Yanghu on 10/10/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCKeepOnlineHelp.h"
#import "JVCConfigModel.h"
#import "JVCAccountHelper.h"
#import "JVCAccountMacro.h"
#import "JVCDataBaseHelper.h"
#import "AppDelegate.h"
#import "JVCAlarmCurrentView.h"
#import "JSONKit.h"
#import "JVCSystemUtility.h"
#import "JVCAlarmModel.h"

enum PushMessage
{
    NOTIFY_OFFLINE = 4301,//直接提掉线
    PTCP_ERROR        = 3103,//停止心跳、然后提掉线
    PTCP_CLOSED        = 3104,//停止心跳，然后提掉线
    RECIVE_PUSH_MESSAGE = 4602,
    RECIVE_PUSH_MESSAGE_NEW = 4604,

};

@interface JVCKeepOnlineHelp ()
{
    int iUserAlarmState;
}

@end
@implementation JVCKeepOnlineHelp

static JVCKeepOnlineHelp *_shareInstance = nil;

static const int KEEPONLINE_SUCCESS = 0;//保持在线的正确结果
static const int KMAX_ERROR_COUNT   = 4;//最大提掉线次数
static const int KTAGADDNUM         = 1000;//tag最大值

int _iErrorNUm = 0;//保持在线的统计次数
NSTimer *timerCuntDown;//倒计时的
UIAlertView *alertView;
/**
 *  单例
 *
 *  @return 返回JVCKeepOnlineHelp的单例
 */
+ (JVCKeepOnlineHelp *)shareKeepOnline
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
 *  启心跳
 */
-(void)startKeepOnline
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        BOOL resultLanguage = [[JVCSystemUtility shareSystemUtilityInstance] judgeAPPSystemLanguage];
        DDLogVerbose(@"result=%d",!resultLanguage);
        [[JVCAccountHelper sharedJVCAccountHelper] keepOnline:kkToken languageType:!resultLanguage];
        
        [JVCAccountHelper sharedJVCAccountHelper].delegate = self;
        
        /**
         *  上传报警信息
         */
        [[JVCAccountHelper sharedJVCAccountHelper]  activeServerPushToken:kkToken];

    });
    
}

- (void)getAccountAlarmState
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
         iUserAlarmState = [[JVCAccountHelper sharedJVCAccountHelper] getAlarmStateInt];
        
    });
}

/**
 *  停心跳
 */
-(void)stopKeepOnline
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_ACCOUNT) {

            [[JVCAccountHelper sharedJVCAccountHelper] stopServerTimer];
            
        }
        
    });
}

/**
 *  注销用户，这个里面有停心跳
 */
- (void)userLoginOut
{
    /**
     *  账号注销，就带有停心跳命令
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_ACCOUNT) {
            
         int result =   [[JVCAccountHelper sharedJVCAccountHelper] UserLogout];
            
            DDLogVerbose(@"-%s-%d",__FUNCTION__,result);
        }
        
    });

}

/**
 *  维持在线的委托回调
 *
 *  @param keepOnlineType 返回的维持在线的结果
 */
-(void)keepOnlineReturnValue:(int)keepOnlineType
{
    DDLogVerbose(@"保存在线的返回值=%d",keepOnlineType);
    
    [self performSelectorOnMainThread:@selector(dealWithKeepOnResult:) withObject:[NSNumber numberWithInt:keepOnlineType] waitUntilDone:NO ];

}

- (void)dealWithKeepOnResult:(NSNumber *)resultNum
{
    int result = resultNum.intValue;
    
    if (KEEPONLINE_SUCCESS == result) {
        
        _iErrorNUm = 0;
        
    }else if(NOTIFY_OFFLINE == result){//直接提掉线
        
        [self userOffLineImmediately];
        
        
    }else if(PTCP_ERROR ==result ||PTCP_CLOSED == result)
    {
        //停止心跳
        [self stopKeepOnline];
        //弹出提掉线提示
        [self userOffLineNerWorkError];
        
    }else{
        _iErrorNUm++;
        
        if(_iErrorNUm>=KMAX_ERROR_COUNT)
        {
            result = -10000;
            
            //停止心跳
            [self stopKeepOnline];
            //弹出提掉线提示
            [self userOffLineNerWorkError];
            _iErrorNUm=0;
        }
        
    }

}
/**
 *  帐号服务器的长连接的回调 （包含实时报警、赶人下线、TCP断开）
 *
 *  @param keepOnlineType
 */
-(void)serverPushCallBack:(int)message_type serverPushData:(NSData *)serverPushData
{
    
    
    NSLog(@"帐号服务器的长连接的回调 （包含实时报警、赶人下线、TCP断开=%@",[[NSString alloc] initWithData:serverPushData  encoding:NSUTF8StringEncoding]);
    
    switch (message_type) {
        case NOTIFY_OFFLINE:
        case PTCP_ERROR:
        case PTCP_CLOSED:
            [self performSelectorOnMainThread:@selector(dealWithKeepOnResult:) withObject:[NSNumber numberWithInt:message_type] waitUntilDone:NO ];

            break;
            
         case RECIVE_PUSH_MESSAGE://报警的
            break;
            
        case RECIVE_PUSH_MESSAGE_NEW://报警的
            
            [self performSelectorOnMainThread:@selector(dealWithCurrentAlarm:) withObject:serverPushData waitUntilDone:NO ];

            break;
            
        default:
            break;
    }
}

/**
 *  立马提掉线
 */
- (void)userOffLineImmediately
{
    [self closeAlertView];
    
    alertView  = [[UIAlertView alloc] initWithTitle:@"15" message:LOCALANGER(@"AlertkeepLineError_title") delegate:self cancelButtonTitle:LOCALANGER(@"AlertkeepLineError_LoginIn") otherButtonTitles:LOCALANGER(@"AlertkeepLineError_userOut"), nil];
    alertView.tag = 2*KTAGADDNUM;
    alertView.delegate = self;
    [alertView show];
    [alertView release];
    
    [self startTimerCountDown];

}

/**
 *  网路异常
 */
- (void)userOffLineNerWorkError
{
    
    [self closeAlertView];

    alertView  = [[UIAlertView alloc] initWithTitle:LOCALANGER(@"AlertkeepLineError_network_title") message:nil delegate:self cancelButtonTitle:LOCALANGER(@"Sure") otherButtonTitles: nil];
    alertView.delegate = self;
    [alertView show];
    
}

- (void)closeAlertView
{
    if (alertView!=nil) {
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
        [alertView release];
        alertView = nil;
    }
}

- (void)timerCountDown
{
    if(alertView)
    {
        if(alertView.title.intValue >0)
        {
            alertView.title = [NSString stringWithFormat:@"%d",alertView.title.intValue-1];
            
        }else{
            
            [self stopTimerCountDown];
            
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            if (alertView.tag==(2*KTAGADDNUM)) {
                
                [self alertView:alertView clickedButtonAtIndex:1];
                
            }else{
                [self alertView:alertView clickedButtonAtIndex:0];
                
            }
        }
    }

}

/**
 *  开启倒计时
 */
- (void)startTimerCountDown
{
    timerCuntDown = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCountDown) userInfo:nil repeats:YES];
}

/**
 *  关闭倒计时
 */
- (void)stopTimerCountDown
{
    if (timerCuntDown &&[timerCuntDown isValid]) {
        [timerCuntDown invalidate];
        timerCuntDown =nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (2*KTAGADDNUM == alertView.tag) {
        [self stopTimerCountDown];
        if ( 0 ==buttonIndex) {//继续登录
            
            [self loginInWithOffLine];
            
        }else{//退出
            
            [self keepOnLineErrorToPresentLoginViewController];
        }
    }else
    {//退出
        [self keepOnLineErrorToPresentLoginViewController];
        
    }
}

/**
 *  保持在线失败后，跳转到登入界面
 */
- (void)keepOnLineErrorToPresentLoginViewController
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate presentLoginViewController];
    //并且把秘密置换成功
    [[JVCDataBaseHelper shareDataBaseHelper] updateUserAutoLoginStateWithUserName:kkUserName loginState:kLoginStateOFF];
}

- (void)loginInWithOffLine
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        int result = [[JVCAccountHelper sharedJVCAccountHelper] JudgeUserPasswordStrength:kkUserName ];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            DDLogInfo(@"=%s=%d",__FUNCTION__,result);
            
            if (result == USERTYPE_OLD) {
                
                [self loginInWithOldUserType];
                
            }else if(result == USERTYPE_NEW ){
                
                [self loginInWithNewUserType];
                
            }else {//超时以及其他的一些提示
                
                [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
                
                
            }
            
        });
    });

}

/**
 *  老账号登录
 */
- (void)loginInWithOldUserType
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int resultOldType = [[JVCAccountHelper sharedJVCAccountHelper] OldUserLogin:kkUserName passWord:kkPassword];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (RESERT_USER_AND_PASSWORD == resultOldType) {//重置用户名和密码
                
                
            }else if(RESERT_PASSWORD == resultOldType)//重置密码的，再后台自动重置
            {
              //  [self modifyPassWordInbackGround];
                
            }else
            {
                [self keepOnLineErrorToPresentLoginViewController];
            }
        });
    });
}

/**
 *  后台修改密码
 */
- (void)modifyPassWordInbackGround
{
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int result = [[JVCAccountHelper sharedJVCAccountHelper] ResetUserPassword:kkUserName username:kkPassword];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(LOGINRUSULT_SUCCESS == result)//成功
            {
                [self changeWindowRootViewController];
                
            }else{//修改失败之后，也要让用户切换试图
                
                [self changeWindowRootViewController];
                
            }
            
        });
        
    });
}

#pragma mark 新账号登录
/**
 *  新账号登录
 */
- (void)loginInWithNewUserType
{
    
    [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        int resultnewType = [[JVCAccountHelper sharedJVCAccountHelper] UserLogin:kkUserName passWord:kkPassword];
        

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

            if (LOGINRESULT_SUCCESS == resultnewType) {//成功
                
                [self startKeepOnline];
                
            }else{
                
                [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"登录失败"];
                //跳转到登录界面
                [self keepOnLineErrorToPresentLoginViewController];

            }
            
        });
    });
}


- (void)dealWithCurrentAlarm:(NSData *)date
{
    id result = [date objectFromJSONData];
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *resultDic = (NSDictionary *)result;
        
        if ([[ JVCSystemUtility shareSystemUtilityInstance] judgeDictionIsNil:resultDic]) {
            JVCAlarmModel *model = [[JVCAlarmModel alloc] initAlarmModelWithDictionary:resultDic];
            model.bNewAlarm = YES;
            
            JVCAlarmCurrentView *viewCurrent = [[JVCAlarmCurrentView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [viewCurrent initCurrentAlarmView:model];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:viewCurrent];
            [viewCurrent release];

        }
        
    }
    
    
  }


@end
