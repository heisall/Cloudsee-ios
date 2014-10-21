//
//  JVDeviceCAlarmAddTableViewCell.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/21/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVDeviceCAlarmAddTableViewCell.h"
#import "JVCControlHelper.h"
@implementation JVDeviceCAlarmAddTableViewCell
static const int KCellOrignX    = 20;//距离左侧的距离
static const int KCellSpan      = 10;//间距
static const int KCellLabelFont = 16;//字体大小
static const int KCellSwitchOrigin = 200;//
static const int KCellLabelHeight  = 20;//高度
static const int KCellLabelOriginY = 10;//距离顶端的距离

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initAlarmAddTableViewContentView:(JVCLockAlarmModel *)model
{
    for (UIView *contentView in self.contentView.subviews) {
        
        [contentView removeFromSuperview];
    }
    
    JVCControlHelper *controlHelper = [JVCControlHelper shareJVCControlHelper];
    UIImageView *imageViewBG = [controlHelper imageViewWithIamge:@"arm_loc_cellbg.png"];
    imageViewBG.frame = CGRectMake((self.width-imageViewBG.width)/2.0, 0, imageViewBG.width, imageViewBG.height);
    [self.contentView addSubview:imageViewBG];
    
    NSString *imageStr = nil;
    
    if (model.alarmType == JVCAlarmLockType_Door) {
        imageStr = @"arm_device_0.png";
    }else{
        imageStr = @"arm_device_1.png";
    }
    UIImageView *imageViewDevice = [controlHelper imageViewWithIamge:imageStr];
    imageViewDevice.frame = CGRectMake(KCellOrignX, (imageViewBG.height - imageViewDevice.height)/2.0, imageViewDevice.width, imageViewDevice.height);
    [self.contentView addSubview:imageViewDevice];
    
    //uilabel
    UILabel *labelDevice = [controlHelper labelWithText:@"设备名称" textFontSize:KCellLabelFont];
    labelDevice.frame = CGRectMake(imageViewDevice.right+KCellSpan, KCellLabelOriginY, labelDevice.width, KCellLabelHeight);
    [self.contentView addSubview:labelDevice];

    //开关
    UISwitch *switchDevcie = [[UISwitch alloc] initWithFrame:CGRectMake(KCellSwitchOrigin, labelDevice.top, 0, 0)];
    switchDevcie.on = model.alarmState;
    [self.contentView addSubview:switchDevcie];
    //设备名
    UILabel *labelNickDevice = [controlHelper labelWithText:(model.alarmName.length>0?model.alarmName:@"NOName") textFontSize:KCellLabelFont];
    labelNickDevice.numberOfLines = 1;
    labelNickDevice.frame = CGRectMake(imageViewDevice.right+KCellSpan, labelDevice.bottom+KCellSpan, labelDevice.width, KCellLabelHeight);
    [self.contentView addSubview:labelNickDevice];
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
