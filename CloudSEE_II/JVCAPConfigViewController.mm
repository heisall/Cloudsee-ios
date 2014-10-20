//
//  JVCAPConfigViewController.m
//  CloudSEE_II
//  AP设置的发现设备界面
//  Created by chenzhenyang on 14-10-20.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCAPConfigViewController.h"
#import "JVCSystemConfigMacro.h"

@interface JVCAPConfigViewController ()

@end

@implementation JVCAPConfigViewController
@synthesize delegate;

static NSString const *KApConfigImageWithFileName = @"apConfigHomeIPC.bundle";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.view.backgroundColor=SETLABLERGBCOLOUR(240.0, 240.0, 240.0);
    
    UIImage *deviceImage=[self returnBundleImage:@"new_d.png"];
    
    UILabel *infoLbl=[[UILabel alloc] init];
    infoLbl.frame=CGRectMake((self.view.frame.size.width-deviceImage.size.width)/2.0, 60.0, deviceImage.size.width, 30.0);
    infoLbl.textColor=SETLABLERGBCOLOUR(50.0, 50.0, 50.0);
    infoLbl.font=[UIFont systemFontOfSize:20.0];
    infoLbl.text=NSLocalizedString(@"apSetting_new_device", nil);
    infoLbl.backgroundColor=[UIColor clearColor];
    infoLbl.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:infoLbl];
    [infoLbl release];
    
    UIImageView *deviceImageView=[[UIImageView alloc] init];
    deviceImageView.frame=CGRectMake((self.view.frame.size.width-deviceImage.size.width)/2.0, (self.view.frame.size.height-deviceImage.size.height)/2.0*0.8, deviceImage.size.width, deviceImage.size.height);
    
    deviceImageView.backgroundColor=[UIColor clearColor];
    
    deviceImageView.image=deviceImage;
    [self.view addSubview:deviceImageView];
    [deviceImageView release];
    
    UIImage *newDeviceIconImage=[self returnBundleImage:NSLocalizedString(@"new_d", nil)];
    
    UIImageView *deviceImageIconView=[[UIImageView alloc] init];
    deviceImageIconView.frame=CGRectMake(deviceImageView.frame.origin.x-newDeviceIconImage.size.width/3.0, deviceImageView.frame.origin.y-newDeviceIconImage.size.height/2.0, newDeviceIconImage.size.width, newDeviceIconImage.size.height);
    
    deviceImageIconView.backgroundColor=[UIColor clearColor];
    
    deviceImageIconView.image=newDeviceIconImage;
    [self.view addSubview:deviceImageIconView];
    [deviceImageIconView release];
    
    UIImage *btnImage=[self returnBundleImage:@"ap_next.png"];
    
    
    UILabel *operationInfo=[[UILabel alloc] init];
    
    int heightLable = 90;
    int fontSize = 12.0;
    
    if (iphone5) {
        
        heightLable = 120;
        fontSize = 14;
    }
    
//    if ([OperationSet judgeSystemLocalLanguage]) {
//        
//        fontSize = 14;
//        
//    }
    
    operationInfo.frame=CGRectMake((self.view.frame.size.width-btnImage.size.width)/2.0, deviceImageView.frame.origin.y+deviceImageView.frame.size.height+10.0, btnImage.size.width, heightLable);
    operationInfo.textColor=SETLABLERGBCOLOUR(50.0, 50.0, 50.0);
    
    if (IOS_VERSION <IOS7) {
        
        operationInfo.adjustsFontSizeToFitWidth = YES;
        
    }
    
    operationInfo.font=[UIFont systemFontOfSize:fontSize];
    operationInfo.numberOfLines             = 0;
    
    operationInfo.text=NSLocalizedString(@"setWifiStep", nil);
    operationInfo.backgroundColor=[UIColor clearColor];
    operationInfo.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:operationInfo];
    [operationInfo release];
    
    UIButton *nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    nextBtn.frame=CGRectMake((self.view.frame.size.width-btnImage.size.width)/2.0, operationInfo.frame.size.height+operationInfo.frame.origin.y+10.0, btnImage.size.width, btnImage.size.height);
    [nextBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(gotoSetting) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:LOCALANGER(@"apSetting_new_device_next") forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
}

/**
 *  返回UIImage
 *
 *	@param	ImageName	图片的名字
 *
 *	@return	返回指定指定图片名的图片
 */
-(UIImage *)returnBundleImage:(NSString *)ImageName{
    
    NSString *main_image_dir_path=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:(NSString *)KApConfigImageWithFileName];
    
    NSString *image_path=[main_image_dir_path stringByAppendingPathComponent:ImageName];
    
    return [UIImage imageWithContentsOfFile:image_path];
    
}

/**
 *	前往配置界面
 */
-(void)gotoSetting{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(buttonClick:)]) {
        
        [self.delegate buttonClick:buttonClickType_Next];
    }
    
}

/**
 *	下一步请求
 */
-(void)nextClick{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(buttonClick:)]) {
        
        [self.delegate buttonClick:buttonClickType_Next];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
