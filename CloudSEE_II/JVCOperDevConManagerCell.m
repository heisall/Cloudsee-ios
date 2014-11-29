//
//  JVCOperDevConManagerCell.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/28/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCOperDevConManagerCell.h"
#import "UIImage+BundlePath.h"
#import "JVCRGBColorMacro.h"
#import "JVCRGBHelper.h"

@interface JVCOperDevConManagerCell ()
{
    UIImageView *iconImageView;
    UILabel     *titleLabel;
    UILabel     *safeTimerLabel;
    UISwitch    *switchSafe;
    
    NSMutableArray *arrayContentList;
    NSMutableArray *arrayImageList;
}

@end

@implementation JVCOperDevConManagerCell
@synthesize deviceDelegate;

static int const KImageViewOriginX      = 20;//开始位置
static int const KSeperateSpan          = 10;//间距
static int const KTitleLabeWith         = 100;//titleLabel with
static int const KTitleLabeFont         = 18;//titleLabel font

static int const KSaftTimerLabeWith     = 150;//titleLabel with
static int const KSWitchWith            = 79;//swith with
static int const KSwitchHeight          = 27;//switch height


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initArrayList];
        
        [self initCellContent];
        
    }
    
    return self;
}

- (void)initArrayList
{
    arrayContentList    = [[NSMutableArray alloc] init];
    [arrayContentList addObject:@"JVCOperationDeviceConnectManagerSafeState"];
    [arrayContentList addObject:@"JVCOperationDeviceConnectManagerSafeMoveAttention"];
    [arrayContentList addObject:@"JVCOperationDeviceConnectManagerSafeTimerduration"];

    arrayImageList      = [[NSMutableArray alloc] init];
    [arrayImageList addObject:@"opr_devSafe.png"];
    [arrayImageList addObject:@"opr_devAttention.png"];
    [arrayImageList addObject:@"opr_devAlarm.png"];

}



- (void)dealloc
{
    [arrayImageList release];
    [arrayContentList release];
    [super dealloc];
}

 - (void)initCellContent
{
    //横线
    UIImage *imgLine = [UIImage imageNamed:@"mor_line.png"];
    UIImageView *HeadlineImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width- imgLine.size.width)/2.0, imgLine.size.height, imgLine.size.width, imgLine.size.height)];
    HeadlineImageView.image = imgLine;
    [self.contentView addSubview:HeadlineImageView];
    [HeadlineImageView release];

    //icon
    NSString *nameImage = [UIImage imageBundlePath:@"opr_devAlarm.png"];
    UIImage *image      = [[UIImage alloc] initWithContentsOfFile:nameImage];
    iconImageView       = [[UIImageView alloc] initWithFrame:CGRectMake(KImageViewOriginX, (self.height -image.size.height)/2.0 , image.size.width, image.size.height)];
    [image              release];
    [self.contentView   addSubview:iconImageView];
    [iconImageView      release];
    
    //title
    titleLabel          = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.right+KSeperateSpan, 0, KTitleLabeWith, self.height)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font          = [UIFont systemFontOfSize:KTitleLabeFont];
    [self.contentView   addSubview:titleLabel];
    [titleLabel         release];
    
    //safelabe
    safeTimerLabel          = [[UILabel alloc] initWithFrame:CGRectMake(self.width - KSaftTimerLabeWith - KImageViewOriginX, 0, KSaftTimerLabeWith, self.height)];
    safeTimerLabel.backgroundColor = [UIColor clearColor];
    safeTimerLabel.userInteractionEnabled = YES;
    safeTimerLabel.font          = [UIFont systemFontOfSize:KTitleLabeFont];
    UIColor *color      = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:kJVCRGBColorMacroLoginGray];
    if(color)
    {
        safeTimerLabel.textColor = color;
    }
    [self.contentView   addSubview:safeTimerLabel];
    [safeTimerLabel         release];
    safeTimerLabel.textAlignment = UITextAlignmentRight;
    safeTimerLabel.hidden   = YES;
    
    //uiswitch
    switchSafe          = [[UISwitch alloc] initWithFrame:CGRectMake(self.width - KSWitchWith -10, (self.height - KSwitchHeight)/2.0, 0, 0)];
    [switchSafe addTarget:self action:@selector(changeDeviceSwitchState:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:switchSafe];
    [switchSafe release];
    
    //横线
    UIImage *imgLineEnd = [UIImage imageNamed:@"mor_line.png"];
    UIImageView *endlineImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width- imgLine.size.width)/2.0, self.height-imgLine.size.height, imgLine.size.width, imgLine.size.height)];
    endlineImageView.image = imgLineEnd;
    [self.contentView addSubview:endlineImageView];
    [endlineImageView release];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAlarmTimerLabel:)];
    [safeTimerLabel addGestureRecognizer:tapGesture];
    [tapGesture release];
    
}

- (void)updateCellContentWithIndex:(JVCOperaDevConManagerCellType)index  safeTimer:(NSString *)stringSafe
{
    if (index >=arrayImageList.count) {
        
        return;
    }
    
    NSString *nameImage     = [UIImage imageBundlePath:[arrayImageList objectAtIndex:index]];
    UIImage *image          = [[UIImage alloc] initWithContentsOfFile:nameImage];
    iconImageView.image     = image;
    [image release];
    NSString *strContent    = [arrayContentList objectAtIndex:index];
    titleLabel.text         = LOCALANGER(strContent);
    
    switchSafe.tag  = -1;
    
    switch (index) {
            
        case JVCOperaDevConManagerCellTypeSafe:
        case JVCOperaDevConManagerCellTypeMoventAttention:
        {
            safeTimerLabel.hidden = YES;
            switchSafe.hidden   = NO;
            switchSafe.tag      = index;
        }
            break;
        case JVCOperaDevConManagerCellTypeTimerDuration:
        {
            safeTimerLabel.hidden   = NO;
            switchSafe.hidden       = YES;
            safeTimerLabel.text     = stringSafe;
        }
            break;
            
        default:
            break;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeDeviceSwitchState:(UISwitch *)switchSafe
{
    if (deviceDelegate !=nil && [deviceDelegate respondsToSelector:@selector(JVCOperDevConManagerClickCallBack:switchState:)]) {
        [deviceDelegate JVCOperDevConManagerClickCallBack:switchSafe.tag switchState:switchSafe.on];
    }
}

- (void)tapAlarmTimerLabel:(UIGestureRecognizer *)gesture
{
    if (deviceDelegate !=nil && [deviceDelegate respondsToSelector:@selector(JVCOperDevConManagerClickCallBack:switchState:)]) {
        [deviceDelegate JVCOperDevConManagerClickCallBack:JVCOperaDevConManagerCellTypeTimerDuration switchState:0];
    }
}

@end
