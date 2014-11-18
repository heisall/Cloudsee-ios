//
//  JVCLogShowViewController.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-18.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCLogShowViewController.h"

@interface JVCLogShowViewController ()

@end

@implementation JVCLogShowViewController

@synthesize strLogPath;

- (void)viewDidLoad {
    
    self.navigationController.navigationBarHidden = NO;
    
    [super viewDidLoad];
    
    self.title                = @"文本预览";
    
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

-(void)deallocWithViewDidDisappear {


    self.navigationController.navigationBarHidden  = YES;

}

/**
 *  获取日志文本内容
 *
 *  @return 账号日志内容
 */
-(NSString *)textWithLog {
    
    NSMutableString *returnText = [[NSMutableString alloc] initWithCapacity:10];
    
    NSArray *pathsAccount=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *pathAccountHome=[pathsAccount objectAtIndex:0];
    
    NSString * pathAccount=[pathAccountHome stringByAppendingPathComponent:self.strLogPath];
    
    NSData *data = [NSData dataWithContentsOfFile:pathAccount];
    
    if (data.length > 0) {
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [returnText appendString:result];
        
        [result release];
    }
    
    
    return  [returnText autorelease];
}

-(void)dealloc {

    [strLogPath release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
