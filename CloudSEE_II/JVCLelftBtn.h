//
//  JVCLelftBtn.h
//  CloudSEE_II
//
//  Created by Yanghu on 11/28/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JVCLelftBtn : UIView
{
    UIButton *btn;
}
@property(nonatomic,retain)UIButton *btn;

- (id)initwitLeftString:(NSString *)leftString  frame:(CGRect )frame;
@end
