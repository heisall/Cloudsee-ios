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

static const int kNodeviceLabelHeigt = 40;//lab的高度

@implementation JVCDeviceListNoDevieCell

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
    //暂无图片
    NSString *imageName = [UIImage imageBundlePath:@"dev_nodevBg.png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageName];
    UIImageView *imageViewNoDevice = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - image.size.width)/2.0, (frameHeight - image.size.height-kNodeviceLabelHeigt)/2.0, image.size.width, image.size.height)];
    imageViewNoDevice.image  = image;
    [self.contentView addSubview:imageViewNoDevice];
    [imageViewNoDevice release];
    [image release];
    //提示
    UILabel *labelNodevie = [[UILabel alloc] initWithFrame:CGRectMake(0, imageViewNoDevice.bottom, self.width, kNodeviceLabelHeigt)];
    labelNodevie.backgroundColor = [UIColor clearColor];
    labelNodevie.numberOfLines = 0;
    labelNodevie.textAlignment = UITextAlignmentCenter;
    labelNodevie.lineBreakMode = UILineBreakModeWordWrap;
    UIColor *labColor = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroDeviceListLabelGray];
    if (labColor) {
        labelNodevie.textColor = labColor;
    }
    labelNodevie.text = @"点我添加设备";
    [self.contentView addSubview:labelNodevie];
    [labelNodevie release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
