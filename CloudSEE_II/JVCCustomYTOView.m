//
//  JVCCustomYTOView.m
//  CloudSEE_II
//  云台控制
//  Created by Yanghu on 10/7/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCCustomYTOView.h"

static const int  ADDYTOPERATIONNUM =  20;

static const NSString * BUNDLENAMEYT = @"YTOperation.bundle";//云台控制
static const int kImageImageSeperateCount = 2;//图片分割的数组大小
#define JudgeIphone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface JVCCustomYTOView ()
{
    
    CGPoint startPoint;
    
	float x_point;
    
	float y_point;
    
    BOOL  isAuto;
    
    //云台是否显示出来
    BOOL bShowYTView;  //yes 云台显示出来   no：没有
    
}

@end

@implementation JVCCustomYTOView

@synthesize delegateYTOperation;


static JVCCustomYTOView *_shareInstance = nil;

/**
 *  单例
 *
 *  @return 返回DevicePredicateObject 单例
 */
+ (JVCCustomYTOView *)shareInstance
{
    @synchronized(self)
    {
        if (_shareInstance == nil) {
            
            _shareInstance = [[self alloc] init ];
            
            _shareInstance.multipleTouchEnabled=YES;
            
            _shareInstance.backgroundColor= [UIColor colorWithRed:239.0/255 green:239.0/255 blue: 239.0/255 alpha:1];
            
            [_shareInstance initWithView];
            
        }
        return _shareInstance;
    }
    return _shareInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (_shareInstance == nil) {
            
            _shareInstance = [super allocWithZone:zone];
            
            return _shareInstance;
            
        }
    }
    return nil;
}

-(void)initWithView{
    
    UIView *_v=[[UIView alloc] init];
    double _iphonePadding=0.0;
    
    if (JudgeIphone5) {
        _iphonePadding=15.0;
    }
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HidenYTOperationView)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [_v addGestureRecognizer:singleRecognizer];
    [singleRecognizer release];
    
    UIImage *_closeImage=[[UIImage alloc ]initWithContentsOfFile:[self getBundleImagePath:@"ytoClose.png"]];
    UIImage *_closeImageHover=[[UIImage alloc ]initWithContentsOfFile:[self getBundleImagePath:@"ytoClose.png"]];

    UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame=CGRectMake([UIApplication sharedApplication].keyWindow.frame.size.width-_closeImage.size.width-15.0, 5.0+_iphonePadding, _closeImage.size.width*1.2, _closeImage.size.height*1.2);
    [closeBtn setBackgroundImage:_closeImage forState:UIControlStateNormal];
    [closeBtn setBackgroundImage:_closeImageHover forState:UIControlStateHighlighted];

    closeBtn.showsTouchWhenHighlighted=YES;
    [closeBtn addTarget:self action:@selector(HidenYTOperationView) forControlEvents:UIControlEventTouchDown];
    [self addSubview:closeBtn];
    _v.frame=CGRectMake(closeBtn.frame.origin.x-5.0, closeBtn.frame.origin.y-5.0, closeBtn.frame.size.width+15.0, closeBtn.frame.size.height+15.0);
    _v.backgroundColor=[UIColor clearColor];
    [self addSubview:_v];
    [_v setUserInteractionEnabled:YES];
    [_v release];
    [_closeImage release];
    [_closeImageHover release];
    if (JudgeIphone5) {
        _iphonePadding=40.0;
    }
	NSMutableArray *imageNameList=[NSMutableArray arrayWithCapacity:10];
	[imageNameList addObject:[NSString stringWithFormat:@"%@",@"ytoUpBtn.png|1,1"]];
	[imageNameList addObject:[NSString stringWithFormat:@"%@",@"ytoLeftBtn.png|2,1"]];
	[imageNameList addObject:[NSString stringWithFormat:@"%@",@"ytoAutoBtn.png|2,2"]];
	[imageNameList addObject:[NSString stringWithFormat:@"%@",@"ytoRightBtn.png|2,3"]];
	[imageNameList addObject:[NSString stringWithFormat:@"%@",@"ytoDownBtn.png|3,1"]];
	[imageNameList addObject:[NSString stringWithFormat:@"%@",@"ytoZoom+Btn.png|3,2"]];
	[imageNameList addObject:[NSString stringWithFormat:@"%@",@"ytoZoom-Btn.png|3,3"]];
	[imageNameList addObject:[NSString stringWithFormat:@"%@",@"ytoScale+Btn.png|1,2"]];
	[imageNameList addObject:[NSString stringWithFormat:@"%@",@"ytoScale-Btn.png|1,3"]];
	float padding=15.0;
	float y_padding=10.0;
    float y_paddingSize=7.5;
    float x_padding=25.0;
    float subX = 0;
    
    if (!iphone5) {
        y_padding=3.0;
        y_paddingSize=3.5;
        subX = 10;
    }
    
	for (int i=0; i<[imageNameList count]; i++) {
		NSArray *array=[[imageNameList objectAtIndex:i] componentsSeparatedByString:@"|"];
        float x_value=0.0;
        float y_value=0.0;
        float _x=0.0;
		if (2==[array count]) {
            
			NSArray *info=[[array objectAtIndex:1] componentsSeparatedByString:@","];
            
			if ([info count]==2) {
                
				//UIImage *image=[UIImage imageNamed:[array objectAtIndex:0]];
                UIImage *image=[UIImage imageWithContentsOfFile:[self getBundleImagePath: [array objectAtIndex:0]]];

				UIButton *menuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                
				if (1==[[info objectAtIndex:0] intValue]) {
                    
                    if ([[info objectAtIndex:1] intValue]>1) {
                        
                        x_value=40.0;
                        y_value=8.0;
                        
                        if ([[info objectAtIndex:1] intValue]>=2) {
                            
                            _x=15.0;
                            
                            if ([[info objectAtIndex:1] intValue]>2) {
                                
                                _x=45.0;
                            }
                            
                            y_value=10.0;
                        }
                        
                    }
                    
					menuBtn.frame=CGRectMake(x_padding+(image.size.width+padding)*[[info objectAtIndex:1] intValue]+x_value+_x,  y_paddingSize+y_value+_iphonePadding, image.size.width, image.size.height);
                    
				}else if (2==[[info objectAtIndex:0] intValue]) {
					
					menuBtn.frame=CGRectMake(x_padding+(image.size.width+padding)*([[info objectAtIndex:1] intValue]-1.0),  y_paddingSize+(image.size.height+y_padding)*([[info objectAtIndex:0] intValue]-1)+_iphonePadding, image.size.width, image.size.height);
                    
				}else if (3==[[info objectAtIndex:0] intValue]) {
                    
                    if ([[info objectAtIndex:1] intValue]>1) {
                        
                        x_value=40.0;
                        y_value=25.0;
                        
                        if ([[info objectAtIndex:1] intValue]>=2) {
                            
                            _x=15.0;
                            
                            if ([[info objectAtIndex:1] intValue]>2) {
                                
                                _x=45.0;
                            }
                            
                            y_value=25.0;
                        }
                        
                    }else{
                        y_value = 3;
                    }
					menuBtn.frame=CGRectMake(x_padding+(image.size.width+padding)*[[info objectAtIndex:1] intValue]+x_value+_x,  y_paddingSize+(image.size.height+y_padding)*([[info objectAtIndex:0] intValue]-1)-y_value+_iphonePadding, image.size.width, image.size.height);
				}
                
				menuBtn.tag=i+100;
                NSString *imageSelect = [array objectAtIndex:0];
                NSArray *imageArray = [imageSelect componentsSeparatedByString:@"."];
                if (imageArray.count == 2) {
                    NSString *strImageSelect = [NSString stringWithFormat:@"%@_sec.%@",[imageArray objectAtIndex:0],[imageArray objectAtIndex:1]];
                    
                    NSString *imageselect = [self getBundleImagePath:strImageSelect];
                    UIImage *secBtnImage = [[UIImage alloc] initWithContentsOfFile:imageselect ];
                    [menuBtn setBackgroundImage:secBtnImage forState:UIControlStateHighlighted];
                    
                    [secBtnImage release];
                }
				[menuBtn setBackgroundImage:image forState:UIControlStateNormal];
				[menuBtn addTarget:self action:@selector(upStartMenuClick:) forControlEvents:UIControlEventTouchDown];
				[menuBtn addTarget:self action:@selector(upInMenuClickEnd:) forControlEvents:UIControlEventTouchUpInside];
				[menuBtn addTarget:self action:@selector(upOutClickEnd:) forControlEvents:UIControlEventTouchUpOutside];
                
				[self addSubview:menuBtn];
			}
            
		}
	}
    
    UIButton *btn1 = (UIButton*)[self viewWithTag:105];
    UIButton *btn2 = (UIButton*)[self viewWithTag:106];
    UIButton *btn3 = (UIButton*)[self viewWithTag:107];
    UIButton *btn4 = (UIButton*)[self viewWithTag:108];
    
    UILabel *titleLable=[[UILabel alloc] init];
    titleLable.frame=CGRectMake(btn1.frame.size.width+btn1.frame.origin.x, btn2.frame.origin.y+4.0, btn2.frame.origin.x-btn1.frame.size.width-btn1.frame.origin.x, btn2.frame.size.height-8);
    titleLable.text=NSLocalizedString(@"focus", nil);
    titleLable.textColor=[UIColor blackColor];
    titleLable.font=[UIFont systemFontOfSize:14];
    titleLable.backgroundColor=[UIColor clearColor];
    titleLable.textAlignment=UITextAlignmentCenter;
    [self addSubview:titleLable];
    [titleLable release];
    
    UILabel *titleLable1=[[UILabel alloc] init];
    titleLable1.frame=CGRectMake(btn3.frame.size.width+btn3.frame.origin.x, btn3.frame.origin.y+4.0, btn4.frame.origin.x-btn3.frame.size.width-btn3.frame.origin.x, btn3.frame.size.height-8.0);
    titleLable1.text=NSLocalizedString(@"Zoom", nil);
    titleLable1.textColor=[UIColor blackColor];
    titleLable1.textAlignment=UITextAlignmentCenter;
    titleLable1.font=[UIFont systemFontOfSize:14];
    titleLable1.backgroundColor=[UIColor clearColor];
    [self addSubview:titleLable1];
    [titleLable1 release];
    
}


-(void)upInMenuClickEnd:(UIButton*)button{
    
	NSUInteger type=button.tag;
    
    int iOperationType = -1;
    
	switch (type) {
            
		case 100:{
            iOperationType      = JVN_YTCTR_TYPE_U + ADDYTOPERATIONNUM;
			break;
		}
		case 101:{
            iOperationType      = JVN_YTCTR_TYPE_L + ADDYTOPERATIONNUM;
			break;
		}
		case 102:{
            if (isAuto) {
                iOperationType  = JVN_YTCTR_TYPE_AT;
                
            }else{
                iOperationType  = JVN_YTCTR_TYPE_A;
            }
            isAuto=!isAuto;
			break;
		}
		case 103:{
            iOperationType      = JVN_YTCTR_TYPE_R + ADDYTOPERATIONNUM;
			break;
		}
		case 104:{
            iOperationType      = JVN_YTCTR_TYPE_D + ADDYTOPERATIONNUM;
			break;
		}
		case 105:{
            iOperationType      = JVN_YTCTR_TYPE_BJD + ADDYTOPERATIONNUM;
			break;
		}
		case 106:{
            iOperationType      = JVN_YTCTR_TYPE_BJX + ADDYTOPERATIONNUM;
			break;
		}
		case 107:{
            iOperationType      = JVN_YTCTR_TYPE_BBD + ADDYTOPERATIONNUM;
			break;
		}
		case 108:{
            iOperationType      = JVN_YTCTR_TYPE_BBX + ADDYTOPERATIONNUM;
			break;
		}
		default:
			break;
            
	}
    
    if (delegateYTOperation !=nil &&[delegateYTOperation respondsToSelector:@selector(YTOperationDelegateCallBackWithJVNYTCType:)]) {
        [delegateYTOperation YTOperationDelegateCallBackWithJVNYTCType:iOperationType];
    }
    
}
-(void)upStartMenuClick:(UIButton*)button{
    
	NSUInteger type=button.tag;
    
    int iOperationType = -1;
    
	switch (type) {
		case 100:{
            iOperationType = JVN_YTCTR_TYPE_U;
			break;
		}
		case 101:{
            iOperationType = JVN_YTCTR_TYPE_L;
			break;
		}
		case 102:{
			//[main ytCTL:JVN_YTCTRL_A goOn:goOn];
			break;
		}
		case 103:{
            iOperationType = JVN_YTCTR_TYPE_R;
			break;
		}
		case 104:{
            iOperationType = JVN_YTCTR_TYPE_D;
			break;
		}
		case 105:{
            iOperationType = JVN_YTCTR_TYPE_BJD;
			break;
		}
		case 106:{
            iOperationType = JVN_YTCTR_TYPE_BJX;
			break;
		}
		case 107:{
            iOperationType = JVN_YTCTR_TYPE_BBD;
			break;
		}
		case 108:{
            iOperationType = JVN_YTCTR_TYPE_BBX;
			break;
		}
		default:
			break;
	}
    
    if (delegateYTOperation !=nil &&[delegateYTOperation respondsToSelector:@selector(YTOperationDelegateCallBackWithJVNYTCType:)]) {
        [delegateYTOperation YTOperationDelegateCallBackWithJVNYTCType:iOperationType];
    }
    
	
}

-(void)upOutClickEnd:(UIButton*)button{
    
	NSUInteger type= button.tag;
    
    int iOperationType = -1;
    
	switch (type) {
		case 100:{
            iOperationType = JVN_YTCTR_TYPE_U + ADDYTOPERATIONNUM;
			break;
		}
		case 101:{
            iOperationType = JVN_YTCTR_TYPE_L + ADDYTOPERATIONNUM;
			break;
		}
		case 102:{
			//[main ytCTL:JVN_YTCTRL_A goOn:goOn];
			break;
		}
		case 103:{
            iOperationType = JVN_YTCTR_TYPE_R + ADDYTOPERATIONNUM;
			break;
		}
		case 104:{
            iOperationType = JVN_YTCTR_TYPE_D + ADDYTOPERATIONNUM;
			break;
		}
		case 105:{
            iOperationType = JVN_YTCTR_TYPE_BJD + ADDYTOPERATIONNUM;
			break;
		}
		case 106:{
            iOperationType = JVN_YTCTR_TYPE_BJX + ADDYTOPERATIONNUM;
			break;
		}
		case 107:{
            iOperationType = JVN_YTCTR_TYPE_BBD + ADDYTOPERATIONNUM;
			break;
		}
		case 108:{
            iOperationType = JVN_YTCTR_TYPE_BBX + ADDYTOPERATIONNUM;
			break;
		}
		default:
			break;
	}
    
    /**
     *  防止发送-1的情况
     */
    if (iOperationType !=-1) {
        
        if (delegateYTOperation !=nil &&[delegateYTOperation respondsToSelector:@selector(YTOperationDelegateCallBackWithJVNYTCType:)]) {
            
            [delegateYTOperation YTOperationDelegateCallBackWithJVNYTCType:iOperationType];
            
        }
    }
    
    
}

- (void)dealloc {
    
    [super dealloc];
    
}

/**
 *  返回UIImage
 *
 *	@param	ImageName	图片的名字
 *
 *	@return	返回指定指定图片名的图片
 */
-(NSString *)getBundleImagePath:(NSString *)ImageName{
    
    NSString *main_image_dir_path=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:(NSString *)BUNDLENAMEYT];
    
    NSString *image_path= nil;//[main_image_dir_path stringByAppendingPathComponent:ImageName];
    
    NSArray *array = [ImageName componentsSeparatedByString:@"."];
    
    if (kImageImageSeperateCount == array.count ) {
        
        NSString *imageName = [array objectAtIndex:0];
        imageName  = [imageName stringByAppendingString:@"@2x."];
        imageName = [imageName stringByAppendingString:[array objectAtIndex:1]];
        image_path = [main_image_dir_path stringByAppendingPathComponent:imageName];
    }
    return image_path;
}

/**
 *  显示云台
 */
-(void)showYTOperationView{
    
    bShowYTView = YES;

    [self setHidden:NO];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.layer addAnimation:transition forKey:nil];
    
    
}

/**
 *  隐藏云台
 */
-(void)HidenYTOperationView{
    
    bShowYTView = NO;

    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self setHidden:YES];
    [self.layer addAnimation:transition forKey:nil];
    
}

/**
 *  获取是否显示云台
 *
 *  yes  云台显示   no：云台隐藏
 */
- (BOOL)getYTViewShowState
{
    return bShowYTView;
}

@end
