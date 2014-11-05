//
//  JVCOperationHelpView.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/4/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCOperationHelpView.h"
#import "UIImage+BundlePath.h"
#import "JVCControlHelper.h"

@interface JVCOperationHelpView ()
{
    int  nOperationType;
    
    NSMutableArray *arrayList;
    NSMutableArray *arrayListTitle;

}
@end

@implementation JVCOperationHelpView


- (void)AddDeviceHelpView
{
    
    nOperationType = JVCOperationHelpType_Add;
    
    UIWindow *keyWindw = [UIApplication sharedApplication].keyWindow;
    
    self.frame = keyWindw.frame;
    self.backgroundColor= [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1] ;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    //operationhelp@2x.png 高亮的光圈
    NSString  *imageNameStr = [UIImage imageBundlePath:@"operationhelp.png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageNameStr];
    UIImageView *horIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake( keyWindw.width - image.size.width,20, image.size.width, image.size.height)];
    NSLog(@"%@==",NSStringFromCGRect(horIamgeView.frame));
    horIamgeView.image =image;
    [self addSubview:horIamgeView];
    [horIamgeView release];
    [image release];
    
    //箭头
    NSString  *imageIndexStr = [UIImage imageBundlePath:@"operationHelp_rightup.png"];
    UIImage *imageIndex = [[UIImage alloc] initWithContentsOfFile:imageIndexStr];
    UIImageView *horIamgeIndexView = [[UIImageView alloc] initWithFrame:CGRectMake(keyWindw.width - horIamgeView.width -imageIndex.size.width-5 , horIamgeView.bottom+10, imageIndex.size.width, imageIndex.size.height)];
    horIamgeIndexView.image =imageIndex;
    [self addSubview:horIamgeIndexView];
    [horIamgeIndexView release];
    [imageIndex release];
    
    UILabel *labelHelp = [[JVCControlHelper shareJVCControlHelper] labelWithText:LOCALANGER(@"JVCOperationHelp_add") textFontSize:18];
    labelHelp.frame = CGRectMake(0, horIamgeIndexView.bottom+10, self.width, labelHelp.height);
    labelHelp.textColor = [UIColor whiteColor];
    labelHelp.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelHelp];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOperationHelp)];
    [self addGestureRecognizer:gesture];
    [gesture release];

}


- (void)operationEditDeviceHelpView
{
    arrayList = [[NSMutableArray alloc] init];
    
    [arrayList addObject:@"operationHelp_leftUp.png"];
    [arrayList addObject:@"operationHelp_leftUp.png"];
    [arrayList addObject:@"operationHelp_rightup.png"];
    
    arrayListTitle = [[NSMutableArray alloc] init];
    
    [arrayListTitle addObject:@"设备管理"];
    [arrayListTitle addObject:@"连接模式"];
    [arrayListTitle addObject:@"通道管理"];

    nOperationType = JVCOperationHelpType_DeviceManager;
    
    UIWindow *keyWindw = [UIApplication sharedApplication].keyWindow;
    
    self.frame = keyWindw.frame;
    
    UIScrollView *helpListView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    helpListView.directionalLockEnabled = YES;
    helpListView.pagingEnabled = YES;
    helpListView.showsVerticalScrollIndicator=NO;
    helpListView.showsHorizontalScrollIndicator=NO;
    helpListView.bounces=NO;
    helpListView.frame=CGRectMake(0.0,0.0, self.frame.size.width, self.frame.size.height);
    helpListView.delegate = self;
    helpListView.backgroundColor=[UIColor clearColor];
    
    for (int i=0; i<arrayList.count ; i++) {
       
        CGRect rectFrame = [[UIScreen mainScreen] bounds];
        
        UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(i*rectFrame.size.width, rectFrame.origin.x, rectFrame.size.width, rectFrame.size.height)];
//        imageView.backgroundColor= [UIColor colorWithWhite:0.7 alpha:0.5] ;
      
        
        //operationhelp@2x.png 高亮的光圈
        NSString  *imageNameStr = [UIImage imageBundlePath:@"operationhelp.png"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageNameStr];
        UIImageView *horIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake( self.width - image.size.width,100, image.size.width, image.size.height)];
        horIamgeView.image =image;
        [imageView addSubview:horIamgeView];
        [horIamgeView release];
        [image release];
        
        //箭头
        NSString  *imageIndexStr = [UIImage imageBundlePath:[arrayList objectAtIndex:i]];
        UIImage *imageIndex = [[UIImage alloc] initWithContentsOfFile:imageIndexStr];
        UIImageView *horIamgeIndexView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - horIamgeView.width -imageIndex.size.width , horIamgeView.bottom+10, imageIndex.size.width, imageIndex.size.height)];
        horIamgeIndexView.image =imageIndex;
        [imageView addSubview:horIamgeIndexView];
        [horIamgeIndexView release];
        [imageIndex release];
        
        UILabel *labelHelp = [[JVCControlHelper shareJVCControlHelper] labelWithText:[arrayListTitle objectAtIndex:i] textFontSize:18];
        labelHelp.frame = CGRectMake(0, horIamgeIndexView.bottom+10, labelHelp.width, labelHelp.height);
        [imageView addSubview:labelHelp];

        [helpListView addSubview:imageView];
        [imageView release];
    }
    [self  addSubview:helpListView];
    [helpListView release];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   int index=fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
    
    if (index == arrayList.count -1) {//最后一个
        [self clickOperationHelp];
    }
}

- (void)clickOperationHelp
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
