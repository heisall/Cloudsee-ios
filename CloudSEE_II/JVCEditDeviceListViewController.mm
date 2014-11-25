//
//  JVCEditDeviceListViewController.m
//  CloudSEE_II
//  设备管理根类
//  Created by chenzhenyang on 14-9-28.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCEditDeviceListViewController.h"
#import "JVCRGBHelper.h"
#import "JVCAppHelper.h"
#import "JVCEditDeviceOperationView.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCChannelScourseHelper.h"
#import "JVCLickTypeViewController.h"
#import "JVCConfigModel.h"
#import "JVCLocalEditDeviceInfoViewController.h"
#import "JVCLocalLickTypeViewController.h"
#import "JVCAddDevieAlarmViewController.h"
#import "JVNetConst.h"
#import "JVCOperationController.h"
#import "JVCOperationControllerIphone5.h"

#import "JVCLockAlarmModel.h"
#import "JVCAlarmMacro.h"
#import "JVCDeviceHelper.h"

#import "JVCAlarmCurrentView.h"
#import "JVCOperationHelpView.h"
#import "JVCTencentHelp.h"
#import "JVCNetworkSettingViewController.h"
#import "JVCDeviceUpdateViewController.h"

@interface JVCEditDeviceListViewController (){
    
    NSMutableArray *mArrayColors;
    NSMutableArray *mArrayIconNames;
    NSMutableArray *mArrayIconTitles;
    __block BOOL    isAnimationFinshed;
    
    NSTimer        *requestTimer;
    
    __block JVCNetworkSettingHelper *networkSettingObj; //网络设置的句柄
}

typedef NS_ENUM (NSInteger,JVCEditDeviceListViewControllerClickType){
    
    JVCEditDeviceListViewControllerClickType_beganIndex = 1000,
    JVCEditDeviceListViewControllerClickType_NetworkSetting,
    JVCEditDeviceListViewControllerClickType_deviceManager,
    JVCEditDeviceListViewControllerClickType_linkModel,
    JVCEditDeviceListViewControllerClickType_channelManage,
    JVCEditDeviceListViewControllerClickType_play,
     JVCEditDeviceListViewControllerClickType_safe,
    JVCEditDeviceListViewControllerClickType_alarm,
    JVCEditDeviceListViewControllerClickType_update,
};

@end

@implementation JVCEditDeviceListViewController

static const int             kInitWithLayoutColumnCount           = 3;
static const CGFloat         kAlertTostViewTime                   = 2.0f;
static const NSTimeInterval  kRequestTimeout                      = 15.0f;
static const NSTimeInterval  kPopRootTimeDelay                    = 0.2f;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        UITabBarItem *moreItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"jvc_editDevice_title", nil) image:nil tag:1];
        [moreItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_deviceManager_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_deviceManager_unselect.png"]];
        self.tabBarItem = moreItem;
        [moreItem release];
        
        self.title = self.tabBarItem.title;
        
        UIColor *tabarTitleColor = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroTabarItemTitleColor];
        
        if (tabarTitleColor) {
            
            [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:tabarTitleColor, UITextAttributeTextColor, nil] forState:UIControlStateSelected];//高亮状态。
        }
        
        if (IOS8) {
            self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tab_deviceManager_unselect.png"] selectedImage:[UIImage imageNamed:@"tab_deviceManager_select.png"]];
            self.tabBarItem.selectedImage = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBarItem.image = [self.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }

    }
    
    return self;
}


#pragma mark 父类的可见和不可见清除控件和加载控件的处理模块

-(void)initLayoutWithViewWillAppear {

    [titles removeAllObjects];
    
    [deviceListTableView reloadData];
    
    [titles addObjectsFromArray:[[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceNicknameWithDevceList]];
    
    [self initWithTopToolView];
    
    if (titles.count > 0) {
        
        [toolBarView setSelectedTopItemAtIndex:self.nIndex];
    }
    
    [self changeCurrentSafeWithAlarmOperationView];
    
//    JVCOperationHelpView *helpView = [[JVCOperationHelpView alloc] init];
//    [helpView operationEditDeviceHelpView];
//    [self.view addSubview:helpView];
//    [helpView release];
    
}

-(void)deallocWithViewDidDisappear {

    if (deviceListTableView.height > 0) {
        
        [self dropDownCilckWithTableHidden:dropImageView];
    }
    
    [self clearToolView];
    
}

/**
 *  还原索引
 */
-(void)resetSelectedIndex {
    
     self.nIndex = 0;
}

/**
 *  初始化加载视图RGB集合数据
 */
-(void)initWithRgbListArray {
    
    mArrayColors                 = [[NSMutableArray alloc] initWithObjects:kJVCRGBColorMacroGreen,kJVCRGBColorMacroSkyBlue,kJVCRGBColorMacroOrange,kJVCRGBColorMacroDeepRed,kJVCRGBColorMacroYellow,kJVCRGBColorMacroPurple,kJVCRGBColorMacroSkyBlue,kJVCRGBColorMacroGreen,nil];
}

/**
 *  前往视频播放界面
 *
 *  @param index 当前选择的通道索引
 */
-(void)gotoPlayViewController:(int)index {
    
    JVCOperationController *tOPVC;
    
    if (iphone5) {
        
        tOPVC = [[JVCOperationControllerIphone5 alloc] init];
        
    }else
    {
        tOPVC = [[JVCOperationController alloc] init];
        
    }
    
    tOPVC.strSelectedDeviceYstNumber = [self currentYstTitles];
    tOPVC._iSelectedChannelIndex     = index;
    [self.navigationController pushViewController:tOPVC animated:YES];
    [tOPVC release];

}

/**
 *  初始化图片名称集合
 */
- (void)initWithIconImageNameListArray{
    
    mArrayIconNames  = [[NSMutableArray alloc] initWithCapacity:10];
    
    [mArrayIconNames addObjectsFromArray:@[@"edi_RemoteSetup.png",@"edi_deviceModify.png",@"edi_linkModel.png",
                                           @"edi_channelManager.png",@"edi_play.png",@"edi_safe_un.png",@"edi_alarm.png",@"edi_deviceUpdate.png"]];
}

/**
 *  动画结束
 */
-(void)animationEndCallBack {

    dispatch_async(dispatch_get_main_queue(), ^{

        [self changeCurrentSafeWithAlarmOperationView];
    
    });
}

/**
 *  隐藏和显示报警和安全防护的按钮
 *
 *  @param isHidden 是否显示
 */
- (void)showWithHiddenSafeAndAlarmView:(BOOL)isHidden withEnableSale:(BOOL)isEanble{
    
    JVCEditDeviceOperationView *safeView = (JVCEditDeviceOperationView *)[operationView viewWithTag: JVCEditDeviceListViewControllerClickType_safe];
    
    JVCEditDeviceOperationView *alarmView = (JVCEditDeviceOperationView *)[operationView viewWithTag:JVCEditDeviceListViewControllerClickType_alarm];
    
     JVCEditDeviceOperationView *updateView = (JVCEditDeviceOperationView *)[operationView viewWithTag:JVCEditDeviceListViewControllerClickType_update];
    
    alarmView.hidden  = isHidden;
    safeView.hidden   = isHidden;
    updateView.hidden = isHidden;
    
    [safeView setIconImage:isEanble == NO?[UIImage imageNamed:@"edi_safe_se.png"]:[UIImage imageNamed:@"edi_safe_un.png"]];
}

/**
 *  初始化图片标题
 */
-(void)initWithIconTitleListArray {
    
    mArrayIconTitles              = [[NSMutableArray alloc] initWithCapacity:10];
    
    [mArrayIconTitles addObjectsFromArray:@[LOCALANGER(@"JVCNetworkSettingViewController_title"),LOCALANGER(@"jvc_editDevice_Editbtn_device"),LOCALANGER(@"jvc_editDevice_Editbtn_licktype"),LOCALANGER(@"jvc_editDevice_Editbtn_channels"),LOCALANGER(@"jvc_editDevice_Editbtn_SeeImedity"),LOCALANGER(@"jvc_editDevice_Editbtn_safe"),LOCALANGER(@"jvc_editDevice_Editbtn_alarmseting"),LOCALANGER(@"jvc_editDevice_Editbtn_update")]];
}

/**
 *  初始化功能区域按钮
 */
-(void)initWithOperationView {
    
    [super initWithOperationView];
    
    DDLogVerbose(@"%s----View=%@",__FUNCTION__,self.view);
    
    UIImage *viewBgImage =[UIImage imageNamed:@"edi_bg.png"];
    
    JVCRGBHelper *rgbHelper  = [JVCRGBHelper shareJVCRGBHelper];
    
    for (int i = 0; i< mArrayColors.count; i++) {
        
        CGRect position;
        
        position.size.width  = viewBgImage.size.width*1.05;
        position.size.height = viewBgImage.size.height*1.05;
        
        [[JVCAppHelper shareJVCAppHelper] viewInThePositionOfTheSuperView:self.view.frame.size.width viewCGRect:position nColumnCount:kInitWithLayoutColumnCount viewIndex:i+1];
        
        
        UIColor *backgroundColor = [rgbHelper rgbColorForKey:[mArrayColors objectAtIndex:i]];
        
        if (!backgroundColor) {
            
            continue;
        }
        
        JVCEditDeviceOperationView *bgView = [[JVCEditDeviceOperationView alloc] initWithFrame:position backgroundColor:backgroundColor cornerRadius:position.size.height/2.0];
        
        if (i < mArrayIconNames.count && i< mArrayIconTitles.count) {
            
            UIImage  *iconImage   = [UIImage imageNamed:[mArrayIconNames objectAtIndex:i]];
            NSString *title       = [mArrayIconTitles objectAtIndex:i];
            
            UIColor   *titleColor = [rgbHelper rgbColorForKey:kJVCRGBColorMacroEditDeviceButtonFont];
            
            if (titleColor) {
                
                //初始化标题和图标
                [bgView initWithLayoutView:title titleColor:titleColor iconImage:iconImage];
            }
        }
        
        //添加单击事件
        UITapGestureRecognizer* singleRecognizer;
        
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleCilck:)];
        singleRecognizer.numberOfTapsRequired = 1;
        [bgView addGestureRecognizer:singleRecognizer];
        [singleRecognizer release];
        
        //设置Tag标志
        bgView.tag  = JVCEditDeviceListViewControllerClickType_beganIndex + i + 1;
        
        [operationView addSubview:bgView];
        [bgView release];
    }
}

/**
 *  获取当前的设备实体
 *
 *  @return 当前的设备实体
 */
-(JVCDeviceModel *)getCurrentDeviceModel {

    JVCDeviceSourceHelper *deviceSourceObj  = [JVCDeviceSourceHelper shareDeviceSourceHelper];
    
    return (JVCDeviceModel *)[[deviceSourceObj deviceListArray] objectAtIndex:self.nIndex];
}

/**
 *  返回当前索引的设备实体
 *
 *  @return 当前索引的设备实体
 */
-(void)changeCurrentSafeWithAlarmOperationView {
    
    if (titles.count > 0) {
        
        JVCDeviceModel *model= [self getCurrentDeviceModel];
    
        [self showWithHiddenSafeAndAlarmView:!model.isDeviceType withEnableSale:!model.isDeviceSwitchAlarm];
        
    }
}

/**
 *  单击事件
 *
 *  @param recognizer 单击手势对象
 */
-(void)singleCilck:(UITapGestureRecognizer*)recognizer
{
    if (isAnimationFinshed) {
        
        return;
    }
    if ([recognizer state] == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:kOperationViewAnimationScaleBig animations:^{
            
            recognizer.view.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
            isAnimationFinshed = TRUE;
            
            
        } completion:^(BOOL finished){
            
            [UIView animateWithDuration:kOperationViewAnimationScaleRestore animations:^{
                
                recognizer.view.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finshed){
                
                 isAnimationFinshed = FALSE;
                //单击事件
                [self opeartionClick:recognizer.view.tag];
                
                
            }];
        }];
    }
}

/**
 *  功能按钮逻辑处理事件
 *
 *  @param type 点击按钮的类别
 */
-(void)opeartionClick:(int)type{
    
    if (titles.count<=0) {
        
        return;
    }
    
    switch (type)
    {
        case JVCEditDeviceListViewControllerClickType_alarm:{
            
            [[JVCTencentHelp shareTencentHelp] tencenttrackCustomKeyValueEvent:kTencentEvent_safeManager];

            [self connetDeviceWithYSTNum];
            
        }
            break;
        case JVCEditDeviceListViewControllerClickType_deviceManager:{
            
            [[JVCTencentHelp shareTencentHelp] tencenttrackCustomKeyValueEvent:kTencentEvent_DeviceManager];

            [self editDeviceInfo];
        }
            break;
        case JVCEditDeviceListViewControllerClickType_linkModel:{
            
            [[JVCTencentHelp shareTencentHelp] tencenttrackCustomKeyValueEvent:kTencentEvent_LickType];

            [self editDeviceLinkType];
        }
            break;
        case JVCEditDeviceListViewControllerClickType_channelManage:{
            
            [[JVCTencentHelp shareTencentHelp] tencenttrackCustomKeyValueEvent:kTencentEvent_channelManager];

            [self editChannelsInfo];
        }
            break;
        case JVCEditDeviceListViewControllerClickType_play:{
            {//判断设备的通道号大于0，才让连接
                NSString *titleYst = [self currentYstTitles];
                
                NSArray *arrayList = [[JVCChannelScourseHelper shareChannelScourseHelper] channelModelWithDeviceYstNumber:titleYst];
                
                if (arrayList.count>0) {
                    
                    [self gotoPlayViewController:0];

                }
            }
            
            [[JVCTencentHelp shareTencentHelp] tencenttrackCustomKeyValueEvent:kTencentEvent_EditView];

        }
            break;
            
        case JVCEditDeviceListViewControllerClickType_safe:{
            
            [[JVCTencentHelp shareTencentHelp] tencenttrackCustomKeyValueEvent:kTencentEvent_AlarmDevieManage];
            
            [self safeWithChangeStatus];
        }
            break;
        case JVCEditDeviceListViewControllerClickType_NetworkSetting:{
        
            [self gotoNetworkSetting];
        }
            break;
        case JVCEditDeviceListViewControllerClickType_update:{
        
            [self gotoDeviceUpdateController];
        }
            break;
            
        default:
            break;
    }
}

/**
 *  改变当前设备的安全防护状态
 */
-(void)safeWithChangeStatus{

    int alarmType = DEVICE_ALARTM_SWITCH;
    
    JVCDeviceHelper *deviceHelperObj = [JVCDeviceHelper sharedDeviceLibrary];
    JVCDeviceModel  *model           = [self getCurrentDeviceModel];
    JVCAlertHelper *alertObj        = [JVCAlertHelper shareAlertHelper];
    
    if (!model.bDeviceServiceOnlineState) {
        
       [alertObj alertToastWithKeyWindowWithMessage:NSLocalizedString(@"device_off_line", nil) ];
        return;
    }
    

    [alertObj alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), ^{
        
        int result = [deviceHelperObj controlDeviceOperationSwitchButton:(NSString *)kkUserName deviceGuidStr:model.yunShiTongNum operationType:alarmType switchState:!model.isDeviceSwitchAlarm updateText:nil];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [alertObj alertHidenToastOnWindow];

            
            if (result != 0) {
                
                [alertObj alertToastOnWindowWithText:NSLocalizedString(@"operation_error", nil) delayTime:kAlertTostViewTime];

            }else{
                
                switch (alarmType) {
                        
                    case DEVICE_ALARTM_SWITCH:{
                        model.isDeviceSwitchAlarm  = !model.isDeviceSwitchAlarm;
                        
                        if (model.isDeviceSwitchAlarm) {
                            
                            [alertObj alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_editDevice_Editbtn_safe_open")];
                        }else{
                            [alertObj alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_editDevice_Editbtn_safe_close")];

                        }
                        [self changeCurrentSafeWithAlarmOperationView];
                        break;
                    }
                        
                    default:
                        break;
                }
            }
        });
    });
}

/**
 *  前往网络设置模块
 */
-(void)gotoNetworkSetting {
    
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    JVCNetworkSettingErrorBlock networkSettingErrorBlock = ^(int errorType){
    
        if (networkSettingObj) {
            
            [networkSettingObj disconnect];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            NSString *strkey = [NSString stringWithFormat:@"JVCNetworkSettingViewController_error%d",errorType];
            [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(strkey, nil)];
        
        });
        
    };
    
    JVCNetworkSettingResultSSIDListBlock networkSettingResultSSIDListBlock = ^(NSMutableArray *SSIDList){
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (UIViewController *viewCon in self.navigationController.viewControllers) {
                
                if ([viewCon isKindOfClass:[JVCNetworkSettingViewController class]]) {
                    
                    JVCNetworkSettingViewController *network = (JVCNetworkSettingViewController *)viewCon;
                    
                    [network refreshSSIDListData:SSIDList];
                }
            }
        
        });
    };
    
//    JVCNetworkSettingConnectResultBlock  networkSettingConnectResultBlock = ^(int connectResultType){
//        
//        switch (connectResultType) {
//                
//            case CONNECTRESULTTYPE_Disconnect:{
//            
//            }
//                
//                break;
//                
//            default:
//                
//                break;
//        }
//        
//        if (networkSettingObj) {
//            
//            [networkSettingObj release];
//            networkSettingObj = nil;
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//        
//            [self performSelector:@selector(popRootViewController) withObject:nil afterDelay:kPopRootTimeDelay];
//        });
//    };

    JVCNetworkSettingGetNetworkInfoBlock networkSettingNetworkInfoBlock = ^(NSMutableDictionary *networkInfo){
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
             [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
            
            JVCNetworkSettingBackBlock  networkSettingBackBlock = ^{
                
                if (networkSettingObj) {
                    
                    [networkSettingObj disconnect];
                }
            };
            
            JVCNetworkSettingGetSSIDListBlock  networkSettingGetSSIDListBlock = ^{
            
                if (networkSettingObj) {
                    
                    [networkSettingObj refreshWifiListInfo];
                }
            };
            
            JVCNetworkSettingSetWifiConnectTypeBlock  networkSettingSetWifiConnectTypeBlock = ^(NSString *strSSIDName ,NSString *strSSIDPassWord ,NSString *strWifiAuth,NSString *strWifiEncryp){
            
                if (networkSettingObj) {
                    
                    [networkSettingObj setWifiConnectType:strSSIDName withSSIDPassWord:strSSIDPassWord withWifiAuth:strWifiAuth withWifiEncrypt:strWifiEncryp];
                }
            
            };
        
            JVCNetworkSettingSetWiredConnectTypeBlock networkSettingSetWiredConnectTypeBlock =^(int nDHCP,NSString *strIp,NSString *strSubnetMask,NSString *strDefaultGateway,NSString *strDns){
                
                if (networkSettingObj) {
                    
                    [networkSettingObj setWiredConnectType:nDHCP withIpAddress:strIp withSubnetMask:strSubnetMask withDefaultGateway:strDefaultGateway withDns:strDns];
                    
                    JVCDeviceModel *model = (JVCDeviceModel *)[self getCurrentDeviceModel];
                    
                    model.
                }
            };
            
            JVCNetworkSettingViewController *networkSettingViewController       = [[JVCNetworkSettingViewController alloc] init];
            networkSettingViewController.mdDeviceNetworkInfo                    = networkInfo;
            networkSettingViewController.networkSettingSetWiredConnectTypeBlock = networkSettingSetWiredConnectTypeBlock;
            networkSettingViewController.networkSettingBackBlock                = networkSettingBackBlock;
            networkSettingViewController.networkSettingGetSSIDListBlock         = networkSettingGetSSIDListBlock;
            networkSettingViewController.networkSettingSetWifiConnectTypeBlock  = networkSettingSetWifiConnectTypeBlock;
            [self.navigationController pushViewController:networkSettingViewController animated:YES];
            [networkSettingViewController release];
        
        });
    
    };
    
    networkSettingObj                                    = [[JVCNetworkSettingHelper alloc] init];
    networkSettingObj.networkSettingErrorBlock           = networkSettingErrorBlock;
    networkSettingObj.networkSettingGetNetworkInfoBlock  = networkSettingNetworkInfoBlock;
    networkSettingObj.networkSettingResultSSIDListBlock  = networkSettingResultSSIDListBlock;
    networkSettingObj.networkSettingHelperDeleagte       = self;

    JVCDeviceModel *model                                 = [[JVCDeviceSourceHelper shareDeviceSourceHelper] getDeviceModelByYstNumber:[self currentYstTitles]];
    
    [networkSettingObj connectVideoWithDeviceModel:model withChannel:1 withLocalChannel:1];
}

//前往设备升级界面
- (void)gotoDeviceUpdateController
{
    JVCDeviceModel *model                                  = [[JVCDeviceSourceHelper shareDeviceSourceHelper] getDeviceModelByYstNumber:[self currentYstTitles]];

    if (!model.bDeviceServiceOnlineState) {
        
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"device_off_line", nil) ];
        return;
    }
    
    JVCDeviceUpdateViewController *devieUpdate = [[JVCDeviceUpdateViewController alloc] init];
    devieUpdate.modelDevice = model;
    [self.navigationController pushViewController:devieUpdate animated:YES];
    [devieUpdate release];
}

#pragma mark ------------- JVCNetworkSettingHelper delegate
-(void)JVCNetworkSettingConnectResult:(int)connectResultType{
    
    switch (connectResultType) {
            
        case CONNECTRESULTTYPE_Disconnect:{
            
        }
            
            break;
            
        default:
            
            break;
    }
    
    if (networkSettingObj) {
        
        [networkSettingObj release];
        networkSettingObj = nil;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
        
        if (connectResultType != CONNECTRESULTTYPE_Disconnect) {
            
            NSString *localInfoKey=[NSString  stringWithFormat:@"connectResultInfo_%d",connectResultType];
            [[JVCAlertHelper shareAlertHelper] alertToastMainThreadOnWindow:NSLocalizedString(localInfoKey, nil)];
        }
      
        [self.navigationController popToRootViewControllerAnimated:NO];
    });

}

/**
 *  获取
 */
-(void)popRootViewController{

    dispatch_async(dispatch_get_main_queue(), ^{
    
        [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
    
        [self.navigationController popToRootViewControllerAnimated:NO];
    });
}

#pragma mark 设备管理
//设备管理点击事件
- (void)editDeviceInfo
{
    JVCDeviceModel *model = [[JVCDeviceSourceHelper shareDeviceSourceHelper] getDeviceModelByYstNumber:[self currentYstTitles]];

    if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_LOCAL) {//本地登录
        
        JVCLocalEditDeviceInfoViewController *editDeviceInfVC = [[JVCLocalEditDeviceInfoViewController alloc] init];
        editDeviceInfVC.deviceModel = model;
        editDeviceInfVC.deleteDelegate = self;
        [self.navigationController pushViewController:editDeviceInfVC animated:YES];
        [editDeviceInfVC release];
        
    }else{
    
        JVCEditDeviceInfoViewController *editDeviceInfVC = [[JVCEditDeviceInfoViewController alloc] init];
        editDeviceInfVC.deviceModel = model;
        editDeviceInfVC.deleteDelegate = self;
        [self.navigationController pushViewController:editDeviceInfVC animated:YES];
        [editDeviceInfVC release];
    }
}

/**
 *  连接模式
 */
- (void)editDeviceLinkType
{
    
    JVCDeviceModel *model = [[JVCDeviceSourceHelper shareDeviceSourceHelper] getDeviceModelByYstNumber:[self currentYstTitles]];
    
    if (model.bIpOrDomainAdd) {
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_editDevice_noSupport")];
        return;
    }
    
    if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_LOCAL) {//本地登录
        
        JVCLocalLickTypeViewController *deviceLinkType = [[JVCLocalLickTypeViewController alloc] init];
        deviceLinkType.deviceModel = model;
        [self.navigationController pushViewController:deviceLinkType animated:YES];
        [deviceLinkType release];

    }else{
    
        JVCLickTypeViewController *deviceLinkType = [[JVCLickTypeViewController alloc] init];
        deviceLinkType.deviceModel = model;
        [self.navigationController pushViewController:deviceLinkType animated:YES];
        [deviceLinkType release];

    }
}



/**
 *  删除设备的回调
 */
- (void)deleteDeviceInfoCallBack
{
    if (self.nIndex == titles.count -1) {
        
        self.nIndex --;
    }

    DDLogVerbose(@"%s---",__FUNCTION__);
}

/**
 *  删除通道的时候，删除最后一个通道的时候，同时删除设备的回调
 */
- (void)jvcEditChannelInfoDeleteSuccess
{
    if (self.nIndex == titles.count -1) {
        
        self.nIndex --;
    }
    
    DDLogVerbose(@"%s---",__FUNCTION__);
}

#pragma 通道管理
- (void)editChannelsInfo
{
     if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_LOCAL) {//本地登录
         
         JVCLocalEditChannelInfoTableViewController *editChannelVC = [[JVCLocalEditChannelInfoTableViewController alloc] init];
         editChannelVC.deleteDelegate = self;
         editChannelVC.YstNum = [self currentYstTitles];
         [editChannelVC initChannelist];
         editChannelVC.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:editChannelVC animated:YES];
         [editChannelVC release];

     }else{
         
         JVCEditChannelInfoTableViewController *editChannelVC = [[JVCEditChannelInfoTableViewController alloc] init];
         editChannelVC.deleteDelegate = self;
         editChannelVC.YstNum = [self currentYstTitles];
         [editChannelVC initChannelist];
         editChannelVC.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:editChannelVC animated:YES];
         [editChannelVC release];
     }
}

-(void)dealloc{
    
    [mArrayIconNames release];
    [mArrayColors release];
    [mArrayIconTitles release];
    [networkSettingObj release];
    [super dealloc];
}

- (void)viewDidLoad
{
    self.tenCentKey = kTencentKey_deviceConfig;

    [self initWithRgbListArray];
    [self initWithIconTitleListArray];
    [self initWithIconImageNameListArray];
    [titles addObjectsFromArray:[[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceNicknameWithDevceList]];
    [super viewDidLoad];
    
    [self changeCurrentSafeWithAlarmOperationView];
    
   
    
}

/**
 *  返回当前选中的云视通号
 *
 *  @return 当前选中的云视通号
 */
- (NSString *)currentYstTitles
{

    JVCDeviceSourceHelper *deviceSourceHelper = [JVCDeviceSourceHelper shareDeviceSourceHelper];
    
    JVCDeviceModel        *deviceModel        =(JVCDeviceModel *) [[deviceSourceHelper deviceListArray] objectAtIndex:self.nIndex];
    
    return deviceModel.yunShiTongNum;
}


#pragma mark  连接云视通 不让显示=============
/**
 *  连接云视通
 */
- (void)connetDeviceWithYSTNum
{
    JVCDeviceModel  *model           = [self getCurrentDeviceModel];
    JVCAlertHelper *alertObj        = [JVCAlertHelper shareAlertHelper];
    
    if (!model.bDeviceServiceOnlineState) {
        
        [alertObj alertToastWithKeyWindowWithMessage:NSLocalizedString(@"device_off_line", nil) ];
        return;
    }
    [JVCAlarmCurrentView shareCurrentAlarmInstance].bIsInPlay = YES;

    [alertObj alertShowToastOnWindow];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *selectyst = [self currentYstTitles];
        
        JVCDeviceModel *deviceModel = [[JVCDeviceSourceHelper shareDeviceSourceHelper] getDeviceModelByYstNumber:selectyst];
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        ystNetWorkHelperObj.ystNWHDelegate = self;
        
        NSString *deviceUserName ;
        NSString *delvicePassword;
        
        if (deviceModel == nil) {
            
            deviceUserName  = (NSString *)DefaultUserName;
            delvicePassword = (NSString *)DefaultPassWord;
        }else{
            
            deviceUserName = deviceModel.userName;
            delvicePassword = deviceModel.passWord;
        }
        
        if (deviceModel.linkType) {
            
            [ystNetWorkHelperObj ipConnectVideobyDeviceInfo:AlarmLockChannelNum nRemoteChannel:AlarmLockChannelNum strUserName:deviceUserName strPassWord:delvicePassword strRemoteIP:deviceModel.ip nRemotePort:[deviceModel.port intValue] nSystemVersion:IOS_VERSION isConnectShowVideo:NO];
            
        }else{
            
            [ystNetWorkHelperObj ystConnectVideobyDeviceInfo:AlarmLockChannelNum
                                                                                   nRemoteChannel:AlarmLockChannelNum strYstNumber:deviceModel.yunShiTongNum
                                                                                      strUserName:deviceUserName
                                                                                      strPassWord:delvicePassword nSystemVersion:IOS_VERSION isConnectShowVideo:NO];
        }
        
    });
    
}


/**
 *  连接的回调代理
 *
 *  @param connectCallBackInfo 返回的连接信息
 *  @param nlocalChannel       本地通道连接从1开始
 *  @param connectType         连接返回的类型
 */
-(void)ConnectMessageCallBackMath:(NSString *)connectCallBackInfo nLocalChannel:(int)nlocalChannel connectResultType:(int)connectResultType
{

    if (connectResultType == CONNECTRESULTTYPE_Succeed) {
        
    }else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            JVCAlertHelper *alertObj =  [JVCAlertHelper shareAlertHelper];
            
            [alertObj alertHidenToastOnWindow];
            [alertObj alertToastMainThreadOnWindow:LOCALANGER(@"jvcEditDeviceList_search_timeOut")];
        });
      
        [JVCAlarmCurrentView shareCurrentAlarmInstance].bIsInPlay = NO ;
    }
}

/**
*  视频来O帧之后请求文本聊天
*
*  @param nLocalChannel 本地显示的通道编号 需减去1
*/
-(void)RequestTextChatCallback:(int)nLocalChannel withDeviceType:(int)nDeviceType{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        [ystNetWorkHelperObj RemoteOperationSendDataToDevice:nLocalChannel remoteOperationCommand:JVN_REQ_TEXT];
        
    });
}

/**
 *  文本聊天请求的结果回调
 *
 *  @param nLocalChannel 本地本地显示窗口的编号
 *  @param nStatus       文本聊天的状态
 */
-(void)RequestTextChatStatusCallBack:(int)nLocalChannel withStatus:(int)nStatus{
    
    if (nStatus == JVN_RSP_TEXTACCEPT) {
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        ystNetWorkHelperObj.ystNWRODelegate                      = self;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            JVCCloudSEENetworkHelper *netWorkHelper = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
            
            netWorkHelper.ystNWTDDelegate = self;
            
            [ystNetWorkHelperObj RemoteOperationSendDataToDevice:AlarmLockChannelNum remoteOperationType:TextChatType_getAlarmType remoteOperationCommand:-1];
        });
        
        [self performSelectorOnMainThread:@selector(startRequestCheckTimer) withObject:nil waitUntilDone:NO];
        
    }else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
           JVCAlertHelper *alertObj =  [JVCAlertHelper shareAlertHelper];
        
            [alertObj alertHidenToastOnWindow];
            [alertObj alertToastMainThreadOnWindow:LOCALANGER(@"JVCNetworkSettingViewController_error0")];
            [self disAlarmRemoteLink];
        });
    }
}

/**
 *  开启检测的Timer
 */
-(void)startRequestCheckTimer{
    
   requestTimer = [NSTimer scheduledTimerWithTimeInterval:kRequestTimeout
                                     target:self
                                   selector:@selector(RequestTimeoutMath)
                                   userInfo:nil
                                    repeats:NO];

}

-(void)RequestTimeoutMath {
    
    requestTimer =nil;
    JVCAlertHelper *alertObj =  [JVCAlertHelper shareAlertHelper];
    [alertObj alertHidenToastOnWindow];
    [alertObj alertToastMainThreadOnWindow:LOCALANGER(@"REQ_RES_TIMEOUT")];
    [self disAlarmRemoteLink];
}

/**
 *  停止检测的Timer
 */
-(void)stopRequestTimer {
    
    if (requestTimer != nil) {
        
        if ([requestTimer isValid]) {
            
            [requestTimer invalidate];
            requestTimer = nil;
        }
    }
}

#pragma mark  文本聊天的回调
/**
 *  文本聊天返回的回调
 *
 *  @param nYstNetWorkHelpTextDataType 文本聊天的状态类型
 *  @param objYstNetWorkHelpSendData   文本聊天返回的内容
 */
-(void)ystNetWorkHelpTextChatCallBack:(int)nYstNetWorkHelpTextDataType objYstNetWorkHelpSendData:(id)objYstNetWorkHelpSendData
{
    switch (nYstNetWorkHelpTextDataType) {
            
        case TextChatType_getAlarmType://获取列表的
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                JVCAlertHelper *alertObj =  [JVCAlertHelper shareAlertHelper];
                
                [alertObj alertHidenToastOnWindow];
            });
            
            [self performSelectorOnMainThread:@selector(stopRequestTimer) withObject:nil waitUntilDone:NO];
            [self handleGetDevieAlarmArrayList:objYstNetWorkHelpSendData];
           
        }
            break;
        case TextChatType_setAlarmType://添加报警设备
            
            break;
        case TextChatType_deleteAlarm://删除报警的
            
            break;
        default:
            break;
    }
    
}

/**
 *获取门磁手环报警信息
 */
- (void)handleGetDevieAlarmArrayList:(id)objYstNetWorkHelpSendData
{
    NSMutableArray *arrayAram = [[NSMutableArray alloc] initWithCapacity:10];
    
    if ( [objYstNetWorkHelpSendData isKindOfClass:[NSArray class]]) {
        
        
        NSArray *array= (NSArray *)objYstNetWorkHelpSendData;
        
        for (NSDictionary *tdic in array) {
            JVCLockAlarmModel *model = [[JVCLockAlarmModel alloc] initAlarmLockModelWithDictionary:tdic];
            [arrayAram addObject:model];
            [model release];
        }
    }
    
    [self performSelectorOnMainThread:@selector(addAlarmDeviceViewController:) withObject:arrayAram waitUntilDone:NO];
    [arrayAram release];
}

/**
 *  添加门磁报警的
 */
- (void)addAlarmDeviceViewController:(NSMutableArray *)arrayArm
{
    [arrayArm retain];
    
    JVCAddDevieAlarmViewController *viewControler = [[JVCAddDevieAlarmViewController alloc] init];
    viewControler.arrayAlarmList = arrayArm;
    [self.navigationController pushViewController:viewControler animated:YES];
    [viewControler release];
    
    [arrayArm release];
}


/**
 *  断开远程连接方法
 */
- (void)disAlarmRemoteLink
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [JVCAlarmCurrentView shareCurrentAlarmInstance].bIsInPlay = NO;

        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        ystNetWorkHelperObj.ystNWHDelegate = nil;
        
        [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] disconnect:AlarmLockChannelNum];
    });
}

@end
