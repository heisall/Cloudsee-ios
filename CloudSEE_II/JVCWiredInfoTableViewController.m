//
//  JVCWiredInfoTableViewController.m
//  CloudSEE_II
// 
//  Created by chenzhenyang on 14-11-12.
//  Copyright (c) 2014年 chenzhenyang. All rights reserved.
//

#import "JVCWiredInfoTableViewController.h"


@interface JVCWiredInfoTableViewController (){
    
    CGFloat               cellHeight;         //Cell的高度
}

@end

@implementation JVCWiredInfoTableViewController
@synthesize mdNetworkInfo;

static const NSTimeInterval  kTableViewCellWithSpacing  = 12.0f;

static const int             kDeviceOnlineFlag          = 1;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initLayoutWithTitles];
    [self initLayoutWithChangeTitles];
    [self initLayoutWithOperationView];
}

/**
 *  初始化功能视图
 */
-(void)initLayoutWithOperationView{
    
}

/**
 *  初始化视图标题集合
 */
-(void)initLayoutWithTitles {
    
    if (!titles) {
        
        titles = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    [titles addObject:(NSString *)kWiredWithIP];
    [titles addObject:(NSString *)kWiredWithSubnetMask];
    [titles addObject:(NSString *)kWiredWithGateway];
    [titles addObject:(NSString *)kWiredWithDNS];
    [titles addObject:(NSString *)kWiredWithMAC];
    [titles addObject:(NSString *)kWiredWithCloudSEEID];
    [titles addObject:(NSString *)kWiredWithStatus];
    
    NSString *strImage = [UIImage imageBundlePath:@"con_fieldUnSec.png"];
    UIImage *image     = [UIImage imageWithContentsOfFile:strImage];
    
    CGFloat  height    = image.size.height;
    
    cellHeight = height + kTableViewCellWithSpacing*2;
}

/**
 *  初始化加载可输入的标签字典数组
 */
-(void)initLayoutWithChangeTitles {
    
    if (!mdCacheNetworkInfo) {
        
        mdCacheNetworkInfo = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
}

/**
 *  判断key值在可改变的字典数组里是否存在
 *
 *  @param key 查询的key
 *
 *  @return 存在返回 YES
 */
-(BOOL)checkKeyIsExistInChangeCacheMdic:(NSString *)key{

    return [mdCacheNetworkInfo objectForKey:key] == nil ? FALSE : YES;
}

-(void)dealloc{

    [titles release];
    [mdNetworkInfo release];
    [mdCacheNetworkInfo release];
    DDLogVerbose(@"%s----------------",__FUNCTION__);
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark ---------- tableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return titles.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";
    
    JVCWireTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[[JVCWireTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for ( UIView *_tVC in cell.contentView.subviews) {
        [_tVC removeFromSuperview];
    }
    
    NSString *key  = [titles objectAtIndex:indexPath.row];
    NSString *name = [self.mdNetworkInfo objectForKey:key];
    
    cell.frame     = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cellHeight);
    cell.deleage   = self;
    
    if (name) {
        
        if ([key isEqualToString:(NSString *)kWiredWithCloudSEEID]) {
            
            char cYstGroup=[[self.mdNetworkInfo objectForKey:(NSString *)kWiredWithCloudSEEGroup] intValue];
            
            if (cYstGroup) {
                
                [cell initContentView:key withTextFiled:[NSString stringWithFormat:@"%c%@",cYstGroup,name] withIndex:indexPath.row withTextFiledEnabled:[self checkKeyIsExistInChangeCacheMdic:key]];
            }
            
        }else if([key isEqualToString:(NSString *)kWiredWithStatus]){
            
            [cell initContentView:key withTextFiled:name.intValue == kDeviceOnlineFlag?@"在线":@"不在线" withIndex:indexPath.row withTextFiledEnabled:[self checkKeyIsExistInChangeCacheMdic:key]];
        
        }else{
        
           [cell initContentView:key withTextFiled:name withIndex:indexPath.row withTextFiledEnabled:[self checkKeyIsExistInChangeCacheMdic:key]];
        }
    }

    return cell;
}

-(void)closeTableViewCellResignFirstResponder {

    for (JVCWireTableViewCell *cell in self.tableView.visibleCells) {
        
        [cell resignFirstResponderMath];
    }
}

#pragma mark ---------- JVCWiredTableViewCell delegate

-(void)textFiledWithTextChange:(NSString *)text withIndex:(int)index {
    
}

#pragma mark ------------- UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

@end
