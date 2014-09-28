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

@interface JVCDeviceListWithChannelListViewController ()

@end

@implementation JVCDeviceListWithChannelListViewController

static const int kInitWithChannelViewColumnCount = 4;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.title  = @"选择通道";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

/**
 *  初始化功能按钮
 */
-(void)initWithOperationView {
    
    JVCRGBHelper   *rgbHelper                   = [JVCRGBHelper shareJVCRGBHelper];
    JVCAppHelper   *appHelper                   = [JVCAppHelper shareJVCAppHelper];
    
    UIImage        *channelOperationViewBgImage = [UIImage imageNamed:@"dev_channelList_button_bg.png"];
    
    UIColor        *skyColor                    = [rgbHelper rgbColorForKey:kJVCRGBColorMacroSkyBlue];
    
    NSMutableArray *titleViews                  = [[NSMutableArray alloc] initWithCapacity:10];
    
    CGFloat         totalHeight                 = 0.0;
    
    CGFloat         spacingY                    = 0.0;
    
    if (skyColor) {
        
        for (int i = 0; i < 64; i++) {
            
            CGRect position;
            
            position.size.width  = channelOperationViewBgImage.size.width;
            position.size.height = channelOperationViewBgImage.size.height;
            
            [appHelper viewInThePositionOfTheSuperView:self.view.frame.size.width viewCGRect:position nColumnCount:kInitWithChannelViewColumnCount viewIndex:i+1];
            
        
            if (i == 0) {
                
                spacingY      = position.origin.y ;
            }
            
            if (i == 63) {
                DDLogVerbose(@"%s---63===%lf",__FUNCTION__,position.origin.y + position.size.height);
            }
            
            totalHeight       = position.origin.y + position.size.height ;
            
            JVCDeviceListWithChannelListTitleView *channelTitleView = [[JVCDeviceListWithChannelListTitleView alloc] initWithFrame:position backgroundColor:skyColor cornerRadius:5.0f];
            [titleViews addObject:channelTitleView];
            
            //初始化按钮标题
            [channelTitleView initWithTitleView:[NSString stringWithFormat:@"第%d通道",i+1]];
            
            [channelTitleView release];
        
        }
        
        UIScrollView *titlelableScoollView = [[UIScrollView alloc] init];
        titlelableScoollView.frame = CGRectMake(0.0, toolBarView.frame.origin.y + toolBarView.frame.size.height ,self.view.frame.size.width, self.view.frame.size.height - toolBarView.frame.origin.y - toolBarView.frame.size.height -200.0);
        [self.view addSubview:titlelableScoollView];
        
        DDLogVerbose(@"%s---scrollView=%@ tooBarView=%lf",__FUNCTION__,titlelableScoollView, 300.0);
        
        titlelableScoollView.directionalLockEnabled         =  NO;
        titlelableScoollView.showsVerticalScrollIndicator   =  FALSE;
        titlelableScoollView.showsHorizontalScrollIndicator =  FALSE;
        titlelableScoollView.clipsToBounds                  = YES;
        titlelableScoollView.backgroundColor                = [UIColor clearColor];
        
        CGSize newSize = CGSizeMake(self.view.frame.size.width,totalHeight);
        [titlelableScoollView setContentSize:newSize];
        
        
        for (JVCDeviceListWithChannelListTitleView *channelTitleView in titleViews) {
        
            [titlelableScoollView addSubview:channelTitleView];
        }
        
        [titlelableScoollView release];
    }
    
    [titleViews release];
    
    
    
    
    
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
