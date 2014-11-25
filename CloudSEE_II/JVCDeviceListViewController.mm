//
//  JVCDeviceListViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/10/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDeviceListViewController.h"
#import "MJRefreshHeaderView.h"
#import "UIScrollView+MJRefresh.h"
#import "JVCRGBHelper.h"
#import "JVCDeviceListDeviceVIew.h"
#import "JVCAppHelper.h"
#import "JVCDeviceHelper.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCSystemUtility.h"
#import "JVCDeviceListWithChannelListViewController.h"
#import "JVCDeviceListNoDevieCell.h"
#import "JVCChannelScourseHelper.h"
#import "AppDelegate.h"
#import "JVCAPConfigPreparaViewController.h"
#import "JVCQRAddDeviceViewController.h"
#import "JVCDeviceMacro.h"
#import "JVCConfigModel.h"
#import "JVCLocalAddDeviceViewController.h"
#import "JVCIPAddViewController.h"
#import "JVCScanNewDeviceViewController.h"
#import "JVCVoiceencInfoViewController.h"
#import "JVCOperationController.h"
#import "JVCChannelScourseHelper.h"
#import "JVCOperationControllerIphone5.h"
#import "JVCLocalQRAddDeviceViewController.h"
#import "JVCOperationHelpView.h"

#import "JVCWheelShowOperationController.h"
#import "JVCWheelShowOperationControllerIphone5.h"
#import "JVCOpenAdevitiseViewController.h"

static const int             kTableViewCellInViewColumnCount         = 2 ;    //判断设备的颜色值是第几个数组
static const int             kTableViewCellColorTypeCount            = 4 ;    //判断设备的颜色值是第几个数组
static const int             kTableViewCellNODevice                  = 600;   //广告条的高度

static const int             kTableViewCellNormalCellHeight          = 10 ;   //cell减去图片高度的间距
static const CGFloat         kTableViewIconImageViewBorderColorAlpha = 0.3f;
static const CGFloat         kTableViewIconImageViewCornerRadius     = 6.0f;
static const NSTimeInterval  KTimeAfterDelayTimer                    = 0.3 ;  //动画延迟时间
static const int             kPopViewOffx                            = 290 ;  //popview弹出的x坐标
static const int             kTableViewSingleDeviceViewBeginTag      = 1000;  //设备视图的默认起始标志
static const int             kPOPViewTag                             = 1000248;
static const NSTimeInterval  kLanSearchTime                          = 3*60;  //局域网广播轮询的时间
static const int             kScanfDeviceMaxCount                    = 5; //设备视图的默认起始标志
static const NSTimeInterval  kAfterDelayTimer                        = 2;  //2秒之后的停止下拉刷新

@interface JVCDeviceListViewController ()
{
    NSMutableArray          *_arrayColorList; //存放颜色数据的数组
    NSTimer                 *lanSerchtimer;
}

@end

@implementation JVCDeviceListViewController

static const int            kPlayVideoChannelsCount  = 1;   //直接观看的默认通道数

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        
        UITabBarItem *moreItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"jvc_DeviceList_title", nil) image:nil tag:1];
        [moreItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_device_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_device_unselect.png"]];
        self.tabBarItem = moreItem;
        [moreItem release];
        
        self.title = self.tabBarItem.title;
        
        self.navigationController.navigationBar.hidden = NO;
        
        //初始化颜色数组
        _arrayColorList = [[NSMutableArray alloc] initWithObjects:kJVCRGBColorMacroDeviceListBlue,kJVCRGBColorMacroDeviceListSkyBlue,kJVCRGBColorMacroDeviceListGreen,kJVCRGBColorMacroDeviceListYellow,nil];
        
        UIColor *tabarTitleColor = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroTabarItemTitleColor];
        
        if (tabarTitleColor) {
            
            [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:tabarTitleColor, UITextAttributeTextColor, nil] forState:UIControlStateSelected];//高亮状态。
        }
        
        if (IOS8) {
            self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tab_device_unselect.png"] selectedImage:[UIImage imageNamed:@"tab_device_select.png"]];
            self.tabBarItem.selectedImage = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.tabBarItem.image = [self.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *tabbarBackgroundColor  = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroNavBackgroundColor];
    if (tabbarBackgroundColor) {
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:tabbarBackgroundColor,UITextAttributeTextColor,nil] forState:UIControlStateHighlighted];
        
    }
    DDLogVerbose(@"%s",__FUNCTION__);
    
    //添加按钮
    UIImage *imageRight = [UIImage imageNamed:@"dev_add.png"];
    UIButton *RightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, imageRight.size.width, imageRight.size.height)];
    [RightBtn setImage:imageRight forState:UIControlStateNormal];
    [RightBtn addTarget:self action:@selector(showAddDevicePopView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:RightBtn];
    self.navigationItem.rightBarButtonItem=rightBarBtn;
    [RightBtn release];
    [rightBarBtn release];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getDeviceList];
    
    
    if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_ACCOUNT)
    {
        [self setupRefresh];
        
    }

}

- (void)initLayoutWithViewWillAppear
{
    [super initLayoutWithViewWillAppear];
    
    JVCConfigModel *configObj = [JVCConfigModel shareInstance];
    
    if (configObj._bISLocalLoginIn == TYPELOGINTYPE_LOCAL)
    {
        [self.tableView removeHeader];
        
    }else{
        
        [self setupRefresh];

    }
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:NO];
    
    JVCConfigModel *configObj = [JVCConfigModel shareInstance];
    
    if (configObj.isLanSearchDevices) {
        
        configObj.isLanSearchDevices = FALSE;
        
        [self StartLANSerchAllDevice];
    }
    
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //自动下拉刷新
    //[_tableView headerBeginRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = NSLocalizedString(@"jvc_PullToRefreshText", nil);
    self.tableView.headerReleaseToRefreshText = NSLocalizedString(@"jvc_PullReleaseToRefreshText", nil);
    self.tableView.headerRefreshingText =NSLocalizedString(@"jvc_PullRefreshingText", nil) ;
}

- (void)TableheaderEndRefreshing
{
    [self.tableView headerEndRefreshing];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    if ([[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceListArray].count == 0) {//没有设备下拉刷新获取设备
        
        [self performSelector:@selector(TableheaderEndRefreshing) withObject:nil afterDelay:kAfterDelayTimer];

        [self getDeviceList];
    }else{
        [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [JVCDeviceMathsHelper shareJVCUrlRequestHelper].deviceUpdate = self;
            
            [[JVCDeviceMathsHelper shareJVCUrlRequestHelper] updateAccountDeviceListInfo];
            
        });

    }
}

#pragma mark 弹出添加设备选项卡，用户选中相应按钮的回调
/**
 *  选中item的回调
 *
 *  @param index 索引
 */
- (void)didSelectItemRowAtIndex:(int)index
{
    switch (index ) {
            
        case AddDevicePopType_NormalAddDevice:
            [self AddDevice];
            break;
        case AddDevicePopType_QRAddDevice:
            [self startQRScan];
            break;
        case AddDevicePopType_WlanAddDevice:
            [self AddWlanDevice];
            break;
        case AddDevicePopType_ScanADDDevice:{
        
            [self gotoScanfDeviceViewController];
        }
            break;
        case AddDevicePopType_VloceAddDevice:{
        
            [self beginVoiceencConfig];
            break;
        }
        case AddDevicePopType_IP:
            [self ipAddDevice];
            break;
    
        default:
            break;
    }
}

#pragma mark 开始声波配置 

/**
 *  开始声波配置
 */
-(void)beginVoiceencConfig{
    
    JVCVoiceencInfoViewController *jvcVoiceencViewcontroller = [[JVCVoiceencInfoViewController alloc] init];
    [self.navigationController pushViewController:jvcVoiceencViewcontroller animated:YES];
    
    [jvcVoiceencViewcontroller release];
}

/**
 *  ip添加设备
 */
- (void)ipAddDevice
{
    JVCIPAddViewController *viewController = [[JVCIPAddViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark 跳转到添加设备界面
/**
 *  跳转到添加设备界面
 */
- (void)AddDevice
{
    if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_LOCAL) {
        
        JVCLocalAddDeviceViewController *addDeviceVC = [[JVCLocalAddDeviceViewController alloc] init];
        addDeviceVC.addDeviceDelegate = self;
        [self.navigationController pushViewController:addDeviceVC animated:YES];
        [addDeviceVC release];
    }else{
        
        JVCAddDeviceViewController *addDeviceVC = [[JVCAddDeviceViewController alloc] init];
        addDeviceVC.addDeviceDelegate = self;
        [self.navigationController pushViewController:addDeviceVC animated:YES];
        [addDeviceVC release];
    }
}

/**
 *  跳转到局域网扫描设备界面
 */
- (void)gotoScanfDeviceViewController
{
    JVCScanNewDeviceViewController *scanfDeviceController = [[JVCScanNewDeviceViewController alloc] init];
    [self.navigationController pushViewController:scanfDeviceController animated:YES];
    [scanfDeviceController release];
}

/**
 *  防止时间被多次点击
 *
 *  @param sender btn
 */
- (void)showAddDevicePopView:(UIButton *)sender
{
    [self popAddDeviceItems];
}
/**
 *  弹出添加设备选项
 */
- (void)popAddDeviceItems
{
    CGPoint point = CGPointMake(kPopViewOffx, self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height);
    NSArray *titles = nil;
    NSArray *images = nil;

    //设备列表界面

    if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_LOCAL) {//本地增加域名或ip添加设备

        titles = @[LOCALANGER(@"jvc_DeviceList_add_yst"), LOCALANGER(@"jvc_DeviceList_add_eq"), LOCALANGER(@"jvc_DeviceList_add_wlan"),LOCALANGER(@"jvc_DeviceList_add_scan"), LOCALANGER(@"jvc_DeviceList_add_volce"),LOCALANGER(@"jvc_DeviceList_add_ip")];
        images = @[@"add_normal.png", @"add_QR.png", @"add_scan.png",@"add_wlan.png",@"add_voice.png", @"add_IP.png"];
        
    }else{
        
        
        titles = @[LOCALANGER(@"jvc_DeviceList_add_yst"), LOCALANGER(@"jvc_DeviceList_add_eq"), LOCALANGER(@"jvc_DeviceList_add_wlan"),LOCALANGER(@"jvc_DeviceList_add_scan"), LOCALANGER(@"jvc_DeviceList_add_volce")];
        images = @[@"add_normal.png", @"add_QR.png", @"add_scan.png",@"add_wlan.png",@"add_voice.png" ];
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    JVCAddDevicePopView *pop = (JVCAddDevicePopView *)[window viewWithTag:kPOPViewTag];
    
    if (!pop) {
        
        pop    = [[JVCAddDevicePopView alloc] initWithPoint:point titles:titles images:images];
        pop.popDelegate             = self;
        pop.tag                     = kPOPViewTag;
        [pop show];
        [pop release];
    }
}

/**
 *  二维码扫描
 */
- (void)startQRScan
{
    AppDelegate *delegateApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegateApp.QRViewController.delegate = self;
    [self.navigationController presentModalViewController:delegateApp.QRViewController animated:YES];
    [delegateApp.QRViewController startScan];
    
}

#pragma mark 二维码扫描的回调
- (void)customViewController:(JVCQRCoderViewController *)controller didScanResult:(NSString *)result
{
    [controller dismissViewControllerAnimated:YES completion:^{
        
        if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_LOCAL) {
            
            JVCLocalQRAddDeviceViewController *qrAddDeviceVC = [[JVCLocalQRAddDeviceViewController alloc] init];
            [self.navigationController pushViewController:qrAddDeviceVC animated:YES];
            [qrAddDeviceVC performSelector:@selector(YstTextFieldTextL:) withObject:result afterDelay:KTimeAfterDelayTimer];
            [qrAddDeviceVC release];

        }else{
            
            JVCQRAddDeviceViewController *qrAddDeviceVC = [[JVCQRAddDeviceViewController alloc] init];
            [self.navigationController pushViewController:qrAddDeviceVC animated:YES];
            [qrAddDeviceVC performSelector:@selector(YstTextFieldTextL:) withObject:result afterDelay:KTimeAfterDelayTimer];
            [qrAddDeviceVC release];

        }
    }];
}

/**
 *  添加无线设备
 */
- (void)AddWlanDevice
{
    JVCAPConfigPreparaViewController *configViewController = [[JVCAPConfigPreparaViewController alloc] init];
    [self.navigationController pushViewController:configViewController animated:YES];
    [configViewController release];
}

#pragma mark  tableView 的方法

- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceListArray].count == 0) {
        
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return 1;
    }
   
    return  [[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceListArray].count%kTableViewCellInViewColumnCount == 0 ?  [[JVCDeviceSourceHelper shareDeviceSourceHelper]deviceListArray].count/kTableViewCellInViewColumnCount: [[JVCDeviceSourceHelper shareDeviceSourceHelper]deviceListArray].count/kTableViewCellInViewColumnCount+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if ([[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceListArray].count == 0) {//没有设备，显示没有设备cell
        
        return kTableViewCellNODevice;
    }
    if (indexPath.section == 0) {
        
        return kTableViewCellAdeviceHeigit;
    }
    
    if ([[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceListArray].count == 0) {//没有设备，显示没有设备cell
        
        return self.view.height - kTableViewCellAdeviceHeigit;
    }
    
    UIImage *deviceImage     = [UIImage imageNamed:@"dev_device_bg.png"];
    
    return kTableViewCellNormalCellHeight + deviceImage.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {//新品展示图片
        
        if ([[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceListArray].count == 0) {//加载没有设备cell
            
            static NSString *cellIdentify = @"cellIndetifyNodevice";
            
            JVCDeviceListNoDevieCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
            
            if (cell == nil) {
                
                cell = [[[JVCDeviceListNoDevieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify] autorelease];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell initContentCellWithHeigint:self.view.height - kTableViewCellAdeviceHeigit];
            cell.addDelegate = self;
            return cell;
        }else{
            
            static NSString *cellAdverIdentify = @"cellAdevetIndetify";
            
            JVCDeviceListAdvertCell *cell = [tableView dequeueReusableCellWithIdentifier:cellAdverIdentify];
            
            if (cell == nil) {
                
                cell = [[[JVCDeviceListAdvertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellAdverIdentify] autorelease];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell initCellContent];
            cell.JVCAdevrtDelegate = self;
            return cell;
        }
        
    }else{
        
            static NSString *cellIdentify = @"cellIndetifyNormal";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
            
            if (cell == nil) {
                
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify] autorelease];
            }
            
            for (UIView  *v in cell.contentView.subviews) {
                
                [v removeFromSuperview];
                v = nil;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            for (int index = indexPath.row * kTableViewCellInViewColumnCount; index < (indexPath.row +1 )* kTableViewCellInViewColumnCount ; index++) {
                
                
                if (index < [[JVCDeviceSourceHelper shareDeviceSourceHelper]deviceListArray].count) {
                    
                    JVCDeviceModel *modelCell = [[[JVCDeviceSourceHelper shareDeviceSourceHelper]deviceListArray] objectAtIndex:index];
                    
                    int viewIndex  = index % kTableViewCellInViewColumnCount;
                    int colorIndex = index % kTableViewCellColorTypeCount;
                    
                    JVCRGBHelper *rgbHelper  = [JVCRGBHelper shareJVCRGBHelper];
                    
                    UIImage *deviceImage     = [UIImage imageNamed:@"dev_device_bg.png"];
                    UIImage *iconDeviceImage = [UIImage imageNamed:@"dev_device_default_icon.png"];
                    
                    CGRect position;
                    position.size.width  = deviceImage.size.width;
                    position.size.height = deviceImage.size.height;
                    
                    [[JVCAppHelper shareJVCAppHelper] viewInThePositionOfTheSuperView:cell.width viewCGRect:position nColumnCount:kTableViewCellInViewColumnCount viewIndex:viewIndex+1];
                    
                    UIColor *deviceDeviceViewColor = [rgbHelper rgbColorForKey:[_arrayColorList objectAtIndex:colorIndex]];
                    
                    if (deviceDeviceViewColor) {
                        
                        JVCDeviceListDeviceVIew *deviceView = [[JVCDeviceListDeviceVIew alloc] initWithFrame:position backgroundColor:[UIColor blueColor] cornerRadius:kTableViewIconImageViewCornerRadius];                        deviceView.backgroundColor = deviceDeviceViewColor;
                        deviceView.frame           = position;
                        deviceView.tag             = index + kTableViewSingleDeviceViewBeginTag;
                        
                        UIColor *titleGontColor = [rgbHelper rgbColorForKey:kJVCRGBColorMacroWhite];
                        UIColor *borderColor    = [rgbHelper rgbColorForKey:kJVCRGBColorMacroWhite alpha:kTableViewIconImageViewBorderColorAlpha];
                        
                        if (titleGontColor && borderColor) {
                            
                            [deviceView initWithLayoutView:iconDeviceImage titleFontColor:titleGontColor borderColor:borderColor];
                        }
        
                     
                        NSString *onLineState = modelCell.onLineState == 1?LOCALANGER(@"jvc_DeviceList_online"):LOCALANGER(@"jvc_DeviceList_offline");
                        NSString *wifiState = modelCell.hasWifi == 1?@"WI-FI":@"";

                        if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_LOCAL) {
                            onLineState = @"";
                            wifiState = @"";
                        }
                        [deviceView setAtObjectTitles:modelCell.nickName onlineStatus:onLineState wifiStatus:wifiState];
                        
                        //添加选中设备的事件
                        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDeviceToPlay:)];
                        [deviceView addGestureRecognizer:gesture];
                        [gesture release];
                        
                        [cell.contentView addSubview:deviceView];
                    }
                }
            }
            
            cell.contentView.clipsToBounds = NO;
            cell.clipsToBounds = NO;
            
            return cell;
        }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1&&[[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceListArray].count == 0) {
        
        [self AddDevice];
    }
}


#pragma mark 选中相应设备的按下事件
/**
 *  选中相应的设备
 */
- (void)selectDeviceToPlay:(UITapGestureRecognizer *)gesture
{
    BOOL isMoreDevice = [JVCConfigModel shareInstance].iDeviceBrowseModel;
    
    int nIndex =  gesture.view.tag - kTableViewSingleDeviceViewBeginTag;
    
    JVCDeviceSourceHelper    *deviceSourceHelperObj  = [JVCDeviceSourceHelper shareDeviceSourceHelper];
    JVCChannelScourseHelper  *channelSourceHelperObj = [JVCChannelScourseHelper shareChannelScourseHelper];
    
    JVCDeviceModel           *deviceModel = (JVCDeviceModel *) [[deviceSourceHelperObj deviceListArray] objectAtIndex:nIndex];
    
    NSMutableArray           *channels    = [channelSourceHelperObj channelValuesWithDeviceYstNumber:deviceModel.yunShiTongNum];
    
    if (channels.count == kPlayVideoChannelsCount) {
        
        isMoreDevice == YES ? [self moreDeviceShowVideo:0 withYstNumber:deviceModel.yunShiTongNum]:[self singleDeviceShowVideo:0 withYstNumber:deviceModel.yunShiTongNum];
        
    }else{
        
        JVCDeviceListWithChannelListViewController *deviceChannelList = [[JVCDeviceListWithChannelListViewController alloc] init];
        deviceChannelList.nIndex                                      = nIndex;
        [self.navigationController pushViewController:deviceChannelList animated:YES];
        [deviceChannelList release];
    }

}


/**
 *   单设备观看模式
 *
 *  @param index     通道索引号（一个设备的有序通道集合中）
 *  @param isConnect 是否全连
 */
-(void)singleDeviceShowVideo:(int)index withYstNumber:(NSString *)ystNumber{
    
    JVCOperationController *tOPVC;
    
    if (iphone5) {
        
        tOPVC =[[JVCOperationControllerIphone5 alloc] init];
        
    }else
    {
        tOPVC = [[JVCOperationController alloc] init];
    }
    
    tOPVC.strSelectedDeviceYstNumber = ystNumber;
    tOPVC._iSelectedChannelIndex     = index;
    [self.navigationController pushViewController:tOPVC animated:YES];
    [tOPVC release];
}

/**
 *   多设备观看模式
 *
 *  @param index     通道索引号（一个设备的有序通道集合中）
 *  @param isConnect 是否全连
 */
-(void)moreDeviceShowVideo:(int)index withYstNumber:(NSString *)ystNumber{
    
    JVCDeviceSourceHelper   *deviceSourceObj  = [JVCDeviceSourceHelper shareDeviceSourceHelper];
    JVCChannelScourseHelper *channelSourceObj = [JVCChannelScourseHelper shareChannelScourseHelper];
    
    [channelSourceObj sortChannelListByDeviceList:[deviceSourceObj deviceListArray]];
    
    JVCChannelModel *channelModelObj = [channelSourceObj channelModelAtIndex:index withDeviceYstNumber:ystNumber];
    
    JVCOperationController *tOPVC;
    
    if (iphone5) {
        
        tOPVC = [[JVCWheelShowOperationControllerIphone5 alloc] init];
        
    }else
    {
        tOPVC = [[JVCWheelShowOperationController alloc] init];
        
    }
    
    tOPVC.strSelectedDeviceYstNumber = ystNumber;
    tOPVC._iSelectedChannelIndex     = [channelSourceObj IndexAtChannelModelInChannelList:channelModelObj];
    [self.navigationController pushViewController:tOPVC animated:YES];
    [tOPVC release];
}

#pragma mark 获取设备
- (void)getDeviceList
{
   
    if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_LOCAL) {//本地登录
        
        /**
         *  获取本地通设备列表
         */
        [[JVCDeviceSourceHelper shareDeviceSourceHelper] getLocalDeviceList];
        
        //开启广播
        [self startLanSearchDeviceTimer];
        
        [self.tableView reloadData];
        /**
         *  获取本地通道列表
         */
        [[JVCChannelScourseHelper shareChannelScourseHelper] getAllLocalChannelsList];

        
    }else{
    
        [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSDictionary *tdicDevice =[[JVCDeviceHelper sharedDeviceLibrary] getAccountByDeviceList];
            
            DDLogVerbose(@"设备==%@====",tdicDevice);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
                
                if (![[JVCSystemUtility shareSystemUtilityInstance] judgeDictionIsNil:tdicDevice]) {//非空
                
                    //把从服务器获取到的数据存放到数组中
                    [[JVCDeviceSourceHelper shareDeviceSourceHelper] addServerDateToDeviceList:tdicDevice];
                    //必须刷新
                    [self.tableView reloadData];
                    
                     //开启广播
                    [self startLanSearchDeviceTimer];
                    
                    [[JVCLANScanWithSetHelpYSTNOHelper sharedJVCLANScanWithSetHelpYSTNOHelper] setDevicesHelper:[[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceModelListConvertLocalCacheModel]];
                    
                    if ([[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceListArray].count > 0) {
                        
                        //加载设备通道弹出的提示
                        [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
                        
                        [self getAllChannelsList];
                        
                    }
                    
                    
                }else{//空
                    
                    [self showaddAPConfigDevice];

                    [[JVCAlertHelper shareAlertHelper]  alertToastWithKeyWindowWithMessage:LOCALANGER(@"JDCSVC_GetDevice_Error")];
                }
            });
        });
    }
}

/**
 *  当设备数量为0时的处理方法
 */
-(void)addHelpWhenDeviceCountZero
{
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageview.image = [UIImage imageNamed:@"NoDevice.png"];
    [self.view addSubview:imageview];
    [imageview release];
}

/**
 *  获取通道
 */
- (void)getAllChannelsList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JVCDeviceHelper *deviceSourceObj = [JVCDeviceHelper sharedDeviceLibrary];
        NSDictionary    *channelMDic     = [deviceSourceObj getAccountByChannelList];
        
        if (![[JVCSystemUtility shareSystemUtilityInstance] judgeDictionIsNil:channelMDic]) {//非
            
            JVCChannelScourseHelper *channelsHelperObj = [JVCChannelScourseHelper shareChannelScourseHelper];
            
            [channelsHelperObj addChannelsMDicToChannelList:channelMDic];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
            
            [self showaddAPConfigDevice];

        });
        
    });
}

/**
 *  添加设备的回调
 */
- (void)addDeviceSuccessCallBack
{
    [self StartLANSerchAllDevice];
}



#pragma mark ------------------------ 广播刷新设备的接口
#pragma mark --- 局域网广播轮询方法

/**
 *  开始局域网广播设备
 */
-(void)startLanSearchDeviceTimer {
    
    lanSerchtimer=[NSTimer scheduledTimerWithTimeInterval:kLanSearchTime
                                                   target:self
                                                 selector:@selector(StartLANSerchAllDevice)
                                                 userInfo:nil
                                                  repeats:YES];
    [lanSerchtimer fire];

}

/**
 *  停止心跳
 */
-(void)stopTimer{
    
    //局域网探测设备的轮询TIMER
    if(lanSerchtimer!=nil && [lanSerchtimer isValid]){
        
        [lanSerchtimer invalidate];
        lanSerchtimer=nil;
        
    }
}

/**
 *  添加广播
 */
-(void)StartLANSerchAllDevice {
    
    if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_ACCOUNT ) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            [[JVCDeviceMathsHelper shareJVCUrlRequestHelper] updateAccountDeviceListInfo];
            [JVCDeviceMathsHelper shareJVCUrlRequestHelper].deviceUpdate = self;

        });

    }
    
    if (NETLINTYEPE_3G== [JVCConfigModel shareInstance]._netLinkType) {
        
        return;
    }
    
    //还原设备的在线信息
    [[JVCDeviceSourceHelper shareDeviceSourceHelper] restoreDeviceListOnlineStatusInfo];
    
    JVCLANScanWithSetHelpYSTNOHelper *jvcLANScanWithSetHelpYSTNOHelperObj=[JVCLANScanWithSetHelpYSTNOHelper sharedJVCLANScanWithSetHelpYSTNOHelper];
    jvcLANScanWithSetHelpYSTNOHelperObj.delegate = self;
    
    DDLogVerbose(@"%s-------------self lan=%@",__FUNCTION__,self);
    
    [jvcLANScanWithSetHelpYSTNOHelperObj SerachLANAllDevicesAsynchronousRequestWithDeviceListData];
    
}

/**
 *  局域网扫描之后的回调
 *
 *  @param SerachLANAllDeviceList 扫描出来的所有设备
 */
-(void)SerachLANAllDevicesAsynchronousRequestWithDeviceListDataCallBack:(NSMutableArray *)SerachLANAllDeviceList {

    [SerachLANAllDeviceList  retain];
    
    DDLogVerbose(@"%s-----------lanModel=%@",__FUNCTION__,SerachLANAllDeviceList);
    
    JVCDeviceSourceHelper *deviceSourceObj = [JVCDeviceSourceHelper shareDeviceSourceHelper];
    
     NSArray *lanModelDeviceList=[deviceSourceObj LANModelListConvertToSourceModel:SerachLANAllDeviceList];
    
    [lanModelDeviceList retain];
    
    [[JVCDeviceSourceHelper shareDeviceSourceHelper] updateLanModelToChannelListData:lanModelDeviceList];
    
    [lanModelDeviceList release];
    
    [SerachLANAllDeviceList release];
}


#pragma mark 没有设备的时候，点击无线添加和有线添加按钮事件的回调
/**
 *  选中设备类型
 */
- (void)addDeviceTypeCallback:(int)linkType
{
    switch (linkType) {
        case DEVICECLICKTYpe_Wire:
            [self beginVoiceencConfig];
            break;
        case DEVICECLICKTYpe_WireLess:
            [self AddDevice];
            break;
        default:
            break;
    }
}

/**
 *  显示ap配置
 */
- (void)showaddAPConfigDevice
{
    if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_ACCOUNT) {
        
        NSString *ystNum = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *)kSAVEYSTNUM];
        
        if (ystNum.length>0) {
            
            [[JVCAlertHelper shareAlertHelper] alertControllerWithTitle:LOCALANGER(@"JDCSViewController_ap_setting") delegate:self selectAction:@selector(AddDevice) cancelAction:@selector(removeAddapNum) selectTitle:LOCALANGER(@"jvc_DeviceList_APadd") cancelTitle:LOCALANGER(@"jvc_DeviceList_APquit") alertTage:0];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 0) {
        
       [self AddDevice];

    }else{
    
        [self removeAddapNum];
    }
}

- (void)removeAddapNum
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:(NSString *)kSAVEYSTNUM];

}

#pragma mark 刷新设备成功的回调
/**
 *  更新设备信息成功的回调
 */
- (void)updateDeviceInfoMathSuccess
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
        [self.tableView headerEndRefreshing];
        [JVCDeviceMathsHelper shareJVCUrlRequestHelper].deviceUpdate = nil;
        [self.tableView reloadData];
    
    });
  
}

/**
 *  选中相应的图片
 *
 *  @param index 图片索引
 */
- (void)JVCAdvertClickImageWithIndex:(NSString *)urlString;
{
    JVCOpenAdevitiseViewController *openViewController = [[JVCOpenAdevitiseViewController alloc] init];
    openViewController.openUrlString = urlString;
    [self.navigationController pushViewController:openViewController animated:YES];
    [openViewController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_arrayColorList release];
    _arrayColorList = nil;
    
    [super dealloc];
}

@end
