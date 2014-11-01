//
//  JVCLocaOperationModifyViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/31/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCLocaOperationModifyViewController.h"
#import "JVCDeviceHelper.h"
#import "JVCPredicateHelper.h"
#import "JVCDeviceModel.h"
#import "JVCDeviceSourceHelper.h"
#import "JVCResultTipsHelper.h"
@interface JVCLocaOperationModifyViewController ()

@end

@implementation JVCLocaOperationModifyViewController
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mofidyServerUserAndPassWord:(NSString *)userName  passWord:(NSString *)passWord
{
    int result = [[JVCPredicateHelper shareInstance] predicateModifyLinkModelYSTWithName:userName andPassWord:passWord];
    
    if (kOperationMofifyTypeSUCCESS == result) {//正则校验用户名密码合法，调用判断用户名强度的方法
        
        self.modifyModel.userName = userName;
        self.modifyModel.passWord = passWord;
        
        result = [[JVCDeviceSourceHelper shareDeviceSourceHelper] updateLocalDeviceNickNameWithYst:self.modifyModel.yunShiTongNum NickName:self.modifyModel.nickName deviceName:passWord passWord:passWord iscustomLinkModel:NO];

        
        if (modifyDelegate !=nil && [modifyDelegate respondsToSelector:@selector(modifyDeviceInfoCallBack)]) {//修改成功 返回
            
            [modifyDelegate modifyDeviceInfoCallBack];
        }
        
        
    }else{//正则校验失败，提示相应的错误
        
        
        [[JVCResultTipsHelper shareResultTipsHelper] showModifyDevieLinkModelError:result];
        
    }
    
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
