//
//  JVCVoiceencInfoViewController.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-10-23.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCVoiceencInfoViewController.h"
#import "JVCControlHelper.h"
#import "JVCVoiceencInputSSIDWithPasswordViewController.h"

@interface JVCVoiceencInfoViewController ()

@end

@implementation JVCVoiceencInfoViewController

static const CGFloat kImageIconWithTop       = 100.0f;
static const CGFloat kInfoTVWithFontSize     = 14.0f;
static const int     kInfoTVWithNumberOfLine = 2;
static const CGFloat kInfoTVWithLineOfHeight = kInfoTVWithFontSize + 6.0f;


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
    imageRect.origin.y   =  kImageIconWithTop;
    imageView.frame      = imageRect;
    
    [self.view addSubview:imageView];
    
    UILabel *infoTV        = [controlHelperObj labelWithText:@"用顶针轻插配置孔\n直到您听到嘀的一声"];
    infoTV.frame           = CGRectMake(imageView.origin.x, 30.0, imageView.frame.size.width, kInfoTVWithLineOfHeight*kInfoTVWithNumberOfLine);
    infoTV.textAlignment   = NSTextAlignmentCenter;
    infoTV.numberOfLines   = kInfoTVWithNumberOfLine;
    infoTV.font            = [UIFont systemFontOfSize:kInfoTVWithFontSize];
    
    [self.view addSubview:infoTV];
    
    UIButton *nextButton = [controlHelperObj buttonWithTitile:@"下一步" normalImage:@"voi_input_next.png" horverimage:nil];
    
    CGRect NextBtnRect = nextButton.frame;
    
    NextBtnRect.origin.x  = (self.view.frame.size.width - NextBtnRect.size.width)/2.0;
    NextBtnRect.origin.y  = imageView.frame.size.height + imageView.frame.origin.y + 50.0f;
    nextButton.frame      = NextBtnRect;
    [nextButton addTarget:self action:@selector(gotoVoicConfig) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}

/**
 *  前往声波配置界面
 */
-(void)gotoVoicConfig {

    JVCVoiceencInputSSIDWithPasswordViewController *jvcVoiceencViewcontroller = [[JVCVoiceencInputSSIDWithPasswordViewController alloc] init];
    
    [self.navigationController pushViewController:jvcVoiceencViewcontroller animated:YES];
    
    [jvcVoiceencViewcontroller release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
