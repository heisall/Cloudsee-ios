//
//  JVCOldDeviceHelpViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/4/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCOldDeviceHelpViewController.h"

@interface JVCOldDeviceHelpViewController ()

@end

@implementation JVCOldDeviceHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = LOCALANGER(@"device_old_update_title");
    
    NSString *imageBundlePath = [UIImage imageBundlePath:LOCALANGER(@"device_old_update")];
    UIImage *iamgeAp = [[UIImage alloc] initWithContentsOfFile:imageBundlePath];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    
    scrollView.contentSize = CGSizeMake(iamgeAp.size.width, iamgeAp.size.height);
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iamgeAp.size.width, iamgeAp.size.height)];
    imageview.image = iamgeAp;
    [scrollView addSubview:imageview];
    [imageview release];
    [iamgeAp release];
    [self.view addSubview:scrollView];
    [scrollView release];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
