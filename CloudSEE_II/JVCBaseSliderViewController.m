//
//  JVCBaseSliderViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseSliderViewController.h"
#import "JVCRGBHelper.h"
static const int  NavicationSlideViewControllersCount = 1;//navicationbar的viewcontroller的数量，1标示根试图

@interface JVCBaseSliderViewController ()

@end

@implementation JVCBaseSliderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLayoutSubviews {
    
    if (IOS_VERSION>=IOS7) {
        
        CGRect viewBounds = self.view.bounds;
        
        CGFloat topBarOffset = self.topLayoutGuide.length;
        
        viewBounds.origin.y = topBarOffset * -1;
        
        self.view.bounds = viewBounds;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIColor *viewDefaultColor = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroViewControllerBackGround];
    
    if (viewDefaultColor) {
        
        self.view.backgroundColor = viewDefaultColor;
    }
    
    if (self.navigationController.viewControllers.count != NavicationSlideViewControllersCount) {//不是顶级试图
        
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

}

- (void)BackClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
