//
//  JVCMediaNoDateView.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/19/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCMediaNoDateView.h"
#import "UIImage+BundlePath.h"
#import "JVCRGBColorMacro.h"
#import "JVCRGBHelper.h"

@implementation JVCMediaNoDateView
static const int  kSeperateSpan = 10;
static const int  kLabelHeight  = 30;

- (id)initWithFrame:(CGRect)frame Title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        
        NSString *imageString = [UIImage imageBundlePath:@"med_noDate.png"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageString];
        UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-image.size.width)/2.0, self.height/2.0-image.size.height - kLabelHeight, image.size.width, image.size.height)];
        iamgeView.image = image;
        [self addSubview:iamgeView];
        [iamgeView release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, iamgeView.bottom+kSeperateSpan, self.width, kLabelHeight)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.text = title;
        UIColor *colorrgb = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroLoginGray];
        if (colorrgb) {
            label.textColor = colorrgb;
        }
        [self addSubview:label];
        [label release];
    }
    return self;
}

- (void)dealloc
{
    
    [super dealloc];
}
@end
