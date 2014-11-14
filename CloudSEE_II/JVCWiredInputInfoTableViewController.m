//
//  JVCWiredInputInfoTableViewController.m
//  CloudSEE_II
//
//  Created by chenzhenyang on 14-11-13.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCWiredInputInfoTableViewController.h"

@interface JVCWiredInputInfoTableViewController ()

@end

@implementation JVCWiredInputInfoTableViewController
@synthesize wiredInfoTableViewSaveBlock;

static const CGFloat         kNavRightItemWithFontSize  = 14.0f;

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

-(void)dealloc{

    [wiredInfoTableViewSaveBlock release];
    [super dealloc];
}

-(void)BackClick{
    
    [self closeTableViewCellResignFirstResponder];
    [super BackClick];
}

/**
 *  保存IP地址
 */
-(void)wiredSaveClick{
    
    [self closeTableViewCellResignFirstResponder];
    
    if (self.wiredInfoTableViewSaveBlock) {
        
        self.wiredInfoTableViewSaveBlock([self valueAtKey:(NSString *)kWiredWithIP],[self valueAtKey:(NSString *)kWiredWithGateway],[self valueAtKey:(NSString *)kWiredWithIP],[self valueAtKey:(NSString *)kWiredWithDNS]);
    }
}

/**
 *  初始化功能视图
 */
-(void)initLayoutWithOperationView{
    
    UIImage *tImageScan = [UIImage imageNamed:@"ap_finsh.png"];
    
    UIButton *tImageScanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tImageScanBtn.titleLabel.font = [UIFont systemFontOfSize:kNavRightItemWithFontSize];
    tImageScanBtn.frame = CGRectMake(0, 0, tImageScan.size.width, tImageScan.size.height);
    [tImageScanBtn addTarget:self action:@selector(wiredSaveClick) forControlEvents:UIControlEventTouchUpInside];
    [tImageScanBtn setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    [tImageScanBtn setBackgroundImage:tImageScan forState:UIControlStateNormal];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:tImageScanBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
    [rightBar release];
}


/**
 *  判断一个字典数组里面key的Value是否存在，存在添加到另一个数组
 *
 *  @param key       查询的key
 *  @param baseMdDic 查询的key的字典
 *  @param addMddic  被添加到的另一个字典
 */
-(void)checkKeyIsExistValue:(NSString *)key withBaseMdDic:(NSMutableDictionary*)baseMdDic withAddMDdic:(NSMutableDictionary *)addMddic{
    
    if ([baseMdDic objectForKey:key]) {
        
        [addMddic setObject:[baseMdDic objectForKey:key] forKey:key];
    }
}

/**
 *  初始化加载可输入的标签字典数组
 */
-(void)initLayoutWithChangeTitles {
    
    [super initLayoutWithChangeTitles];
    
    [self checkKeyIsExistValue:(NSString *)kWiredWithIP          withBaseMdDic:self.mdNetworkInfo withAddMDdic:mdCacheNetworkInfo];
    [self checkKeyIsExistValue:(NSString *)kWiredWithSubnetMask withBaseMdDic:self.mdNetworkInfo withAddMDdic:mdCacheNetworkInfo];
    [self checkKeyIsExistValue:(NSString *)kWiredWithGateway    withBaseMdDic:self.mdNetworkInfo withAddMDdic:mdCacheNetworkInfo];
    [self checkKeyIsExistValue:(NSString *)kWiredWithDNS         withBaseMdDic:self.mdNetworkInfo withAddMDdic:mdCacheNetworkInfo];
}

-(void)closeTableViewCellResignFirstResponder {
    
    for (JVCWireTableViewCell *cell in self.tableView.visibleCells) {
        
        [cell resignFirstResponderMath];
    }
}

#pragma mark ---------- JVCWiredTableViewCell delegate

-(void)textFiledWithTextChange:(NSString *)text withIndex:(int)index {
    
    if (index < titles.count) {
        
        if ([self checkKeyIsExistInChangeCacheMdic:[titles objectAtIndex:index]]) {
            
            [mdCacheNetworkInfo setObject:text forKey:[titles objectAtIndex:index]];
        }
    }
}

/**
 *  根据Key值获取Value
 *
 *  @param key
 *
 *  @return key对应的Value
 */
-(NSString *)valueAtKey:(NSString *)key{
    
    return [mdCacheNetworkInfo objectForKey:key] == nil ? @"" :[mdCacheNetworkInfo objectForKey:key];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
