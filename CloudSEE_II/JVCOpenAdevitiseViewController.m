//
//  JVCOpenAdevitiseViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCOpenAdevitiseViewController.h"

@interface JVCOpenAdevitiseViewController ()

@end

@implementation JVCOpenAdevitiseViewController
@synthesize openUrlString;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /**
     *添加webview
     */
    UIWebView *webView  = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.delegate    = self;
    [self.view          addSubview:webView];
    [webView            release];
    
    self.title = LOCALANGER(@"JVC_Adver_title");
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.openUrlString]];
    [webView loadRequest:request];
    [[JVCAlertHelper shareAlertHelper] alertToastWithController:self.view];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"GetDetailDemoPointError")];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dealloc
{
    [openUrlString release];
    [super dealloc];
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
