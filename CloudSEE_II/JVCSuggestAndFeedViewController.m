//
//  JVCSuggestAndFeedViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/11/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCSuggestAndFeedViewController.h"
#import "JVCAccountHelper.h"
#import "JVCConfigModel.h"
@interface JVCSuggestAndFeedViewController ()

@end

@implementation JVCSuggestAndFeedViewController

static const  NSString *kRequestUrlHead = @"http://192.168.4.234/member.php?mod=mobile&session=";
static const  NSString *kRequestUrlFoot = @"&username=";
static const  NSString *kSuccessString  = @"viewthread";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = LOCALANGER(@"suggestAndFeedBack");
    
    NSString *sessionKey = @"0";
    
    NSString *userName = @"jv_guest";
    
    if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_ACCOUNT) {//账号，获取sessionkey
        
         NSString *accountSession = [[JVCAccountHelper sharedJVCAccountHelper] getAccountSessionKey];
        
        if (accountSession !=nil) {
            
            sessionKey  = accountSession;
        }
        userName = kkUserName;

    }
    
    
    /**
     *添加webview
     */
    UIWebView *webView  = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.delegate    = self;
    [self.view          addSubview:webView];
    [webView            release];

    
    NSURL *urlRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",kRequestUrlHead,sessionKey,kRequestUrlFoot,userName]];
    NSURLRequest *request =[NSURLRequest requestWithURL:urlRequest];
    [webView loadRequest:request];
    DDLogVerbose(@"%@====%s",[NSString stringWithFormat:@"%@%@%@%@",kRequestUrlHead,sessionKey,kRequestUrlFoot,userName],__FUNCTION__);
    [[JVCAlertHelper shareAlertHelper] alertToastWithController:self.view];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"GetDetailDemoPointError")];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [request.URL absoluteString];
            
    if([urlString rangeOfString:(NSString *)kSuccessString].location !=NSNotFound){

        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_more_suggest_success")];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
