//
//  JVCBaseSliderViewController.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseSliderViewController.h"
#import "JVCRGBHelper.h"
static const int  NavicationSlideViewControllersCount = 1;//navicationbar的viewcontroller的数量，1标示根试图

@interface JVCBaseSliderViewController ()

@end

@implementation JVCBaseSliderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        /**
         *  解决父类UIViewController带导航条添加ScorllView坐标系下沉64像素的问题（ios7）
         
         */
        
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeAll;
            
        }
        
    }
    return self;
}

- (void) viewDidLayoutSubviews {
    
    if (IOS_VERSION>=IOS7) {
        
        CGRect viewBounds = self.view.bounds;
        
        CGFloat topBarOffset = self.topLayoutGuide.length;
        
        viewBounds.origin.y = topBarOffset * -1;
        
        self.view.bounds = viewBounds;
    }
    
}

@end
