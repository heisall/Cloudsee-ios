//
//  JVCHelpVIew.h
//  CloudSEE_II
//
//  Created by Yanghu on 10/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JVCWelcomeDelegate <NSObject>

- (void)JVCWelcomeCallBack;

@end
@interface JVCHelpVIew : UIView<UIScrollViewDelegate>
{
    id<JVCWelcomeDelegate>delegateWelcome;
}
@property(nonatomic,assign) id<JVCWelcomeDelegate>delegateWelcome;
@end

