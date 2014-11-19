//
//  JVCLogShowViewController.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-18.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCLogShowViewController.h"
#import  "JVCSystemUtility.h"
#import "JVCAlertHelper.h"

@interface JVCLogShowViewController ()

@end

@implementation JVCLogShowViewController

@synthesize strLogPath;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSString *path= nil;
    
    path = [[NSBundle mainBundle] pathForResource:@"arm_clear" ofType:@"png"];
    
    if (path == nil) {
        
        path = [[NSBundle mainBundle] pathForResource:@"arm_clear@2x" ofType:@"png"];
        
    }
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
    [image release];
    
    UITextView  *textView     = [[UITextView alloc] initWithFrame:self.view.frame];
    textView.textColor        = [UIColor darkTextColor];
    textView.font             = [UIFont systemFontOfSize:14];
    textView.backgroundColor  = [UIColor grayColor];
    textView.editable         = NO;
    textView.scrollEnabled    = YES;
    textView.text             = [self textWithLog];
    
    [self.view addSubview:textView];
    
    [textView release];
}

-(void)clear {

    NSString       *path= [[JVCSystemUtility shareSystemUtilityInstance] getDocumentpathAtFileName:self.strLogPath];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
    [[JVCAlertHelper shareAlertHelper] alertWithMessage:NSLocalizedString(@"JVCLog_clear", nil)];
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  获取日志文本内容
 *
 *  @return 账号日志内容
 */
-(NSString *)textWithLog {
    
    NSMutableString *returnText = [[NSMutableString alloc] initWithCapacity:10];
    NSString        *pathAccount= [[JVCSystemUtility shareSystemUtilityInstance] getDocumentpathAtFileName:self.strLogPath];
    NSData          *data = [NSData dataWithContentsOfFile:pathAccount];
    
    if (data.length > 0) {
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [returnText appendString:result];
        
        [result release];
    }

    return  [returnText autorelease];
}

-(void)dealloc {

    DDLogVerbose(@"%s------------------",__FUNCTION__);
    [strLogPath release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
