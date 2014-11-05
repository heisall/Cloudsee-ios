//
//  JVCDemoCell.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/14/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDemoCell.h"
#import "JVCDeviceModel.h"
#import "JVCRGBColorMacro.h"
#import "JVCRGBHelper.h"
@implementation JVCDemoCell
static const  int KMYVIDEOCELLHEIGHTADDHEIGH  = 10.0;//左边距
static const  int KLabelWith                  = 150;//label的宽度
static const  int KLabelHeight                = 40;//label的高度
static const  int KLabelLineHeight            = 1;//labelLIne的高度
static const  int KLabelTitleFont             = 16;//label字体
static const  int KLabelTimerHeight           = 14;//labeltimer的字体
static const  int KLabelTimerWith             = 300;
@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
- (void)initCellWithModel:(JVCDeviceModel *)model  imageName:(NSString *)imageName
{
    for ( UIView *_tVC in self.contentView.subviews) {
        [_tVC removeFromSuperview];
    }
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    UIColor *colorLine = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kDemoLineColor];

//    
//    [mdicRgbModelList setObject:demoLine forKey:kDemoLineColor];
//    [mdicRgbModelList setObject:loginTitle forKey:kDemoTitle];
//    [mdicRgbModelList setObject:loginTimer forKey:kDemoTimer];

    UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, KLabelLineHeight)];
    
    if (colorLine) {
        labelLine.backgroundColor = colorLine;

    }
    [self.contentView addSubview:labelLine];
    [labelLine release];
    
    UIColor *colorDefault = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroLoginGray];
    NSString *imagePath = [UIImage imageBundlePath:imageName];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    NSString *iamgecellpath = [UIImage imageBundlePath:@"dem_def.png"];
    UIImage *iamgecellBg = [[UIImage alloc] initWithContentsOfFile:iamgecellpath];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - iamgecellBg.size.width)/2, KMYVIDEOCELLHEIGHTADDHEIGH, KLabelWith, KLabelHeight)];
    if (colorDefault) {
        labelTitle.textColor = colorDefault;
    }
    labelTitle.font = [UIFont systemFontOfSize:KLabelTitleFont];
    labelTitle.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:labelTitle];
    labelTitle.text = model.yunShiTongNum;
    [labelTitle release];

    UILabel *labelTimer = [[UILabel alloc] initWithFrame:CGRectMake(self.width - KLabelWith, KMYVIDEOCELLHEIGHTADDHEIGH, KLabelWith, KLabelHeight)];
    if (colorDefault) {
        labelTimer.textColor = colorDefault;
    }
    labelTimer.backgroundColor = [UIColor clearColor];
    labelTimer.textAlignment = UITextAlignmentCenter;
    [self.contentView addSubview:labelTimer];
    labelTimer.font = [UIFont systemFontOfSize:KLabelTimerHeight];
    labelTimer.text = @"";
    [labelTimer release];
    
  
    
    UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - iamgecellBg.size.width)/2, KLabelHeight, iamgecellBg.size.width,iamgecellBg.size.height)];
    
    self.imageView = imageViewBg;
    imageViewBg.image = image;
    [self.contentView addSubview:imageViewBg];
    [imageViewBg release];
    [image release];
    
}

- (void)dealloc
{
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
