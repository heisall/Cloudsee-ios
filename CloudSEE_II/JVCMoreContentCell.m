//
//  JVCMoreContentCell.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/26/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCMoreContentCell.h"
#import "JVCRGBHelper.h"
#import "DCRoundSwitch.h"
#import "JVCConfigModel.h"

static const int  moreContentCellOff_X  = 20;//距离组边框的距离

static const int  moreContentCellSeperate  = 20;//距离图片的距离


static const int  moreContentCellLabelWith  = 300;//label的宽

static const int  moreContentCellTextFont  = 16;//字体大小

static const int  moreContentRight= 40;//new 的位置距离右边的位置

static const int  KSwitchSubWitch= 79;//减去switch的宽度

static const int  KSwitchSubWitchRadio= 15;//覆盖的view的消角


static const int  KdCRoudSwitchSwitchSubWitch   = 100;//减去switch的宽度
static const int  KdCRoudSwitchSwitchSubHeight  = 29;//减去switch的宽度





@implementation JVCMoreContentCell
@synthesize delegateSwitch;
@synthesize switchCell;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 *  根据model初始化
 *
 *  @param model mode类型数据
 */
- (void)initContentCells:(JVCMoreSettingModel *)model
{
    for (UIView *contentView in self.contentView.subviews) {
        [contentView removeFromSuperview];
    }
    
    self.clipsToBounds = YES;
    //横线
    UIImage *imgLine = [UIImage imageNamed:@"mor_line.png"];
    UIImageView *HeadlineImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width- imgLine.size.width)/2.0, imgLine.size.height, imgLine.size.width, imgLine.size.height)];
    HeadlineImageView.image = imgLine;
    [self.contentView addSubview:HeadlineImageView];
    [HeadlineImageView release];
    //图标
    UIImage *imgIcon = [UIImage imageNamed:model.iconImageName];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(moreContentCellOff_X, (self.height - imgIcon.size.height)/2.0, imgIcon.size.width, imgIcon.size.height)];
    iconImageView.image = imgIcon;
    [self.contentView addSubview:iconImageView];
    [iconImageView release];
    
    //标签
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.right+moreContentCellSeperate, iconImageView.top, moreContentCellLabelWith, iconImageView.height)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.font = [UIFont systemFontOfSize:moreContentCellTextFont];
    labelTitle.text = model.itemName;
    UIColor *color = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:KLickTypeLeftLabelColor];
    if (color) {
        labelTitle.textColor = color;
    }
    [self.contentView addSubview:labelTitle];
    [labelTitle release];
    
    NSString *imageNewPath = [UIImage imageBundlePath:@"mor_cellnew.png"];
    UIImage *imgIconNew = [[UIImage alloc] initWithContentsOfFile:imageNewPath];
    if (model.bNewState) {//有新便签
        
        UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width -moreContentRight-imgIconNew.size.width , (self.height - imgIconNew.size.height)/2.0, imgIconNew.size.width, imgIconNew.size.height)];
        newImageView.image = imgIconNew;
        [self.contentView addSubview:newImageView];
        [newImageView release];

    }

    DCRoundSwitch *dCRoudSwitch = nil;
    
    if (model.bBtnState == MoreSettingCellType_CustomSwitc) {
        
         dCRoudSwitch = [[DCRoundSwitch alloc] initWithFrame:CGRectMake(self.width -KdCRoudSwitchSwitchSubWitch-20, labelTitle.top,KdCRoudSwitchSwitchSubWitch , KdCRoudSwitchSwitchSubHeight)];
        dCRoudSwitch.offText= NSLocalizedString(@"jvc_more_singel_device", nil);
        dCRoudSwitch.onText = NSLocalizedString(@"jvc_more_muti_device", nil);
        // [dCRoudSwitch setOn: delegate.isScreenMutable];
        
        [dCRoudSwitch setOn:[JVCConfigModel shareInstance].iDeviceBrowseModel animated:NO ignoreControlEvents:YES];
        [dCRoudSwitch addTarget:self action:@selector(deviceBrowseSwitchalue:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:dCRoudSwitch];
        dCRoudSwitch.hidden = YES;
        [dCRoudSwitch release];

    }else{
        
        UISwitch *switchTempCell = [[UISwitch alloc] initWithFrame:CGRectMake(self.width -moreContentRight-imgIconNew.size.width, labelTitle.top, 0, 0 )];
        self.switchCell = switchTempCell;
        [switchCell addTarget:self action:@selector(changeSwitchState:) forControlEvents:UIControlEventValueChanged];
        if ([JVCConfigModel shareInstance]._bISLocalLoginIn == TYPELOGINTYPE_LOCAL) {
            switchTempCell.enabled =YES;
            
            UIView *viewCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, switchTempCell.width, switchTempCell.height)];
            viewCover.backgroundColor = [UIColor grayColor];
            viewCover.alpha = 0.5;
            [switchTempCell addSubview:viewCover];
            viewCover.layer.cornerRadius = KSwitchSubWitchRadio;
            [viewCover release];
            
        }
        [self.contentView addSubview:switchCell];
        self.accessoryType = UITableViewCellAccessoryNone;
        switchCell.hidden = YES;

    }
 
    switch (model.bBtnState) {

        case MoreSettingCellType_Switch:
        {
            switchCell.tag = MoreSettingCellType_Switch;
            switchCell.hidden = NO;

        }
            break;
            
        case MoreSettingCellType_AccountSwith:
        {
            switchCell.tag = MoreSettingCellType_AccountSwith;
            switchCell.hidden = NO;

        }
            break;
            
        case MoreSettingCellType_index:
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        
            case MoreSettingCellType_CustomSwitc:
            dCRoudSwitch.hidden = NO;
            break;
        default:
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
    }
    [imgIconNew release];
    [switchCell release];

}

/**
 *  switch value数值发生变化之后得到的
 *
 *  @param switchOn 传入的switch
 */
- (void)changeSwitchState:(UISwitch *)switchOn
{
    if (delegateSwitch !=nil && [delegateSwitch respondsToSelector:@selector(modifySwitchState:)]) {
        
        [delegateSwitch modifySwitchState:switchOn];
    }
}

- (void)deviceBrowseSwitchalue:(DCRoundSwitch *)tempSwitch
{
    JVCConfigModel *configModel =   [JVCConfigModel shareInstance];
    configModel.iDeviceBrowseModel = tempSwitch.on;
    
    if (tempSwitch.on) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:(NSString *)deviceBrowseModelType];
        
    }else{
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:(NSString *)deviceBrowseModelType];

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

- (void)dealloc
{
    [self.switchCell  release];
    
    [super dealloc];
}

@end
