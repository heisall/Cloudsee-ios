//
//  JVCAlarmCell.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAlarmCell.h"
#import "JVCAlarmModel.h"
#import "JVCControlHelper.h"
#import "JVCRGBHelper.h"
#import "JVCRGBColorMacro.h"
@implementation JVCAlarmCell
static const int KLabelOriginX   = 10;//距离左边界的距离
static const int KLabelSpan      = 0;//labe之间的距离
static const int KLabelSize      = 14;//labe字体大小
static const int KLabelSizeTitle      = 20;//标题的字体大小

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initAlermCell:(JVCAlarmModel *)model
{
    for (UIView *viewSub in self.contentView.subviews) {
        [viewSub removeFromSuperview];
    }
    /**
     *  背景
     */
    NSString *imageCellBgPath = nil;
    if (model.bNewAlarm) {
        imageCellBgPath = [UIImage imageBundlePath:@"arm_new_cellbg.png"];
    }else{
        imageCellBgPath = [UIImage imageBundlePath:@"arm_cellbg.png"];
    }
    UIImage *imageCellBg = [[UIImage alloc] initWithContentsOfFile:imageCellBgPath];
    UIImageView *ImageViewCellBg = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-imageCellBg.size.width)/2.0 , 0, imageCellBg.size.width, imageCellBg.size.height)];
    ImageViewCellBg.image = imageCellBg;
    [self.contentView addSubview:ImageViewCellBg];
    [ImageViewCellBg release];
    [imageCellBg release];
    
    NSString *imageArmPathDef = [UIImage imageBundlePath:@"arm_def.png"] ;
    UIImage *imageAlarmDef = [[UIImage alloc] initWithContentsOfFile:imageArmPathDef];
    UIImageView *imgViewAlerm = [[UIImageView alloc] initWithFrame:CGRectMake(ImageViewCellBg.left+ KLabelOriginX, (ImageViewCellBg.frame.size.height-imageAlarmDef.size.height)/2.0, imageAlarmDef.size.width, imageAlarmDef.size.height)];
    imgViewAlerm.image = imageAlarmDef;
    imgViewAlerm.tag=10;
    [self.contentView addSubview:imgViewAlerm];
    [imgViewAlerm release];
    [imageAlarmDef release];
    /**
     *  new
     */
    if (model.bNewAlarm) {
        NSString *newString = LOCALANGER(@"JVCArm_New");
        UIImage *imgNew = [UIImage imageNamed:newString];
        UIImageView *imageViewNew = [[UIImageView alloc] initWithFrame:CGRectMake(ImageViewCellBg.left,ImageViewCellBg.top, imgNew.size.width, imgNew.size.height)];
        imageViewNew.tag = 10005;
        imageViewNew.image = imgNew;
        [self.contentView addSubview:imageViewNew];
        [imageViewNew release];
    }
    
    
    /**
     *  警告的图片 ！
     */
    UIImage *imageCellAlarm = [UIImage imageNamed:@"arm_exc.png"];
    UIImageView *ImageViewCellalarm = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageCellAlarm.size.width, imageCellAlarm.size.height)];
    ImageViewCellalarm.center = imgViewAlerm.center;
    ImageViewCellalarm.image = imageCellAlarm;
    [self.contentView addSubview:ImageViewCellalarm];
    [ImageViewCellalarm release];
    
    
    UIColor *color = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroAlertCellColor];
    /**
     *  文字时间
     */
    NSString *stringlangue = [NSString stringWithFormat:@"home_alarm_%d",model.iAlarmType];
    UILabel *label = [[JVCControlHelper shareJVCControlHelper] labelWithText:[NSString stringWithFormat:@"%@%@",model.strALarmDeviceNickName,LOCALANGER(stringlangue)] textFontSize:KLabelSizeTitle];
    [label retain];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.font = [UIFont systemFontOfSize:KLabelSize];
    if (color) {
        label.textColor = color;
    }
    label.frame = CGRectMake(imgViewAlerm.frame.size.width+imgViewAlerm.frame.origin.x+10, imgViewAlerm.frame.origin.y, label.width, label.height);
    [self.contentView addSubview:label];
    [label release];
    
    /**
     *  昵称
     */
    UILabel *labelNickName = [[JVCControlHelper shareJVCControlHelper] labelWithText:model.strALarmDeviceNickName];
    [labelNickName retain];
    if (color) {
        labelNickName.textColor = color;
    }
    labelNickName.text =@"";
    labelNickName.font = [UIFont systemFontOfSize:KLabelSize];
    labelNickName.frame = CGRectMake(label.left, label.bottom+KLabelSpan, labelNickName.width, 0);
    [self.contentView addSubview:labelNickName];
    [labelNickName release];
    
    /**
     *  报警级别
     */
    UILabel *labelALarmType = [[UILabel alloc] initWithFrame:CGRectMake(labelNickName.left, labelNickName.bottom+KLabelSpan, 80, 20)];
    labelALarmType.backgroundColor = [UIColor clearColor];
    labelALarmType.font = [UIFont systemFontOfSize:13];
    if (color) {
        labelALarmType.textColor = color;
    }
    labelALarmType.text = LOCALANGER(@"jvc_alarmlist_alarmLeavel");
    [self.contentView addSubview:labelALarmType];
    [labelALarmType release];
    
    /**
     *  图片显示报警的级别
     */
    UIImage *imgNormal = [UIImage imageNamed:@"arm_nor.png"];
    UIImage *imgHover = [UIImage imageNamed:@"arm_hor.png"];
    
    CGFloat fWith = imgNormal.size.width;
    CGFloat fHeight = imgNormal.size.height;
    int add_y=0;
    if ([[JVCSystemUtility shareSystemUtilityInstance] judgeAPPSystemLanguage]) {
        add_y = 15;
    }
    CGFloat foff_x =  labelALarmType.frame.size.width+labelALarmType.frame.origin.x-add_y;
    
    for(int i=0;i<6;i++)
    {
        UIImageView *imageAlarm = [[UIImageView alloc] initWithFrame:CGRectMake(foff_x+i*(fWith+3), labelALarmType.frame.origin.y+(labelALarmType.frame.size.height-fHeight)/2.0+1, fWith, fHeight)];
        if (i<=model.iAlarmType/2) {
            imageAlarm.image = imgHover;
        }else{
            imageAlarm.image = imgNormal;
        }
        
        [self.contentView addSubview:imageAlarm];
        [imageAlarm release];
    }
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
