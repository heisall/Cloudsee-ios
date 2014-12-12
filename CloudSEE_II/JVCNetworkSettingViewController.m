//
//  JVCNetworkSettingViewController.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-11.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCNetworkSettingViewController.h"
#import "JVCNetworkSettingWithTopItem.h"
#import "JVCControlHelper.h"
#import "JVCWiredInfoTableViewController.h"
#import "JVCWiredInputInfoTableViewController.h"
#import "JVCApConfigSSIDListView.h"
#import "JVNetConst.h"
#import "JVCOnlyShowWifiView.h"
#import "JVCWifiInfoTableViewController.h"
#import "JVCCloudSEENetworkHelper.h"

@interface JVCNetworkSettingViewController (){

    NSMutableArray *titles;
    UIView         *selectedItemBg;    //顶部选中视图
    int             nSelectedIndex;    //当前选中的索引
    UIScrollView   *operationListView; //操作视图
    
    UIButton       *autoBtn;
    UIButton       *inputBtn;
    int             nWiredConnectType;
    JVCApConfigSSIDListView *apConfigSSIDListView;
    int             nNetwotkType;
}

enum ITEM_INIT_TYPE {

    ITEM_INIT_WIRED = 0,
    ITEM_INIT_WIFI  = 1,
};

enum DeviceNetWorkType {
    
    DeviceNetWorkTypeWired  = 0, //有线连接工作状态
    DeviceNetWorkTypeWifi   = 2, //无线连接工作状态
    
};

enum WiredType {
    
  WiredTypeAuto  = 1, //有线连接的自动获取
  WiredTypeInput = 0, //有线连接的手动输入

};

@end

@implementation JVCNetworkSettingViewController
@synthesize mdDeviceNetworkInfo;
@synthesize networkSettingSetWiredConnectTypeBlock;
@synthesize networkSettingBackBlock;
@synthesize networkSettingGetSSIDListBlock;
@synthesize networkSettingSetWifiConnectTypeBlock;
@synthesize networkSettingAPOpenBlock;

static const int             kTopItemWithBeginFlagValue = 1000000000;
static const NSTimeInterval  kTopItemMoveWithDuration   = 0.3f;
static const CGFloat         kWiredAutoWithTop          = 40.0f;
static const CGFloat         kInputAutoWithTop          = 20.0f;
static const CGFloat         kNavRightItemWithFontSize  = 14.0f;
static const NSTimeInterval  kPowerInfoWithDuration     = 3.0f;

static NSString const       *kDeviceNetworkModelKey     = @"ACTIVED";      //当前设备使用的网络类型 //0:有线连接 2:无线连接
static NSString const       *kWiredConnetTypeKey        = @"bDHCP";        //有线连接接入网络的类型 //0:自动 1:手动输入
static NSString const       *kWifiWithIP                = @"WIFI_IP";      //无线连接的IP
static NSString const       *kNetworkUserPower          = @"ClientPower";  //网络连接的权限
static NSString const       *kWifiWithSSID              = @"WIFI_ID";      //无线连接的热点
static NSString const       *kWifiWithPassword          = @"WIFI_PW";      //无线连接的热点密码

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"JVCNetworkSettingViewController_title", nil);
    
    titles = [[NSMutableArray alloc] initWithCapacity:10];
    [self initLayoutWithTopView];
    [self initLayoutWithOperationView];
}


-(void)dealloc{

    [titles release];
    [mdDeviceNetworkInfo release];
    [networkSettingSetWiredConnectTypeBlock release];
    [networkSettingGetSSIDListBlock release];
    [networkSettingSetWifiConnectTypeBlock release];
    
    [super dealloc];
}

-(void)BackClick {
    
    if (self.networkSettingBackBlock) {
        
        self.networkSettingBackBlock();
    }
    [super BackClick];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

-(void)initLayoutWithViewWillAppear {
    
    [self navigationRightHiddenAndShowMath];
   
}

/**
 *  导航条右侧按钮的隐藏和显示方法
 */
-(void)navigationRightHiddenAndShowMath {

    if (nSelectedIndex  == DeviceNetWorkTypeWired) {
        
        [apConfigSSIDListView resignFirstResponderMath];
        
        if (nWiredConnectType != [self wiredConnectTypeWithMdNetworkInfo]) {
            
            [self initLayoutWithNavigationRightBarItemButton];
            
        }else{
            
            [self NavigationRightBarItemButtonWithHidden];
        }
        
    }else {
        
        if ([self checkDeviceConnectIsWifiType]) {
            
            [self NavigationRightBarItemButtonWithHidden];
            
        }else {
        
            [self initLayoutWithWifiNavigationRightBarItemButton];
        }
    }
}

/**
 *  判断设备是否是无线连接状态
 *
 *  @return YES是
 */
-(BOOL)checkDeviceConnectIsWifiType {
    
    NSString *swifiIp=[self.mdDeviceNetworkInfo objectForKey:(NSString *)kWifiWithIP];
    
    if (nNetwotkType == DeviceNetWorkTypeWifi && swifiIp.length >0) {
        
        return YES;
    }
    
    return NO;
}

/**
 *  初始化顶部的功能视图
 */
-(void)initLayoutWithTopView {
    
    [titles addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"JVCNetworkSettingViewController_item1",nil)]];
    [titles addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"JVCNetworkSettingViewController_item2", nil)]];
    
    UIImage *topViewBgImage = [UIImage imageNamed:@"nws_topItemBg.png"];
    
    UIImageView *topViewBg  = [[UIImageView alloc] initWithImage:topViewBgImage];
    
    topViewBg.frame            = CGRectMake(0.0, 0.0, topViewBgImage.size.width, topViewBgImage.size.height);
    topViewBg.backgroundColor  = [UIColor clearColor];
    topViewBg.userInteractionEnabled = YES;
    [self.view addSubview:topViewBg];
    [topViewBg release];
    
    UIImage *topItemSelectedViewImage = [UIImage imageNamed:@"nws_topItemSelected.png"];
    
    selectedItemBg                    = [[UIView alloc] init];
    selectedItemBg.frame              = CGRectMake(0.0, 0.0, topItemSelectedViewImage.size.width, topItemSelectedViewImage.size.height);
    selectedItemBg.backgroundColor    = [UIColor colorWithPatternImage:topItemSelectedViewImage];
    [self.view addSubview:selectedItemBg];
    [selectedItemBg release];
    
    for (int i=0; i < titles.count ; i++) {
        
        CGRect topItemRect                        =  CGRectMake(i*topItemSelectedViewImage.size.width, 0.0, topItemSelectedViewImage.size.width,topItemSelectedViewImage.size.height);
        
        JVCNetworkSettingWithTopItem *topItemView = [[JVCNetworkSettingWithTopItem alloc] initWithFrame:topItemRect withTitle:[titles objectAtIndex:i]];
        topItemView.tag                           = kTopItemWithBeginFlagValue + i;
        
        UITapGestureRecognizer *singleRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ItemViewClick:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [topItemView addGestureRecognizer:singleRecognizer];
        [singleRecognizer release];
        [self.view addSubview:topItemView];
        [topItemView release];
        
    }
    
    [self refreshTopItemViewStatus];
}

/**
 *  初始化右侧的配置按钮(有线连接)
 */
-(void)initLayoutWithNavigationRightBarItemButton{

    UIImage *tImageScan = [UIImage imageNamed:@"ap_finsh.png"];
    
    UIButton *finshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finshBtn.titleLabel.font = [UIFont systemFontOfSize:kNavRightItemWithFontSize];
    finshBtn.frame = CGRectMake(0, 0, tImageScan.size.width, tImageScan.size.height);
    [finshBtn addTarget:self action:@selector(configFinshed) forControlEvents:UIControlEventTouchUpInside];
    [finshBtn setTitle:NSLocalizedString(@"JVCNetworkSettingViewController_save", nil) forState:UIControlStateNormal];
    [finshBtn setBackgroundImage:tImageScan forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:finshBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
    [rightBar release];
}

/**
 *  初始化右侧的配置按钮(无线连接)
 */
-(void)initLayoutWithWifiNavigationRightBarItemButton{
    
    UIImage *tImageScan = [UIImage imageNamed:@"ap_finsh.png"];
    
    UIButton *finshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finshBtn.titleLabel.font = [UIFont systemFontOfSize:kNavRightItemWithFontSize];
    finshBtn.frame = CGRectMake(0, 0, tImageScan.size.width, tImageScan.size.height);
    [finshBtn addTarget:self action:@selector(configWifiFinshed) forControlEvents:UIControlEventTouchUpInside];
    [finshBtn setTitle:NSLocalizedString(@"JVCNetworkSettingViewController_finish", nil) forState:UIControlStateNormal];
    [finshBtn setBackgroundImage:tImageScan forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:finshBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
    [rightBar release];
}

/**
 *  初始化右侧的配置按钮
 */
-(void)NavigationRightBarItemButtonWithHidden{
    
    self.navigationItem.rightBarButtonItem = nil;
}

/**
 *  根据Key值获取Value
 *
 *  @param key
 *
 *  @return key对应的Value
 */
-(NSString *)valueAtKey:(NSString *)key{
    
    return [mdDeviceNetworkInfo objectForKey:key] == nil ? @"" :[mdDeviceNetworkInfo objectForKey:key];
}

/**
 *  开始配置(有线)
 */
-(void)configFinshed {
    
    if (self.networkSettingSetWiredConnectTypeBlock && [self checkNetworkUserPower]) {
    
         self.networkSettingSetWiredConnectTypeBlock(nWiredConnectType,[self.mdDeviceNetworkInfo objectForKey:(NSString *)kWiredWithIP],[self.mdDeviceNetworkInfo objectForKey:(NSString *)kWiredWithSubnetMask],[self.mdDeviceNetworkInfo objectForKey:(NSString *)kWiredWithGateway],[self.mdDeviceNetworkInfo objectForKey:(NSString *)kWiredWithDNS]);
    }
}

/**
 *  无线
 */
-(void)configWifiFinshed{
    
    if ([self checkNetworkUserPower]) {
        
         [apConfigSSIDListView startConfig];
    }
}

/**
 *  根据网络传输的设备网络参数获取当前有线连接的类型
 *
 *  @return 有线连接的类型
 */
-(int)wiredConnectTypeWithMdNetworkInfo {

    int nWiredType         = WiredTypeAuto;
    
    NSString *strWiredType = [self.mdDeviceNetworkInfo objectForKey:(NSString *)kWiredConnetTypeKey];
    
    if (strWiredType) {
        
        nWiredType         = [strWiredType intValue];
    }
    
    return nWiredType;
}

/**
 *  初始化功能按钮视图
 */
-(void)initLayoutWithOperationView {
    
    
    NSString *strNetworkType = [self.mdDeviceNetworkInfo objectForKey:(NSString *)kDeviceNetworkModelKey];
    
    if (strNetworkType) {
        
        nNetwotkType   = [strNetworkType intValue];
    }
    
    CGFloat width  = self.view.frame.size.width;
    
    operationListView                                = [[UIScrollView alloc] init];
    operationListView.directionalLockEnabled         = YES;
    operationListView.pagingEnabled                  = YES;
    operationListView.showsVerticalScrollIndicator   = NO;
    operationListView.showsHorizontalScrollIndicator = YES;
    operationListView.bounces                        = NO;
    operationListView.clipsToBounds                  = YES;
    operationListView.frame                          = CGRectMake(0.0,selectedItemBg.frame.size.height+selectedItemBg.frame.origin.y, width, self.view.frame.size.height-selectedItemBg.frame.size.height-selectedItemBg.frame.origin.y);
    operationListView.delegate                       = self;
    
    operationListView.backgroundColor                = [UIColor clearColor];
    
    CGSize newSize = CGSizeMake(width * titles.count,operationListView.frame.size.height);
    [operationListView setContentSize:newSize];
    [self.view addSubview:operationListView];
    
    for (int i = 0; i < titles.count; i++) {
        
       CGRect  operationItemRect = CGRectMake(width*i, 0.0, width, operationListView.frame.size.height);
        
        UIView *operationItemView = ( i == ITEM_INIT_WIRED ? [self initLayoutWithWiredView:operationItemRect]:[self initLayoutWithWifiView:operationItemRect]);
        
        if (operationItemView) {
            
            [operationListView addSubview:operationItemView];
        }
    }
    
    if (nNetwotkType != DeviceNetWorkTypeWired) {
        
        [self refreshItemView:nSelectedIndex+1];
    }

    [operationListView release];
}

/**
 *  初始化有线的功能视图
 */
-(UIView *)initLayoutWithWiredView:(CGRect)rect{
    
    nWiredConnectType  = [self wiredConnectTypeWithMdNetworkInfo];
    
    UIView *wiredView                = [[UIView alloc] init];
    wiredView.frame                  = rect;
    wiredView.backgroundColor        = [UIColor clearColor];
    
    JVCControlHelper *controlHelperObj = [JVCControlHelper shareJVCControlHelper];
    
    autoBtn                            = [controlHelperObj buttonWithTitile:NSLocalizedString(@"JVCNetworkSettingViewController_wired_item1", nil) normalImage:@"nws_wired_btnBg.png" horverimage:nil];
    
    [autoBtn setImage:[UIImage imageNamed:@"nws_wired_Icon.png"] forState:UIControlStateNormal];
    [autoBtn setImage:[UIImage imageNamed:@"nws_wired_IconSelected.png"] forState:UIControlStateSelected];
    [autoBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 110)];
    [autoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 90)];
    [autoBtn addTarget:self action:@selector(DeviceWithAutoConnect:) forControlEvents:UIControlEventTouchUpInside];
    
    [autoBtn setTitleColor:SETLABLERGBCOLOUR(74.0f, 87.0f, 108.0f) forState:UIControlStateNormal];
    
    CGRect autoBtnRect   = autoBtn.frame;
    autoBtnRect.origin.x = (rect.size.width - autoBtnRect.size.width)/2.0;
    autoBtnRect.origin.y = kWiredAutoWithTop;
    autoBtn.frame        = autoBtnRect;
    
    [wiredView addSubview:autoBtn];
    
    inputBtn              = [controlHelperObj buttonWithTitile:NSLocalizedString(@"JVCNetworkSettingViewController_wired_item2", nil)  normalImage:@"nws_wired_btnBg.png" horverimage:nil];
    
    [inputBtn setTitleColor:SETLABLERGBCOLOUR(74.0f, 87.0f, 108.0f) forState:UIControlStateNormal];
    CGRect inputRect      = autoBtn.frame;
    inputRect.origin.y    = kInputAutoWithTop + autoBtn.bottom;
    inputBtn.frame        = inputRect;
    
    [inputBtn addTarget:self action:@selector(DeviceWithInputConnect:) forControlEvents:UIControlEventTouchUpInside];
    
    [inputBtn setImage:[UIImage imageNamed:@"nws_wired_Icon.png"] forState:UIControlStateNormal];
    [inputBtn setImage:[UIImage imageNamed:@"nws_wired_IconSelected.png"] forState:UIControlStateSelected];
    [inputBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 110)];
    [inputBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 90)];
    
    [wiredView addSubview:inputBtn];
    
    [self refreshWiredConnectButtonSelected];
    
    return [wiredView autorelease];
}

/**
 *  刷新无线设备的热点信息
 *
 *  @param ssidListData ssid 数组
 */
-(void)refreshSSIDListData:(NSMutableArray *)ssidListData{

    [apConfigSSIDListView refreshWifiViewShowInfo:ssidListData];
}

/**
 *  初始化无线连接的配置界面
 *
 *  @return 无线连接的配置界面
 */
-(UIView *)initLayoutWithWifiView:(CGRect)rect{
    
    
    if (![self checkDeviceConnectIsWifiType]) {
        
        JVCApConfigSSIDListViewRefreshSSIDListBlock  apConfigSSIDListViewRefreshSSIDListBlock = ^{
            
            if (self.networkSettingGetSSIDListBlock) {
                
                self.networkSettingGetSSIDListBlock();
            }
            
        };
        
        JVCApConfigSSIDListViewStartConfigingBlock  apConfigSSIDListViewStartConfigingBlock = ^(NSString *strWifiEnc,NSString *strWifiAuth,NSString *strWifiSSid,NSString *strWifiPassWor){
            
            if (strWifiSSid.length <= 0) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:NSLocalizedString(@"wifi-name-nil", nil)];
                });
                
            }else{
                
                if (self.networkSettingSetWifiConnectTypeBlock) {
                    
                    self.networkSettingSetWifiConnectTypeBlock(strWifiSSid ,strWifiPassWor,strWifiAuth,strWifiEnc);
                }
            }
        };
        
        apConfigSSIDListView                                          = [[JVCApConfigSSIDListView alloc] initWithFrame:rect];
        apConfigSSIDListView.apConfigSSIDListViewRefreshSSIDListBlock = apConfigSSIDListViewRefreshSSIDListBlock;
        apConfigSSIDListView.apConfigSSIDListViewStartConfigingBlock  = apConfigSSIDListViewStartConfigingBlock;
        
        [apConfigSSIDListView getDeviceWifiListData];
        
        
        return [apConfigSSIDListView autorelease];
        
        
    }else {
        
        JVCOnlyShowWifiViewDetailBlock  onlyShowWifiViewDetailBlock = ^{
        
            dispatch_async(dispatch_get_main_queue(), ^{
            
                JVCWifiInfoTableViewController *wiredInfoViewController = [[JVCWifiInfoTableViewController alloc] init];
                wiredInfoViewController.mdNetworkInfo                    = self.mdDeviceNetworkInfo;
                [self.navigationController pushViewController:wiredInfoViewController animated:YES];
                [wiredInfoViewController release];
                
            });
        
        };
        
        JVCOnlyShowWifiViewAPOpen  onlyShowWifiViewAPOpen = ^{
            
            self.networkSettingAPOpenBlock();
            
        };
        
        NSString *strSsid     = [self.mdDeviceNetworkInfo objectForKey:(NSString *)kWifiWithSSID];
        NSString *strPassword = [self.mdDeviceNetworkInfo objectForKey:(NSString *)kWifiWithPassword];
        
        JVCOnlyShowWifiView *onlyShowView        = [[JVCOnlyShowWifiView alloc] initWithFrame:rect withSSIDName:strSsid withPassword:strPassword];
        onlyShowView.onlyShowWifiViewDetailBlock = onlyShowWifiViewDetailBlock;
        onlyShowView.onlyShowWifiViewAPOpen      = onlyShowWifiViewAPOpen;
        
        return [onlyShowView autorelease];
    }
}

/**
 *  更新手动输入和自动获取按钮的状态
 */
-(void)refreshWiredConnectButtonSelected {

    dispatch_async(dispatch_get_main_queue(), ^{
    
        autoBtn.selected  = FALSE;
        inputBtn.selected = FALSE;
        
        nWiredConnectType == WiredTypeAuto ? [autoBtn setSelected:YES]:[inputBtn setSelected:YES];
    });
}

/**
 *  判断当前网络连接用户的权限 有权限返回YES
 *
 *  @return 无权限返回NO
 */
-(BOOL)checkNetworkUserPower {

    NSString *strPower = [self.mdDeviceNetworkInfo objectForKey:(NSString *)kNetworkUserPower];
    
    if (strPower) {
        
        int nPower = [strPower intValue];
        
        if (nPower&POWER_USER) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
               [[JVCAlertHelper shareAlertHelper] alertToastMainThreadOnWindow:NSLocalizedString(@"JVCNetworkSettingViewController_power", nil)];
            
            });
            
            return NO;
            
        }
    }

    return YES;
}

/**
 *  自动获取
 */
-(void)DeviceWithAutoConnect:(UIButton *)click{
    
    nWiredConnectType = WiredTypeAuto;
    [self refreshWiredConnectButtonSelected];
    
    JVCWiredInfoTableViewController *wiredInfoViewController = [[JVCWiredInfoTableViewController alloc] init];
    wiredInfoViewController.title                            = click.titleLabel.text;
    wiredInfoViewController.mdNetworkInfo                    = self.mdDeviceNetworkInfo;
    [self.navigationController pushViewController:wiredInfoViewController animated:YES];
    [wiredInfoViewController release];
}

/**
 *  手动输入
 */
-(void)DeviceWithInputConnect:(UIButton *)click{
    
    nWiredConnectType = WiredTypeInput;
    [self refreshWiredConnectButtonSelected];
    
    JVCWiredInputInfoTableViewSaveBlock saveBlock   = ^(NSString *strIp,NSString *strSubnetMask,NSString *strDefaultGateway,NSString *strDns){
        
        if (self.networkSettingSetWiredConnectTypeBlock) {
            
            self.networkSettingSetWiredConnectTypeBlock(nWiredConnectType,strIp,strSubnetMask,strDefaultGateway,strDns);
        }
    };
    
    JVCWiredInputInfoTableViewController *wiredInfoViewController = [[JVCWiredInputInfoTableViewController alloc] init];
    wiredInfoViewController.title                            = click.titleLabel.text;
    wiredInfoViewController.mdNetworkInfo                    = self.mdDeviceNetworkInfo;
    wiredInfoViewController.wiredInfoTableViewSaveBlock      = saveBlock;
    [self.navigationController pushViewController:wiredInfoViewController animated:YES];
    [wiredInfoViewController release];
    
}

/**
 *  顶部按钮的点击事件
 *
 *  @param sender 点击的单击事件对象
 */
-(void)ItemViewClick:(id)sender{
    
    UITapGestureRecognizer *topBtnSender = (UITapGestureRecognizer*)sender;
    
    int index                            = topBtnSender.view.tag - kTopItemWithBeginFlagValue;
    
    [self refreshItemView:index];
}


/**
 *  刷新对应连接模式的视图
 */
-(void)refreshItemView:(int)index{
    
    if (index != nSelectedIndex) {
        
        JVCNetworkSettingWithTopItem *topItemView = (JVCNetworkSettingWithTopItem *)[self.view viewWithTag:kTopItemWithBeginFlagValue + index];
        
        [UIView beginAnimations:@"TopSelectedItem" context:nil];
        
        [UIView setAnimationDuration:kTopItemMoveWithDuration];
        
        selectedItemBg.frame = topItemView.frame;
        nSelectedIndex       = index;
        
        [self refreshTopItemViewStatus];
        
        [UIView commitAnimations];
        
        [self changeScorllViewAtIndex:nSelectedIndex];
    }
}

/**
 *  刷新顶部按钮的状态
 */
-(void)refreshTopItemViewStatus {

    for (int i=0; i<titles.count; i++) {
        
        JVCNetworkSettingWithTopItem *topItemView=(JVCNetworkSettingWithTopItem *)[self.view viewWithTag:kTopItemWithBeginFlagValue+i];
        
        [topItemView isSelected:i == nSelectedIndex];
    }
    
    [self navigationRightHiddenAndShowMath];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark scorllViewDelegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
      selectedItemBg.frame=CGRectMake(scrollView.contentOffset.x/2,  selectedItemBg.frame.origin.y,  selectedItemBg.frame.size.width,  selectedItemBg.frame.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int index = fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
    
    nSelectedIndex  = index;
    
    [self refreshTopItemViewStatus];
}

/**
 *  改变ScrollView的选中页
 *
 *  @param index 当前索引
 */
-(void)changeScorllViewAtIndex:(int)index{
    
    CGPoint position = CGPointMake(operationListView.bounds.size.width*index,0);
    
    [operationListView setContentOffset:position animated:YES];
}

@end
