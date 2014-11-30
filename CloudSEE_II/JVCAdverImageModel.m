//
//  JVCAdverImageModel.m
//  CloudSEE_II
//
//  Created by Yanghu on 11/20/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAdverImageModel.h"

@interface JVCAdverImageModel ()

@property(nonatomic,copy)JVCDownLoadAdverImageSuccess downLoadAdverSuccess;

@end

@implementation JVCAdverImageModel
@synthesize downSuccess;
@synthesize urlStirng;
@synthesize index;
@synthesize AdLick;
@synthesize localDownUrl;
@synthesize downLoadAdverSuccess;
@synthesize localImageName;
@synthesize enAdLick;
@synthesize enUrlStirng;
/**
 *  初始化
 *
 *  @param string urlstring
 *
 *  @return 对象
 */
- (id)initAdvertImageModel:(NSString *)string  LinkUrl:(NSString *)lickUrl  index:(int)imageIndex  downState:(BOOL)state downLoadSuccessBlock:(JVCDownLoadAdverImageSuccess)block enUrl:(NSString *)enUrl  enLickUrl:(NSString *)lickUrlEn
{
    if(self = [super init])
    {
        self.urlStirng = string;
        self.downSuccess = state;
        self.AdLick = lickUrl;
        self.index= imageIndex;
        self.localDownUrl = nil;
        self.enUrlStirng = enUrl;
        self.enAdLick = lickUrlEn;
        if (!state) {
            
            [self downLoadImageWithUrl];

            if (block) {
                
                self.downLoadAdverSuccess = block;
            }
        }
    }
    return self;
}

- (void)downLoadImageWithUrl
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        
        
           NSString *documentPath =  [[JVCSystemUtility shareSystemUtilityInstance] creatDirectoryAtDocumentPath:kAdverDocument];
            
            NSFileManager *manager = [[NSFileManager alloc] init];
        
        NSString *urlString = self.urlStirng;
        if (![[JVCSystemUtility shareSystemUtilityInstance] judgeAPPSystemLanguage]) {
            
            urlString = self.enUrlStirng;
            
        }
            NSString *saveIamgeName = [urlString stringByReplacingOccurrencesOfString:@"/" withString:@""];
            NSString *savePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",saveIamgeName]];
            if (![manager fileExistsAtPath:savePath]) {
                
             
                
                NSData *imageDate =  [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];

                if (imageDate.length>0) {//保存图片

            BOOL writeResult = [UIImagePNGRepresentation([UIImage imageWithData:imageDate]) writeToFile:savePath options:NSAtomicWrite error:nil];
                
                DDLogVerbose(@"写图片到本地结果=%d",writeResult);
                if (writeResult) {
                    self.localDownUrl = savePath;
                    self.downSuccess = YES;
                    
                    if (self.downLoadAdverSuccess) {
                        self.downLoadAdverSuccess(self.index);
                    }
                }
                      }
                
            }else{
            
                self.localDownUrl = savePath;
                self.downSuccess = YES;
                
                if (self.downLoadAdverSuccess) {
                    self.downLoadAdverSuccess(self.index);
                }
            }
            
            [manager release];
        
    });
}


- (void)dealloc
{
    [localDownUrl release];
    [localImageName release];
    [AdLick release];
    [urlStirng release];
    [super dealloc];
}
@end
