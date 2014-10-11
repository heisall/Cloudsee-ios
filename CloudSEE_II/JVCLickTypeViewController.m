//
//  JVCLickTypeViewController.m
//  CloudSEE_II
//  连接模式
//  Created by Yanghu on 10/10/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCLickTypeViewController.h"
#import "JVCRGBHelper.h"
#import "JVCDeviceModel.h"
#import "JVCDeviceMacro.h"
#import "JVCLabelFieldSView.h"
@interface JVCLickTypeViewController ()
{
    UIImageView *imageViewSlide ;//滚动的横线
    
    UIButton *btnIP;
    
    UIButton *btnYst;
    
    JVCLabelFieldSView *viewYSt;
}

@end

@implementation JVCLickTypeViewController
@synthesize deviceModel;
static const int KHeadViewHeigin    = 44;//head头的高度
static const NSTimeInterval   KLinkTypeAnimationTimer  = 0.5;//动画时间
static const int KLabelOriginX      = 20;//距离左边框的位置
static const int KLabelWith         = 80;//label的宽度
static const int KSpan              = 20;//textfield之间的间距
static const int kTextFieldLabelSpan = 5;//textfield与label的间距


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
    //头模块
    [self initHeadView];
    //滑动模块
    [self initSlideView];
    
    UITextField *textFieldYst;
    UITextField *textFieldYstName;
    UITextField *textFieldYstPassWord;

    NSString *imageSlideStr      = [UIImage imageBundlePath:@"con_Slide.png"];
    UIImage *imageSlide     = [[UIImage alloc] initWithContentsOfFile:imageSlideStr];
    
    viewYSt = [[JVCLabelFieldSView alloc] initWithFrame:CGRectMake(0, KHeadViewHeigin+imageSlide.size.height, self.view.width, self.view.height)];
    [viewYSt initViewWithTitlesArray:[NSArray arrayWithObjects:@"云视通",@"用户名",@"密码",nil]  ];

    [self.view addSubview:viewYSt];
}

/**
 *  初始化headView
 */
- (void)initHeadView
{
    btnIP = [UIButton buttonWithType:UIButtonTypeCustom];
    btnIP.frame = CGRectMake(0, 0, self.view.width/2.0, KHeadViewHeigin);
    [btnIP setTitle:@"域名/IP地址" forState:UIControlStateNormal];
    //设置标题的颜色
    JVCRGBHelper *rgbHelper = [JVCRGBHelper shareJVCRGBHelper];
    
    UIColor *selectColor = [rgbHelper rgbColorForKey: kJVCRGBColorMacroEditDeviceTopBarItemSelectFontColor];
    UIColor *unSelectColor = [rgbHelper rgbColorForKey: kJVCRGBColorMacroEditDeviceTopBarItemUnselectFontColor];
    btnYst = [UIButton buttonWithType:UIButtonTypeCustom];
    btnYst.frame = CGRectMake(btnIP.right, btnIP.top, self.view.width/2.0, KHeadViewHeigin);
    [btnYst setTitle:@"云视通号" forState:UIControlStateNormal];
    //设置标题的颜色
    
    if (selectColor) {
        
        [btnYst setTitleColor:selectColor forState:UIControlStateSelected];
        [btnIP setTitleColor:selectColor forState:UIControlStateSelected];
    }
    
    if (unSelectColor) {
        
        [btnYst setTitleColor:unSelectColor forState:UIControlStateNormal];
        [btnIP setTitleColor:unSelectColor forState:UIControlStateNormal];

    }
    
    [btnYst addTarget:self action:@selector(animationSlideView:) forControlEvents:UIControlEventTouchUpInside];
    [btnIP addTarget:self action:@selector(animationSlideView:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btnYst];
    [self.view addSubview:btnIP];
}

/**
 *  初始化滑动模块
 */
- (void)initSlideView
{
    NSString *imageSlideStr      = [UIImage imageBundlePath:@"con_Slide.png"];
    UIImage *imageSlide     = [[UIImage alloc] initWithContentsOfFile:imageSlideStr];
    
    NSString *imageStr      = [UIImage imageBundlePath:@"con_line.png"];
    UIImage *imageLine      = [[UIImage alloc] initWithContentsOfFile:imageStr];
    
    UIImageView *imageViewLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, KHeadViewHeigin, self.view.width, imageSlide.size.height)];
    imageViewLine.image     = imageLine;
    [imageLine release];
    [self.view addSubview:imageViewLine];
    [imageViewLine release];
    
     imageViewSlide = [[UIImageView alloc] initWithFrame:CGRectMake(0, KHeadViewHeigin, self.view.width/2.0, imageSlide.size.height)];
    imageViewSlide.image     = imageSlide;
    [imageSlide release];
    [self.view addSubview:imageViewSlide];
    
    if (deviceModel.linkType == CONNECTTYPE_IP) {//ip连接
        
        [self animationSlideView:btnIP];
        
    }else{
        
        [self animationSlideView:btnYst];

    }

}

/**
 *  动画事件
 *
 *  @param btn 按下的btn
 */
- (void)animationSlideView:(UIButton *)btn
{
    [self setBtnUnSelected];
    
    btn.selected = YES;
    
    [UIView animateWithDuration:KLinkTypeAnimationTimer animations:^{
    
        CGRect frame = imageViewSlide.frame;
        DDLogVerbose(@"%@===%@",NSStringFromCGRect(frame),NSStringFromCGRect(imageViewSlide.frame));
        frame.origin.x = btn.frame.origin.x;
        imageViewSlide.frame =frame;
        DDLogVerbose(@"[0000=%@===%@",NSStringFromCGRect(frame),NSStringFromCGRect(imageViewSlide.frame));

        btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
    }];
}

- (void)setBtnUnSelected
{
    btnYst.selected = NO;
    btnYst.transform = CGAffineTransformIdentity;
    btnIP.selected  = NO;
    btnIP.transform = CGAffineTransformIdentity;

}


- (void)dealloc
{
    [deviceModel release];
    
    [imageViewSlide release];

    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
