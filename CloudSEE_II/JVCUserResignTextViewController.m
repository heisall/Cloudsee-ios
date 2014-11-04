//
//  JVCUserResignTextViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/3/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCUserResignTextViewController.h"

@interface JVCUserResignTextViewController ()

@end

@implementation JVCUserResignTextViewController

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
    
    self.navigationItem.title=NSLocalizedString(@"jvc_resign_Resign_DownLineText", nil);
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSString *tPath = [[NSBundle mainBundle] pathForResource:NSLocalizedString(@"jvc_resign_userResign", nil) ofType:@"txt"];
    
    NSString *body = [NSString stringWithContentsOfFile:tPath encoding:NSUTF8StringEncoding error:nil];
    if(!body)
    {
        body = [NSString stringWithContentsOfFile:tPath encoding:0x80000632 error:nil];
    }
    if(!body)
    {
        body = [NSString stringWithContentsOfFile:tPath encoding:0x80000631 error:nil];
    }
    textView.text =body;
    [self.view addSubview:textView];
    textView.editable = NO;
    [textView release];

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
