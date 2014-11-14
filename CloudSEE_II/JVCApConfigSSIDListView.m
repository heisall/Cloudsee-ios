//
//  JVCApConfigSSIDListView.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-13.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCApConfigSSIDListView.h"

#import "MJRefreshHeaderView.h"
#import "UIScrollView+MJRefresh.h"

@interface JVCApConfigSSIDListView () {

    NSMutableArray *maSSDlistData;
    
    UITableView               *_mTableView;
    UIActivityIndicatorView   *tActine;
    UILabel                   *tlabelName;
    UITextField               *_tfContentInfo;
    UITextField               *_tfContentInfoPw;
    NSInteger                  iSelectIndexRow;
    NSTimer                   *timerRepeat;
    NSTimer                   *getWifiListTimer;
    UIView                    *textFieldBg;
}

@end

@implementation JVCApConfigSSIDListView
@synthesize apConfigSSIDListViewRefreshSSIDListBlock;
@synthesize apConfigSSIDListViewStartConfigingBlock;

static const NSTimeInterval kGetWifiListInfoWithMaxTime        = 50.0f;
static const CGFloat        kTitleTVWithHeight                 = 24.0f;
static const CGFloat        kUserNameTextFieldWithTitleLeft    = 10.0f;
static const CGFloat        kPasswordWithUserNameTextFieldTop  = 32.0f;
static const CGFloat        kUserNameTextFieldWithTop          = 35.0f;
static const CGFloat        kWifiTitleInfoWithTextFieldBgTop   = 10.0f;
static const CGFloat        kWifiTitleInfoWithHeight           = 20.0f;
static const CGFloat        kActityHeight                      = 20.0f;
static const CGFloat        kWifiListViewCellHeight            = 50.0f;
static const CGFloat        kWifiCellIconWithRight             = 20.0f;

static NSString const *kConfigWifiEnc    =  @"wifiEnc";
static NSString const *kConfigWifiAuth   =  @"wifiAuth";
static NSString const *kWifiUserName     =  @"wifiUserName";


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        maSSDlistData = [[NSMutableArray alloc] initWithCapacity:10];
        [self initLayoutWithInputSSidAndPassword];
        [self initLayoutWithWifiListTableView];
        
    }
    return self;
}

-(void)dealloc{
    
    [apConfigSSIDListViewStartConfigingBlock release];
    [apConfigSSIDListViewRefreshSSIDListBlock release];
    [tActine release];
    [tlabelName release];
    [_mTableView release];
    [maSSDlistData release];
    [super dealloc];
}

/**
 *  开始配置
 */
-(void)startConfig {
    
    [self resignFirstResponderMath];
    
    if (_tfContentInfoPw.text.length<=0) {
        
        _tfContentInfoPw.text = @"";
    }
    
    NSString *encStr =nil;
    NSString *authStr=nil;
    
    if (maSSDlistData.count == 0) {
        
        encStr = @"0";
        authStr = @"0";
        
    }else
    {
        NSDictionary *dicTemp = [maSSDlistData objectAtIndex:iSelectIndexRow];
        
        encStr  =  [dicTemp objectForKey:kConfigWifiEnc];
        authStr =  [dicTemp objectForKey:kConfigWifiAuth];
    }
    
    if (self.apConfigSSIDListViewStartConfigingBlock) {
        
        self.apConfigSSIDListViewStartConfigingBlock(encStr,authStr,_tfContentInfo.text,_tfContentInfoPw.text);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        //取消获取wifi列表的timer
        [self stopGetWifiListTimer];
    
    });
}

/**
 *  初始化加载热点和密码的文本框
 */
-(void)initLayoutWithInputSSidAndPassword{
    
    UIImage *tImageBg =[UIImage imageNamed:@"ap_textBg.png"];
    
    textFieldBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, tImageBg.size.height+20)];
    textFieldBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:textFieldBg];
    [textFieldBg release];
    
    UIImageView *timageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-tImageBg.size.width)/2.0, 20, tImageBg.size.width, tImageBg.size.height)];
    timageView.image = tImageBg;
    timageView.tag =202;
    [self addSubview:timageView];
    [timageView release];
    
    UILabel *tlebel             = [[UILabel alloc] initWithFrame:CGRectMake(0.0,0.0 , 30.0, kTitleTVWithHeight)];
    tlebel.backgroundColor      = [UIColor clearColor];
    tlebel.text = @"  ";
    
    _tfContentInfo              = [[UITextField alloc] init];
    _tfContentInfo.frame        = CGRectMake((self.frame.size.width - tImageBg.size.width)/2.0+kUserNameTextFieldWithTitleLeft, kUserNameTextFieldWithTop,tImageBg.size.width - kUserNameTextFieldWithTitleLeft, kTitleTVWithHeight);
    _tfContentInfo.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _tfContentInfo.keyboardAppearance=UIKeyboardAppearanceAlert;
    _tfContentInfo.placeholder  = NSLocalizedString(@"wifi-name-selected", nil);
    _tfContentInfo.enabled      = FALSE;
    [self addSubview:_tfContentInfo];
    
    _tfContentInfoPw                 = [[UITextField alloc] init];
    _tfContentInfoPw.frame           = CGRectMake(_tfContentInfo.frame.origin.x, _tfContentInfo.frame.origin.x + _tfContentInfo.frame.size.height + kPasswordWithUserNameTextFieldTop ,tImageBg.size.width - kUserNameTextFieldWithTitleLeft, kTitleTVWithHeight);
    [_tfContentInfoPw setBorderStyle:UITextBorderStyleNone];
    _tfContentInfoPw.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _tfContentInfoPw.keyboardType    = UIKeyboardTypeASCIICapable;
    _tfContentInfoPw.returnKeyType   = UIReturnKeyDone;
    _tfContentInfoPw.delegate = self;
    _tfContentInfoPw.clearButtonMode = UITextFieldViewModeAlways;
    _tfContentInfoPw.secureTextEntry = YES;
    _tfContentInfoPw.enabled         = YES;
    _tfContentInfoPw.placeholder     = NSLocalizedString(@"ResignPassWord", nil);
    
    [self addSubview:_tfContentInfoPw];
    [tlebel release];
}

/**
 *  初始化Wifi热点列表视图
 */
-(void)initLayoutWithWifiListTableView {
    
    tlabelName = [[UILabel alloc] initWithFrame:CGRectMake(_tfContentInfo.frame.origin.x, textFieldBg.frame.size.height+kWifiTitleInfoWithTextFieldBgTop, self.frame.size.width - _tfContentInfo.frame.origin.x*2, kWifiTitleInfoWithHeight)];
    
    tlabelName.text = NSLocalizedString(@"wifi_select_loading", nil);
    tlabelName.backgroundColor = [UIColor clearColor];
    tlabelName.textAlignment = UITextAlignmentLeft;
    [self addSubview:tlabelName];
    
    tActine = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    tActine.frame = CGRectMake(0.0, tlabelName.frame.origin.y, kActityHeight, kActityHeight);
    [tActine startAnimating];
    [self addSubview:tActine];
    
    _mTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, tlabelName.frame.size.height + tlabelName.frame.origin.y, self.frame.size.width, self.frame.size.height - tlabelName.frame.origin.y-tlabelName.size.height) style:UITableViewStyleGrouped] ;
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
    _mTableView.backgroundView = nil;
    _mTableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_mTableView];
    
    [self setupRefresh];
    
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_mTableView addHeaderWithTarget:self action:@selector(getDeviceWifiListData)];
    //自动下拉刷新
    //[_tableView headerBeginRefreshing];
    
    _mTableView.headerPullToRefreshText = LOCALANGER(@"jvc_PullToRefreshText");
    _mTableView.headerReleaseToRefreshText = LOCALANGER(@"jvc_PullReleaseToRefreshText");
    _mTableView.headerRefreshingText = LOCALANGER(@"jvc_PullRefreshingText");
}

/**
 *  更新设备的WIFi信息
 */
-(void)getDeviceWifiListData{

    if (self.apConfigSSIDListViewRefreshSSIDListBlock) {
    
        self.apConfigSSIDListViewRefreshSSIDListBlock();
    }
}

/**
 *  刷新无线列表信息
 *
 *  @param wifiListData 无线列表信息
 */
-(void)refreshWifiViewShowInfo:(NSMutableArray*)wifiListData{
    
    tlabelName.text = NSLocalizedString(@"selectedWifi", nil);
    
    [tActine stopAnimating];
    [tActine removeFromSuperview];
    tActine=nil;

    [maSSDlistData removeAllObjects];
    [maSSDlistData addObjectsFromArray:wifiListData];
    [_mTableView  reloadData];
    [self stopGetWifiListTimer];
    [_mTableView headerEndRefreshing];
    
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
    [_mTableView headerEndRefreshing];
    
    getWifiListTimer = nil;
    
    
    [[JVCAlertHelper shareAlertHelper] alertControllerWithTitle:NSLocalizedString(@"get_WIFI_list_timeOut", nil) delegate:self selectAction:nil cancelAction:nil  selectTitle:NSLocalizedString(@"Sure", nil) cancelTitle:nil];
}

#pragma mark tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return maSSDlistData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    for (UIView *v in cell.contentView.subviews) {
        
        [v removeFromSuperview];
        v = nil;
    }
    
    UIImage *image         = [UIImage imageNamed:@"ap_wifi_icon.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - image.size.width - kWifiCellIconWithRight, (kWifiListViewCellHeight - image.size.height ) / 2.0, image.size.width, image.size.height)];
    imageView.image        = image;
    [cell addSubview:imageView];
    [imageView release];
    
    
    int row=indexPath.row;
    
    NSDictionary *dic=(NSDictionary*)[maSSDlistData objectAtIndex:row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:(NSString *)kWifiUserName]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kWifiListViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic=(NSDictionary*)[maSSDlistData objectAtIndex:indexPath.row];
    iSelectIndexRow = indexPath.row;
    _tfContentInfo.text = [dic objectForKey:(NSString *)kWifiUserName];
}

#pragma mark ---------UITextFiledDelegate
/**
 *  键盘收回时间
 *
 *  @param textField 当前的文本框
 *
 *  @return YES收起
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
 
    [self resignFirstResponderMath];
    return YES;
}

/**
 *  键盘关闭事件
 */
-(void)resignFirstResponderMath {
    
    [_tfContentInfo resignFirstResponder];
    [_tfContentInfoPw resignFirstResponder];

}

@end
