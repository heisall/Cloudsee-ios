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

static const CGFloat KGesturesViewWithTop                      = 130.0f;
static const CGFloat KDeviceImageViewWithGesturesViewWithLeft  = 22.0f;
static const CGFloat KDeviceImageViewWithGesturesViewWithTop   = 100.0f;
static const CGFloat KTitleViewWithGesturesViewBottom          = 75.0f;
static const CGFloat KTitleViewWithSuperViewLeft               = 10.0f;
static const CGFloat KTitleTvWithFontSize                      = 16.0f;
static const CGFloat KTitleTvWithLineHeight                    = KTitleTvWithFontSize + 4.0;
static const int     KTitleTvWithNumberOfLines                 = 2;
static const CGFloat KTitleTvWithSuperViewTop                  = 10.0f;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
       self.title = LOCALANGER(@"JVCVoiceencHelpViewController_title");
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
    rectDevice.origin.x = ges.frame.size.width + ges.frame.origin.x - KDeviceImageViewWithGesturesViewWithLeft;
    rectDevice.origin.y = ges.frame.origin.y + KDeviceImageViewWithGesturesViewWithTop;
    dev.frame           = rectDevice;
    
    [self.view addSubview:dev];
    
    [dev release];
    
    UIImageView *titleView = [self imageViewWithImageName:@"voi_help_txtbg.png"];
    
    [titleView retain];
    
    CGRect rectTitle       = titleView.frame;
    rectTitle.origin.y     = ges.frame.origin.y - KTitleViewWithGesturesViewBottom;
    rectTitle.origin.x     = 50.0f;
    titleView.frame        = rectTitle;
    
    UILabel *titleLbl        = [[UILabel alloc] init];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textColor       = [UIColor whiteColor];
    titleLbl.textAlignment   = NSTextAlignmentLeft;
    titleLbl.numberOfLines   = 1;
    titleLbl.font            = [UIFont systemFontOfSize:KTitleTvWithFontSize];
    titleLbl.numberOfLines   = KTitleTvWithNumberOfLines;
    titleLbl.frame           = CGRectMake( KTitleViewWithSuperViewLeft,KTitleTvWithSuperViewTop , titleView.frame.size.width - KTitleViewWithSuperViewLeft * 2,KTitleTvWithLineHeight * KTitleTvWithNumberOfLines);
    titleLbl.text            = LOCALANGER(@"JVCVoiceencHelpViewController_helpString");
    [titleView addSubview:titleLbl];
    [titleLbl release];
    
    [self.view addSubview:titleView];
    
    [titleView release];
    
    [ges release];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
