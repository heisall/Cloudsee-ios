//
//  JVCAddLockDeviceViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAddLockDeviceViewController.h"
#import "JVCControlHelper.h"
#import "JVCEditLockDeviceNickNameViewController.h"
@interface JVCAddLockDeviceViewController ()

@end

@implementation JVCAddLockDeviceViewController
static const  int  KBtnTagDoor = 100;//门磁的的tag
static const  int  KBtnTagBra  = 101;//手环的tag
static const  int  kEdgeOff    = 100;//向下距离

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
    
    [self  initContentView];
    
    self.title = @"添加设备";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initContentView
{
    JVCControlHelper *controlHelper = [JVCControlHelper shareJVCControlHelper];
    UIButton *btn  = [controlHelper buttonWithTitile:@"门磁设备" normalImage:@"arm_dev_dor.png" horverimage:nil];
    btn.titleEdgeInsets = UIEdgeInsetsMake(kEdgeOff, 0, 0, 0);
    btn.frame = CGRectMake((self.view.width-btn.width)/2.0, (self.view.height- btn.height*2)/3.0, btn.width, btn.height);
    btn.tag = KBtnTagDoor;
    [btn addTarget:self action:@selector(addLockDevice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btnBra  = [controlHelper buttonWithTitile:@"手环设备" normalImage:@"arm_dev_Bra.png" horverimage:nil];
    btnBra.titleEdgeInsets = UIEdgeInsetsMake(kEdgeOff, 0, 0, 0);
    btnBra.frame = CGRectMake((self.view.width-btnBra.width)/2.0, btn.bottom+(self.view.height- btn.height*2)/3.0, btn.width, btn.height);
    btnBra.tag = KBtnTagBra;
    [btnBra addTarget:self action:@selector(addLockDevice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBra];

}

- (void)addLockDevice:(UIButton *)btn
{
    switch (btn.tag) {
        case KBtnTagDoor:
            [self editLockDeviceNickName];
            break;
        case KBtnTagBra:
            
            break;
            
        default:
            break;
    }
}

- (void)editLockDeviceNickName
{
    JVCEditLockDeviceNickNameViewController *editVC = [[JVCEditLockDeviceNickNameViewController alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
    [editVC release];
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
