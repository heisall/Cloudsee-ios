//
//  JVCAPConfigPlayVideoIphone4ViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAPConfigPlayVideoIphone4ViewController.h"
@interface JVCAPConfigPlayVideoIphone4ViewController ()
{
    JVCAPConfigMiddleView *middleView ;
}

@end

@implementation JVCAPConfigPlayVideoIphone4ViewController

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

/**
 *  初始化中间功能按钮视图
 */
-(void)initLayoutWithOperationView:(CGRect )frame{
    
    middleView = [[JVCAPConfigMiddleView alloc]init];
    middleView.frame = frame;
    middleView.delegateApOperationMiddle = self;
    NSArray *title = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Audio", nil),NSLocalizedString(@"PTZ Control", nil),NSLocalizedString(@"megaphone", nil), nil];
    
    [middleView updateAPViewWithTitleArray:title ];
    [self.view addSubview:middleView];
    [middleView release];
    
    UIButton *talkViewBtn =(UIButton *) [middleView getSelectbtn:OPERATIONAPBTNCLICKTYPE_Talk];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(aplongPressedStartTalk:)];
    longPress.allowableMovement = NO;
    longPress.minimumPressDuration = 0.5;
    [talkViewBtn addGestureRecognizer:longPress];
    [longPress release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  按钮按下的回调
 *
 *  @param buttonType 选中的那个button
 */
- (void)ApConfigoperationMiddleViewButtonCallback:(int)buttonType
{
    DDLogVerbose(@"%s---%d",__FUNCTION__,buttonType);
    
    if (![self judgeAPOpenVideoPlaying]) {//没有图像直接返回
        return;
    }
    
    switch (buttonType) {
        case OPERATIONAPBTNCLICKTYPE_AUDIO:
            [self ApAudioBtnClick];
            break;
        case OPERATIONAPBTNCLICKTYPE_YTOPERATION:
            [self  APYTOperationViewShow];
            break;
        case OPERATIONAPBTNCLICKTYPE_Talk:
            [self ApchatBtnRequest];
            break;
            
        default:
            break;
    }

}

/**
 *  获取bug的状态
 *
 *  @param index 索引
 *
 *  @return btn的状态
 */
- (BOOL)getMiddleBtnSelectState:(int)index
{
    return  [middleView getBtnSelectState: index];
}

- (void)setApBtnUnSelect:(int)index
{
    [middleView setButtonunSelect:index];
}

- (void)setApBtnSelect:(int)index
{
    [middleView setAPConfigButtonSelect:index ];
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
