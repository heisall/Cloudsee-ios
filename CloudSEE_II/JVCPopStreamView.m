//
//  JVCPopStreamView.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/15/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCPopStreamView.h"

@interface JVCPopStreamView ()
{
    UIButton *btnBG;
    
    int streamHeight;
}

@end

@implementation JVCPopStreamView
@synthesize delegateStream;
static const NSTimeInterval kAnimationTimer = 0.3;//动画时间
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initStreamView:(UIButton *)btn  andSelectindex:(NSInteger)index  streamCountType:(BOOL)streamCountType{
    self = [super init];
    
    if (self) {
        
        self.clipsToBounds = YES;
        // Initialization code  25 165; 269 96
        
        UIImage *tInputImage = [UIImage imageNamed:@"str_bg.png"];

        UIImage *btnSelectImage = [UIImage imageNamed:@"str_btnSec.png"];
        
        streamHeight = tInputImage.size.height;
        int addTag = 0;
        NSArray *arrayTitle = [NSArray arrayWithObjects:NSLocalizedString(@"HD", nil),NSLocalizedString(@"SD", nil),NSLocalizedString(@"Fluent", nil), nil];
        
        if (JVCStreamCountType_Second == streamCountType) {
            streamHeight = streamHeight*2/3.0;
            arrayTitle =  [NSArray arrayWithObjects:NSLocalizedString(@"SD", nil),NSLocalizedString(@"Fluent", nil), nil];
            addTag = 1;
        }

        
        [btn.superview.superview addSubview:self];
        
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - tInputImage.size.width-5,[UIScreen mainScreen].bounds.size.height - 49  , tInputImage.size.width, 0);
        
        UIImageView *imageBG = [[UIImageView alloc] initWithImage:tInputImage];
        imageBG.frame = CGRectMake(0,0, tInputImage.size.width, streamHeight);
        [self addSubview:imageBG];
        [imageBG release];
        
        CGFloat height = (tInputImage.size.height - 10)/3;
        
        if (index>[arrayTitle count] ) {
            if (JVCStreamCountType_Second != streamCountType) {
                index=[arrayTitle count]-1;
            }
        }
        for (int i = 0; i<[arrayTitle count]; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:[arrayTitle objectAtIndex:i ] forState:UIControlStateNormal];
            btn.frame = CGRectMake((imageBG.frame.size.width - btnSelectImage.size.width)/2.0, i*height+5, btnSelectImage.size.width, btnSelectImage.size.height);
            if (i +1 +addTag== index) {
                [btn setBackgroundImage:btnSelectImage forState:UIControlStateNormal];
            }
            
            [btn addTarget:self action:@selector(selectStreamType:) forControlEvents:UIControlEventTouchUpInside];
            
            [btn setBackgroundImage:btnSelectImage forState:UIControlStateHighlighted];
            btn.tag = i+1+addTag;
            
            [self addSubview:btn];
        }
        
    }
    return self;
}

- (void)show
{
    btnBG = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBG.frame = [UIScreen mainScreen].bounds;
    [btnBG addTarget:self action:@selector(dismissStream) forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:btnBG];
    
    [btnBG addSubview:self];

//    UIImage *tInputImage = [UIImage imageNamed:@"str_bg.png"];
    [UIView animateWithDuration:kAnimationTimer animations:^{
    
        CGRect FrameEnd = self.frame;
        FrameEnd.origin.y =FrameEnd.origin.y - streamHeight;
        FrameEnd.size.height = streamHeight;
        self.frame = FrameEnd;
    }];
 

}

/**
 *  选中画质按钮
 *
 *  @param btn btn
 */
- (void)selectStreamType:(UIButton *)btn
{
    if (delegateStream !=nil && [delegateStream respondsToSelector:@selector(changeStreamViewCallBack:)]) {
        
        [delegateStream changeStreamViewCallBack:(int)btn.tag];
    }
    
    [self dismissStream];
}

/**
 *  让码流设置界面消失
 */
- (void)dismissStream
{
    [UIView animateWithDuration:kAnimationTimer animations:^{
        
        CGRect frame = self.frame;
        frame.size.height = 0;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        [btnBG removeFromSuperview];

    }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
