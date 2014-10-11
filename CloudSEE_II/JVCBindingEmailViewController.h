//
//  JVCBindingEmailViewController.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/11/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCBaseWithGeneralViewController.h"

@protocol FinishAndSkipBindingEmailDelegate <NSObject>

/**
 *  绑定邮箱的回调、完成或者跳过的回调
 */
- (void)FinishAndSkipBindingEmailCallback;

@end

@interface JVCBindingEmailViewController : JVCBaseWithGeneralViewController<UITextFieldDelegate>
{
    id<FinishAndSkipBindingEmailDelegate>delegateEmail;
    
}

@property(nonatomic,assign)id<FinishAndSkipBindingEmailDelegate>delegateEmail;




@end
