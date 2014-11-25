//
//  JVCOperationMiddleViewIphone5.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/30/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCOperationMiddleViewIphone5.h"
#import "JVCSystemUtility.h"

static const int  OFF_X  =  20;                      //距离左边距的距离
static const int OPERATIONBIGITEM  = 20.0;           //距离

static const int kSperateNum       = 6;           //上下个2个共4个  中间2个

#define bundleOperationMiddleViewIphone5  @"OperationMiddleViewIphone5.bundle"

@interface JVCOperationMiddleViewIphone5 ()
{
    
    NSMutableArray *_arrayList;
    
    UIButton *btnAudio;
    
    UIButton *btnCellBg;//音频监听的
    
    NSMutableArray *_arrayCellbglist;
    NSMutableArray *_arrayCellbglistHor;

    
}

@end
@implementation JVCOperationMiddleViewIphone5
@synthesize delegateIphone5BtnCallBack;
/**
 *  这个方法之前，一定要设置view的frame
 *  显示音频监听、云台、远程回放view
 *
 *  @param titleArray  主title
 *  @param detailArray 副title
 *  @param skinType    皮肤
 */
- (void)updateViewWithTitleArray:(NSArray *)titleArray detailArray:(NSArray *)detailArray skinType:(int )skinType
{
    [self initImageArray];
    
    [self initCellbgArray];
    
    [self  initCellBgArraySelect];
    
    int seperateNum = 2;
    
    detailArray = nil;

//    if (![[JVCSystemUtility shareSystemUtilityInstance] judgeAPPSystemLanguage]) {
//        detailArray = nil;
//        seperateNum = 2;
//    }
    
    NSString *cellBgImageHeight = [UIImage imageBundlePath:[_arrayCellbglist objectAtIndex:0]];
    UIImage *cellBgImageNorHeight = [[UIImage alloc] initWithContentsOfFile:cellBgImageHeight];
    CGFloat heightSeperate = (self.frame.size.height-3*cellBgImageNorHeight.size.height)/ kSperateNum;
    
    CGFloat height = cellBgImageNorHeight.size.height;
    for (int i = 0;i<titleArray.count;i++) {
        /**
         *  主要信息
         */
        NSString *strTitle = [titleArray objectAtIndex:i];
        
        NSString *strDetailTitle = nil;
        
        if (i<detailArray.count) {
            /**
             *  detail信息
             */
            strDetailTitle = [detailArray objectAtIndex:i];
        }
        
     
            
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0,2*heightSeperate+i*(heightSeperate+height), self.frame.size.width, cellBgImageNorHeight.size.height)];
        
        
        NSString *cellBgImage = [UIImage imageBundlePath:[_arrayCellbglist objectAtIndex:i]];
        UIImage *cellBgImageNor = [[UIImage alloc] initWithContentsOfFile:cellBgImage];
        
        NSString *cellBgHor = [UIImage imageBundlePath:[_arrayCellbglistHor objectAtIndex:i]];
        UIImage *cellBgImageHor = [[UIImage alloc] initWithContentsOfFile:cellBgHor];
        
        UIButton *cellBgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cellBgBtn.userInteractionEnabled = NO;
        cellBgBtn.frame = CGRectMake((self.width - cellBgImageNor.size.width)/2.0, 0, cellBgImageNor.size.width, cellBgImageNor.size.height);
        [cellBgBtn setBackgroundImage:cellBgImageNor forState:UIControlStateNormal];
        [cellBgBtn setBackgroundImage:cellBgImageHor forState:UIControlStateSelected];

        [contentView addSubview:cellBgBtn];
        [cellBgImageHor release];
        [cellBgImageNor release];
        
        UIImage *image = [UIImage imageWithContentsOfFile:[self getBundleImagePaht:[_arrayList objectAtIndex:i]]];
        
        UIImage *imageHover = image;
        //只有第一个按钮有选中状态
        if (i == 0) {
            
            imageHover = [UIImage imageWithContentsOfFile:[self getBundleImagePaht:[NSString stringWithFormat:@"audioBigListennerSelectedBtn_%d.png",skinType]]];
            
        }
        
        UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
        btnImage.frame = CGRectMake(OFF_X, (height - image.size.height)/2.0, image.size.width, image.size.height);
        [btnImage setBackgroundImage:image forState:UIControlStateNormal];
        //[btnImage setBackgroundImage:imageHover forState:UIControlStateHighlighted];
        [btnImage setBackgroundImage:imageHover forState:UIControlStateSelected];
        btnImage.tag = i;
        btnImage.userInteractionEnabled = NO;
        [btnImage addTarget:self  action:@selector(imagebtnClick:) forControlEvents:UIControlEventTouchDragInside];
        [contentView addSubview:btnImage];
        
        if (i ==0) {
            
            btnAudio = btnImage;
            
            btnCellBg = cellBgBtn;
        }
        
        
        UILabel *_titleName=[[UILabel alloc] init];
        _titleName.frame=CGRectMake(btnImage.frame.origin.x+btnImage.frame.size.width+OPERATIONBIGITEM, (height - (seperateNum-1)*20.0)/seperateNum, 210.0, 20.0);
        _titleName.textAlignment=UITextAlignmentLeft;
        _titleName.text= strTitle;
        _titleName.font= [UIFont systemFontOfSize:16];
        _titleName.textColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        _titleName.backgroundColor=[UIColor clearColor];
        [contentView addSubview:_titleName];
        [_titleName release];
        
        UILabel *_titleInfo=[[UILabel alloc] init];
        _titleInfo.frame=CGRectMake(_titleName.frame.origin.x, _titleName.frame.origin.y+_titleName.frame.size.height+5.0, 210.0, 18.0);
        _titleInfo.textAlignment=UITextAlignmentLeft;
        _titleInfo.text=    strDetailTitle;
        _titleInfo.font=[UIFont systemFontOfSize:14];
        _titleInfo.textColor=[UIColor colorWithRed:154.0/255 green:154.0/255  blue:154.0/255  alpha:1];
        _titleInfo.backgroundColor=[UIColor clearColor];
        [contentView  addSubview:_titleInfo];
        [_titleInfo release];
        
        if (i !=0) {
            
            NSString *imageNextName = [UIImage imageBundlePath:@"ope_midnext.png"];
            UIImage *nextImage = [[UIImage alloc] initWithContentsOfFile:imageNextName];
            
            UIImageView *imageViewNextImage=[[UIImageView alloc] init];
            imageViewNextImage.frame=CGRectMake(self.frame.size.width-4*nextImage.size.width, (height-nextImage.size.height)/2.0, nextImage.size.width, nextImage.size.height);
            imageViewNextImage.userInteractionEnabled = YES;
            [imageViewNextImage setImage:nextImage];
            [contentView addSubview:imageViewNextImage];
            [imageViewNextImage release];
        }
        
//        //最后一列 没有boderImage
//        if (i != titleArray.count -1) {
//            
//            UIImage *boderImage=[UIImage imageWithContentsOfFile:[self getBundleImagePaht:@"boderBigLine.png"]];
//            UIImageView *_boderImageView=[[UIImageView alloc] init];
//            _boderImageView.frame=CGRectMake((self.frame.size.width-boderImage.size.width)/2.0, height-boderImage.size.height, boderImage.size.width, boderImage.size.height);
//            [_boderImageView setImage:boderImage];
//            [contentView addSubview:_boderImageView];
//            [_boderImageView release];
//        }
        
        contentView.tag = i;
        /**
         *  添加手势
         */
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackGroup:)];
        
        [contentView addGestureRecognizer:recognizer];
        
        [recognizer release];
        
        [self addSubview:contentView];
        
        [contentView release];
        
    }
}

//设置选中的btn的类型
- (void)setAudioBtnSelectWithSkin
{
    
    UIImage *imageHover = [UIImage imageWithContentsOfFile:[self getBundleImagePaht:[NSString stringWithFormat:@"audioBigListennerSelectedBtn.png"]]];
    //[btnAudio setBackgroundImage:imageHover forState:UIControlStateHighlighted];
    [btnAudio setBackgroundImage:imageHover forState:UIControlStateSelected];
    [btnAudio setSelected:YES];
    
    [btnCellBg setSelected:YES];
    
    
}

//设置btn为非选中状态
- (void)setAudioBtnUNSelect
{
    [btnAudio setSelected:NO];
    [btnCellBg setSelected:NO];

}
/**
 *  返回UIImage
 *
 *	@param	ImageName	图片的名字
 *
 *	@return	返回指定指定图片名的图片
 */
-(NSString *)getBundleImagePaht:(NSString *)ImageName{
    
    NSString *main_image_dir_path=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundleOperationMiddleViewIphone5];
    
    NSString *image_path=[main_image_dir_path stringByAppendingPathComponent:ImageName];
    
    return image_path;
}

/**
 *  返回按钮的状态
 *
 *  @return 选中状态yes 非选中状态No
 */
- (BOOL)getAudioBtnState
{
    return btnAudio.selected;
}

/**
 *  点击背景的回调
 *
 *  @param gesture 手势
 */
- (void)clickBackGroup:(UITapGestureRecognizer *)gesture
{
    if (delegateIphone5BtnCallBack !=nil &&[delegateIphone5BtnCallBack respondsToSelector:@selector(operationMiddleIphone5BtnCallBack:)]) {
        
        [delegateIphone5BtnCallBack operationMiddleIphone5BtnCallBack:(int )gesture.view.tag];
    }
}

- (void)imagebtnClick:(UIButton *)btn
{
    if (delegateIphone5BtnCallBack !=nil &&[delegateIphone5BtnCallBack respondsToSelector:@selector(operationMiddleIphone5BtnCallBack:)]) {
        
        [delegateIphone5BtnCallBack operationMiddleIphone5BtnCallBack:(int )btn.tag];
    }

}

/**
 *  初始化数组信息
 */
- (void)initImageArray
{
    _arrayList = [[NSMutableArray alloc] init];
    
    [_arrayList addObject:@"audioBigListennerBtn.png"];
    [_arrayList addObject:@"ytoBigBtn.png"];
    [_arrayList addObject:@"playBackBigBtn.png"];
    
}

- (void)initCellbgArray
{
    _arrayCellbglist = [[NSMutableArray alloc] init];
    [_arrayCellbglist addObject:@"op_audioCellBgNor.png"];
    [_arrayCellbglist addObject:@"op_ytCellbgNor.png"];
    [_arrayCellbglist addObject:@"op_playBackBgBor.png"];
}

- (void)initCellBgArraySelect
{
    _arrayCellbglistHor = [[NSMutableArray alloc] init];
    
    [_arrayCellbglistHor addObject:@"op_audioCellBgHor.png"];
    [_arrayCellbglistHor addObject:@"op_ytCellbgNor.png"];
    [_arrayCellbglistHor addObject:@"op_playBackBgBor.png"];
}

- (void)dealloc
{
    [_arrayList release];
    
    [super dealloc];
}

@end
