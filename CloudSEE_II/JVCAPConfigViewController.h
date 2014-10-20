//
//  JVCAPConfigViewController.h
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-10-20.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"

@protocol JVCAPConfigViewControllerDelegate <NSObject>

/**
 *  扫描界面的按钮回调
 *
 *  @param buttonClickType
 *
 enum buttonClickType {
 
 buttonClickType_Next   = 0, //下一步
 buttonClickType_Skip   = 1, //跳过
 };
 *
 */
-(void)buttonClick:(int)buttonClickType;

@end

@interface JVCAPConfigViewController : JVCBaseWithGeneralViewController {
    
    id<JVCAPConfigViewControllerDelegate> delegate;
    
}
enum buttonClickType {
    
    buttonClickType_Next   = 0, //下一步
    buttonClickType_Skip   = 1, //跳过
};

@property (nonatomic,assign) id<JVCAPConfigViewControllerDelegate> delegate;


@end
