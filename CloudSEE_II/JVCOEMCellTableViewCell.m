//
//  JVCOEMCellTableViewCell.m
//  CloudSEE_II
//
//  Created by David on 14/12/11.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "JVCOEMCellTableViewCell.h"
#import "JVCCloudSEENetworkMacro.h"
#import "JVCAlarmHelper.h"

@implementation JVCOEMCellTableViewCell
@synthesize contentArray;
@synthesize labelContent;
@synthesize switchRound;
@synthesize delegateOEM;
@synthesize dicDevice;
@synthesize stringCellIndetidy;

static int const KOEMImageViewOriginX               = 20;//开始位置
static int const KOEmSeperateSpan                   = 10;//间距
static int const KOEmDefaultImageHeight             = 25;//图片的默认高度
static int const KOEMTitleLabeWith                  = 150;//titleLabel with
static int const KOEmTitleLabeFont                  = 16;//titleLabel font
static int const KOEMSWitchWith                     = 79;//swith with
static int const KOEMSwitchHeight                   = 27;//switch height

- (void)dealloc
{
    [stringCellIndetidy release];
    [contentArray release];
    [labelContent release];
    [switchRound  release];
    [dicDevice    release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
    }
    
    return self;
}

//初始化cell
- (void)initContentView
{
    for (UIView *viewContent in self.contentView.subviews) {
        
        [viewContent removeFromSuperview];
    }

    

    //横线
    UIImage *imgLine = [UIImage imageNamed:@"mor_line.png"];
    UIImageView *HeadlineImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width- imgLine.size.width)/2.0, imgLine.size.height, imgLine.size.width, imgLine.size.height)];
    HeadlineImageView.image = imgLine;
    [self.contentView addSubview:HeadlineImageView];
    [HeadlineImageView release];
    
//    //icon
    NSString *stringPath    = [UIImage imageBundlePath:[NSString stringWithFormat:@"%@.png",[self.contentArray objectAtIndex:self.tag]] ];
        UIImageView  *iconImageView       = [[UIImageView alloc] initWithFrame:CGRectMake(KOEMImageViewOriginX, (self.height -KOEmDefaultImageHeight)/2.0 ,0, 0)];
    if (stringPath !=nil) {
        UIImage *iconImage      = [[UIImage alloc] initWithContentsOfFile:stringPath];
        iconImageView.frame     = CGRectMake(iconImageView.left, (self.height -iconImage.size.height)/2.0 , iconImage.size.width, iconImage.size.height);
        iconImageView.image    = iconImage;
        [iconImage              release];
    }else{
        iconImageView.image = nil;
    }
    [self.contentView addSubview:iconImageView];
    [iconImageView release];
//
//    
//    //title
    UILabel *titleLabel         = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.right+KOEmSeperateSpan, 0, KOEMTitleLabeWith, self.height)];
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.text             = LOCALANGER([self.contentArray objectAtIndex:self.tag]);
    titleLabel.font             = [UIFont systemFontOfSize:KOEmTitleLabeFont];
    self.labelContent           = titleLabel;
    [self.contentView           addSubview:titleLabel];
    [titleLabel                 release];
    

    //uiswitch
    DCRoundSwitch *switchSafe          = [[DCRoundSwitch alloc] initWithFrame:CGRectMake(self.width - KOEMSWitchWith -10, (self.height - KOEMSwitchHeight)/2.0, KOEMSWitchWith, KOEMSwitchHeight)];
    switchSafe.onText                   = LOCALANGER(@"wifi_P_Model");
    switchSafe.offText                   = LOCALANGER(@"wifi_N_MODEL");


    switchSafe.hidden       = YES;
    [switchSafe addTarget:self action:@selector(changeOEMDeviceSwitchState:) forControlEvents:UIControlEventValueChanged];
    self.switchRound        = switchSafe;
    [self.contentView addSubview:switchSafe];
    [switchSafe release];
    
    int indexType = [[JVCAlarmHelper shareAlarmHelper] getOemDeviceListIndex:self.stringCellIndetidy];
    switch (indexType) {
        case JVCOEMCellType_PNMode:
        {
            switchSafe.hidden       = NO;
            
            NSString *keyValue = [self.dicDevice objectForKey:[self.contentArray objectAtIndex:self.tag]];
            if (keyValue.intValue == JVCCloudSEENetworkDevicePNModeTypeP) {
                
                [self.switchRound setOn:NO animated:NO ignoreControlEvents:YES];

            }else{
                [self.switchRound setOn:YES animated:NO ignoreControlEvents:YES];

            }

        }
            break;
        case JVCOEMCellType_FlashModel:
        {
            
            NSString *keyValue = [self.dicDevice objectForKey:[self.contentArray objectAtIndex:self.tag]];
            if (keyValue !=nil) {
                
                NSString *localString = [NSString stringWithFormat:@"JVCCloudSEENetworkDeviceFlashMode_%d",keyValue.intValue];
                titleLabel.text             = [NSString stringWithFormat:@"%@(%@)",LOCALANGER([self.contentArray objectAtIndex:self.tag]),LOCALANGER(localString)];
            }
        }
            break;
        case JVCOEMCellType_TimerZone:
        {
            NSString *keyValue = [self.dicDevice objectForKey:[self.contentArray objectAtIndex:self.tag]];
            if (keyValue !=nil) {
                
                titleLabel.text             = [NSString stringWithFormat:@"%@",LOCALANGER([self.contentArray objectAtIndex:self.tag])];
            }
        }
            break;
            
        default:
            break;
    }
    

    
    //横线
    UIImage *imgLineEnd = [UIImage imageNamed:@"mor_line.png"];
    UIImageView *endlineImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width- imgLine.size.width)/2.0, self.height-imgLine.size.height, imgLine.size.width, imgLine.size.height)];
    endlineImageView.image = imgLineEnd;
    [self.contentView addSubview:endlineImageView];
    [endlineImageView release];
    

}



- (void)changeOEMDeviceSwitchState:(DCRoundSwitch *)switchSafe
{
    if (delegateOEM !=nil && [delegateOEM respondsToSelector:@selector(JVCOEMCELLClickCallBack:idObject:)]) {
        [delegateOEM JVCOEMCELLClickCallBack:self.tag idObject:switchRound];
    }
}

- (void)awakeFromNib {
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
