//
//  JVCDeviceListAdvertCell.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/24/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCDeviceListAdvertCell.h"
#import "StyledPageControl.h"
#import "JVCDeviceHelper.h"
#import "JVCSystemConfigMacro.h"
#import "JVCLogHelper.h"
#import "JVCSystemUtility.h"
#import "JVCAdverImageModel.h"



@interface JVCDeviceListAdvertCell ()
{
    /**
     *  滚动的广告条
     */
    UIScrollView        *_scrollView;
    
    /**
     *  pageControl
     */
    StyledPageControl   *_pageController;
    
    NSMutableArray      *_arrayDefaultImage;
    
    BOOL                requestAdvertState;
    
    BOOL                hasInitCell;//标识应经初始化cell了
}

@end

@implementation JVCDeviceListAdvertCell
@synthesize JVCAdevrtDelegate;
static const kScrollewViewTag       = 11212;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _arrayDefaultImage = [[NSMutableArray alloc] init];
        
        [self setDefaultImageWithCount:1];
        
        requestAdvertState = NO;
        
        hasInitCell        = NO;
        
        
    }
    return self;
}

/**
 *  设置默认广告位个数
 *
 *  @param count 个数
 */
- (void)setDefaultImageWithCount:(int)count{

    [_arrayDefaultImage removeAllObjects];
    
    for (int i=0; i<count; i++) {
        
        NSString *stringPic = [NSString stringWithFormat:@"devAdv_default.png"];
        
        NSString *imageBundlePath = [UIImage imageBundlePath:LOCALANGER(stringPic)];
        
        JVCAdverImageModel *imageModel = [[JVCAdverImageModel alloc] initAdvertImageModel:imageBundlePath LinkUrl:nil index:i downState:YES downLoadSuccessBlock:nil enUrl:nil enLickUrl:nil];
        imageModel.localDownUrl = imageBundlePath;
        [_arrayDefaultImage addObject:imageModel];
        
        [imageModel release];
    }

}

/**
 *  初始化cell
 */
- (void)initCellContent
{
    
    [self UpdateSaveAdvertiseInfo];

}

- (void)initContentView
{
    for (UIView *contentViewInCell in self.contentView.subviews) {
        
        [contentViewInCell removeFromSuperview];
        contentViewInCell = nil;
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, kTableViewCellAdeviceHeigit)];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(self.width*_arrayDefaultImage.count, self.height);
    [self.contentView addSubview:_scrollView];
    
    for (int i=0; i<_arrayDefaultImage.count; i++) {
        JVCAdverImageModel *model = [_arrayDefaultImage objectAtIndex:i];

        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_scrollView.width, 0, _scrollView.width, _scrollView.height)];
        imgView.userInteractionEnabled = YES;
        imgView.tag = i+kScrollewViewTag;
        UIImage *imageName = nil;
        if (model.downSuccess) {
            
            imageName = [[UIImage alloc]initWithContentsOfFile:model.localDownUrl];
           
        }
        imgView.image = imageName;
        [imageName release];
        
        UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAdvertImage:)];
        [imgView addGestureRecognizer:tapRecognize];
        [tapRecognize release];
        
        [_scrollView addSubview:imgView];
        [imgView release];
    }
    
    [_scrollView release];
    
    _pageController = [[StyledPageControl alloc] initWithFrame:CGRectMake(self.width - 100, _scrollView.height - 30,80 , 30)];
    [_pageController setPageControlStyle:PageControlStyleThumb];
    _pageController.currentPage = 0;
    _pageController.numberOfPages = _arrayDefaultImage.count;
    [_pageController setThumbImage:[UIImage imageNamed:@"devAdv_white.png"]];
    [_pageController setSelectedThumbImage:[UIImage imageNamed:@"devAdv_red.png"]];
    [self.contentView addSubview:_pageController];
    [_pageController release];
    
    if (_arrayDefaultImage.count == 1) {
        _pageController.hidden =YES;
    }
}

- (void)upDateAdvertiseContent:(int)index
{
    int indexSelect = index-1;
    JVCAdverImageModel *model = [_arrayDefaultImage objectAtIndex:indexSelect];

    UIImageView *imageVeiw =(UIImageView *) [self viewWithTag:indexSelect+kScrollewViewTag];
    UIImage *imageScrol ;
    if (model.downSuccess) {
        
        imageScrol = [UIImage imageWithContentsOfFile:model.localDownUrl];
        
    }
    imageVeiw.image = imageScrol;

}

- (void)clickAdvertImage:(UITapGestureRecognizer *)gesture
{
    int  i = gesture.view.tag;
    
    JVCAdverImageModel *model = [_arrayDefaultImage objectAtIndex:i];
    
    if(model.AdLick)
    {
        if (JVCAdevrtDelegate !=nil &&[JVCAdevrtDelegate respondsToSelector:@selector(JVCAdvertClickImageWithIndex:)]) {
            [JVCAdevrtDelegate JVCAdvertClickImageWithIndex:model.AdLick];
        }
    }
}

- (void)getAdverInfo
{
    NSString *stringVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kAPPAderseVersion];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSDictionary *dicTic = [[JVCDeviceHelper sharedDeviceLibrary] getAdverInfoList:stringVersion.integerValue];
      
        [[JVCLogHelper shareJVCLogHelper] writeDataToFile:[dicTic description] fileType:LogType_LoginManagerLogPath];
        
        DDLogVerbose(@"收到的广告的字典=%@",dicTic);
     
        if ([[JVCSystemUtility shareSystemUtilityInstance] JudgeGetDictionIsLegal:dicTic]) {//下载图片
            //缓存当前版本号
            NSString *strVersion = [dicTic objectForKey:AdverJsonInfo_Version];
            [[NSUserDefaults standardUserDefaults]setObject:strVersion forKey:  kAPPAderseVersion];
            
            if (dicTic !=nil) {
                [[NSUserDefaults standardUserDefaults] setObject:dicTic forKey:kAdverInfo];
                
            }

            NSArray *arrayList = [dicTic objectForKey:AdverJsonInfo_INFO];
            
            //下载完成的回调
            
            JVCDownLoadAdverImageSuccess downLoadSuccess = ^(int index){
            
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    [self upDateAdvertiseContent:index];
                
                });

            };
            
            NSMutableArray *arrAdvert = [[NSMutableArray alloc] init];
            for (int i=0; i<arrayList.count; i++) {
                
                NSDictionary *tDic = [arrayList objectAtIndex:i];
                
                int indexValue = [[tDic objectForKey:Json_AD_NO] intValue];
                NSString *urlString = [tDic objectForKey:Json_AD_URL];
                NSString *lickString = [tDic objectForKey:Json_AD_LINK];
                
                NSString *enUrlString = [tDic objectForKey:Json_AD_URL_En];
                NSString *enLickString = [tDic objectForKey:Json_AD_LINK_En];

                JVCAdverImageModel *model = [[JVCAdverImageModel alloc] initAdvertImageModel:urlString LinkUrl:lickString index:indexValue downState:NO downLoadSuccessBlock:downLoadSuccess enUrl:enUrlString enLickUrl:enLickString];
                [arrAdvert addObject:model];
                [model release];
                
            }
            
            NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
            NSArray *sortArray = [arrAdvert sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
            [arrAdvert release];
            [_arrayDefaultImage removeAllObjects];
            [_arrayDefaultImage addObjectsFromArray:sortArray];
            
            requestAdvertState = YES;
        }else{
//            int result =    [[dicTic objectForKey:DEVICE_JSON_RT] intValue];
//            if (result == kAdverNoUpdate) {
//                
//                [self UpdateSaveAdvertiseInfo];
//                
//            }else{
//                self ini
//            }

            requestAdvertState = YES;
            
            [self UpdateSaveAdvertiseInfo];
        }
        
    
    });
}

- (void)UpdateSaveAdvertiseInfo
{
    NSDictionary *tAdevrtdic = [[NSUserDefaults standardUserDefaults] objectForKey:kAdverInfo];
    
    if ([[JVCSystemUtility shareSystemUtilityInstance] JudgeGetDictionIsLegal:tAdevrtdic]||tAdevrtdic != nil ) {
        NSArray *arrayList = [tAdevrtdic objectForKey:AdverJsonInfo_INFO];
        
        if (arrayList.count == 0) {
            return;
        }
        
        //下载完成的回调
        
        JVCDownLoadAdverImageSuccess downLoadSuccess = ^(int index){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self upDateAdvertiseContent:index];
                
            });
            
        };
        
        NSMutableArray *arrAdvert = [[NSMutableArray alloc] init];
        for (int i=0; i<arrayList.count; i++) {
            
            NSDictionary *tDic = [arrayList objectAtIndex:i];
            
            int indexValue = [[tDic objectForKey:Json_AD_NO] intValue];
            NSString *urlString = [tDic objectForKey:Json_AD_URL];
            NSString *lickString = [tDic objectForKey:Json_AD_LINK];
            
            NSString *enUrlString = [tDic objectForKey:Json_AD_URL_En];
            NSString *enLickString = [tDic objectForKey:Json_AD_LINK_En];
            
            JVCAdverImageModel *model = [[JVCAdverImageModel alloc] initAdvertImageModel:urlString LinkUrl:lickString index:indexValue downState:NO downLoadSuccessBlock:downLoadSuccess enUrl:enUrlString enLickUrl:enLickString];
            [arrAdvert addObject:model];
            [model release];
            
        }
        
        NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
        NSArray *sortArray = [arrAdvert sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
        [arrAdvert release];
        [_arrayDefaultImage removeAllObjects];
        [_arrayDefaultImage addObjectsFromArray:sortArray];
        [self initContentView];


    }else{
    
        [self setDefaultImageWithCount:1];
        [self initContentView];


    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffX = floor(scrollView.contentOffset.x/self.width) ;
    [_pageController setCurrentPage:contentOffX];
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
    [super dealloc];
}

@end
