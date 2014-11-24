//
//  JVCHorizontalStreamView.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCHorizontalStreamView.h"

@implementation JVCHorizontalStreamView

@synthesize horStreamDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)showHorizonStreamView:(UIButton *)btn  andSelectindex:(NSInteger)index streamCountType:(BOOL)streamCountType{
    self = [super init];
    if (self) {
        
        // Initialization code  25 165; 269 96
        UIImage *tInputImage = [UIImage imageNamed:@"HorizontalScreenStreambg.png"];
        
        int heightTotal = tInputImage.size.height;
        int addTag = 0;
        NSArray *arrayTitle = [NSArray arrayWithObjects:NSLocalizedString(@"HD", nil),NSLocalizedString(@"SD", nil),NSLocalizedString(@"Fluent", nil), nil];

        if (JVCStreamCountType_Second == streamCountType) {
            heightTotal = heightTotal*2/3.0;
            arrayTitle =  [NSArray arrayWithObjects:NSLocalizedString(@"SD", nil),NSLocalizedString(@"Fluent", nil), nil];
            addTag = 1;
        }
        
        UIImage *btnSelectImage = [UIImage imageNamed:@"HorizontalScreenStreambgSelect.png"];
        
        [btn.superview.superview addSubview:self];
        
        self.frame = CGRectMake(btn.origin.x , btn.superview.superview.frame.size.height -heightTotal-49, tInputImage.size.width, 0);
        DDLogVerbose(@"=%@====%@",self,btn);
        UIImageView *imageBG = [[UIImageView alloc] initWithImage:tInputImage];
        imageBG.frame = CGRectMake(0,0, tInputImage.size.width,heightTotal);
        [self addSubview:imageBG];
        [imageBG release];
        
        CGFloat height = (tInputImage.size.height - 10)/3;
        
        
        if (index>=[arrayTitle count]) {
            
            if (JVCStreamCountType_Second != streamCountType) {
                index=[arrayTitle count];
            }
        }
        for (int i = 0; i<[arrayTitle count]; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:[arrayTitle objectAtIndex:i ] forState:UIControlStateNormal];
            btn.frame = CGRectMake((imageBG.frame.size.width - btnSelectImage.size.width)/2.0, i*height+1, btnSelectImage.size.width, btnSelectImage.size.height);
            if (i+1+addTag == index) {
                [btn setBackgroundImage:btnSelectImage forState:UIControlStateNormal];
            }
            
            [btn addTarget:self action:@selector(selectStream:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [btn setBackgroundImage:btnSelectImage forState:UIControlStateHighlighted];
            btn.tag = i+1+addTag;
            
            [self addSubview:btn];
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        self.frame = CGRectMake(self.origin.x, btn.superview.superview.frame.size.height -heightTotal-49, tInputImage.size.width, heightTotal);
        [UIView commitAnimations];
        
    }
    return self;
}

- (void)selectStream:(UIButton *)btn
{
    if (horStreamDelegate !=nil &&[horStreamDelegate respondsToSelector:@selector(horizontalStreamViewCallBack:)]) {
        [horStreamDelegate horizontalStreamViewCallBack:btn];
    }
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
