//
//  JVCLogShowViewController.h
//  CloudSEE_II
//  用于显示日志文件文本的Viewcontroller
//  Created by chenzhenyang on 14-11-18.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"

@interface JVCLogShowViewController : JVCBaseWithGeneralViewController {

    NSString *strLogPath;
}

@property (nonatomic,retain) NSString *strLogPath;

@end
