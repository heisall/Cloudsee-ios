//
//  JVCDeviceListNoDevieCell.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDeviceListNoDevieCell.h"
#import "JVCRGBColorMacro.h"
#import "JVCRGBHelper.h"

static const int kLabelHeigt = 30;//lab的高度
static const int kLabelOriginX = 40;//距离左侧的距离
static const int kLabelOriginY = 10;//距离上侧的距离
static const int kSpan         = 20;//间距

@implementation JVCDeviceListNoDevieCell
@synthesize addDelegate;
static const int kTag         = 100;//tag

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        DDLogVerbose(@"==%@==",NSStringFromCGRect(self.frame));
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

/**
 *  初始化cell
 */
- (void)initContentCellWithHeigint:(CGFloat)frameHeight
{
    NSString *devWlanPath = [UIImage imageBundlePath:@"no_devWlan.png"];
    UIImage *imageWlan = [[UIImage alloc] initWithContentsOfFile:devWlanPath];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake((self.width -imageWlan.size.width)/2.0, kLabelOriginY, imageWlan.size.width, kLabelHeigt)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.text = @"无线设备";
    [self.contentView addSubview:labelTitle];
    [labelTitle release];
    
    //无线设备图片
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(labelTitle.left, labelTitle.bottom+kSpan, labelTitle.width, imageWlan.size.height)];
    imageview.image = imageWlan;
    [self.contentView addSubview:imageview];
    [imageview release];
    
    JVCRGBHelper *rgbLabelHelper      = [JVCRGBHelper shareJVCRGBHelper];
    UIColor *btnColorBlue  = [rgbLabelHelper rgbColorForKey:kJVCRGBColorMacroLoginBlue];
    
    NSString *devWlanBtnPath = [UIImage imageBundlePath:@"no_devBtn.png"];
    UIImage *imageBtnWlan = [[UIImage alloc] initWithContentsOfFile:devWlanBtnPath];
    
    //按钮
    UIButton *btnWlan = [UIButton buttonWithType:UIButtonTypeCustom];
    btnWlan.frame = CGRectMake(imageview.left, imageview.bottom+kSpan, imageBtnWlan.size.width, imageBtnWlan.size.height);
    [btnWlan setTitle:@"无线设备" forState:UIControlStateNormal];
    btnWlan.tag = kTag;
    [btnWlan addTarget:self action:@selector(addDeviceClickWithType:) forControlEvents:UIControlEventTouchUpInside];
    if (btnColorBlue) {
        [btnWlan setTitleColor:btnColorBlue forState:UIControlStateNormal];
    }
    [btnWlan setBackgroundImage:imageBtnWlan forState:UIControlStateNormal];
    [self.contentView addSubview:btnWlan];
    
    //有限设备
    UILabel *labelWire = [[UILabel alloc] initWithFrame:CGRectMake((self.width -imageWlan.size.width)/2.0, btnWlan.bottom+kSpan, imageWlan.size.width, kLabelHeigt)];
    labelWire.backgroundColor = [UIColor clearColor];
    labelWire.text = @"有线设备";
    [self.contentView addSubview:labelWire];
    [labelWire release];

    //有限设备图片
    NSString *devWlanwirePath = [UIImage imageBundlePath:@"no_devWire.png"];
    UIImage *imageWireWlan = [[UIImage alloc] initWithContentsOfFile:devWlanwirePath];
    UIImageView *imageviewWire = [[UIImageView alloc] initWithFrame:CGRectMake(labelWire.left, labelWire.bottom+kSpan, labelTitle.width, imageWireWlan.size.height)];
    imageviewWire.image = imageWireWlan;
    [self.contentView addSubview:imageviewWire];
    [imageviewWire release];
    
    //按钮
    UIButton *btnWireWlan = [UIButton buttonWithType:UIButtonTypeCustom];
    btnWireWlan.frame = CGRectMake(imageviewWire.left, imageviewWire.bottom+kSpan, imageBtnWlan.size.width, imageBtnWlan.size.height);
    [btnWireWlan setTitle:@"有线设备" forState:UIControlStateNormal];
    if (btnColorBlue) {
        [btnWireWlan setTitleColor:btnColorBlue forState:UIControlStateNormal];
    }
    btnWireWlan.tag = 1+kTag;
    [btnWireWlan addTarget:self action:@selector(addDeviceClickWithType:) forControlEvents:UIControlEventTouchUpInside];
    [btnWireWlan setBackgroundImage:imageBtnWlan forState:UIControlStateNormal];
    [self.contentView addSubview:btnWireWlan];
    
    [imageBtnWlan release];
    [imageWlan release];
    [imageWireWlan release];
}

- (void)addDeviceClickWithType:(UIButton *)btn
{
    if (addDelegate !=nil && [addDelegate respondsToSelector:@selector(addDeviceTypeCallback:)]) {
        
        [addDelegate addDeviceTypeCallback:btn.tag-kTag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
