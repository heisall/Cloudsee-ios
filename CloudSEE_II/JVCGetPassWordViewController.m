//
//  JVCGetPassWordViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/29/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCGetPassWordViewController.h"
#import "JVCSystemUtility.h"

@interface JVCGetPassWordViewController ()
{
    BOOL _boolHUBstate;

}

@end

@implementation JVCGetPassWordViewController
static  NSString const *FINDPASSWORD = @"http://webapp.afdvr.com/findpwd/index.html";
static  NSString const *FINDPASSWORDEN = @"http://webappen.afdvr.com/findpwd/index.html";

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
    
    self.navigationController.navigationBarHidden = NO;

    // Do any additional setup after loading the view.
    
    // Do any additional setup after loading the view.
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.title = NSLocalizedString(@"JVCGetPassWordViewController_title", nil);

    NSURL *url=nil;

        if ([[JVCSystemUtility shareSystemUtilityInstance] judgeAPPSystemLanguage]) {
    
        url =[NSURL URLWithString:(NSString *)FINDPASSWORD];
            
        }else{
            url =[NSURL URLWithString:(NSString *)FINDPASSWORDEN];

        }
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    webView.delegate = self;
    [webView loadRequest:request];
    [self.view addSubview:webView];
    [webView release];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
     if (!_boolHUBstate) {
         [[JVCAlertHelper shareAlertHelper] alertToastWithController:self.view];
         _boolHUBstate = YES;
     }
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[JVCAlertHelper shareAlertHelper]alertHidenToastOnWindow];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:NSLocalizedString(@"JVCGetPassWordViewController_error", nil)];
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
