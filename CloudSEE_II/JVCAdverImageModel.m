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
/**
 *  初始化
 *
 *  @param string urlstring
 *
 *  @return 对象
 */
- (id)initAdvertImageModel:(NSString *)string  LinkUrl:(NSString *)lickUrl  index:(int)imageIndex  downState:(BOOL)state downLoadSuccessBlock:(JVCDownLoadAdverImageSuccess)block
{
    if(self = [super init])
    {
        self.urlStirng = string;
        self.downSuccess = state;
        self.AdLick = lickUrl;
        self.index= imageIndex;
        self.localDownUrl = nil;
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
    
       NSData *imageDate =  [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.urlStirng]];
        
        if (imageDate.length>0) {//保存图片
            
           NSString *documentPath =  [[JVCSystemUtility shareSystemUtilityInstance] creatDirectoryAtDocumentPath:kAdverDocument];
            
            NSFileManager *manager = [[NSFileManager alloc] init];
            
            NSString *saveIamgeName = [self.urlStirng stringByReplacingOccurrencesOfString:@"/" withString:@""];
            NSString *savePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",saveIamgeName]];
            if (![manager fileExistsAtPath:savePath]) {

            BOOL writeResult = [UIImageJPEGRepresentation([UIImage imageWithData:imageDate], 1.0) writeToFile:savePath options:NSAtomicWrite error:nil];
                
                DDLogVerbose(@"写图片到本地结果=%d",writeResult);
                if (writeResult) {
                    self.localDownUrl = savePath;
                    self.downSuccess = YES;
                    
                    if (self.downLoadAdverSuccess) {
                        self.downLoadAdverSuccess();
                    }
                }
                
            }
            
            [manager release];
        }
        
    });
}


-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        DDLogVerbose(@"文件后缀不认识");
    }
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
