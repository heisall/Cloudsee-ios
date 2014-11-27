//
//  JVCBaseWithGeneralViewController.m
//  CloudSEE_II
//  通用的ViewController基类 用来处理系统兼容性
//  Created by chenzhenyang on 14-9-29.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"
#import "JVCRGBHelper.h"
#import "JVCCatchCrash.h"

static const int  NavicationViewControllersCount = 1;//navicationbar的viewcontroller的数量，1标示根试图

@interface JVCBaseWithGeneralViewController (){

    BOOL  isViewDidDisappear; //判断视图是否可见
}

@end

@implementation JVCBaseWithGeneralViewController
@synthesize tenCentKey;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        /**
         *  解决父类UIViewController带导航条添加ScorllView坐标系下沉64像素的问题（ios7）
         
         */
        
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            
        }
        
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    if (isViewDidDisappear) {
        
        isViewDidDisappear = FALSE;
        
        [self initLayoutWithViewWillAppear];
       
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    if (self.tenCentKey.length>0) {
        
        [MTA trackPageViewBegin:self.tenCentKey];
        
    }
}

- (void) disMissTencentView
{
    if (self.tenCentKey.length>0) {
        
        [MTA trackPageViewEnd:self.tenCentKey];
        
    }
}

/**
 *  视图可见时加载的view
 */
- (void)initLayoutWithViewWillAppear{

}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
    if (!isViewDidDisappear) {
        
        isViewDidDisappear = TRUE;
        
        [self deallocWithViewDidDisappear];
                
    }
    
    [self disMissTencentView];
}

/**
 *  视图不可见时释放的View
 */
-(void)deallocWithViewDidDisappear{


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //注册消息处理函数的处理方法
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    if (self.navigationController.viewControllers.count != NavicationViewControllersCount) {//不是顶级试图
        
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
    
    UIColor *viewDefaultColor = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroViewControllerBackGround];
    
    if (viewDefaultColor) {
        
        self.view.backgroundColor = viewDefaultColor;
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
    
        if (!self.hidesBottomBarWhenPushed) {
            
            contentRect.size.height = contentRect.size.height - self.tabBarController.tabBar.height;
        }
        

        self.view.frame = contentRect;

    }else{
        
        CGRect contentRect = self.view.frame;
        
        
        //减去导航条的高度
        if (!self.navigationController.navigationBarHidden) {
            contentRect.size.height = contentRect.size.height - self.navigationController.navigationBar.frame.size.height;
        }
        
        if (!self.hidesBottomBarWhenPushed) {
            
            contentRect.size.height = contentRect.size.height - self.tabBarController.tabBar.height;
        }
        
        self.view.frame = contentRect;

    }
}

/**
 *  根据图片大小返回一个UImageView
 *
 *  @param imageName 图片的名称
 *
 *  @return 返回一个图片大小的ImageView
 */
-(UIImageView *)imageViewWithImageName:(NSString *)imageName{
    
    UIImage *image              = [UIImage imageWithContentsOfFile:[UIImage imageBundlePath:imageName]];
    
    UIImageView *imageView      = [[UIImageView alloc] initWithImage:image];
    imageView.image             = image;
    imageView.backgroundColor   = [UIColor clearColor];
    
    return [imageView autorelease];
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

- (void)dealloc
{
    [self.tenCentKey release];
    
    [super dealloc];
}

@end
