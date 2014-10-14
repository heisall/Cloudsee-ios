//
//  JVCDefaultViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/14/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDefaultViewController.h"
#import "JVCSystemUtility.h"

@interface JVCDefaultViewController ()

@end

@implementation JVCDefaultViewController

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
    
    NSString *picImage = @"Default.png";
    
    if (iphone5) {
        
        picImage = @"Default-568h@2x.png";
    }
    NSString *imagebgName = [UIImage imageBundlePath:picImage];
    UIImage *imageBg = [[UIImage alloc] initWithContentsOfFile:imagebgName];
    UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageViewBg.image = imageBg;
    [self.view addSubview:imageViewBg];
    [imageViewBg release];
    [imageBg release];
    
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
