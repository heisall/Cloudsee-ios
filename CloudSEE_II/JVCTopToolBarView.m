//
//  JVCTopToolBarView.m
//  JVCEditDevice
//
//  Created by chenzhenyang on 14-9-25.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCTopToolBarView.h"
#import "JVCRGBHelper.h"

#import "JVCLableScoollView.h"

@implementation JVCTopToolBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    
    return self;
}

/**
 *  初始化设备管理的顶部工具栏
 */
-(void)initWithLayout {
    
    
    UIImage *topBarLineImage = [UIImage imageNamed:@"edit_topBar_line.png"];
    UIImage *topBarDropImage   = [UIImage imageNamed:@"edi_topBar_dropBtn.png"];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, topBarDropImage.size.height);
    
    JVCRGBHelper *rgbHelper = [JVCRGBHelper shareJVCRGBHelper];
    
    if ([rgbHelper rgbColorForKey:kJVCRGBColorMacroEditTopToolBarBackgroundColor]) {
        
        self.backgroundColor = [rgbHelper rgbColorForKey:kJVCRGBColorMacroEditTopToolBarBackgroundColor];
    }
    
    NSArray *titles = [NSArray arrayWithObjects:@"A361",@"A35555555562",@"A3633456",@"A361",@"A35555555562",@"A366666663",@"A36444444441",@"A35555555562",@"A36333333",@"A361",@"A35555555562",@"A3633456",@"A361",@"A35555555562",@"A366666663",@"A36444444441",@"A35555555562",@"A36333333", nil];
    
    CGRect toolViewRect = CGRectMake(0.0, 0.0,self.frame.size.width - topBarDropImage.size.width - topBarLineImage.size.width, self.frame.size.height);
    
    JVCLableScoollView *lableScoollView = [[JVCLableScoollView alloc] initWithFrame:toolViewRect];
    [lableScoollView initWithLayout:titles];
    [self addSubview:lableScoollView];
    [lableScoollView release];
    
    UIImageView *lineView = [[UIImageView alloc] init];
    lineView.frame        = CGRectMake(lableScoollView.frame.origin.x + lableScoollView.frame.size.width,lableScoollView.frame.origin.y , topBarLineImage.size.width, topBarLineImage.size.height);
    lineView.backgroundColor = [UIColor clearColor];
    lineView.image        = topBarLineImage;
    [self addSubview:lineView];
    [lineView release];
}


@end
