//
//  JVCApConfigDeviceViewController.m
//  CloudSEE_II
//  配置设备的无线网络
//  Created by chenzhenyang on 14-10-20.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCApConfigDeviceViewController.h"

@interface JVCApConfigDeviceViewController () {

    UITableView               *_mTableView;
    UIActivityIndicatorView   *tActine;
    UILabel                   *tlabelName;
    UITextField               *_tfContentInfo;
    UITextField               *_tfContentInfoPw;
    NSInteger                  iSelectIndexRow;
    NSTimer                   *timerRepeat;
    NSTimer                   *getWifiListTimer;
    NSMutableArray            *_wifiInfoDatas;
    
    UIView                    *textFieldBg;
}

@end

@implementation JVCApConfigDeviceViewController
@synthesize delegate;

static const NSTimeInterval kGetWifiListInfoWithMaxTime        = 50.0f;
static const CGFloat        kTitleTVWithHeight                 = 24.0f;
static const CGFloat        kUserNameTextFieldWithTitleLeft    = 10.0f;
static const CGFloat        kPasswordWithUserNameTextFieldTop  = 32.0f;
static const CGFloat        kUserNameTextFieldWithTop          = 35.0f;
static const CGFloat        kNavRightItemWithFontSize          = 14.0f;
static const CGFloat        kWifiTitleInfoWithTextFieldBgTop   = 10.0f;
static const CGFloat        kWifiTitleInfoWithHeight           = 20.0f;
static const CGFloat        kActityHeight                      = 20.0f;
static const CGFloat        kWifiListViewCellHeight            = 50.0f;

static NSString const *kConfigWifiEnc    =  @"wifiEnc";
static NSString const *kConfigWifiAuth   =  @"wifiAuth";
static NSString const *kWifiUserName     =  @"wifiUserName";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
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
    
    [self initLayoutWithInputSSidAndPassword];

}

/**
 *  初始化加载热点和密码的文本框
 */
-(void)initLayoutWithInputSSidAndPassword{
    
    UIImage *tImageBg =[UIImage imageNamed:@"ap_textBg.png"];
    
    textFieldBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, tImageBg.size.height+20)];
    textFieldBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textFieldBg];
    [textFieldBg release];
    
    UIImageView *timageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-tImageBg.size.width)/2.0, 20, tImageBg.size.width, tImageBg.size.height)];
    timageView.image = tImageBg;
    timageView.tag =202;
    [self.view addSubview:timageView];
    [timageView release];
    
    UILabel *tlebel             = [[UILabel alloc] initWithFrame:CGRectMake(0.0,0.0 , 30.0, kTitleTVWithHeight)];
    tlebel.backgroundColor      = [UIColor clearColor];
    //self.leftView = tlebel;
    tlebel.text = @"  ";
    
    _tfContentInfo              = [[UITextField alloc] init];
    _tfContentInfo.frame        = CGRectMake((self.view.frame.size.width - tImageBg.size.width)/2.0+kUserNameTextFieldWithTitleLeft, kUserNameTextFieldWithTop,tImageBg.size.width - kUserNameTextFieldWithTitleLeft, kTitleTVWithHeight);
    _tfContentInfo.tag          = 200;
    _tfContentInfo.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _tfContentInfo.keyboardAppearance=UIKeyboardAppearanceAlert;
    _tfContentInfo.placeholder  = NSLocalizedString(@"wifi-name", nil);
    [self.view addSubview:_tfContentInfo];
    
    _tfContentInfoPw                 = [[UITextField alloc] init];
    _tfContentInfoPw.frame           = CGRectMake(_tfContentInfo.frame.origin.x, _tfContentInfo.frame.origin.x + _tfContentInfo.frame.size.height + kPasswordWithUserNameTextFieldTop ,tImageBg.size.width - kUserNameTextFieldWithTitleLeft, kTitleTVWithHeight);
    _tfContentInfoPw.tag             = 201;
    [_tfContentInfoPw setBorderStyle:UITextBorderStyleNone];
    _tfContentInfoPw.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _tfContentInfoPw.keyboardType    = UIKeyboardTypeASCIICapable;
    _tfContentInfoPw.returnKeyType   = UIReturnKeyDone;
    _tfContentInfoPw.delegate = self;
    _tfContentInfoPw.clearButtonMode = UITextFieldViewModeAlways;
    _tfContentInfoPw.secureTextEntry = YES;
    _tfContentInfoPw.enabled         = YES;
    _tfContentInfoPw.placeholder     = NSLocalizedString(@"ResignPassWord", nil);
    
    [self.view addSubview:_tfContentInfoPw];
    [tlebel release];
}


/**
 *  初始化Wifi热点列表视图
 */
-(void)initLayoutWithWifiListTableView {
    
    
    tlabelName = [[UILabel alloc] initWithFrame:CGRectMake(_tfContentInfo.frame.origin.x, textFieldBg.frame.size.height+kWifiTitleInfoWithTextFieldBgTop, self.view.frame.size.width, kWifiTitleInfoWithHeight)];
    
    tlabelName.text = NSLocalizedString(@"wifi_select_loading", nil);
    tlabelName.backgroundColor = [UIColor whiteColor];
    tlabelName.textAlignment = UITextAlignmentLeft;
    [self.view addSubview:tlabelName];
    
    tActine = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    tActine.frame = CGRectMake(0.0, tlabelName.frame.origin.y, kActityHeight, kActityHeight);
    [tActine startAnimating];
    [self.view addSubview:tActine];
    
    _mTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, textFieldBg.frame.size.height + tlabelName.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - tlabelName.frame.origin.y-tlabelName.size.height) style:UITableViewStyleGrouped] ;
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
    _mTableView.backgroundView = nil;
    _mTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mTableView];

}


/**
 *  键盘收回时间
 *
 *  @param textField 当前的文本框
 *
 *  @return YES收起
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_tfContentInfo resignFirstResponder];
    [_tfContentInfoPw resignFirstResponder];
    
    return YES;
}

/**
 *  开始配置
 */
- (void)configClick
{
    
    if (_tfContentInfo.text.length <= 0) {
        
        //[OperationSet showAlert:NSLocalizedString(@"wifi-name-nil", nil)];
        
        return;
    }
    
    if (_tfContentInfoPw.text.length<=0) {
        
        _tfContentInfoPw.text = @"";
    }
    
    NSString *encStr =nil;
    NSString *authStr=nil;
    
    if (_wifiInfoDatas.count == 0) {
        
        encStr = @"0";
        authStr = @"0";
        
    }else
    {
        NSDictionary *dicTemp = [_wifiInfoDatas objectAtIndex:iSelectIndexRow];
        
        encStr  =  [dicTemp objectForKey:kConfigWifiEnc];
        authStr =  [dicTemp objectForKey:kConfigWifiAuth];
    }
    
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(runApSetting:strWifiAuth:strWifiSSid:strWifiPassWord:)]) {
        
        [self.delegate runApSetting:encStr  strWifiAuth:authStr strWifiSSid:_tfContentInfo.text strWifiPassWord:_tfContentInfoPw.text];
    }
    
    //取消获取wifi列表的timer
    [self stopGetWifiListTimer];
}

/**
 *  刷新无线列表信息
 *
 *  @param wifiListData 无线列表信息
 */
-(void)refreshWifiViewShowInfo:(NSMutableArray*)wifiListData{

    if(!_wifiInfoDatas){
        
        _wifiInfoDatas = [[NSMutableArray alloc] init];
    }
    
    tlabelName.text = NSLocalizedString(@"selectedWifi", nil);
    
    [tActine stopAnimating];
    [tActine removeFromSuperview];
    tActine=nil;
    
    [_wifiInfoDatas removeAllObjects];
    DDLogWarn(@"%s---%@-----%@",__FUNCTION__,wifiListData,_wifiInfoDatas);
    
    [_wifiInfoDatas addObjectsFromArray:wifiListData];
    [_mTableView  reloadData];
    
    [self stopGetWifiListTimer];
}

/**
 *  关闭获取无线设备列表信息的超时判断
 */
- (void)stopGetWifiListTimer
{
    if (getWifiListTimer !=nil||[getWifiListTimer isValid]) {
        
        [getWifiListTimer invalidate];
        getWifiListTimer = nil;
    }
}

/**
 *  开启获取设备无线网络的超时判断
 */
- (void)startWifiListTimeOut
{
    if (!getWifiListTimer) {
        
        getWifiListTimer = [NSTimer scheduledTimerWithTimeInterval:kGetWifiListInfoWithMaxTime
                                                            target:self
                                                          selector:@selector(showGetWifiListTimerOut)
                                                          userInfo:nil
                                                           repeats:NO];
    }
}

/**
 *  弹出获取无线网络超时的对话框提示
 */
- (void)showGetWifiListTimerOut
{
    getWifiListTimer = nil;
    UIAlertView *alertViewTimeOut = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"get_WIFI_list_timeOut", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles: nil];
    [alertViewTimeOut show];
    [alertViewTimeOut release];
}


#pragma mark tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _wifiInfoDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
//        UIImage *image=[UIImage imageNamed:@"wifiXhBtn.png"];
//        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(280, (UITABLECELLHEIGHT-image.size.height)/2.0, image.size.width, image.size.height)];
//        imageView.image=image;
//        imageView.tag = 201;
//        imageView.image = [UIImage imageNamed:@"wifiXhBtn.png"];
//        [cell addSubview:imageView];
//        [imageView release];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    for (UIView *v in cell.contentView.subviews) {
        
        [v removeFromSuperview];
        v = nil;
    }
    
    int row=indexPath.row;
    NSDictionary *dic=(NSDictionary*)[_wifiInfoDatas objectAtIndex:row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:(NSString *)kWifiUserName]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	return kWifiListViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic=(NSDictionary*)[_wifiInfoDatas objectAtIndex:indexPath.row];
    iSelectIndexRow = indexPath.row;
    _tfContentInfo.text = [dic objectForKey:(NSString *)kWifiUserName];
    // _tfContentInfoPw.text =
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
