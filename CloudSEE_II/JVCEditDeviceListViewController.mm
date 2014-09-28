//
//  JVCEditDeviceListViewController.m
//  JVCEditDevice
//  视频管理界面
//  Created by chenzhenyang on 14-9-23.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCEditDeviceListViewController.h"
#import "JVCRGBHelper.h"
#import "JVCEditDeviceOperationView.h"
#import "JVCDeviceListDeviceVIew.h"
#import "JVCAppHelper.h"
#import "JVCEditViewControllerDropListViewCell.h"
#import "JVCAnimationHelper.h"

@interface JVCEditDeviceListViewController () {

    NSMutableArray *mArrayColors;
    NSMutableArray *mArrayIconNames;
    NSMutableArray *mArrayIconTitles;
    int  nIndex ;
    UITableView    *deviceListTableView;
    UIImageView    *dropImageView;
    
    NSArray        *titles;
    JVCTopToolBarView *toolBarView;         //顶部工具条
}

typedef NS_ENUM (NSInteger,JVCEditDeviceListViewControllerClickType){
    
    JVCEditDeviceListViewControllerClickType_beganIndex = 1000,
    JVCEditDeviceListViewControllerClickType_remoteSetup,
    JVCEditDeviceListViewControllerClickType_deviceManager,
    JVCEditDeviceListViewControllerClickType_linkModel,
    JVCEditDeviceListViewControllerClickType_channelManage,
    JVCEditDeviceListViewControllerClickType_play,
    JVCEditDeviceListViewControllerClickType_add,
};
@end

@implementation JVCEditDeviceListViewController

static const int            kInitWithLayoutColumnCount           = 3;
static const CGFloat        kDropTableViewHeight                 = 46.0f;
static const NSTimeInterval kOperationViewAnimationScaleBig      = 0.7;
static const NSTimeInterval kOperationViewAnimationScaleRestore  = 0.5;
static const NSTimeInterval kDropListViewAnimationBegin          = 0.8;
static const NSTimeInterval kDropListViewAnimationEnd            = 0.5;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        UITabBarItem *moreItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"设备管理", nil) image:nil tag:1];
        [moreItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_deviceManager_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_deviceManager_unselect.png"]];
        self.tabBarItem = moreItem;
        [moreItem release];
        
        self.title = self.tabBarItem.title;
        
        /**
         *  解决父类UIViewController带导航条添加ScorllView坐标系下沉64像素的问题（ios7）
         
         */
        
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
      
        
    }
    return self;
}

/**
 *  初始化加载视图RGB集合数据
 */
-(void)initWithRgbListArray {
    
    mArrayColors                 = [[NSMutableArray alloc] initWithObjects:kJVCRGBColorMacroGreen,kJVCRGBColorMacroSkyBlue,kJVCRGBColorMacroOrange,kJVCRGBColorMacroDeepRed,kJVCRGBColorMacroYellow,kJVCRGBColorMacroPurple,nil];
}

/**
 *  初始化图片名称集合
 */
- (void)initWithIconImageNameListArray{
    
    mArrayIconNames  = [[NSMutableArray alloc] initWithCapacity:10];
    
    [mArrayIconNames addObjectsFromArray:@[@"edi_RemoteSetup.png",@"edi_deviceManger.png",@"edi_linkModel.png",
                                           @"edi_deviceManger.png",@"edi_channelManager.png",@"edi_add.png"]];
}

/**
 *  初始化图片标题
 */
-(void)initWithIconTitleListArray {

    mArrayIconTitles              = [[NSMutableArray alloc] initWithCapacity:10];
    
    [mArrayIconTitles addObjectsFromArray:@[@"远程设置",@"设备管理",@"连接模式",
                                            @"通道管理",@"立即观看",@"添加设备"]];
}

/**
 *  初始化布局
 */
-(void)initWithLayoutView{
    
     titles = [[NSArray alloc] initWithObjects:@"A361",@"A35555555562",@"A3633456",@"A361",@"A35555555562",@"A366666663",@"A36444444441",@"A35555555562",@"A36333333",@"A361",@"A35555555562",@"A3633456",@"A361",@"A35555555562",@"A366666663",@"A36444444441",@"A35555555562",@"A36333333", nil];
    
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
    
    UIImage *viewBgImage =[UIImage imageNamed:@"edi_bg.png"];
    
    JVCRGBHelper *rgbHelper  = [JVCRGBHelper shareJVCRGBHelper];
    
    for (int i = 0; i< mArrayColors.count; i++) {
        
        CGRect position;
        
        position.size.width  = viewBgImage.size.width;
        position.size.height = viewBgImage.size.height;
        
        [[JVCAppHelper shareJVCRGBHelper] viewInThePositionOfTheSuperView:self.view.frame.size.width viewCGRect:position nColumnCount:kInitWithLayoutColumnCount viewIndex:i+1];
        
        position.origin.y = position.origin.y + toolBarView.frame.origin.y + toolBarView.frame.size.height;
        
        UIColor *backgroundColor = [rgbHelper rgbColorForKey:[mArrayColors objectAtIndex:i]];
        
        if (!backgroundColor) {
            
            continue;
        }
        
        JVCEditDeviceOperationView *bgView = [[JVCEditDeviceOperationView alloc] initWithFrame:position backgroundColor:backgroundColor cornerRadius:position.size.height/2.0];
        
        if (i < mArrayIconNames.count && i< mArrayIconTitles.count) {
            
             UIImage  *iconImage   = [UIImage imageNamed:[mArrayIconNames objectAtIndex:i]];
             NSString *title       = [mArrayIconTitles objectAtIndex:i];
            
             UIColor   *titleColor = [rgbHelper rgbColorForKey:kJVCRGBColorMacroEditDeviceButtonFont];
            
             if (titleColor) {
                
                //初始化标题和图标
                [bgView initWithLayoutView:title titleColor:titleColor iconImage:iconImage];
             }
        }
        
        //添加单击事件
        UITapGestureRecognizer* singleRecognizer;
        
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleCilck:)];
        singleRecognizer.numberOfTapsRequired = 1;
        [bgView addGestureRecognizer:singleRecognizer];
        [singleRecognizer release];
        
        //设置Tag标志
        bgView.tag  = JVCEditDeviceListViewControllerClickType_beganIndex + i + 1;
        
        [self.view addSubview:bgView];
        [bgView release];
    }
}

#pragma mark -------------JVCTopToolBarView delegate

-(void)topItemSelectedIndex:(int)index {

    DDLogVerbose(@"%s----%d",__FUNCTION__,index);
    
    [[JVCAnimationHelper shareJVCAnimationHelper] startWithAnimation:self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:0 duration:0.7 animationType:kJVCAnimationMacroCube animationSubType:index > nIndex ? kCATransitionFromLeft : kCATransitionFromRight];

    nIndex = index;
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
                
                
            }];
        }
        
    } if ([recognizer state] == UIGestureRecognizerStateBegan) {
        
        [deviceListTableView reloadData];
    }
}

/**
 *  单击事件
 *
 *  @param recognizer 单击手势对象
 */
-(void)singleCilck:(UITapGestureRecognizer*)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:kOperationViewAnimationScaleBig animations:^{
            
            recognizer.view.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
            
            
        } completion:^(BOOL finished){
            
            [UIView animateWithDuration:kOperationViewAnimationScaleRestore animations:^{
            
                recognizer.view.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finshed){
            
              //单击事件
                
                switch (recognizer.view.tag)
                {
                    case JVCEditDeviceListViewControllerClickType_remoteSetup:{
                        
                    }
                        break;
                    case JVCEditDeviceListViewControllerClickType_deviceManager:{
                        
                    }
                        break;
                    case JVCEditDeviceListViewControllerClickType_linkModel:{
                        
                    }
                        break;
                    case JVCEditDeviceListViewControllerClickType_channelManage:{
                        
                    }
                        break;
                    case JVCEditDeviceListViewControllerClickType_play:{
                        
                    }
                        break;
                        
                    case JVCEditDeviceListViewControllerClickType_add:{
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            
            }];
        }];
        
    }
}

-(void)dealloc{

    [mArrayIconNames release];
    [mArrayColors release];
    [mArrayIconTitles release];
    [titles release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initWithRgbListArray];
    [self initWithIconImageNameListArray];
    [self initWithIconTitleListArray];
    [self initWithLayoutView];
    
    UISwipeGestureRecognizer *swipeGestureRecognizer;
    
    swipeGestureRecognizer =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizer:)];
    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    [swipeGestureRecognizer release];
    
    swipeGestureRecognizer =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizer:)];
    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    [swipeGestureRecognizer release];
    
    deviceListTableView            = [[UITableView alloc] init];
    deviceListTableView.delegate   = self;
    deviceListTableView.dataSource = self;
    deviceListTableView.frame      = CGRectMake(0.0, 0.0, self.view.frame.size.width, 0.0);
    [deviceListTableView setSeparatorColor:[UIColor clearColor]]; //去掉UITableViewCell的边框
    [self.view addSubview:deviceListTableView];
    [deviceListTableView release];
}

/**
 *  左右滑动切换设备
 *
 *  @param swipeGestureRecognizer 滑动的对象
 */
-(void)swipeGestureRecognizer:(UISwipeGestureRecognizer *)swipeGestureRecognizer{
    
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        
        if (nIndex > 0) {
            
            nIndex --;
            [toolBarView setSelectedTopItemAtIndex:nIndex];
             [[JVCAnimationHelper shareJVCAnimationHelper] startWithAnimation:self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:0 duration:0.7 animationType:kJVCAnimationMacroCube animationSubType: kCATransitionFromRight];
        }
        
    }else if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight){
        
        if (nIndex < titles.count -1) {
            
            nIndex ++;
            [toolBarView setSelectedTopItemAtIndex:nIndex];
            
            [[JVCAnimationHelper shareJVCAnimationHelper] startWithAnimation:self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:0 duration:0.7 animationType:kJVCAnimationMacroCube animationSubType: kCATransitionFromLeft];
            
        }
    }

}

#pragma mark ---------- deviceListTableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  mArrayIconNames.count;
    
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
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.view.backgroundColor = [UIColor clearColor];
        deviceListTableView.frame = CGRectMake(deviceListTableView.frame.origin.x, deviceListTableView.frame.origin.y, deviceListTableView.frame.size.width, 0.0);
        dropImageView.transform   =  CGAffineTransformIdentity;
        
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return kDropTableViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    UIImage *topBarDropImage   = [UIImage imageNamed:@"edi_topBar_dropBtn.png"];
    
    return topBarDropImage.size.height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    {

    return [NSString stringWithFormat:@"共%d个设备", mArrayIconNames.count];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
