//
//  JVCDeviceListViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/24/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDeviceListViewController.h"
#import "MJRefreshHeaderView.h"
#import "UIScrollView+MJRefresh.h"
#import "JVCDeviceListAdvertCell.h"
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

static const int             kTableViewCellInViewColumnCount         = 2 ; //判断设备的颜色值是第几个数组
static const int             kTableViewCellColorTypeCount            = 4 ; //判断设备的颜色值是第几个数组
static const int             kTableViewCellAdeviceHeigit             = 180;//广告条的高度
static const int             kTableViewCellNormalCellHeight          = 10 ; //cell减去图片高度的间距
static const CGFloat         kTableViewIconImageViewBorderColorAlpha = 0.3f;
static const CGFloat         kTableViewIconImageViewCornerRadius     = 6.0f;
static const NSTimeInterval  KTimeAfterDelayTimer                    = 0.3 ; //动画延迟时间
static const int             kPopViewOffx                            = 290 ; //popview弹出的x坐标
static const int             kTableViewSingleDeviceViewBeginTag      = 1000; //设备视图的默认起始标志

@interface JVCDeviceListViewController ()
{
    UITableView             *_tableView;
    NSMutableArray          *_arrayColorList; //存放颜色数据的数组
}

@end

@implementation JVCDeviceListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UITabBarItem *moreItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"设备列表", nil) image:nil tag:1];
        [moreItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_device_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_device_unselect.png"]];
        self.tabBarItem = moreItem;
        [moreItem release];
        
        self.title = self.tabBarItem.title;
        
        self.navigationController.navigationBar.hidden = NO;
        
        //初始化颜色数组
        _arrayColorList = [[NSMutableArray alloc] initWithObjects:kJVCRGBColorMacroDeviceListBlue,kJVCRGBColorMacroDeviceListSkyBlue,kJVCRGBColorMacroDeviceListGreen,kJVCRGBColorMacroDeviceListYellow,nil];
    }
    return self;
}


-(void)initLayoutWithViewWillAppear {

    DDLogVerbose(@"%s------YES",__FUNCTION__);
    [_tableView reloadData];

}

-(void)deallocWithViewDidDisappear {
    
    for (UITableViewCell *cell  in _tableView.visibleCells) {
        
        for (UIView *v in cell.contentView.subviews) {
            
            [v removeFromSuperview];
            v = nil;
        }
        
        [cell removeFromSuperview];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DDLogVerbose(@"%s",__FUNCTION__);
    
    /**
     *  初始化tableview
     */
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    //添加按钮
    UIImage *imageRight = [UIImage imageNamed:@"dev_add.png"];
    UIButton *RightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, imageRight.size.width, imageRight.size.height)];
    [RightBtn setImage:imageRight forState:UIControlStateNormal];
    [RightBtn addTarget:self action:@selector(popAddDeviceItems) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:RightBtn];
    self.navigationItem.rightBarButtonItem=rightBarBtn;
    [RightBtn release];
    [rightBarBtn release];
    
    //添加下拉刷新
    [self setupRefresh];
    
    [self getDeviceList];
}

/**
*  集成刷新控件
*/
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //自动下拉刷新
    //[_tableView headerBeginRefreshing];

    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _tableView.headerPullToRefreshText = @"下拉可以刷新";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新";
    _tableView.headerRefreshingText = @"正在刷新中";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView headerEndRefreshing];
    });
}
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
        case AddDevicePopType_ScanADDDevice:
            
            break;
        case AddDevicePopType_VloceAddDevice:
            
            break;
            
        default:
            break;
    }
}

#pragma mark 跳转到添加设备界面
/**
 *  跳转到添加设备界面
 */
- (void)AddDevice
{
    JVCAddDeviceViewController *addDeviceVC = [[JVCAddDeviceViewController alloc] init];
    addDeviceVC.addDeviceDelegate = self;
    [self.navigationController pushViewController:addDeviceVC animated:YES];
    [addDeviceVC release];
}

/**
 *  弹出添加设备选项
 */
- (void)popAddDeviceItems
{
    CGPoint point = CGPointMake(kPopViewOffx, self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height);
    NSArray *titles = @[@"添加设备", @"扫一扫", @"添加无线设备",@"局域网扫描", @"声波配置"];
    NSArray *images = @[@"add_normal.png", @"add_QR.png", @"add_scan.png",@"add_voice.png", @"add_wlan.png"];
    JVCAddDevicePopView *pop = [[JVCAddDevicePopView alloc] initWithPoint:point titles:titles images:images];
    pop.popDelegate = self;
    [pop show];
    [pop release];
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
        
        JVCQRAddDeviceViewController *qrAddDeviceVC = [[JVCQRAddDeviceViewController alloc] init];
        [self.navigationController pushViewController:qrAddDeviceVC animated:YES];
        [qrAddDeviceVC performSelector:@selector(YstTextFieldTextL:) withObject:result afterDelay:KTimeAfterDelayTimer];
        [qrAddDeviceVC release];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
    }
    if ([[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceListArray].count == 0) {//没有设备，显示没有设备cell
        
        return 1;
    }

    return  [[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceListArray].count%kTableViewCellInViewColumnCount == 0 ?  [[JVCDeviceSourceHelper shareDeviceSourceHelper]deviceListArray].count/kTableViewCellInViewColumnCount: [[JVCDeviceSourceHelper shareDeviceSourceHelper]deviceListArray].count/kTableViewCellInViewColumnCount+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        
        static NSString *cellAdverIdentify = @"cellAdevetIndetify";
        
        JVCDeviceListAdvertCell *cell = [tableView dequeueReusableCellWithIdentifier:cellAdverIdentify];
        
        if (cell == nil) {
            
            cell = [[[JVCDeviceListAdvertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellAdverIdentify] autorelease];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell initCellContent];
        
        return cell;
        
    }else{
        
        if ([[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceListArray].count == 0) {//加载没有设备cell
            
            static NSString *cellIdentify = @"cellIndetifyNodevice";

            JVCDeviceListNoDevieCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
            
            if (cell == nil) {
                
                cell = [[[JVCDeviceListNoDevieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify] autorelease];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell initContentCellWithHeigint:self.view.height - kTableViewCellAdeviceHeigit];
            
            return cell;
            
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
                        
                        [deviceView setAtObjectTitles:modelCell.yunShiTongNum onlineStatus:@"在线" wifiStatus:@"WI-FI"];
                        
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
    JVCDeviceListWithChannelListViewController *deviceChannelList = [[JVCDeviceListWithChannelListViewController alloc] init];
    //deviceChannelList.hidesBottomBarWhenPushed                    = YES;
    deviceChannelList.nIndex                                      = gesture.view.tag - kTableViewSingleDeviceViewBeginTag;
    [self.navigationController pushViewController:deviceChannelList animated:YES];
    [deviceChannelList release];
    
//    DDLogInfo(@"==%s==gesture.view.tag=%d",__FUNCTION__,gesture.view.tag);
//    
//    JVCDeviceListDeviceVIew *deviceView = (JVCDeviceListDeviceVIew *)gesture.view;
//    
//    JVCDeviceModel *modelCell = [[[JVCDeviceSourceHelper shareDeviceSourceHelper]deviceListArray] objectAtIndex:gesture.view.tag];
//    
//    UIView *viewContent = [[UIView alloc] initWithFrame:self.view.frame];
//    
//    CGRect rectOldFram = [deviceView.superview convertRect:deviceView.frame toView:_tableView];
//    CGRect position;
//    position.size.width = deviceView.width;
//    position.size.height = deviceView.height;
//    position.origin.x = rectOldFram.origin.x;//(self.view.width  - deviceView.width)/2.0;
//    position.origin.y =rectOldFram.origin.y;// (self.view.height -  deviceView.height)/2.0;
//
//    JVCDeviceListDeviceVIew *deviceViewNew = [[JVCDeviceListDeviceVIew alloc] initWithFrame:position backgroundColor:deviceView.backgroundColor cornerRadius:6.0f];
//    
//    JVCRGBHelper *rgbHelper  = [JVCRGBHelper shareJVCRGBHelper];
//
//    UIColor *borderColor    = [rgbHelper rgbColorForKey:kJVCRGBColorMacroWhite alpha:0.3];
//    UIColor *titleGontColor = [rgbHelper rgbColorForKey:kJVCRGBColorMacroWhite];
//    
//    UIImage *iconDeviceImage = [UIImage imageNamed:@"dev_device_default_icon.png"];
//
//    if (borderColor) {
//        
//        [deviceViewNew initWithLayoutView:iconDeviceImage borderColor:borderColor titleFontColor:titleGontColor];
//        [deviceViewNew setAtObjectTitles:modelCell.yunShiTongNum onlineStatus:@"在线" wifiStatus:@"WI-FI"];
//    }
//    
//    [viewContent addSubview:deviceViewNew];
//    [self.view addSubview:viewContent];
//    [deviceViewNew release];
//    
//  
//    [UIView animateWithDuration:kAnimationDuratin animations:^{
//    
//        CGRect position;
//        position.size.width = deviceView.width;
//        position.size.height = deviceView.height;
//        position.origin.x = (self.view.width  - deviceView.width)/2.0;;
//        position.origin.y =(self.view.height -  deviceView.height)/2.0;;
//        
//        deviceViewNew.frame = position;
//        
//        viewContent.transform = CGAffineTransformMakeScale(5.0, 5.0);
//        viewContent.alpha     = 0.0;
//
//    
//    } completion:^(BOOL finish){
//    
//        [UIView animateWithDuration:kAnimationDuratin animations:^{
//            
//            viewContent.transform = CGAffineTransformMakeScale(5.0, 5.0);
//            viewContent.alpha     = 0.0;
//            
//        } completion:^(BOOL finish){
//            
//            [viewContent removeFromSuperview];
//            
//        }];
//    }];
}

#pragma mark 获取设备
- (void)getDeviceList
{
    [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSDictionary *tdicDevice =[[JVCDeviceHelper sharedDeviceLibrary] getAccountByDeviceList];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

            
            if (![[JVCSystemUtility shareSystemUtilityInstance]judgeDictionIsNil:tdicDevice]) {//非空
                
                //把从服务器获取到的数据存放到数组中
               [[JVCDeviceSourceHelper shareDeviceSourceHelper] addServerDateToDeviceList:tdicDevice];
                //必须刷新
                [_tableView reloadData];
                
                //获取设备通道
                
                [self getAllChannelsWithDeviceList:[[JVCDeviceSourceHelper shareDeviceSourceHelper] deviceListArray]];
                
            }else{//空
            
                
                [[JVCAlertHelper shareAlertHelper]  alertToastWithKeyWindowWithMessage:LOCALANGER(@"JDCSVC_GetDevice_Error")];

            }
            
        });

    });
}

/**
 *  获取通道
 */
- (void)getAllChannelsWithDeviceList:(NSArray *)deviceListData
{
    [deviceListData retain];
    
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        dispatch_apply([deviceListData count], queue, ^(size_t index){
            
            NSMutableArray *singleDeviceChannelListMArray=[[NSMutableArray alloc] init];
            JVCDeviceModel *model=[deviceListData objectAtIndex:index];
            
            NSDictionary *channelInfoMdic=[[JVCDeviceHelper sharedDeviceLibrary] getDeviceChannelListData:model.yunShiTongNum];
            
            if ([channelInfoMdic isKindOfClass:[NSDictionary class]]) {
                
                [[JVCChannelScourseHelper shareChannelScourseHelper] channelInfoMDicConvertChannelModelToMArrayPoint:channelInfoMdic deviceYstNumber:model.yunShiTongNum];
            }
            
            [singleDeviceChannelListMArray release];
            
        });
        
    });
    
    [deviceListData release];
}

/**
 *  添加设备的回调
 */
- (void)addDeviceSuccessCallBack
{
    [_tableView reloadData];
}

#pragma mark  点击设备的回调
/**
 *  选中要播放的设备的回调
 *
 *  @param selectIndex 选中的播放设备号
 */
- (void)selectDeviceToPlayWithIndex:(int)selectIndex
{
    DDLogInfo(@"===%s===%d",__FUNCTION__,selectIndex);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [_arrayColorList release];
    _arrayColorList = nil;
    
    [_tableView release];
    _tableView = nil;
    
    [super dealloc];
}

@end
