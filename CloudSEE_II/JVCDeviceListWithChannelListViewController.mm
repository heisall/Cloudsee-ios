//
//  JVCDeviceListWithChannelListViewController.m
//  CloudSEE_II
//  设备列表单击设备之后选择通道界面
//  Created by chenzhenyang on 14-9-28.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCDeviceListWithChannelListViewController.h"
#import "JVCRGBHelper.h"
#import "JVCDeviceListWithChannelListTitleView.h"
#import "JVCAppHelper.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCChannelScourseHelper.h"
#import "JVCOperationControllerIphone5.h"
#import "JVCOperationController.h"
#import "JVCChannelScourseHelper.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCWheelShowOperationController.h"
#import "JVCWheelShowOperationControllerIphone5.h"

@interface JVCDeviceListWithChannelListViewController () {

    NSMutableArray                        *titleColors;                //存放标签RGB颜色集合
    UIScrollView                          *titlelableScoollView;       //存放通道的滚动视图
}

@end

@implementation JVCDeviceListWithChannelListViewController

static const int      kInitWithChannelViewColumnCount = 4;
static const CGFloat  kConnectAllButtonWithHeight     = 48.0f;
static const CGFloat  kConnectAllButtonWithWidth      = 280.0f;
static const CGFloat  kConnectAllButtonWithBottom     = 25.0f;
static const CGFloat  kConnectAllButtonWithTop        = 15.0f;
static const CGFloat  kConnectAllButtonWithRadius     = 4.0f;
static const CGFloat  kTitleViewWithRadius            = 5.0f;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.title  = LOCALANGER(@"jvc_channelSelect_title");
        [self initWithTitleColors];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [titles addObjectsFromArray:[[JVCDeviceSourceHelper shareDeviceSourceHelper] ystNumbersWithDevceList]];
    [super viewDidLoad];
    [self initWithConnectAllButton];
    [self initWithChannelListView];
    [toolBarView setSelectedTopItemAtIndex:self.nIndex];
}

-(void)dealloc{

    [titleColors release];
    [super dealloc];
}

/**
 *  初始化标签颜色的rgb集合
 */
-(void)initWithTitleColors {
    
    titleColors = [[NSMutableArray alloc] initWithCapacity:10];
    
    [titleColors addObject:kJVCRGBColorMacroDeviceListWithChannelListLakeBlue];
    [titleColors addObject:kJVCRGBColorMacroDeviceListWithChannelListMediumYellow];
    [titleColors addObject:kJVCRGBColorMacroDeviceListWithChannelListGrassGreen];
    [titleColors addObject:kJVCRGBColorMacroDeviceListWithChannelListWarmOrange];
    
}

/**
 *  初始化功能按钮
 */
-(void)initWithOperationView {
    
    [super initWithOperationView];
    if (!titlelableScoollView) {
        
        titlelableScoollView = [[UIScrollView alloc] init];
        [operationView addSubview:titlelableScoollView];
        [titlelableScoollView release];
    }
}

/**
 *  初始化标签视图
 */
-(void)initWithChannelListView{
    
    NSMutableArray *channelValues               = [[JVCChannelScourseHelper shareChannelScourseHelper] channelValuesWithDeviceYstNumber:[titles objectAtIndex:nIndex]];
    
    [channelValues retain];
    
    if (titlelableScoollView) {
        
        for (UIView *v  in titlelableScoollView.subviews) {
            
            [v removeFromSuperview];
            v = nil;
        }
    }

    JVCRGBHelper   *rgbHelper                   = [JVCRGBHelper shareJVCRGBHelper];
    JVCAppHelper   *appHelper                   = [JVCAppHelper shareJVCAppHelper];
    UIColor        *skyColor                    = [rgbHelper rgbColorForKey:kJVCRGBColorMacroSkyBlue];
    NSMutableArray *titleViews                  = [[NSMutableArray alloc] initWithCapacity:10];
    CGFloat         totalHeight                 = 0.0;
    CGFloat         spacingY                    = 0.0;
    UIImage        *channelOperationViewBgImage = [UIImage imageNamed:@"dev_channelList_button_bg.png"];
    
    if (skyColor) {
        
        for (int i = 0; i < channelValues.count; i++) {
            
            CGRect position;
            
            position.size.width  = channelOperationViewBgImage.size.width;
            position.size.height = channelOperationViewBgImage.size.height;
            
            [appHelper viewInThePositionOfTheSuperView:self.view.frame.size.width viewCGRect:position nColumnCount:kInitWithChannelViewColumnCount viewIndex:i+1];
            
            int column    =  (i + 1) % kInitWithChannelViewColumnCount; // 1
            int row       =  (i + 1) / kInitWithChannelViewColumnCount; // 0
            
            if (column != 0 ) {
                
                row = row + 1;
            }
            
            int colorIndex = (row -1) % titleColors.count;
            
            UIColor *titleViewBgColor = [rgbHelper rgbColorForKey:[titleColors objectAtIndex:colorIndex]];
            
            if (!titleViewBgColor) {
                
                continue;
            }
            
            if (i == 0) {
                
                spacingY      = position.origin.y ;
            }
            
            totalHeight       = position.origin.y + position.size.height ;
            
            int channelValue  = [[channelValues objectAtIndex:i] intValue];
            
            JVCDeviceListWithChannelListTitleView *channelTitleView = [[JVCDeviceListWithChannelListTitleView alloc] initWithFrame:position backgroundColor:[UIColor clearColor] cornerRadius:kTitleViewWithRadius];
            
            channelTitleView.backgroundColor          = titleViewBgColor;
            channelTitleView.frame                    = position;
            channelTitleView.nChannelValueWithIndex   = i;
            [titleViews addObject:channelTitleView];
            
            //初始化按钮标题
            [channelTitleView initWithTitleView:[NSString stringWithFormat:@"%@%d%@",LOCALANGER(@"jvc_channelSelect_Num"), channelValue,LOCALANGER(@"jvc_channelSelect_channel")]];
            
            //添加选中通道的事件
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectChannelToPlay:)];
            [channelTitleView addGestureRecognizer:gesture];
            [gesture release];
        }
        
        CGRect scrollRect;
        
        scrollRect.size.width  = self.view.frame.size.width;
        scrollRect.size.height = self.view.frame.size.height - toolBarView.frame.size.height - kConnectAllButtonWithBottom - kConnectAllButtonWithTop - kConnectAllButtonWithHeight;
        scrollRect.origin.x    = 0.0f;
        scrollRect.origin.y    = 0.0;
        
        titlelableScoollView.frame                          = scrollRect;
        titlelableScoollView.directionalLockEnabled         =  NO;
        titlelableScoollView.showsVerticalScrollIndicator   =  FALSE;
        titlelableScoollView.showsHorizontalScrollIndicator =  FALSE;
        titlelableScoollView.clipsToBounds                  =  YES;
        titlelableScoollView.backgroundColor                =  [UIColor clearColor];
        
        CGSize newSize = CGSizeMake(self.view.frame.size.width,totalHeight);
        [titlelableScoollView setContentSize:newSize];
        
        for (JVCDeviceListWithChannelListTitleView *channelTitleView in titleViews) {
            
            [titlelableScoollView addSubview:channelTitleView];
        }
    }
    
    [titleViews release];
    [channelValues release];
}

/**
 *  滑动结束之后的回调
 */
-(void)animationEndCallBack{

    [self initWithChannelListView];
}

/**
 *  初始化全连按钮
 */
-(void)initWithConnectAllButton{
    
    DDLogVerbose(@"%s---channleListView=%@",__FUNCTION__,self.view);
    JVCRGBHelper *rgbHelper       =  [JVCRGBHelper shareJVCRGBHelper];
    
    UIColor      *connectBtnColor = [rgbHelper rgbColorForKey:kJVCRGBColorMacroNavBackgroundColor];
    
    if (!connectBtnColor) {
        
        return;
    }
    
    CGRect imageViewRect ;
    
    imageViewRect.size.width  = kConnectAllButtonWithWidth;
    imageViewRect.size.height = kConnectAllButtonWithHeight;
    imageViewRect.origin.x    = (operationView.frame.size.width - kConnectAllButtonWithWidth) / 2.0;
    imageViewRect.origin.y    = operationView.frame.size.height - kConnectAllButtonWithHeight - kConnectAllButtonWithBottom;
    
    
    JVCBaseRgbBackgroundColorView *connectBtnImageView = [[JVCBaseRgbBackgroundColorView alloc] initWithFrame:imageViewRect backgroundColor:connectBtnColor cornerRadius:kConnectAllButtonWithRadius];
    
    UIImage  *connectBtnImage     = [connectBtnImageView imageWithUIView];
    UIButton *connectButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    connectButton.frame           = imageViewRect;
    [connectButton setBackgroundImage:connectBtnImage forState:UIControlStateNormal];
    [connectButton addTarget:self action:@selector(connectAllWithSelectedDevice) forControlEvents:UIControlEventTouchUpInside];
    connectButton.backgroundColor = [UIColor clearColor];
    connectButton.clipsToBounds   = YES;
    
    UIColor *titleColor  = [rgbHelper rgbColorForKey:kJVCRGBColorMacroEditDeviceButtonFont];
    
    if (titleColor) {
        
        [connectButton setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    [connectButton setTitle:LOCALANGER(@"jvc_channelSelect_linkAll") forState:UIControlStateNormal];
    [operationView addSubview:connectButton];
    [connectBtnImageView release];

}

/**
 *  当前选择设备的全连事件
 */
-(void)connectAllWithSelectedDevice{
    
    for (UIViewController *con in self.navigationController.viewControllers) {
        
        
        DDLogVerbose(@"%s-----viewContro=%@",__FUNCTION__,con);
        
    }
    
    [self gotoPlayViewController:kJVCChannelScourseHelperAllConnectFlag];
}

/**
 *  选中通道的事件
 *
 *  @param gesture 手势
 */
- (void)selectChannelToPlay:(UIGestureRecognizer *)gesture
{
    
    JVCDeviceListWithChannelListTitleView *channelTitleView = (JVCDeviceListWithChannelListTitleView *)(gesture.view);
    
    int indexWithChannels =  channelTitleView.nChannelValueWithIndex;
    
    DDLogVerbose(@"%s---------------------channelWithChannels=%d",__FUNCTION__,indexWithChannels);
    
    [self gotoPlayViewController:indexWithChannels];
}

/**
 *  前往视频播放界面
 *
 *  @param index 当前选择的通道索引
 */
-(void)gotoPlayViewController:(int)index {
    
    
//    [self sortChannelListByDeviceList];
//    
//    JVCChannelScourseHelper *channelSourceObj = [JVCChannelScourseHelper shareChannelScourseHelper];
//    
//     JVCChannelModel *channelModelObj = [channelSourceObj channelModelAtIndex:index withDeviceYstNumber:[titles objectAtIndex:self.nIndex]];
    
    
    DDLogVerbose(@"%s------yunshitonghao=%@,index=%d",__FUNCTION__,[titles objectAtIndex:self.nIndex],index);
    
    JVCOperationController *tOPVC;
    
    if (iphone5) {
        
        tOPVC = [[JVCOperationControllerIphone5 alloc] init];
        
    }else
    {
        tOPVC = [[JVCOperationController alloc] init];
        
    }
    
    tOPVC.strSelectedDeviceYstNumber = [titles objectAtIndex:self.nIndex];
    
    tOPVC._iSelectedChannelIndex     = index;
//    tOPVC._iSelectedChannelIndex     = [channelSourceObj IndexAtChannelModelInChannelList:channelModelObj];
    [self.navigationController pushViewController:tOPVC animated:YES];
    [tOPVC release];
}


/**
 *  根据设备集合的云视通号顺序排序通道集合数据
 */
-(void)sortChannelListByDeviceList{
    
    NSMutableArray          *channelList      = [[NSMutableArray alloc] initWithCapacity:10];
    JVCDeviceSourceHelper   *deviceSourceObj  = [JVCDeviceSourceHelper shareDeviceSourceHelper];
    JVCChannelScourseHelper *channelSourceObj = [JVCChannelScourseHelper shareChannelScourseHelper];
    
    NSMutableArray        *deviceArray      = [deviceSourceObj deviceListArray];
    
    [deviceArray retain];
    
    
    for (JVCDeviceModel *deviceModel in deviceArray) {
        
        [channelList addObjectsFromArray:[channelSourceObj channelModelWithDeviceYstNumber:deviceModel.yunShiTongNum]];
    }
    

    [channelSourceObj removeAllchannelsObject];
    
    [[channelSourceObj ChannelListArray]  addObjectsFromArray:channelList];
    
    [deviceArray release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
