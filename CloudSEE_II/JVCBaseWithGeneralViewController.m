//
//  JVCBaseWithGeneralViewController.m
//  CloudSEE_II
//  通用的ViewController基类 用来处理系统兼容性
//  Created by chenzhenyang on 14-9-29.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"

@interface JVCBaseWithGeneralViewController ()

@end

@implementation JVCBaseWithGeneralViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        /**
         *  解决父类UIViewController带导航条添加ScorllView坐标系下沉64像素的问题（ios7）
         
         */
        
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //处理UIViewController的可视区域的高度
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        
        CGRect contentRect = self.view.frame;
        
        //减去导航条的高度
        if (!self.navigationController.navigationBarHidden) {
            
            contentRect.size.height = contentRect.size.height - self.navigationController.navigationBar.frame.size.height;
            
        }
        
        //减去状态栏的高度
        if (![UIApplication sharedApplication].statusBarHidden) {
            
            contentRect.size.height = contentRect.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        
        self.view.frame = contentRect;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
