//
//  JVCApHelpViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCApHelpViewController.h"

@interface JVCApHelpViewController ()

@end

@implementation JVCApHelpViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *iamgeAp = [UIImage imageNamed:LOCALANGER(@"more_aphelp")];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.contentSize = CGSizeMake(iamgeAp.size.width, iamgeAp.size.height);
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iamgeAp.size.width, iamgeAp.size.height)];
    imageview.image = iamgeAp;
    [scrollView addSubview:imageview];
    [imageview release];

    [self.view addSubview:scrollView];
    [scrollView release];
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
