//
//  JVCWireTableViewCell.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-12.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCWireTableViewCell.h"
#import "JVCRGBHelper.h"

static const float KLabelOriginX    = 15.0f;//距离左侧的距离
static const float KLabelWith       = 85.0f;//距离顶端的距离
static const float KLabelFieldSpan  = 5.0f;//label与textfield之间的距离
static const int   KLabelFont       = 14;//label的字体大小

@interface JVCWireTableViewCell()
{
    int          nIndex;
    UITextField *tfTextFiled;
}
@end

@implementation JVCWireTableViewCell
@synthesize deleage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
    }
    return self;
}

/**
 *  初始化单个cell的视图
 *
 *  @param title   标签名称
 *  @param text    文本框内容
 *  @param index   在数组的索引
 *  @param enabled 输入框是否允许输入
 */
- (void)initContentView:(NSString *)title  withTextFiled:(NSString *)text withIndex:(int)index withTextFiledEnabled:(BOOL)enabled
{
    nIndex = index;
    
    NSString *strImage = [UIImage imageBundlePath:@"con_fieldUnSec.png"];
    UIImage *image     = [[UIImage alloc] initWithContentsOfFile:strImage];
    
    UILabel *label = nil;
    
    UIColor *colorlabel     = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:KLickTypeLeftLabelColor];
    UIColor *colortextfield = [[JVCRGBHelper shareJVCRGBHelper] rgbColorForKey:KLickTypeTextFieldColor];
    
    label                   = [[UILabel alloc] init];
    label.frame = CGRectMake(KLabelOriginX, (self.frame.size.height -image.size.height)/2.0 , KLabelWith, image.size.height);
    label.text = NSLocalizedString(title, nil);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentLeft;
    
    if (colorlabel) {
        
        label.textColor = colorlabel;
    }
    
    label.font = [UIFont systemFontOfSize:KLabelFont];
    [self.contentView addSubview:label];
    [label release];
    
    UILabel *labelLeftView             = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KLabelFieldSpan, image.size.height)];
    labelLeftView.backgroundColor      = [UIColor clearColor];
    
    tfTextFiled                        = [[UITextField alloc] initWithFrame:CGRectMake(label.right+KLabelFieldSpan, (self.frame.size.height -image.size.height)/2.0, image.size.width, image.size.height)];
    tfTextFiled.backgroundColor          = [UIColor colorWithPatternImage:image];
    tfTextFiled.leftViewMode             = UITextFieldViewModeAlways;
    tfTextFiled.autocapitalizationType   = UITextAutocapitalizationTypeNone;
    tfTextFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tfTextFiled.keyboardType             = UIKeyboardTypeASCIICapable;
    tfTextFiled.returnKeyType            = UIReturnKeyDone;
    tfTextFiled.leftView                 = labelLeftView;
    tfTextFiled.text                     = text;
    tfTextFiled.enabled                  = enabled;
    
    if (enabled) {
        
        tfTextFiled.delegate             = self;
    }
    
    if (colortextfield) {
        
        tfTextFiled.textColor = colortextfield;
    }
    
    [labelLeftView release];
    [self.contentView addSubview:tfTextFiled];

    [tfTextFiled release];
    [image release];
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

/**
 *  如果正在输入，关闭键盘
 */
-(void)resignFirstResponderMath {

     [tfTextFiled resignFirstResponder];
}

#pragma mark textField的delegate方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    DDLogVerbose(@"%s--------%@",__FUNCTION__,textField.text);
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    if (self.deleage !=nil && [self.deleage respondsToSelector:@selector(textFiledWithTextChange:withIndex:)]) {
        
        [self.deleage textFiledWithTextChange:textField.text withIndex:nIndex];
    }
    
    return YES;
}

@end
