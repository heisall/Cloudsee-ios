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

@interface JVCNetworkSettingViewController (){

    NSMutableArray *titles;
    UIView         *selectedItemBg;    //顶部选中视图
    int             nSelectedIndex;    //当前选中的索引
    UIScrollView   *operationListView; //操作视图
}

enum ITEM_INIT_TYPE {

    ITEM_INIT_WIRED = 0,
    ITEM_INIT_WIFI  = 1,
};

@end

@implementation JVCNetworkSettingViewController

static const int             kTopItemWithBeginFlagValue = 1000000000;
static const NSTimeInterval  kTopItemMoveWithDuration   = 0.3f;
static const NSTimeInterval  kWiredAutoWithTop          = 40.0f;
static const NSTimeInterval  kInputAutoWithTop          = 20.0f;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"网络设置";
    
    titles = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self initLayoutWithTopView];
    [self initLayoutWithOperationView];
}

-(void)dealloc{

    [titles release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

/**
 *  初始化顶部的功能视图
 */
-(void)initLayoutWithTopView {
    
    [titles addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"有线连接",nil)]];
    [titles addObject:[NSString stringWithFormat:@"%@",NSLocalizedString(@"无线连接", nil)]];
    
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
 *  初始化功能按钮视图
 */
-(void)initLayoutWithOperationView {
    
    
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
    
    for (int i=0; i < titles.count; i++) {
        
       CGRect  operationItemRect = CGRectMake(width*i, 0.0, width, operationListView.frame.size.height);
        
        UIView *operationItemView = i == ITEM_INIT_WIRED ? [self initLayoutWithWiredView:operationItemRect]:nil;
        
        if (operationItemView) {
            
            [operationListView addSubview:operationItemView];
        }
    }

    [operationListView release];
}


/**
 *  初始化有线的功能视图
 */
-(UIView *)initLayoutWithWiredView:(CGRect)rect{
    
    UIView *wiredView                = [[UIView alloc] init];
    wiredView.frame                  = rect;
    wiredView.backgroundColor        = [UIColor clearColor];
    //wiredView.userInteractionEnabled = YES;
    
    JVCControlHelper *controlHelperObj = [JVCControlHelper shareJVCControlHelper];
    
    UIButton *autoBtn    = [controlHelperObj buttonWithTitile:@"自动获取" normalImage:@"nws_wired_btnBg.png" horverimage:nil];
    
    [autoBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    CGRect autoBtnRect   = autoBtn.frame;
    autoBtnRect.origin.x = (rect.size.width - autoBtnRect.size.width)/2.0;
    autoBtnRect.origin.y = kWiredAutoWithTop;
    autoBtn.frame        = autoBtnRect;
    
    [wiredView addSubview:autoBtn];
    
    UIButton *inputBtn    = [controlHelperObj buttonWithTitile:@"手动输入" normalImage:@"nws_wired_btnBg.png" horverimage:nil];
    
    [inputBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    CGRect inputRect      = autoBtn.frame;
    inputRect.origin.y    = kInputAutoWithTop + autoBtn.bottom;
    inputBtn.frame        = inputRect;
    
    [wiredView addSubview:inputBtn];
    
    return [wiredView autorelease];
}

/**
 *  顶部按钮的点击事件
 *
 *  @param sender 点击的单击事件对象
 */
-(void)ItemViewClick:(id)sender{
    
    UITapGestureRecognizer *topBtnSender = (UITapGestureRecognizer*)sender;
    
    int index                            = topBtnSender.view.tag - kTopItemWithBeginFlagValue;
    
    if (index != nSelectedIndex) {
        
        [UIView beginAnimations:@"TopSelectedItem" context:nil];
        
        [UIView setAnimationDuration:kTopItemMoveWithDuration];
        
        selectedItemBg.frame = topBtnSender.view.frame;
        nSelectedIndex       = index;
        
        [self refreshTopItemViewStatus];
        
        [UIView commitAnimations];
        
//        itemContentManagerView *itemManView=(itemContentManagerView*)[self.view viewWithTag:566];
//        [itemManView changeScorllViewIndexPage:topBtnSender.view.tag-TOPITEMFLAGSTARTINDEXVALUE];
        
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
}


@end
