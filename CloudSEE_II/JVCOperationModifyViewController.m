//
//  JVCOperationModifyViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/31/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCOperationModifyViewController.h"
#import "JVCLabelFieldSView.h"
#import "JVCPredicateHelper.h"
#import "JVCResultTipsHelper.h"
#import "JVCDeviceHelper.h"
#import "JVCDeviceModel.h"
@interface JVCOperationModifyViewController ()
{
    JVCLabelFieldSView *modifyView;
    
    UITextField *textFieldUserName;
    UITextField *textFieldPassWord;
}

@end

@implementation JVCOperationModifyViewController
@synthesize modifyModel;
@synthesize modifyDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)deallocWithViewDidDisappear
{
    [self resinModifyTextFields];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"wifi-change", nil);

    modifyView = [[JVCLabelFieldSView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    modifyView.delegate = self;
    [modifyView initViewWithTitlesArray:[NSArray arrayWithObjects:LOCALANGER(@"jvc_addDevice_userName"),LOCALANGER(@"jvc_addDevice_password"),nil]  ];
    
    [self.view addSubview:modifyView];
    [modifyView release];
    

    //用户名
    textFieldUserName = [modifyView textFieldWithIndex:0];
    textFieldUserName.delegate = self;
    textFieldUserName.text = self.modifyModel.userName;
    textFieldUserName.keyboardType = UIKeyboardTypeASCIICapable;

    //密码
    textFieldPassWord = [modifyView textFieldWithIndex:1];
    textFieldPassWord.text =self.modifyModel.passWord;
    textFieldPassWord.delegate = self;
    textFieldPassWord.secureTextEntry = YES;
    textFieldPassWord.keyboardType = UIKeyboardTypeASCIICapable;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  按钮按下的回调
 */
- (void)JVCLabelFieldBtnClickCallBack
{
    
    [self mofidyServerUserAndPassWord:textFieldUserName.text passWord:textFieldPassWord.text];

}

- (void)mofidyServerUserAndPassWord:(NSString *)userName  passWord:(NSString *)passWord
{
    int result = [[JVCPredicateHelper shareInstance] predicateModifyLinkModelYSTWithName:userName andPassWord:passWord];
    
    if (kOperationMofifyTypeSUCCESS == result) {//正则校验用户名密码合法，调用判断用户名强度的方法
        
        [[JVCAlertHelper shareAlertHelper] alertShowToastOnWindow];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            int resutlModify =-1;
            
            resutlModify = [[JVCDeviceHelper sharedDeviceLibrary] modifyDeviceLinkModel:self.modifyModel.yunShiTongNum linkType:0 userName:textFieldUserName.text password:textFieldPassWord.text ip:@"" port:@"" ];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
                
                [self handlerModifyOperationUserAndPassWord:resutlModify];
                
            });
            
        });
        
        
    }else{//正则校验失败，提示相应的错误
        
        
        [[JVCResultTipsHelper shareResultTipsHelper] showModifyDevieLinkModelError:result];
        
    }

}

- (void)handlerModifyOperationUserAndPassWord:(int )result
{

    if (result == kOperationMofifyTypeSUCCESS) {//成功
        
        self.modifyModel.userName = textFieldUserName.text;
        self.modifyModel.passWord = textFieldPassWord.text;
        
        if (modifyDelegate !=nil && [modifyDelegate respondsToSelector:@selector(modifyDeviceInfoCallBack)]) {//修改成功 返回
            
            [modifyDelegate modifyDeviceInfoCallBack];
        }
        
        
        
    }else{
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"Modify_LinkType_fail")];
    
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/**
 *  背景被按下的回调
 */
- (void)touchUpInsiderBackGroundCallBack
{
    [self resinModifyTextFields];
}

- (void)resinModifyTextFields
{
    [textFieldUserName resignFirstResponder];
    [textFieldPassWord resignFirstResponder];
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
- (void)dealloc
{
    [modifyModel release];
    [super dealloc];
}

@end
