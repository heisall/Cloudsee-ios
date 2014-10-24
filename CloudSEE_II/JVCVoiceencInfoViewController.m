//
//  JVCVoiceencInfoViewController.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-10-23.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCVoiceencInfoViewController.h"
#import "JVCControlHelper.h"

@interface JVCVoiceencInfoViewController ()

@end

@implementation JVCVoiceencInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.title = @"准备工作";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    JVCControlHelper *controlHelperObj = [JVCControlHelper shareJVCControlHelper];
    
    UIImageView *imageView = [controlHelperObj imageViewWithIamge:@"voi_info_icon.png"];
    
    CGRect imageRect     = imageView.frame;
    
    imageRect.origin.x   = (self.view.frame.size.width - imageView.frame.size.width)/2.0;
    imageRect.origin.y   = 80.0f;
    
    imageView.frame      = imageRect;
    
    [self.view addSubview:imageView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
