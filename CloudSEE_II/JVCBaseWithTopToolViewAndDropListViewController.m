//
//  JVCBaseWithTopToolViewAndDropListViewController.m
//  CloudSEE_II
//  顶部工具条和下拉框架
//  Created by chenzhenyang on 14-9-29.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseWithTopToolViewAndDropListViewController.h"

@interface JVCBaseWithTopToolViewAndDropListViewController ()

@end

@implementation JVCBaseWithTopToolViewAndDropListViewController
@synthesize nIndex;

static const CGFloat  kViewWithAnimationSwipe = 0.7f;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        titles = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

/**
 *  初始化顶部的布局
 */
-(void)initWithTopToolView{
    
    if (toolBarView) {
        
        for (UIView *v in toolBarView.subviews) {
            
            [v removeFromSuperview];
            v=nil;
        }
        
        [toolBarView removeFromSuperview];
    }
    
    if (dropImageView) {
        
        [dropImageView removeFromSuperview];
    }
    
    
    CGRect toolViewRect = CGRectMake(0.0, 0.0f, self.view.frame.size.width, 0.0);
    
    toolBarView          = [[JVCTopToolBarView alloc] initWithFrame:toolViewRect];
    toolBarView.jvcTopToolBarViewDelegate   = self;
    [toolBarView initWithLayout:titles];
    [self.view addSubview:toolBarView];
    [toolBarView release];
    
    UIImage *topBarDropImage   = [UIImage imageNamed:@"edi_topBar_dropBtn.png"];
    
    dropImageView    = [[UIImageView alloc] init];
    dropImageView.frame           = CGRectMake(self.view.frame.size.width - topBarDropImage.size.width,toolBarView.frame.origin.y , topBarDropImage.size.width, topBarDropImage.size.height);
    dropImageView.backgroundColor = [UIColor clearColor];
    dropImageView.image           = topBarDropImage;
    dropImageView.userInteractionEnabled = YES;
    [self.view addSubview:dropImageView];
    
    //添加单击事件
    UITapGestureRecognizer *dropClickRecognizer;
    
    dropClickRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropDownCilck:)];
    dropClickRecognizer.numberOfTapsRequired = 1;
    [dropImageView addGestureRecognizer:dropClickRecognizer];
    [dropClickRecognizer release];
    
    [dropImageView release];
}

/**
 *  单击事件
 *
 *  @param recognizer 单击手势对象
 */
-(void)dropDownCilck:(UITapGestureRecognizer*)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateEnded) {
        
        if (deviceListTableView.frame.size.height <= 0.0f) {
            
            [UIView animateWithDuration:kDropListViewAnimationBegin animations:^{
                
                self.view.backgroundColor = [UIColor blackColor];
                deviceListTableView.frame = CGRectMake(deviceListTableView.frame.origin.x, recognizer.view.frame.origin.y, deviceListTableView.frame.size.width, self.view.frame.size.height);
                
                [self.view bringSubviewToFront:deviceListTableView];
                [self.view bringSubviewToFront:recognizer.view];
                recognizer.view.transform =  CGAffineTransformMakeRotation(-180 * M_PI/180.0);
                
                
                
            } completion:^(BOOL finished){
                
            }];
            
        }else {
            
            [UIView animateWithDuration:kDropListViewAnimationEnd animations:^{
                
                self.view.backgroundColor = [UIColor clearColor];
                deviceListTableView.frame = CGRectMake(deviceListTableView.frame.origin.x, deviceListTableView.frame.origin.y, deviceListTableView.frame.size.width, 0.0);
                recognizer.view.transform =  CGAffineTransformIdentity;
                
                
            }completion:^(BOOL finished){
                
                [deviceListTableView reloadData];
                
            }];
        }
        
    }
}

/**
 *  初始化功能区域按钮
 */
-(void)initWithOperationView{
    
    
    
}

/**
 *  初始化下拉的设备表格视图
 */
-(void)initWithDropDeviceListView{
    
    deviceListTableView            = [[UITableView alloc] init];
    deviceListTableView.delegate   = self;
    deviceListTableView.dataSource = self;
    deviceListTableView.frame      = CGRectMake(0.0, 0.0, self.view.frame.size.width, 0.0);
    [deviceListTableView setSeparatorColor:[UIColor clearColor]]; //去掉UITableViewCell的边框
    [self.view addSubview:deviceListTableView];
    [deviceListTableView release];
}

/**
 *  初始化滑动事件
 */
-(void)initWithSwipeGestureRecognizer{
    
    UISwipeGestureRecognizer *swipeGestureRecognizer;
    
    swipeGestureRecognizer =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizer:)];
    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    [swipeGestureRecognizer release];
    
    swipeGestureRecognizer =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizer:)];
    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    [swipeGestureRecognizer release];
    
}

/**
 *  左右滑动切换设备
 *
 *  @param swipeGestureRecognizer 滑动的对象
 */
-(void)swipeGestureRecognizer:(UISwipeGestureRecognizer *)swipeGestureRecognizer{
    
    BOOL changeStatus = FALSE;
    
    switch (swipeGestureRecognizer.direction) {
            
        case UISwipeGestureRecognizerDirectionLeft:{
            
            if (nIndex > 0) {
                
                nIndex --;
                [toolBarView setSelectedTopItemAtIndex:nIndex];
                changeStatus = TRUE;
            }
            
            break;
        }
        case UISwipeGestureRecognizerDirectionRight:{
            
            if (nIndex < titles.count -1) {
                
                nIndex ++;
                [toolBarView setSelectedTopItemAtIndex:nIndex];
                changeStatus = TRUE;
            }
            
            break;
        }
        default:
            break;
    }
    
    if (changeStatus) {
        
        [[JVCAnimationHelper shareJVCAnimationHelper] startWithAnimation:self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:0 duration:kViewWithAnimationSwipe animationType:kJVCAnimationMacroCube animationSubType:swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft?kCATransitionFromRight:kCATransitionFromLeft];
        
        [self animationEndCallBack];
    }
}

/**
 *  动画借结束后处理逻辑
 */
-(void)animationEndCallBack{
    
    
    
}

#pragma mark -------------JVCTopToolBarView delegate

-(void)topItemSelectedIndex:(int)index {
    
    DDLogVerbose(@"%s----%d",__FUNCTION__,index);
    
    [[JVCAnimationHelper shareJVCAnimationHelper] startWithAnimation:self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:0 duration:kViewWithAnimationSwipe animationType:kJVCAnimationMacroCube animationSubType:index > nIndex ? kCATransitionFromLeft : kCATransitionFromRight];
    
    nIndex = index;
    
    [self animationEndCallBack];
}

#pragma mark ---------- deviceListTableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  titles.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentify = @"cellIndentifiy";
    
    JVCEditViewControllerDropListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    
    if (cell == nil) {
        
        cell = [[[JVCEditViewControllerDropListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *viewContent in cell.contentView.subviews) {
        
        [viewContent removeFromSuperview];
        viewContent =nil;
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    [cell initWithLayoutView:@"A3678900000"];
    
    [cell setViewSelectedView:indexPath.row == nIndex];
    
    return cell;
}

#pragma mark ------- deviceListTableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (nIndex != indexPath.row) {
        
        nIndex = indexPath.row;
    }
    
    [self dropDownCilckEnd];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kDropTableViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    UIImage *topBarDropImage   = [UIImage imageNamed:@"edi_topBar_dropBtn.png"];
    
    return topBarDropImage.size.height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    {
    
    return [NSString stringWithFormat:@"共%d个设备", titles.count];
    
}

/**
 *  下拉结束处理逻辑
 */
-(void)dropDownCilckEnd{
    
    [UIView animateWithDuration:kDropListViewAnimationEnd animations:^{
        
        self.view.backgroundColor = [UIColor clearColor];
        deviceListTableView.frame = CGRectMake(deviceListTableView.frame.origin.x, deviceListTableView.frame.origin.y, deviceListTableView.frame.size.width, 0.0);
        dropImageView.transform   =  CGAffineTransformIdentity;
        [toolBarView setSelectedTopItemAtIndex:nIndex];
        
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initWithTopToolView];
    [self initWithOperationView];
    [self initWithDropDeviceListView];
    [self initWithSwipeGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc{

    [titles release];
    [super dealloc];

}



@end
