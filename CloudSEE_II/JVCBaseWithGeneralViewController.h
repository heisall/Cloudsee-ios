//
//  JVCBaseWithGeneralViewController.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-9-29.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JVCBaseWithGeneralViewController : UIViewController

/**
 *  点击返回事件，如果有其他的处理方法，子类可以重写父类的方法
 */
- (void)BackClick;

@end
