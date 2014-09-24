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
#import "JVCRGBColorMacro.h"
#import "JVCRGBHelper.h"
#import "JVCDeviceListDeviceVIew.h"
#import "JVCAppHelper.h"

static const int  kTableViewCellInViewColumnCount    = 2 ; //判断设备的颜色值是第几个数组
static const int  kTableViewCellColorTypeCount       = 4 ; //判断设备的颜色值是第几个数组


@interface JVCDeviceListViewController ()
{
    UITableView *_tableView;

    NSMutableArray *_arrayColorFirstList;//存放颜色数据的数组
    NSMutableArray *_arrayColorSecondList;//存放颜色数据的数组
}

@end

@implementation JVCDeviceListViewController
@synthesize arrayDeviceList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    self.navigationController.navigationBar.hidden = NO;
    
    //初始化颜色数组
    _arrayColorFirstList = [[NSMutableArray alloc] initWithObjects:kJVCRGBColorMacroSkyBlue,kJVCRGBColorMacroPurple,kJVCRGBColorMacroGreen,kJVCRGBColorMacroOrange,nil];
    
    _arrayColorSecondList = [[NSMutableArray alloc] initWithObjects:kJVCRGBColorMacroGreen,kJVCRGBColorMacroOrange,nil];

    
    /**
     *  初始化tableview
     */
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    //添加下拉刷新
    [self setupRefresh];
    
    //添加数据，为了测试
    arrayDeviceList = [[NSMutableArray alloc] init];
    
    for (int i=0; i<5; i++) {
        
       [ arrayDeviceList addObject:[NSString stringWithFormat:@"%d",i]];
    }
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
    _tableView.headerPullToRefreshText = @"下拉可以刷新了";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    _tableView.headerRefreshingText = @"MJ哥正在帮你刷新中,不客气";


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
    
    return self.arrayDeviceList.count%kTableViewCellInViewColumnCount == 0 ? self.arrayDeviceList.count/kTableViewCellInViewColumnCount:self.arrayDeviceList.count/kTableViewCellInViewColumnCount+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return 180;
    }
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLogInfo(@"indexPath=%@",indexPath);
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
    
        static NSString *cellIdentify = @"cellIndetify";
        
        JVCDeviceListDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        
        if (cell == nil) {
            
            cell = [[[JVCDeviceListDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify] autorelease];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.deviceCellDelegate = self;
        
        for (int index = indexPath.row * kTableViewCellInViewColumnCount; index < (indexPath.row +1 )* kTableViewCellInViewColumnCount ; index++) {
            
            if (index < arrayDeviceList.count) {
                
                int viewIndex  = index % kTableViewCellInViewColumnCount;
                int colorIndex = index % kTableViewCellColorTypeCount;
                
                JVCRGBHelper *rgbHelper  = [JVCRGBHelper shareJVCRGBHelper];
                
                UIImage *deviceImage     = [UIImage imageNamed:@"dev_device_bg.png"];
                UIImage *iconDeviceImage = [UIImage imageNamed:@"dev_device_default_icon.png"];
                
                CGRect position;
                position.size.width  = deviceImage.size.width;
                position.size.height = deviceImage.size.height;
                
                [[JVCAppHelper shareJVCRGBHelper] viewInThePositionOfTheSuperView:cell.width viewCGRect:position nColumnCount:kTableViewCellInViewColumnCount viewIndex:viewIndex+1];
                
                if ([rgbHelper setObjectForKey:[_arrayColorFirstList objectAtIndex:colorIndex]]) {
                    
                    JVCDeviceListDeviceVIew *deviceView = [[JVCDeviceListDeviceVIew alloc] initWithFrame:position backgroundColor:RGBConvertColor(rgbHelper.rgbModel.r, rgbHelper.rgbModel.g, rgbHelper.rgbModel.b, 1.0f) cornerRadius:6.0f];
                    
                    if ([rgbHelper setObjectForKey:kJVCRGBColorMacroWhite]) {
                        
                        JVCRGBModel *rgbWhiteModel = (JVCRGBModel *)rgbHelper.rgbModel;
                        
                        [deviceView initWithLayoutView:iconDeviceImage borderColor:RGBConvertColor(rgbWhiteModel.r, rgbWhiteModel.g, rgbWhiteModel.b, 0.3f) titleFontColor:RGBConvertColor(rgbWhiteModel.r, rgbWhiteModel.g, rgbWhiteModel.b, 1.0f)];
                        [deviceView setAtObjectTitles:@"A366" onlineStatus:@"在线" wifiStatus:@"WI-FI"];
                    }
                    
                    [cell.contentView addSubview:deviceView];
                    [deviceView release];
                }
            }
        }
        
        return cell;
    }
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
    [_arrayColorFirstList release];
    _arrayColorFirstList = nil;
    
    [_arrayColorSecondList release];
    _arrayColorSecondList = nil;
    
    [_tableView release];
    _tableView = nil;
    
    [arrayDeviceList release];
    arrayDeviceList = nil;
    
    [super dealloc];
}

@end
