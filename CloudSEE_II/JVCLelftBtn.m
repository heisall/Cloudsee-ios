//
//  JVCLelftBtn.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/28/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCLelftBtn.h"
#import "JVCRGBColorMacro.h"
#import "JVCRGBHelper.h"

@implementation JVCLelftBtn
static const  int KOriginX              = 20;//距离左侧的距离
static const  int KLeftLabeWith         = 80;//宽度
static const  int KBtnWith              = 180;//宽度

@synthesize btn;

- (id)initwitLeftString:(NSString *)leftString  frame:(CGRect )frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initContent:leftString];
        
    }
    return self;
}

- (void)initContent:(NSString *)string
{
    //横线
    UIImage *imgLineEnd = [UIImage imageNamed:@"mor_line.png"];
    UIImageView *startlineImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width- imgLineEnd.size.width)/2.0, 0, imgLineEnd.size.width, imgLineEnd.size.height)];
    startlineImageView.image = imgLineEnd;
    [self addSubview:startlineImageView];
    [startlineImageView release];
    
    UIButton *btnLeft   = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame       = CGRectMake(KLeftLabeWith+KOriginX, 0 , KBtnWith, self.height);
    self.btn            = btnLeft;
    UIColor *color  = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroLoginGray];
//    self.btn.titleLabel.textAlignment = UITextAlignmentRight;
    if (color) {
        [self.btn setTitleColor:color forState:UIControlStateNormal];
    }
    [self addSubview:self.btn ];
    
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(KOriginX, 0, KLeftLabeWith, self.size.height)];
    label.backgroundColor = [UIColor clearColor];
    if (color) {
        label.textColor = color;
    }
    label.text      = string;
    [self addSubview:label];
    [label release];

    //横线
    UIImageView *endlineImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width- imgLineEnd.size.width)/2.0, self.height-imgLineEnd.size.height, imgLineEnd.size.width, imgLineEnd.size.height)];
    endlineImageView.image = imgLineEnd;
    [self addSubview:endlineImageView];
    [endlineImageView release];
}
- (void)dealloc
{
    [btn release];
    [super dealloc];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
