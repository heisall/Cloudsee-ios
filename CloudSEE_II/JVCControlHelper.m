//
//  JVCControlHelper.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/18/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCControlHelper.h"

@implementation JVCControlHelper
static const int KBtnSizewith       = 100;//默认btn的宽度
static const int KBtnSizeHeight     = 45;//默认btn的高度

//默认labe的高度
static const int KLabelSizewith       = 200;//默认btn的宽度
static const int KLabelSizeHeight     = 30;//默认btn的高度
static const int KFontSizeAdd         = 6;//高度比fontsize大6
static const int KFontSize            = 14;//label的默认size
static const float KLabelOriginX      = 10;//距离左侧的距离
static const float KLabelOriginY      = 10;//距离顶端的距离
static const float KTextSpan          = 5;//textfield 与leftLabel的距离
static const float KLeftViewWith      = 10;//左侧view的宽度
static JVCControlHelper *shareJVCControlHelper = nil;

/**
 *  单例
 *
 *  @return 返回JVCResultTipsHelper 对象
 */
+(JVCControlHelper *)shareJVCControlHelper
{
    @synchronized(self)
    {
        if (shareJVCControlHelper == nil) {
            
            shareJVCControlHelper = [[self alloc] init];
            
            
        }
        
        return shareJVCControlHelper;
    }
    
    return shareJVCControlHelper;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareJVCControlHelper == nil) {
            
            shareJVCControlHelper = [super allocWithZone:zone];
            
            return shareJVCControlHelper;
        }
    }
    
    return nil;
}

/**
 *  返回label 字段
 *
 *  @param labelText 文本
 *  @param frame     frame
 *
 *  @return label 对象  （用的时候，retain 一下）
 */
- (UILabel *)labelWithText:(NSString *)labelText
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KLabelSizewith, KLabelSizeHeight)];
    label.backgroundColor = [UIColor clearColor];
    label.text = labelText;
    return [label autorelease];
}

/**
 *  根据文字和字体大小动态生成label
 *
 *  @param labelText 文字
 *  @param fontSize  文字大小
 *
 *  @return 返回label
 */
- (UILabel *)labelWithText:(NSString *)labelText  textFontSize:(int)fontSize
{
    CGSize titleWithSize = [labelText sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, KFontSizeAdd+fontSize)];
    if (titleWithSize.width>KLabelSizewith) {
        
        titleWithSize.width = KLabelSizewith;
    }

    CGSize titleSize = [labelText sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(titleWithSize.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    if (titleSize.height<KLabelSizeHeight+KFontSizeAdd) {
        
        titleSize.height = KLabelSizeHeight+KFontSizeAdd;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.backgroundColor = [UIColor clearColor];
    label.text = labelText;
    return [label autorelease];
}

/**
 *  返回uiimageview对象
 *
 *  @param image image对象
 *
 *  @return imageview
 */
- (UIImageView *)imageViewWithIamge:(NSString *)stringImage
{
    [stringImage retain];
    NSString *path = [UIImage imageBundlePath:stringImage];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    [stringImage release];
    [image release];
    return [imageView autorelease];
}

/**
 *  返回按钮,不传入图片，默认btn的按钮大小
 *
 *  @param titileString 按钮的title
 *  @param normalImage  默认背景
 *  @param horverImage  高亮背景
 *
 *  @return button 对象
 */
- (UIButton *)buttonWithTitile:(NSString *)titileString
                   normalImage:(NSString *)normalImage
                   horverimage:(NSString *)horverImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, KBtnSizewith, KBtnSizeHeight);
    if (titileString !=nil) {
        
        [btn setTitle:titileString forState:UIControlStateNormal];

    }
    if (normalImage != nil) {
        NSString *path = [UIImage imageBundlePath:normalImage];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        btn.frame  = CGRectMake(0, 0, image.size.width, image.size.height);
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [image release];

    }
    if (horverImage !=nil) {
        
        NSString *path = [UIImage imageBundlePath:horverImage];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        btn.frame  = CGRectMake(0, 0, image.size.width, image.size.height);
        [btn setBackgroundImage:image forState:UIControlStateSelected];
        [image release];


    }
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return btn;
}

/**
 *  获取textfiel
 *
 *  @param labelText 左侧lable显示的数据
 *  @param imageName 背景图片，没有的话显示默认的
 *
 *  @return textfield
 */
- (UITextField *)textFieldWithLeftLabelText:(NSString *)labelText
                            backGroundImage:(NSString *)imageName
{
    
    if (!imageName||imageName.length == 0) {
        
        imageName = @"con_fieldUnSec.png";
    }
    NSString *strImage = [UIImage imageBundlePath:imageName];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:strImage];
    
    
    UILabel *labelLeft = [self labelWithText:labelText textFontSize:KFontSize];
    [labelLeft retain];
    labelLeft.frame = CGRectMake(KLabelOriginX+KTextSpan, KLabelOriginY, labelLeft.width+KTextSpan, labelLeft.height);
    labelLeft.text =labelText;
    labelLeft.textAlignment = UITextAlignmentCenter;
    labelLeft.backgroundColor = [UIColor clearColor];
    labelLeft.font = [UIFont systemFontOfSize:KFontSize];
    
    UILabel *labelright = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KLeftViewWith, labelLeft.height)];
    [labelright retain];
    labelright.text =@" ";
    labelright.textAlignment = UITextAlignmentCenter;
    labelright.backgroundColor = [UIColor clearColor];
    labelright.font = [UIFont systemFontOfSize:KFontSize];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(labelLeft.right, labelLeft.top, image.size.width, image.size.height)];
    textField.backgroundColor = [UIColor colorWithPatternImage:image];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    textField.returnKeyType = UIReturnKeyDone;
    textField.leftView = labelLeft;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.rightView = labelright;
    [labelright release];
    [labelLeft release];
    [image release];
    
    return [textField autorelease];
}


/**
 *  返回指定的textfield  左右两侧个空出10
 *
 *  @param placeHold 占位符
 *  @param imageName 背景图
 *
 *  @return 相应的textfield
 */
- (UITextField *)textFieldWithPlaceHold:(NSString *)placeString
                        backGroundImage:(NSString *)imageName
{
    if (!imageName||imageName.length == 0) {
        
        imageName = @"con_fieldUnSec.png";
    }
    NSString *strImage = [UIImage imageBundlePath:imageName];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:strImage];
    
    
    UILabel *labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KLeftViewWith, KLabelSizeHeight)];
    [labelLeft retain];
    labelLeft.textAlignment = UITextAlignmentCenter;
    labelLeft.backgroundColor = [UIColor clearColor];
    labelLeft.font = [UIFont systemFontOfSize:KFontSize];
    
    UILabel *labelright = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KLeftViewWith, KLabelSizeHeight)];
    [labelright retain];
    labelright.textAlignment = UITextAlignmentCenter;
    labelright.backgroundColor = [UIColor clearColor];
    labelright.font = [UIFont systemFontOfSize:KFontSize];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(labelLeft.right, labelLeft.top, image.size.width, image.size.height)];
    textField.backgroundColor = [UIColor colorWithPatternImage:image];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.placeholder = placeString;
    textField.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    textField.returnKeyType = UIReturnKeyDone;
    textField.leftView = labelLeft;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.rightView = labelright;
    [labelright release];
    [labelLeft release];
    [image release];
    
    return [textField autorelease];

}

/**
 *  根据字体 获取带下划线的label
 *
 *  @param titleString  字符串
 *  @param fontSize     字体号
 *
 *  @return 相应的label
 */
- (UILabel *)labelWithUnderLine:(NSString *)titleString  fontSize:(int)fontSize
{
    UILabel *label = [self labelWithText:titleString textFontSize:fontSize];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:titleString];
    NSRange contentRange = {0, [content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    label.attributedText = content;
    [content release];
    return label;
}

/**
 *  给label添加下划线
 *
 *  @param label label下划线
 */
- (void)labelWithDownLine:(UILabel *)label
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSRange contentRange = {0, [content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    label.attributedText = content;
    [content release];

}

/**
 *  根据文字和字体大小、高度动态生成文本所占的长度
 *
 *  @param text     文本
 *  @param fontSize 字体大小
 *  @param height   高度
 *
 *  @return 动态生成的长度
 */
- (CGSize)textWidthWithText:(NSString *)text  withFontSize:(CGFloat)fontSize withHeight:(CGFloat)height{

     CGSize titleWithSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, height)];
    
    return titleWithSize;
}

@end
