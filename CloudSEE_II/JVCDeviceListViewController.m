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

@interface JVCDeviceListViewController ()
{
    UITableView *_tableView;
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
    /**
     *  初始化tableview
     */
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self setupRefresh];
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
    
    return 4;//self.arrayDeviceList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return 180;
    }
    return 44;
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
        [cell initCellContent];
        return cell;
    }else{
    
        static NSString *cellIdentify = @"cellIndetify";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        
        if (cell == nil) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify] autorelease];
        }
        
        
        return cell;

    
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    
    [_tableView release];
    _tableView = nil;
    
    [arrayDeviceList release];
    arrayDeviceList = nil;
    
    [super dealloc];
}

@end
