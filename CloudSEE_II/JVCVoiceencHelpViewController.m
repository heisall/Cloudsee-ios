//
//  JVCVoiceencHelpViewController.m
//  CloudSEE_II
//  声波配置使用说明
//  Created by chenzhenyang on 14-10-14.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCVoiceencHelpViewController.h"

@interface JVCVoiceencHelpViewController ()

@end

@implementation JVCVoiceencHelpViewController

static const CGFloat KGesturesViewWithTop = 150.0f;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
       self.title = @"操作演示";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *ges = [self imageViewWithImageName:@"voi_help_ges.png"];
    
    [ges retain];
    
    CGRect rectGes    = ges.frame;
    rectGes.origin.y  = KGesturesViewWithTop;
    ges.frame         = rectGes;
    
    [self.view addSubview:ges];
    
    
    UIImageView *dev    = [self imageViewWithImageName:@"voi_help_dev.png"];
    
    [dev retain];
    
    CGRect rectDevice   = dev.frame;
    rectDevice.origin.x = ges.frame.size.width + ges.frame.origin.x;
    rectDevice.origin.y = ges.frame.origin.y;
    
    [self.view addSubview:dev];
    [dev release];
    
    
    [ges release];

}

/**
 *  根据图片大小返回一个UImageView
 *
 *  @param imageName 图片的名称
 *
 *  @return 返回一个图片大小的ImageView
 */
-(UIImageView *)imageViewWithImageName:(NSString *)imageName{

    UIImage *image              = [UIImage imageNamed:imageName];
    
    UIImageView *imageView      = [[UIImageView alloc] initWithImage:image];
    imageView.image             = image;
    imageView.backgroundColor   = [UIColor clearColor];
    
    return [imageView autorelease];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
