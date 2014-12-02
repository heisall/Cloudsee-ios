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
#import "JVCControlHelper.h"
#import "UIImage+BundlePath.h"
#import "JVCURlRequestHelper.h"
#import "UIImage+BundlePath.h"
#import "JVCRGBColorMacro.h"
#import "JVCRGBHelper.h"
@interface JVCSuggestAndFeedViewController ()
{
    UITextField *textfield;
    
    UITextView *textView;
    
    int cellContentHeight;
    int cellPhoneHeight;
    
    UILabel *labelCount;

}

@end

@implementation JVCSuggestAndFeedViewController
static const int KCellRowNum                = 2;
static const int KTextFieldPhoneOffy        = 20;
static const int KSeperateSpan              = 20;
static const int KTextViewSpan              = 10;

static const NSTimeInterval Animationtimer  = 0.5;//动画事件
static const int kAminamtionHeigt           = 60;//动画事件

static const int KLabeCountWith             = 30;//宽度
static const int KLabeCountHeight           = 20;//高度
static const int KMAXCOUNT                  = 500;//高度
static const int KSendSuggestSuccess        = 1;//成功
static const int KDefaultFontSize           = 15;//成功

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LOCALANGER(@"jvc_more_suggest");
    // Do any additional setup after loading the view

    [self initTextField];
    
    [self initTextView];
    
    [self initRightBarButton];
    
    UIColor *color = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroLoginGray];
    if (color) {
        textfield.textColor = color;
        textView.textColor = color;
        labelCount.textColor = color;

    }
  
}

- (void)initRightBarButton
{

    NSString *path = [UIImage imageBundlePath:@"ap_finsh.png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn setTitle:LOCALANGER(@"jvc_more_suggestion_send") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:KDefaultFontSize];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:btn];
     self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
    [image release];
}

- (void)initTextField
{

    textfield = [[JVCControlHelper shareJVCControlHelper] textFieldWithPlaceHold:LOCALANGER(@"jvc_more_suggestion_Phone_num") backGroundImage:@"mor_sug_textn.png"];
    textfield.font = [UIFont systemFontOfSize:KDefaultFontSize];
    [textfield retain];
    textfield.delegate = self;
   
    textfield.frame = CGRectMake((self.view.width - textfield.width)/2.0,KTextFieldPhoneOffy, textfield.width, textfield.height);
    [self.view addSubview:textfield];
    [textfield release];

}

- (void)sendMessage
{
    if (textView.text.length<=0) {
        
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_more_suggestion_content")];
        return;
    }
    
    [self resignSuggestTextFieldS];
    
    [[JVCAlertHelper shareAlertHelper]alertShowToastOnWindow];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        JVCURlRequestHelper *urlRequest = [[JVCURlRequestHelper alloc] init];
     int reuslt = [urlRequest sendSuggestWithMessage:textfield.text phoneNum:textView.text];
        [urlRequest release];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JVCAlertHelper shareAlertHelper] alertHidenToastOnWindow];
            [self handleSendSuggestResult:reuslt];
        });
    });
}

- (void)handleSendSuggestResult:(int)result
{
    if (KSendSuggestSuccess == result) {
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_more_suggestion_send_success")];
        [self.navigationController popViewControllerAnimated:YES];

    }else{
        [self suggestSlideDown];
        [[JVCAlertHelper shareAlertHelper] alertToastWithKeyWindowWithMessage:LOCALANGER(@"jvc_more_suggestion_send_error")];

    }
}

- (void)initTextView
{
    NSString *imagebgName = [UIImage correctImageName:@"mor_sug_Norbg.png"];
    UIImage *imageBg = [UIImage imageWithContentsOfFile:imagebgName];
    UIImageView *iamgeview = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width - imageBg.size.width)/2.0, textfield.bottom+KSeperateSpan, imageBg.size.width, imageBg.size.height-KTextViewSpan-5)];
    iamgeview.image = imageBg;
    iamgeview.userInteractionEnabled = YES;
    [self.view addSubview:iamgeview];
    [iamgeview release];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(iamgeview.left + KTextViewSpan,  iamgeview.top+ KTextViewSpan, imageBg.size.width- 2*KTextViewSpan, imageBg.size.height-2*KTextViewSpan)];
    textView.font = [UIFont systemFontOfSize:KDefaultFontSize];
    textView.delegate = self;
    textView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textView];
    [textView release];
    
    labelCount = [[UILabel alloc] initWithFrame:CGRectMake(iamgeview.right-KLabeCountWith-5, iamgeview.bottom -KLabeCountHeight-KTextViewSpan, KLabeCountWith, KLabeCountHeight)];
    labelCount.backgroundColor = [UIColor clearColor];
    labelCount.text = [NSString stringWithFormat:@"%d",KMAXCOUNT];
    [self.view addSubview:labelCount];
    [labelCount release];

}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark TEXTVIEW 的delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>KMAXCOUNT) {
        return NO;
    }else{
        
        int count = KMAXCOUNT - range.location;
        labelCount.text = [NSString stringWithFormat:@"%d",count];
        
        if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
            
            [textView resignFirstResponder];
            [self suggestSlideDown];

            //在这里做你响应return键的代码
            return YES;
        }
        
      
        return YES;
    }

}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self suggestSlideUp];
}

- (void)suggestSlideUp
{
    [UIView animateWithDuration:Animationtimer animations:^{
    
        self.view.frame = CGRectMake(0 , -kAminamtionHeigt, self.view.width, self.view.height);
        
    }];
}

- (void)suggestSlideDown
{
    [UIView animateWithDuration:Animationtimer animations:^{
        
        self.view.frame = CGRectMake(0 , 0, self.view.width, self.view.height);
        
    }];
}


- (void)resignSuggestTextFieldS
{
    [textfield resignFirstResponder];
    [textView resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
