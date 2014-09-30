//
//  JVCAPConfigPreparaViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/28/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAPConfigPreparaViewController.h"

static const int  ADDCONFIGHEIGIN = 64;//按钮多出来的那个高度

@interface JVCAPConfigPreparaViewController ()

@end

@implementation JVCAPConfigPreparaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void) viewDidLayoutSubviews {
//    
//    if (IOS_VERSION>=IOS7) {
//        
//        CGRect viewBounds = self.view.bounds;
//        
//        CGFloat topBarOffset = self.topLayoutGuide.length;
//        
//        viewBounds.origin.y = topBarOffset * -1;
//        
//        self.view.bounds = viewBounds;
//    }
//    
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //ios7
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//    {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
//    }
    NSString *imageBundlePath = [UIImage imageBundlePath:LOCALANGER(@"add_apConfig")];
    UIImage *iamgeAp = [[UIImage alloc] initWithContentsOfFile:imageBundlePath];
    
    NSString *btnBgBundlePath = [UIImage imageBundlePath:@"add_ApConfig.png"];
    UIImage *btnBg = [[UIImage alloc] initWithContentsOfFile:btnBgBundlePath];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    
    scrollView.contentSize = CGSizeMake(iamgeAp.size.width, iamgeAp.size.height+ADDCONFIGHEIGIN);
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iamgeAp.size.width, iamgeAp.size.height)];
    imageview.image = iamgeAp;
    [scrollView addSubview:imageview];
    [imageview release];
    [iamgeAp release];
    [self.view addSubview:scrollView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((self.view.width -btnBg.size.width)/2.0 , imageview.height+(ADDCONFIGHEIGIN -btnBg.size.height)/2.0, btnBg.size.width, btnBg.size.height);
    [btn setBackgroundImage:btnBg forState:UIControlStateNormal];
    [btn setTitle:@"开始添加" forState:UIControlStateNormal];
    [scrollView addSubview:btn];
    [btn addTarget:self action:@selector(exitToAPPConfig) forControlEvents:UIControlEventTouchUpInside];
    [scrollView release];
    [btnBg release];

}

/**
 *  弹出alert提示，看看是否退出程序
 */
- (void)exitToAPPConfig
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCALANGER(@"home_ap_Alert_message_ios7") message:nil delegate:self cancelButtonTitle:LOCALANGER(@"home_ap_Alert_GOON") otherButtonTitles:LOCALANGER(@"home_ap_Alert_NO"), nil];
    alertView.delegate = self;
    [alertView show];
    [alertView release];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {//继续
        
        exit(0);
    }
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
