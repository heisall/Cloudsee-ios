//
//  JVCEditDeviceListViewController.m
//  JVCEditDevice
//
//  Created by chenzhenyang on 14-9-23.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCEditDeviceListViewController.h"
#import "JVCRGBColorMacro.h"
#import "JVCRGBHelper.h"
#import "JVCEditDeviceOperationView.h"
#import "JVCDeviceListDeviceVIew.h"
#import "JVCAppHelper.h"

@interface JVCEditDeviceListViewController () {

    NSMutableArray *mArrayColors;
    NSMutableArray *mArrayIconNames;
    NSMutableArray *mArrayIconTitles;
    int  nIndex ;
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

static const int kInitWithLayoutColumnCount = 3;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        UITabBarItem *moreItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"设备管理", nil) image:nil tag:1];
        [moreItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_deviceManager_select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_deviceManager_unselect.png"]];
        self.tabBarItem = moreItem;
        [moreItem release];
        
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

    UIImage *viewBgImage =[UIImage imageNamed:@"edi_bg.png"];
    
    JVCRGBHelper *rgbHelper  = [JVCRGBHelper shareJVCRGBHelper];
    
    for (int i = 0; i< mArrayColors.count; i++) {
        
        CGRect position;
        
        position.size.width  = viewBgImage.size.width;
        position.size.height = viewBgImage.size.height;
        
        [[JVCAppHelper shareJVCRGBHelper] viewInThePositionOfTheSuperView:self.view.frame.size.width viewCGRect:position nColumnCount:kInitWithLayoutColumnCount viewIndex:i+1];
        
        if (![rgbHelper setObjectForKey:[mArrayColors objectAtIndex:i]]) {
            
            continue;
        }
        
        JVCRGBModel *rgbModel = (JVCRGBModel *)rgbHelper.rgbModel;
        
        JVCEditDeviceOperationView *bgView = [[JVCEditDeviceOperationView alloc] initWithFrame:position backgroundColor:RGBConvertColor(rgbModel.r, rgbModel.g, rgbModel.b,1.0f) cornerRadius:position.size.height/2.0];
        
        if (i < mArrayIconNames.count && i< mArrayIconTitles.count) {
            
             UIImage  *iconImage  = [UIImage imageNamed:[mArrayIconNames objectAtIndex:i]];
             NSString *title      = [mArrayIconTitles objectAtIndex:i];
            
             UIColor   *titleColor ;
            
             if ([rgbHelper setObjectForKey:kJVCRGBColorMacroEditDeviceButtonFont]) {
                
                JVCRGBModel *rgbModel = (JVCRGBModel *)rgbHelper.rgbModel;
                
                titleColor            = RGBConvertColor(rgbModel.r, rgbModel.g, rgbModel.b,1.0f);
                
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
    
    UIImage *deviceImage     = [UIImage imageNamed:@"dev_device_bg.png"];
    UIImage *iconDeviceImage = [UIImage imageNamed:@"dev_device_default_icon.png"];
    
    if ([rgbHelper setObjectForKey:kJVCRGBColorMacroSkyBlue]) {
        
        JVCRGBModel *rgbModel = (JVCRGBModel *)rgbHelper.rgbModel;
        
        JVCDeviceListDeviceVIew *deviceBg = [[JVCDeviceListDeviceVIew alloc] initWithFrame:CGRectMake(20.0, self.view.frame.size.height - deviceImage.size.height-20.0, deviceImage.size.width, deviceImage.size.height) backgroundColor:RGBConvertColor(rgbModel.r, rgbModel.g, rgbModel.b,1.0f) cornerRadius:6.0f];
        
        if ([rgbHelper setObjectForKey:kJVCRGBColorMacroWhite]) {
            
            JVCRGBModel *rgbWhiteModel = (JVCRGBModel *)rgbHelper.rgbModel;
            
            [deviceBg initWithLayoutView:iconDeviceImage borderColor:RGBConvertColor(rgbWhiteModel.r, rgbWhiteModel.g, rgbWhiteModel.b, 0.3f) titleFontColor:RGBConvertColor(rgbWhiteModel.r, rgbWhiteModel.g, rgbWhiteModel.b, 1.0f)];
            [deviceBg setAtObjectTitles:@"A366" onlineStatus:@"在线" wifiStatus:@"WI-FI"];
        }
        
        [self.view addSubview:deviceBg];
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
        
        int clickType  = recognizer.view.tag;
        
        switch (clickType) {
                
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
    }
}

-(void)dealloc{

    [mArrayIconNames release];
    [mArrayColors release];
    [mArrayIconTitles release];
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
}

/**
 *  左右滑动切换设备
 *
 *  @param swipeGestureRecognizer 滑动的对象
 */
-(void)swipeGestureRecognizer:(UISwipeGestureRecognizer *)swipeGestureRecognizer{
    
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        NSLog(@"%s---left",__FUNCTION__);
        
    }else if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight){
    
        NSLog(@"%s---right",__FUNCTION__);
    
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
