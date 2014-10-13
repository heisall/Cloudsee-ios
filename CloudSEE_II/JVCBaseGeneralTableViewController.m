//
//  JVCBaseGeneralTableViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseGeneralTableViewController.h"
#import "MJRefreshHeaderView.h"
#import "UIScrollView+MJRefresh.h"

static const int  NavicationViewControllersCountINTableView = 1;//navicationbar的viewcontroller的数量，1标示根试图


@interface JVCBaseGeneralTableViewController (){

    BOOL  isViewDidDisappear; //判断视图是否可见

}

@end

@implementation JVCBaseGeneralTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
   
        if (self) {
            
            /**
             *  解决父类UIViewController带导航条添加ScorllView坐标系下沉64像素的问题（ios7）
             
             */
            
            if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            {
                self.edgesForExtendedLayout = UIRectEdgeNone;
                
            }
            
             self.tabBarController.hidesBottomBarWhenPushed = YES;
            
            [self setupRefresh];
            
        }

    return self;
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshingData)];
    //自动下拉刷新
    //[_tableView headerBeginRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新";
    self.tableView.headerRefreshingText = @"正在刷新中";
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    if (isViewDidDisappear) {
        
        isViewDidDisappear = FALSE;
        
        [self initLayoutWithViewWillAppear];
        
    }
}

- (void)headerRereshingData
{
    DDLogVerbose(@"下拉刷新");
}

/**
 *  视图可见时加载的view
 */
- (void)initLayoutWithViewWillAppear{
    
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
    if (!isViewDidDisappear) {
        
        isViewDidDisappear = TRUE;
        
        [self deallocWithViewDidDisappear];
    }
}

/**
 *  视图不可见时释放的View
 */
-(void)deallocWithViewDidDisappear{
    
    for (UITableViewCell *cell  in self.tableView.visibleCells) {
        
        for (UIView *v in cell.contentView.subviews) {
            
            [v removeFromSuperview];
            v = nil;
        }
        
        [cell removeFromSuperview];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    if (self.navigationController.viewControllers.count == NavicationViewControllersCountINTableView) {//不是顶级试图
        
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = nil;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.navigationController.viewControllers.count != NavicationViewControllersCountINTableView) {//不是顶级试图
        
        NSString *path= nil;
        
        path = [[NSBundle mainBundle] pathForResource:@"nav_back" ofType:@"png"];
        
        if (path == nil) {
            
            path = [[NSBundle mainBundle] pathForResource:@"nav_back@2x" ofType:@"png"];
            
        }
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [btn addTarget:self action:@selector(BackClick) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = barButtonItem;
        [barButtonItem release];
        [image release];
        
    }
    
    //处理UIViewController的可视区域的高度
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        
        CGRect contentRect = self.view.frame;
        
        //减去导航条的高度
        if (!self.navigationController.navigationBarHidden) {
            
            contentRect.size.height = contentRect.size.height - self.navigationController.navigationBar.frame.size.height;
            
            //减去状态栏的高度
            if (![UIApplication sharedApplication].statusBarHidden) {
                
                contentRect.size.height = contentRect.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
            }
        }
        
        if ((self.tabBarController !=nil) && !self.tabBarController.hidesBottomBarWhenPushed) {
            
            contentRect.size.height = contentRect.size.height - self.tabBarController.tabBar.height;
        }
        
        self.view.frame = contentRect;
    }
}

- (void)BackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//iOS 5
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIDeviceOrientationPortrait);
    
}

//iOS 6
- (BOOL) shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


@end
