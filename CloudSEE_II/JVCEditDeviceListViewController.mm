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
#import "JVCEditChannelInfoTableViewController.h"
#import "JVCLickTypeViewController.h"
#import "JVCConfigModel.h"
#import "JVCLocalEditDeviceInfoViewController.h"
#import "JVCLocalLickTypeViewController.h"
#import "JVCLocalEditChannelInfoTableViewController.h"
#import "JVCAddDevieAlarmViewController.h"
#import "JVNetConst.h"
@interface JVCEditDeviceListViewController (){
    
    NSMutableArray *mArrayColors;
    NSMutableArray *mArrayIconNames;
    NSMutableArray *mArrayIconTitles;
}

typedef NS_ENUM (NSInteger,JVCEditDeviceListViewControllerClickType){
    
    JVCEditDeviceListViewControllerClickType_beganIndex = 1000,
    JVCEditDeviceListViewControllerClickType_remoteSetup,
    JVCEditDeviceListViewControllerClickType_deviceManager,
    JVCEditDeviceListViewControllerClickType_linkModel,
    JVCEditDeviceListViewControllerClickType_channelManage,
    JVCEditDeviceListViewControllerClickType_play,
    JVCEditDeviceListViewControllerClickType_add,
};

@end

@implementation JVCEditDeviceListViewController

static const int  kInitWithLayoutColumnCount           = 3;
static const int  kLocalDeviceChannelNum               = 1;
static const int  kRemoteDeviceChannelNum              = 1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        UITabBarItem *moreItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"设备管理", nil) image:nil tag:1];
        [moreItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_deviceManager_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_deviceManager_unselect.png"]];
        self.tabBarItem = moreItem;
        [moreItem release];
        
        self.title = self.tabBarItem.title;
    }
    return self;
}


#pragma mark 父类的可见和不可见清除控件和加载控件的处理模块

-(void)initLayoutWithViewWillAppear {

    [titles removeAllObjects];
    [titles addObjectsFromArray:[[JVCDeviceSourceHelper shareDeviceSourceHelper] ystNumbersWithDevceList]];
    [self initWithTopToolView];
    
}

-(void)deallocWithViewDidDisappear {

    [self clearToolView];
    self.nIndex = 0;
    
}

/**
 *  初始化加载视图RGB集合数据
 */
-(void)initWithRgbListArray {
    
    mArrayColors                 = [[NSMutableArray alloc] initWithObjects:kJVCRGBColorMacroGreen,kJVCRGBColorMacroSkyBlue,kJVCRGBColorMacroOrange,kJVCRGBColorMacroDeepRed,kJVCRGBColorMacroYellow,kJVCRGBColorMacroPurple,nil];
}

/**
 *  初始化图片名称集合
 */
- (void)initWithIconImageNameListArray{
    
    mArrayIconNames  = [[NSMutableArray alloc] initWithCapacity:10];
    
    [mArrayIconNames addObjectsFromArray:@[@"edi_RemoteSetup.png",@"edi_deviceManger.png",@"edi_linkModel.png",
                                           @"edi_deviceManger.png",@"edi_channelManager.png",@"edi_add.png"]];
}

/**
 *  初始化图片标题
 */
-(void)initWithIconTitleListArray {
    
    mArrayIconTitles              = [[NSMutableArray alloc] initWithCapacity:10];
    
    [mArrayIconTitles addObjectsFromArray:@[@"远程设置",@"设备管理",@"连接模式",
                                            @"通道管理",@"立即观看",@"添加设备"]];
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
        
        position.size.width  = viewBgImage.size.width;
        position.size.height = viewBgImage.size.height;
        
        [[JVCAppHelper shareJVCAppHelper] viewInThePositionOfTheSuperView:self.view.frame.size.width viewCGRect:position nColumnCount:kInitWithLayoutColumnCount viewIndex:i+1];
        
        //position.origin.y = position.origin.y + toolBarView.frame.origin.y + toolBarView.frame.size.height;
        
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
 *  单击事件
 *
 *  @param recognizer 单击手势对象
 */
-(void)singleCilck:(UITapGestureRecognizer*)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:kOperationViewAnimationScaleBig animations:^{
            
            recognizer.view.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
            
            
        } completion:^(BOOL finished){
            
            [UIView animateWithDuration:kOperationViewAnimationScaleRestore animations:^{
                
                recognizer.view.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finshed){
                
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
        case JVCEditDeviceListViewControllerClickType_remoteSetup:{
            
        }
            break;
        case JVCEditDeviceListViewControllerClickType_deviceManager:{
            [self editDeviceInfo];
        }
            break;
        case JVCEditDeviceListViewControllerClickType_linkModel:{
            [self editDeviceLinkType];
        }
            break;
        case JVCEditDeviceListViewControllerClickType_channelManage:{
            [self editChannelsInfo];
        }
            break;
        case JVCEditDeviceListViewControllerClickType_play:{
            
        }
            break;
            
        case JVCEditDeviceListViewControllerClickType_add:{
            
            [self connetDeviceWithYSTNum];
            
        }
            break;
            
        default:
            break;
    }
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
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:@"设备不支持此操作"];
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
 *  添加门磁报警的
 */
- (void)addAlarmDeviceViewController
{
    JVCAddDevieAlarmViewController *viewControler = [[JVCAddDevieAlarmViewController alloc] init];
    viewControler.localChannelNum = kLocalDeviceChannelNum;
    [self.navigationController pushViewController:viewControler animated:YES];
    viewControler.hidesBottomBarWhenPushed = YES;
    [viewControler release];
}

/**
 *  删除设备的回调
 */
- (void)deleteDeviceInfoCallBack
{
    DDLogVerbose(@"%s",__FUNCTION__);
}

#pragma 通道管理
- (void)editChannelsInfo
{
     if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_LOCAL) {//本地登录
         
         JVCLocalEditChannelInfoTableViewController *editChannelVC = [[JVCLocalEditChannelInfoTableViewController alloc] init];
         
         editChannelVC.YstNum = [self currentYstTitles];
         [editChannelVC initChannelist];
         editChannelVC.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:editChannelVC animated:YES];
         [editChannelVC release];

     }else{
         
         JVCEditChannelInfoTableViewController *editChannelVC = [[JVCEditChannelInfoTableViewController alloc] init];
         
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
    [super dealloc];
}

- (void)viewDidLoad
{
    [self initWithRgbListArray];
    [self initWithIconTitleListArray];
    [self initWithIconImageNameListArray];
    [titles addObjectsFromArray:[[JVCDeviceSourceHelper shareDeviceSourceHelper] ystNumbersWithDevceList]];
    [super viewDidLoad];
    
}

/**
 *  返回当前选中的云视通号
 *
 *  @return 当前选中的云视通号
 */
- (NSString *)currentYstTitles
{

    return [titles objectAtIndex:self.nIndex];
}


#pragma mark  连接云视通 不让显示=============
/**
 *  连接云视通
 */
- (void)connetDeviceWithYSTNum
{
    
    [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
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
            
            [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] ipConnectVideobyDeviceInfo:kLocalDeviceChannelNum nRemoteChannel:kRemoteDeviceChannelNum strUserName:deviceUserName strPassWord:delvicePassword strRemoteIP:deviceModel.ip nRemotePort:[deviceModel.port intValue] nSystemVersion:IOS_VERSION isConnectShowVideo:NO];
            
        }else{
            
            [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] ystConnectVideobyDeviceInfo:kLocalDeviceChannelNum
                                                                                   nRemoteChannel:kRemoteDeviceChannelNum strYstNumber:deviceModel.yunShiTongNum
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
    [[JVCAlertHelper shareAlertHelper] performSelectorOnMainThread:@selector(alertHidenToastOnWindow) withObject:nil waitUntilDone:NO];

    if (connectResultType == CONNECTRESULTTYPE_Succeed) {
        
       // [self performSelectorOnMainThread:@selector(addAlarmDeviceViewController) withObject:nil waitUntilDone:NO ];
    }else {
        
        
        [[JVCAlertHelper shareAlertHelper] alertToastMainThreadOnWindow:@"连接失败请请重试"];
        
    }
}

/**
*  视频来O帧之后请求文本聊天
*
*  @param nLocalChannel 本地显示的通道编号 需减去1
*/
-(void)RequestTextChatCallback:(int)nLocalChannel {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
         JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        [ystNetWorkHelperObj RemoteOperationSendDataToDevice:nLocalChannel remoteOperationCommand:JVN_REQ_TEXT];
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
            [ystNetWorkHelperObj remoteGetBindingAlarmDevices:kLocalDeviceChannelNum];
            
        });
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
    DDLogVerbose(@"%s====%d=====%@",__FUNCTION__,nYstNetWorkHelpTextDataType,objYstNetWorkHelpSendData);
}



/**
 *  断开远程连接方法
 */
- (void)disAlarmRemoteLink
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCCloudSEENetworkHelper            *ystNetWorkHelperObj = [JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper];
        
        ystNetWorkHelperObj.ystNWHDelegate = nil;
        
        [[JVCCloudSEENetworkHelper shareJVCCloudSEENetworkHelper] disconnect:kLocalDeviceChannelNum];
    });
}


@end
