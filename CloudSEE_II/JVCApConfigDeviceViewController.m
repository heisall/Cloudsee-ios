//
//  JVCApConfigDeviceViewController.m
//  CloudSEE_II
//  配置设备的无线网络
//  Created by chenzhenyang on 14-10-20.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCApConfigDeviceViewController.h"
#import "JVCApConfigSSIDListView.h"

@interface JVCApConfigDeviceViewController () {

    NSMutableArray            *_wifiInfoDatas;
    JVCApConfigSSIDListView   *apConfigSSIDListView;
}

@end

@implementation JVCApConfigDeviceViewController
@synthesize delegate;

static const CGFloat        kNavRightItemWithFontSize          = 14.0f;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        _wifiInfoDatas = [[NSMutableArray alloc] init];
        self.title = NSLocalizedString(@"ap_Setting_Detail", nil);
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *tImageScan = [UIImage imageNamed:@"ap_finsh.png"];
    
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    
    UIButton *tImageScanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tImageScanBtn.titleLabel.font = [UIFont systemFontOfSize:kNavRightItemWithFontSize];
    tImageScanBtn.frame = CGRectMake(0, 0, tImageScan.size.width, tImageScan.size.height);
    [tImageScanBtn addTarget:self action:@selector(configClick) forControlEvents:UIControlEventTouchUpInside];
    [tImageScanBtn setTitle:NSLocalizedString(@"ap_configer", nil) forState:UIControlStateNormal];
    [tImageScanBtn setBackgroundImage:tImageScan forState:UIControlStateNormal];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:tImageScanBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
    [rightBar release];
    
    
    JVCApConfigSSIDListViewRefreshSSIDListBlock  apConfigSSIDListViewRefreshSSIDListBlock = ^{
    
        [self getDeviceWifiListData];
    
    };
    
    JVCApConfigSSIDListViewStartConfigingBlock  apConfigSSIDListViewStartConfigingBlock = ^(NSString *strWifiEnc,NSString *strWifiAuth,NSString *strWifiSSid,NSString *strWifiPassWor){
      
        if (strWifiSSid.length <= 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [[JVCAlertHelper shareAlertHelper]alertToastWithKeyWindowWithMessage:NSLocalizedString(@"wifi-name-nil", nil)];
            });
            
        }else{
        
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(runApSetting:strWifiAuth:strWifiSSid:strWifiPassWord:)]) {
                
                [self.delegate runApSetting:strWifiEnc  strWifiAuth:strWifiAuth strWifiSSid:strWifiSSid strWifiPassWord:strWifiPassWor];
            }
        }
    };
    
    apConfigSSIDListView                                          = [[JVCApConfigSSIDListView alloc] initWithFrame:self.view.frame];
    apConfigSSIDListView.apConfigSSIDListViewRefreshSSIDListBlock = apConfigSSIDListViewRefreshSSIDListBlock;
    apConfigSSIDListView.apConfigSSIDListViewStartConfigingBlock  = apConfigSSIDListViewStartConfigingBlock;
    [self.view addSubview:apConfigSSIDListView];
    [apConfigSSIDListView release];
    
    [apConfigSSIDListView getDeviceWifiListData];
}

/**
 *  关闭获取无线设备列表信息的超时判断
 */
- (void)stopGetWifiListTimer{

    [apConfigSSIDListView stopGetWifiListTimer];
}

/**
 *  开始配置
 */
- (void)configClick
{
    [apConfigSSIDListView startConfig];
}

/**
 *  刷新无线列表信息
 *
 *  @param wifiListData 无线列表信息
 */
-(void)refreshWifiViewShowInfo:(NSMutableArray*)wifiListData{
    
    [apConfigSSIDListView refreshWifiViewShowInfo:wifiListData];
}

#pragma mark ----------------------- ystNetWorkHelpTextDataDelegate

/**
 *  更新设备的WIFi信息
 */
-(void)getDeviceWifiListData{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(refreshWifiListInfo)]) {
        
        [self.delegate refreshWifiListInfo];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    
    [_wifiInfoDatas release];
    [super dealloc];
}


@end
