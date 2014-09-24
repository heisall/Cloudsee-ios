//
//  JVCDeviceListDeviceCell.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/24/14.
//  设备列表界面，设备的单个cell
//  方块
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDeviceListDeviceCell.h"
#import "JVCRGBHelper.h"
#import "JVCDeviceListDeviceVIew.h"
#import "JVCRGBModel.h"
#import "JVCRGBColorMacro.h"


@implementation JVCDeviceListDeviceCell
@synthesize _arrayCellClolors;
@synthesize deviceCellDelegate;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  初始化设备列表界面
 */
- (void)initCellContent:(NSMutableArray *)arrayColor
{
    for (UIView *contentViewInCell in self.contentView.subviews) {
        
        [contentViewInCell removeFromSuperview];
    }
    
    [arrayColor retain];
    
    JVCRGBHelper *rgbHelper  = [[JVCRGBHelper alloc] init];

    UIImage *deviceImage     = [UIImage imageNamed:@"dev_device_bg.png"];
    UIImage *iconDeviceImage = [UIImage imageNamed:@"dev_device_default_icon.png"];
    
    for (int i=0; i<arrayColor.count; i++) {
        
        NSString *strClolor = [arrayColor objectAtIndex:i];
        
        if ([rgbHelper objectForKeyName:strClolor]) {
            
            JVCRGBModel *rgbModel = (JVCRGBModel *)[rgbHelper objectForKeyName:strClolor];
            
            CGFloat seperate = (self.width - 2*deviceImage.size.width)/3.0;
            JVCDeviceListDeviceVIew *deviceBg = [[JVCDeviceListDeviceVIew alloc] initWithFrame:CGRectMake(seperate+i*(deviceImage.size.width+seperate), 120 - deviceImage.size.height-20.0, deviceImage.size.width, deviceImage.size.height) backgroundColor:RGBConvertColor(rgbModel.r, rgbModel.g, rgbModel.b,1.0f) cornerRadius:6.0f];
            deviceBg.tag = self.tag+i;
            
            DDLogInfo(@"cellTag = %d==self.tag=%d",deviceBg.tag,self.tag);
            
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDeviceToPlay:)];
            [self addGestureRecognizer:gesture];
            [gesture release];
            
            if ([rgbHelper objectForKeyName:kJVCRGBColorMacroWhite]) {
                
                JVCRGBModel *rgbWhiteModel = (JVCRGBModel *)[rgbHelper objectForKeyName:kJVCRGBColorMacroEditDeviceButtonFont];
                
                [deviceBg initWithLayoutView:iconDeviceImage borderColor:RGBConvertColor(rgbWhiteModel.r, rgbWhiteModel.g, rgbWhiteModel.b, 0.3f) titleFontColor:RGBConvertColor(rgbWhiteModel.r, rgbWhiteModel.g, rgbWhiteModel.b, 1.0f)];
                [deviceBg setAtObjectTitles:@"A366" onlineStatus:@"在线" wifiStatus:@"WI-FI"];
            }
            
            [self.contentView addSubview:deviceBg];
        }

    }
    
    
    [rgbHelper release];
    
    [arrayColor release];
 
}

/**
 *  选中相应的设备
 */
- (void)selectDeviceToPlay:(UITapGestureRecognizer *)gesture
{
    if (deviceCellDelegate !=nil &&[deviceCellDelegate respondsToSelector:@selector(selectDeviceToPlayWithIndex:)]) {
        
        DDLogInfo(@"==%s==gesture.view.tag=%d",__FUNCTION__,gesture.view.tag);
        [deviceCellDelegate selectDeviceToPlayWithIndex:gesture.view.tag];
    }
}

@end
