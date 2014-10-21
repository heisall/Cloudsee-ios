//
//  JVCEditLockDeviceNickNameViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCEditLockDeviceNickNameViewController.h"
#import "JVCControlHelper.h"

@interface JVCEditLockDeviceNickNameViewController ()

@end

@implementation JVCEditLockDeviceNickNameViewController
static const  int  KTextFieldOriginY  = 30;//textfield距离左侧的距离
static const  int  KSpan              = 30;//间距

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
    
    self.title = @"完成添加按钮";
    [self initContentView];
}

- (void)initContentView
{
    JVCControlHelper *controlHelper = [JVCControlHelper shareJVCControlHelper];
    UITextField *textField = [controlHelper textFieldWithPlaceHold:@"请输入昵称" backGroundImage:@"arm_dev_tex.png"];
    textField.frame = CGRectMake((self.view.width -textField.width)/2.0, KTextFieldOriginY, textField.width, textField.height);
    textField.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:textField];
    [textField becomeFirstResponder];
    
    UIButton *btn = [controlHelper buttonWithTitile:@"完成" normalImage:@"arm_dev_btn.png" horverimage:nil];
    btn.frame = CGRectMake((self.view.width -btn.width)/2.0 , textField.bottom+KSpan, btn.width, btn.height);
    [btn addTarget:self  action:@selector(finishEditDeviceNick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)finishEditDeviceNick
{
    
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
