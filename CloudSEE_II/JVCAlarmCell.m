//
//  JVCAlarmCell.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/13/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAlarmCell.h"
#import "JVCAlarmModel.h"
@implementation JVCAlarmCell
static const int KLabelOriginX   = 10;//距离左边界的距离
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
    NSString *imageCellBgPath = [UIImage imageBundlePath:@"arm_cellbg.png"] ;
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
//    if (model.bNewAlarmFlag) {
//        UIImage *imgNew = [UIImage imageNamed:LOCALANGER(@"JVCArm_New")];
//        UIImageView *imageViewNew = [[UIImageView alloc] initWithFrame:CGRectMake(ImageViewCellBg.left,ImageViewCellBg.top, imgNew.size.width, imgNew.size.height)];
//        imageViewNew.tag = 10005;
//        imageViewNew.image = imgNew;
//        [self.contentView addSubview:imageViewNew];
//        [imageViewNew release];
//    }
    
    
    /**
     *  警告的图片 ！
     */
    UIImage *imageCellAlarm = [UIImage imageNamed:@"arm_exc.png"];
    UIImageView *ImageViewCellalarm = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageCellAlarm.size.width, imageCellAlarm.size.height)];
    ImageViewCellalarm.center = imgViewAlerm.center;
    ImageViewCellalarm.image = imageCellAlarm;
    [self.contentView addSubview:ImageViewCellalarm];
    [ImageViewCellalarm release];
    
    
    /**
     *  文字
     */
    NSString *_strTemp =nil;
    NSString *typeString =@"tejjlfjajf;ajf;ad"; //;[NSString stringWithFormat:@"home_alarm_%d",model.iAlarmType];
    NSString *strNick = model.strALarmDeviceNickName ;
    
    NSInteger maxLanguageCount  = 6;
    BOOL _bLanguage = [[JVCSystemUtility shareSystemUtilityInstance] judgeAPPSystemLanguage];
    if (!_bLanguage) {
        maxLanguageCount=15;
    }else{
        if (model.iAlarmType == 12) {
            maxLanguageCount = 3;
        }
    }
    if (strNick.length>maxLanguageCount) {
        NSString *str = [strNick substringToIndex:maxLanguageCount];
        strNick = [str stringByAppendingString:@"..."];
    }
    if ([[JVCSystemUtility shareSystemUtilityInstance] judgeAPPSystemLanguage]) {
        _strTemp = [NSString stringWithFormat:@"%@%@",strNick,NSLocalizedString(typeString, nil)];
    }else{
        _strTemp = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(typeString, nil),NSLocalizedString(@"home_alarm_device", nil),strNick ];
    }
    
    
    NSInteger lineBreakModeTemp;
    if ([[JVCSystemUtility shareSystemUtilityInstance] judgeAPPSystemLanguage]) {
        lineBreakModeTemp = UILineBreakModeWordWrap;
        
    }else{
        lineBreakModeTemp = UILineBreakModeCharacterWrap;
        
    }
    
    CGSize consizeSize = [_strTemp sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake((ImageViewCellBg.width - 2*KLabelOriginX)/2.0, 100) lineBreakMode:lineBreakModeTemp];
    consizeSize.height = MIN(consizeSize.height, 50);
    UILabel *_labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(imgViewAlerm.frame.size.width+imgViewAlerm.frame.origin.x+10, imgViewAlerm.frame.origin.y, consizeSize.width, consizeSize.height)];
    _labelTitle.backgroundColor = [UIColor clearColor];
    _labelTitle.text = _strTemp;
    [_labelTitle setTextColor:SETLABLERGBCOLOUR(85.0, 85.0, 85.0)];
    _labelTitle.font =[UIFont systemFontOfSize:14];
    _labelTitle.numberOfLines = 2;
    _labelTitle.lineBreakMode = lineBreakModeTemp;
    [self.contentView addSubview:_labelTitle];
    [_labelTitle release];
    
    /**
     *  报警级别
     */
    UILabel *labelALarmType = [[UILabel alloc] initWithFrame:CGRectMake(_labelTitle.frame.origin.x, _labelTitle.frame.origin.y+_labelTitle.frame.size.height+10, 80, 20)];
    labelALarmType.backgroundColor = [UIColor clearColor];
    labelALarmType.font = [UIFont systemFontOfSize:13];
    [labelALarmType setTextColor:SETLABLERGBCOLOUR(85.0, 85.0, 85.0)];
    labelALarmType.text = @"报警级别";
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
        if (i<=model.iAlarmType*2) {
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
