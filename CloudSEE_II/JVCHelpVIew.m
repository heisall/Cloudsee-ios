//
//  JVCHelpVIew.m
//  CloudSEE_II
//
//  Created by Yanghu on 10/23/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCHelpVIew.h"
#import "StyledPageControl.h"
@interface JVCHelpVIew ()
{
    UIScrollView *helpListView;
    
    NSMutableArray *imageNameList;
    
    StyledPageControl *pageControl;
}
@end

#import "StyledPageControl.h"

@implementation JVCHelpVIew
@synthesize delegateWelcome;
static const  int  KWelcomeListCount  = 4;//欢迎界面的最大值
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initView];
    }
    return self;
}

- (void)initView
{
    imageNameList = [[NSMutableArray alloc] init];
    
    if(iphone5)
    {
        for(int i=0;i<KWelcomeListCount;i++ )
        {
            NSString *string = [NSString stringWithFormat:@"welcom_%d",i];
            [imageNameList addObject:NSLocalizedString(string, nil)];

        }
    
    }else{
    
        for(int i=0;i<KWelcomeListCount;i++ )
        {
            NSString *string = [NSString stringWithFormat:@"welcom_%d_4",i];
            [imageNameList addObject:NSLocalizedString(string, nil)];
            
        }
    
    }
    
    helpListView= [[UIScrollView alloc] init];
    helpListView.directionalLockEnabled = YES;
    helpListView.pagingEnabled = YES;
    helpListView.showsVerticalScrollIndicator=NO;
    helpListView.showsHorizontalScrollIndicator=NO;
    helpListView.bounces=NO;
    helpListView.frame=CGRectMake(0.0,0.0, self.frame.size.width, self.frame.size.height);
    helpListView.delegate = self;
    helpListView.backgroundColor=[UIColor clearColor];

    CGSize newSize = CGSizeMake(self.frame.size.width*[imageNameList count],self.frame.size.height);
    [helpListView setContentSize:newSize];
    [self addSubview:helpListView];
    [helpListView release];

    pageControl = [[StyledPageControl alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height-50.0, self.frame.size.width, 30)];
    [pageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    pageControl.userInteractionEnabled = NO;
    pageControl.backgroundColor = [UIColor clearColor];
    [pageControl setPageControlStyle:PageControlStyleThumb];
    [pageControl setThumbImage:[UIImage imageNamed:@"wel_nor.png"]];
    [pageControl setSelectedThumbImage:[UIImage imageNamed:@"wel_hor.png"]];
    pageControl.numberOfPages=[imageNameList count];
    pageControl.currentPage=0;

    [self addSubview:pageControl];
    [pageControl release];


    for (int i=0;i<[imageNameList count] ; i++) {
        
        UIImage *image=[UIImage imageNamed:[imageNameList objectAtIndex:i]];
        UIImageView *singleHelpViewShow=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0.0,self.frame.size.width, self.frame.size.height)];
        singleHelpViewShow.userInteractionEnabled = YES;
        singleHelpViewShow.backgroundColor=[UIColor blackColor];
        [singleHelpViewShow setImage:image];
        

       
        self.userInteractionEnabled = YES;
        helpListView.userInteractionEnabled = YES;
     
        if (i==[imageNameList count]-1) {
            
            UIImage *btnImage=[UIImage imageNamed:@"wel_btn.png"];
            UIButton *gotoSoftView=[UIButton buttonWithType:UIButtonTypeCustom];
            if(iphone5)
            {
                gotoSoftView.frame=CGRectMake((self.frame.size.width-btnImage.size.width)/2.0, self.frame.size.height-100.0-btnImage.size.height, btnImage.size.width, btnImage.size.height);
                
            }else{
                gotoSoftView.frame=CGRectMake((self.frame.size.width-btnImage.size.width)/2.0, self.frame.size.height-100.0-btnImage.size.height, btnImage.size.width, btnImage.size.height);
                
            }
            [gotoSoftView setBackgroundImage:btnImage forState:UIControlStateNormal];
            [gotoSoftView setTitle:NSLocalizedString(@"welcome_help", nil) forState:UIControlStateNormal];
            [gotoSoftView addTarget:self action:@selector(removeWelcom) forControlEvents:UIControlEventTouchUpInside];
            
            gotoSoftView.userInteractionEnabled = YES;
            [singleHelpViewShow addSubview:gotoSoftView];
            
        }
        [helpListView addSubview:singleHelpViewShow];
        [singleHelpViewShow release];
    }
    [self bringSubviewToFront:pageControl];

}

- (void)toNextPage
{
    int num = pageControl.currentPage+1;
    CGRect rect=CGRectMake(num*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [helpListView scrollRectToVisible:rect animated:YES];
    [pageControl setCurrentPage:num];
    
}

-(void)removeWelcom
{
    if (delegateWelcome !=nil && [delegateWelcome respondsToSelector:@selector(JVCWelcomeCallBack)]) {
        
        [self removeFromSuperview];
        
        [delegateWelcome JVCWelcomeCallBack];
        
    }
}

- (void)removeHelpView
{
    [self removeFromSuperview];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
	int index=fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
	pageControl.currentPage=index;
}
- (void)dealloc {
    [imageNameList release];
    [super dealloc];
}

@end
